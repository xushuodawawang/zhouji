import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../models/focus_session.dart';
import '../repositories/focus_repository.dart';
import '../services/focus_lock_service.dart';
import '../services/notification_service.dart';
import '../services/focus_music_service.dart';

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
    this.title = '',
    this.musicPlaying = false,
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
  final String title;
  final bool musicPlaying;
  bool get isStopwatch => totalSeconds == 0 && !isBreak;

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
    String? title,
    bool? musicPlaying,
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
    title: title ?? this.title,
    musicPlaying: musicPlaying ?? this.musicPlaying,
  );
}

class FocusTimerController extends StateNotifier<FocusTimerState> {
  FocusTimerController({
    required FocusRepository repository,
    required NotificationService notifications,
    FocusMusicService? music,
    FocusLockService? focusLock,
    Future<void> Function(int taskId)? onTaskFocusCompleted,
    required AppSettings settings,
    Future<AppSettings> Function()? loadSettings,
  }) : _repository = repository,
       _notifications = notifications,
       _music = music ?? FocusMusicService(),
       _focusLock = focusLock ?? FocusLockService(),
       _onTaskFocusCompleted = onTaskFocusCompleted ?? ((_) async {}),
       _settings = settings,
       _loadSettings = loadSettings,
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
  final FocusMusicService _music;
  final FocusLockService _focusLock;
  final Future<void> Function(int taskId) _onTaskFocusCompleted;
  AppSettings _settings;
  final Future<AppSettings> Function()? _loadSettings;
  Timer? _ticker;
  bool _completing = false;
  bool _musicManuallyPaused = false;
  int _operation = 0;

  static int remainingAt(ActiveTimer timer, DateTime now) {
    if (timer.mode == TimerMode.stopwatch && timer.isRunning) {
      return math.max(0, now.difference(timer.expectedEndAt).inSeconds);
    }
    if (!timer.isRunning) return math.max(0, timer.remainingSeconds);
    return math.max(0, timer.expectedEndAt.difference(now).inSeconds);
  }

  Future<void> _restore() async {
    if (_loadSettings != null) _settings = await _loadSettings();
    final timer = await _repository.loadActiveTimer();
    if (!mounted) return;
    if (timer == null) {
      state = state.copyWith(
        restoring: false,
        totalSeconds: _settings.pomodoroFocusMinutes * 60,
        remainingSeconds: _settings.pomodoroFocusMinutes * 60,
      );
      return;
    }
    final remaining = remainingAt(timer, DateTime.now());
    final total = timer.totalSeconds ?? _durationFor(timer.phase) * 60;
    state = FocusTimerState(
      status:
          timer.isRunning ? FocusTimerStatus.running : FocusTimerStatus.paused,
      phase: timer.phase,
      remainingSeconds: remaining,
      totalSeconds:
          timer.mode == TimerMode.stopwatch ? 0 : math.max(total, remaining),
      title: timer.title,
      cycleCount: timer.cycleCount,
      taskId: timer.taskId,
      categoryId: timer.categoryId,
      startedAt: timer.startedAt,
      expectedEndAt: timer.expectedEndAt,
      restoring: false,
    );
    if (remaining <= 0 && !state.isStopwatch) {
      await _finishPhase(completed: true);
    } else if (timer.isRunning) {
      _startTicker();
      if (!state.isBreak && _settings.focusMusicEnabled) {
        await _startBackgroundMusic();
      }
      if (!state.isBreak && _settings.focusLockEnabled) {
        await _focusLock.activate();
      }
    }
  }

