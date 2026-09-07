import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../models/focus_session.dart';
import '../repositories/focus_repository.dart';
import '../services/notification_service.dart';

enum FocusTimerStatus { idle, running, paused }

class FocusTimerState {
  const FocusTimerState({
    this.status = FocusTimerStatus.idle,
    this.phase = TimerPhase.focus,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.cycleCount = 0,
    this.taskId,
    this.categoryId,
    this.startedAt,
    this.expectedEndAt,
    this.restoring = true,
  });

  final FocusTimerStatus status;
  final TimerPhase phase;
  final int remainingSeconds;
  final int totalSeconds;
  final int cycleCount;
  final int? taskId;
  final int? categoryId;
  final DateTime? startedAt;
  final DateTime? expectedEndAt;
  final bool restoring;

  bool get isBreak => phase != TimerPhase.focus;
  bool get isActive => status != FocusTimerStatus.idle;
  double get progress =>
      totalSeconds == 0 ? 0 : (1 - remainingSeconds / totalSeconds).clamp(0, 1);

  FocusTimerState copyWith({
    FocusTimerStatus? status,
    TimerPhase? phase,
    int? remainingSeconds,
    int? totalSeconds,
    int? cycleCount,
    int? taskId,
    bool clearTask = false,
    int? categoryId,
    bool clearCategory = false,
    DateTime? startedAt,
    bool clearStartedAt = false,
    DateTime? expectedEndAt,
    bool clearExpectedEndAt = false,
    bool? restoring,
  }) => FocusTimerState(
    status: status ?? this.status,
    phase: phase ?? this.phase,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    totalSeconds: totalSeconds ?? this.totalSeconds,
    cycleCount: cycleCount ?? this.cycleCount,
    taskId: clearTask ? null : taskId ?? this.taskId,
    categoryId: clearCategory ? null : categoryId ?? this.categoryId,
    startedAt: clearStartedAt ? null : startedAt ?? this.startedAt,
    expectedEndAt:
        clearExpectedEndAt ? null : expectedEndAt ?? this.expectedEndAt,
    restoring: restoring ?? this.restoring,
  );
}

class FocusTimerController extends StateNotifier<FocusTimerState> {
  FocusTimerController({
    required FocusRepository repository,
    required NotificationService notifications,
    required AppSettings settings,
  }) : _repository = repository,
       _notifications = notifications,
       _settings = settings,
       super(
         FocusTimerState(
           remainingSeconds: settings.pomodoroFocusMinutes * 60,
           totalSeconds: settings.pomodoroFocusMinutes * 60,
         ),
       ) {
    _restore();
  }

  final FocusRepository _repository;
  final NotificationService _notifications;
  AppSettings _settings;
  Timer? _ticker;
  bool _completing = false;

  static int remainingAt(ActiveTimer timer, DateTime now) {
    if (!timer.isRunning) return math.max(0, timer.remainingSeconds);
    return math.max(0, timer.expectedEndAt.difference(now).inSeconds);
  }

  Future<void> _restore() async {
    final timer = await _repository.loadActiveTimer();
    if (timer == null) {
      state = state.copyWith(restoring: false);
      return;
    }
    final remaining = remainingAt(timer, DateTime.now());
    final total = _durationFor(timer.phase) * 60;
    state = FocusTimerState(
      status:
          timer.isRunning ? FocusTimerStatus.running : FocusTimerStatus.paused,
      phase: timer.phase,
      remainingSeconds: remaining,
      totalSeconds: math.max(total, remaining),
      cycleCount: timer.cycleCount,
      taskId: timer.taskId,
      categoryId: timer.categoryId,
      startedAt: timer.startedAt,
      expectedEndAt: timer.expectedEndAt,
      restoring: false,
    );
    if (remaining <= 0) {
      await _finishPhase(completed: true);
    } else if (timer.isRunning) {
      _startTicker();
    }
  }

  void updateSettings(AppSettings settings) {
    _settings = settings;
    if (!state.isActive && state.phase == TimerPhase.focus) {
      configure(
        focusMinutes: settings.pomodoroFocusMinutes,
        breakMinutes: settings.shortBreakMinutes,
      );
    }
  }

  void configure({required int focusMinutes, required int breakMinutes}) {
    if (state.isActive) return;
    _settings = _settings.copyWith(
      pomodoroFocusMinutes: focusMinutes,
      shortBreakMinutes: breakMinutes,
    );
    if (state.phase == TimerPhase.focus) {
      state = state.copyWith(
        remainingSeconds: focusMinutes * 60,
        totalSeconds: focusMinutes * 60,
      );
    }
  }

  void selectTask({int? taskId, int? categoryId}) {
    if (state.isActive) return;
    state = state.copyWith(
      taskId: taskId,
      clearTask: taskId == null,
      categoryId: categoryId,
      clearCategory: categoryId == null,
    );
  }