  void updateSettings(AppSettings settings) {
    final durationChanged =
        settings.pomodoroFocusMinutes != _settings.pomodoroFocusMinutes;
    final musicChanged =
        settings.focusMusicEnabled != _settings.focusMusicEnabled ||
        settings.focusMusicUri != _settings.focusMusicUri;
    final focusLockChanged =
        settings.focusLockEnabled != _settings.focusLockEnabled;
    _settings = settings;
    if (musicChanged &&
        state.status == FocusTimerStatus.running &&
        !state.isBreak) {
      _musicManuallyPaused = false;
      if (settings.focusMusicEnabled && settings.focusMusicUri.isNotEmpty) {
        unawaited(_startBackgroundMusic());
      } else {
        unawaited(_stopMusic());
      }
    }
    if (focusLockChanged) {
      if (!settings.focusLockEnabled) {
        unawaited(_focusLock.deactivate());
      } else if (state.isActive && !state.isBreak) {
        unawaited(_focusLock.activate());
      }
    }
    if (durationChanged &&
        !state.isActive &&
        state.phase == TimerPhase.focus &&
        state.taskId == null &&
        state.title.isEmpty) {
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

  void selectTask({
    int? taskId,
    int? categoryId,
    int? focusMinutes,
    String title = '',
  }) {
    if (state.isActive) return;
    state = state.copyWith(
      taskId: taskId,
      clearTask: taskId == null,
      categoryId: categoryId,
      clearCategory: categoryId == null,
      title: title,
      phase: TimerPhase.focus,
      remainingSeconds: focusMinutes == null ? null : focusMinutes * 60,
      totalSeconds: focusMinutes == null ? null : focusMinutes * 60,
    );
  }

  Future<void> start() async {
    if (state.restoring || state.status == FocusTimerStatus.running) return;
    final wasPaused = state.status == FocusTimerStatus.paused;
    if (!wasPaused) _musicManuallyPaused = false;
    final operation = ++_operation;
    final now = DateTime.now();
    final expected =
        state.isStopwatch
            ? now.subtract(Duration(seconds: state.remainingSeconds))
            : now.add(Duration(seconds: state.remainingSeconds));
    state = state.copyWith(
      status: FocusTimerStatus.running,
      startedAt: state.startedAt ?? now,
      expectedEndAt: expected,
    );
    await _persist();
    if (operation != _operation || state.status != FocusTimerStatus.running) {
      return;
    }
    if (_settings.notificationEnabled && !state.isStopwatch) {
      await _notifications.scheduleTimerEnd(
        endAt: expected,
        isBreak: state.isBreak,
      );
    }
    if (operation != _operation) return;
    if (!state.isBreak && _settings.focusLockEnabled) {
      await _focusLock.activate();
    }
    if (operation != _operation) return;
    if (!state.isBreak &&
        _settings.focusMusicEnabled &&
        _settings.focusMusicUri.isNotEmpty &&
        !_musicManuallyPaused) {
      await _startBackgroundMusic(resume: wasPaused);
    }
    if (operation == _operation) _startTicker();
  }

  Future<void> pause() async {
    if (state.status != FocusTimerStatus.running) return;
    _operation++;
    final remaining = math.max(
      0,
      state.isStopwatch
          ? DateTime.now().difference(state.expectedEndAt!).inSeconds
          : state.expectedEndAt!.difference(DateTime.now()).inSeconds,
    );
    _ticker?.cancel();
    state = state.copyWith(
      status: FocusTimerStatus.paused,
      remainingSeconds: remaining,
      expectedEndAt: DateTime.now().add(Duration(seconds: remaining)),
      musicPlaying: false,
    );
    await _notifications.cancelTimer();
    await _music.pause();
    await _persist();
  }

  Future<void> resume() => start();

  Future<void> completeCurrent() => _finishPhase(completed: true);

  Future<void> endEarly() => _finishPhase(completed: false);

  Future<void> skipBreak() async {
    if (!state.isBreak) return;
    await _notifications.cancelTimer();
    await _music.stop();
    await _focusLock.deactivate();
    await _repository.clearActiveTimer();
    _ticker?.cancel();
    _setReadyFocus();
  }

  Future<void> reset() async {
    _operation++;
    await _notifications.cancelTimer();
    await _music.stop();
    await _focusLock.deactivate();
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
      final remaining = math.max(
        0,
        state.isStopwatch
            ? DateTime.now().difference(end).inSeconds
            : end.difference(DateTime.now()).inSeconds,
      );
      state = state.copyWith(remainingSeconds: remaining);
      if (remaining <= 0 && !state.isStopwatch) {
        _finishPhase(completed: true);
      }
    });
  }