  Future<void> start() async {
    if (state.status == FocusTimerStatus.running) return;
    final now = DateTime.now();
    final expected = now.add(Duration(seconds: state.remainingSeconds));
    state = state.copyWith(
      status: FocusTimerStatus.running,
      startedAt: state.startedAt ?? now,
      expectedEndAt: expected,
    );
    await _persist();
    if (_settings.notificationEnabled) {
      await _notifications.scheduleTimerEnd(
        endAt: expected,
        isBreak: state.isBreak,
      );
    }
    _startTicker();
  }

  Future<void> pause() async {
    if (state.status != FocusTimerStatus.running) return;
    final remaining = math.max(
      0,
      state.expectedEndAt!.difference(DateTime.now()).inSeconds,
    );
    _ticker?.cancel();
    state = state.copyWith(
      status: FocusTimerStatus.paused,
      remainingSeconds: remaining,
      expectedEndAt: DateTime.now().add(Duration(seconds: remaining)),
    );
    await _notifications.cancelTimer();
    await _persist();
  }

  Future<void> resume() => start();

  Future<void> completeCurrent() => _finishPhase(completed: true);

  Future<void> endEarly() => _finishPhase(completed: false);

  Future<void> skipBreak() async {
    if (!state.isBreak) return;
    await _notifications.cancelTimer();
    await _repository.clearActiveTimer();
    _ticker?.cancel();
    _setReadyFocus();
  }

  Future<void> reset() async {
    await _notifications.cancelTimer();
    await _repository.clearActiveTimer();
    _ticker?.cancel();
    state = FocusTimerState(
      remainingSeconds: _settings.pomodoroFocusMinutes * 60,
      totalSeconds: _settings.pomodoroFocusMinutes * 60,
      cycleCount: state.cycleCount,
      restoring: false,
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final end = state.expectedEndAt;
      if (state.status != FocusTimerStatus.running || end == null) return;
      final remaining = math.max(0, end.difference(DateTime.now()).inSeconds);
      state = state.copyWith(remainingSeconds: remaining);
      if (remaining <= 0) {
        _finishPhase(completed: true);
      }
    });
  }

  Future<void> _finishPhase({required bool completed}) async {
    if (_completing) return;
    _completing = true;
    _ticker?.cancel();
    await _notifications.cancelTimer();
    final wasFocus = state.phase == TimerPhase.focus;
    if (wasFocus && state.startedAt != null) {
      final usedSeconds = math.max(
        0,
        state.totalSeconds - state.remainingSeconds,
      );
      if (usedSeconds > 0 || completed) {
        await _repository.addSession(
          startedAt: state.startedAt!,
          endedAt: DateTime.now(),
          plannedMinutes: (state.totalSeconds / 60).ceil(),
          actualMinutes: math.max(1, (usedSeconds / 60).ceil()),
          mode: TimerMode.pomodoro,
          completed: completed,
          taskId: state.taskId,
          categoryId: state.categoryId,
        );
      }
    }
    await _repository.clearActiveTimer();
    if (wasFocus && completed) {
      final nextCycle = state.cycleCount + 1;
      final longBreak = nextCycle % _settings.longBreakInterval == 0;
      final minutes =
          longBreak ? _settings.longBreakMinutes : _settings.shortBreakMinutes;
      state = FocusTimerState(
        phase: longBreak ? TimerPhase.longBreak : TimerPhase.shortBreak,
        remainingSeconds: minutes * 60,
        totalSeconds: minutes * 60,
        cycleCount: nextCycle,
        taskId: state.taskId,
        categoryId: state.categoryId,
        restoring: false,
      );
    } else {
      _setReadyFocus();
    }
    _completing = false;
  }

  void _setReadyFocus() {
    final seconds = _settings.pomodoroFocusMinutes * 60;
    state = FocusTimerState(
      remainingSeconds: seconds,
      totalSeconds: seconds,
      cycleCount: state.cycleCount,
      taskId: state.taskId,
      categoryId: state.categoryId,
      restoring: false,
    );
  }

  int _durationFor(TimerPhase phase) => switch (phase) {
    TimerPhase.focus => _settings.pomodoroFocusMinutes,
    TimerPhase.shortBreak => _settings.shortBreakMinutes,
    TimerPhase.longBreak => _settings.longBreakMinutes,
  };

  Future<void> _persist() => _repository.saveActiveTimer(
    ActiveTimer(
      mode: TimerMode.pomodoro,
      phase: state.phase,
      startedAt: state.startedAt ?? DateTime.now(),
      expectedEndAt: state.expectedEndAt ?? DateTime.now(),
      remainingSeconds: state.remainingSeconds,
      isRunning: state.status == FocusTimerStatus.running,
      cycleCount: state.cycleCount,
      taskId: state.taskId,
      categoryId: state.categoryId,
    ),
  );

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