  Future<void> _finishPhase({required bool completed}) async {
    if (_completing || state.startedAt == null) return;
    _operation++;
    _completing = true;
    try {
      _ticker?.cancel();
      await _notifications.cancelTimer();
      await _music.stop();
      final wasFocus = state.phase == TimerPhase.focus;
      final wasStopwatch = state.isStopwatch;
      if (wasFocus) await _focusLock.deactivate();
      if (wasFocus && completed && _settings.completionSoundEnabled) {
        await _music.playCompletionSound();
      }
      if (wasFocus && state.startedAt != null) {
        final usedSeconds = math.max(
          0,
          state.isStopwatch
              ? state.remainingSeconds
              : state.totalSeconds - state.remainingSeconds,
        );
        if (usedSeconds > 0 || completed) {
          await _repository.addSession(
            startedAt: state.startedAt!,
            endedAt:
                completed && !wasStopwatch && state.remainingSeconds == 0
                    ? state.expectedEndAt ?? DateTime.now()
                    : DateTime.now(),
            plannedMinutes: (state.totalSeconds / 60).ceil(),
            actualMinutes: math.max(1, (usedSeconds / 60).ceil()),
            mode: state.isStopwatch ? TimerMode.stopwatch : TimerMode.pomodoro,
            note: state.title,
            completed: completed,
            taskId: state.taskId,
            categoryId: state.categoryId,
          );
        }
      }
      await _repository.clearActiveTimer();
      if (wasFocus && completed) {
        final completedTaskId = state.taskId;
        if (_settings.autoCompleteTaskOnFocus && completedTaskId != null) {
          await _onTaskFocusCompleted(completedTaskId);
        }
        if (wasStopwatch) {
          _setReadyFocus();
          return;
        }
        final nextCycle = state.cycleCount + 1;
        final longBreak = nextCycle % _settings.longBreakInterval == 0;
        final minutes =
            longBreak
                ? _settings.longBreakMinutes
                : _settings.shortBreakMinutes;
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
    } finally {
      _completing = false;
    }
  }

  void _setReadyFocus() {
    _musicManuallyPaused = false;
    final seconds = _settings.pomodoroFocusMinutes * 60;
    state = FocusTimerState(
      remainingSeconds: seconds,
      totalSeconds: seconds,
      cycleCount: state.cycleCount,
      restoring: false,
    );
  }

  int _durationFor(TimerPhase phase) => switch (phase) {
    TimerPhase.focus => _settings.pomodoroFocusMinutes,
    TimerPhase.shortBreak => _settings.shortBreakMinutes,
    TimerPhase.longBreak => _settings.longBreakMinutes,
  };

  Future<void> toggleMusicPlayback() async {
    if (state.status != FocusTimerStatus.running || state.isBreak) return;
    if (!_settings.focusMusicEnabled || _settings.focusMusicUri.isEmpty) return;
    if (state.musicPlaying) {
      _musicManuallyPaused = true;
      await _music.pause();
      if (mounted) state = state.copyWith(musicPlaying: false);
      return;
    }
    _musicManuallyPaused = false;
    await _startBackgroundMusic(resume: true);
  }

  Future<void> _startBackgroundMusic({bool resume = false}) async {
    if (state.status != FocusTimerStatus.running || state.isBreak) return;
    var playing = resume && await _music.resume();
    if (!playing) playing = await _music.play(_settings.focusMusicUri);
    if (!mounted) return;
    if (state.status != FocusTimerStatus.running || state.isBreak) {
      if (playing) await _music.stop();
      return;
    }
    state = state.copyWith(musicPlaying: playing);
  }

  Future<void> _stopMusic() async {
    await _music.stop();
    if (mounted) state = state.copyWith(musicPlaying: false);
  }

  Future<void> _persist() => _repository.saveActiveTimer(
    ActiveTimer(
      mode: state.isStopwatch ? TimerMode.stopwatch : TimerMode.pomodoro,
      totalSeconds: state.totalSeconds,
      title: state.title,
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
