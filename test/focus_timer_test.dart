import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/app_settings.dart';
import 'package:zhouji/models/focus_session.dart';
import 'package:zhouji/providers/focus_timer_controller.dart';
import 'package:zhouji/repositories/focus_repository.dart';
import 'package:zhouji/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late FocusRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = FocusRepository(database);
  });

  tearDown(() => database.close());

  test('运行中的剩余时间由预计结束时间戳计算', () {
    final now = DateTime(2026, 7, 24, 10);
    final timer = ActiveTimer(
      mode: TimerMode.pomodoro,
      phase: TimerPhase.focus,
      startedAt: now,
      expectedEndAt: now.add(const Duration(minutes: 25)),
      remainingSeconds: 1,
      isRunning: true,
      cycleCount: 0,
    );
    expect(
      FocusTimerController.remainingAt(
        timer,
        now.add(const Duration(minutes: 3)),
      ),
      22 * 60,
    );
    expect(
      FocusTimerController.remainingAt(
        ActiveTimer(
          mode: timer.mode,
          phase: timer.phase,
          startedAt: timer.startedAt,
          expectedEndAt: timer.expectedEndAt,
          remainingSeconds: 321,
          isRunning: false,
          cycleCount: 0,
        ),
        now.add(const Duration(hours: 1)),
      ),
      321,
    );
  });

  test('暂停、继续会持久化 ActiveTimer 状态', () async {
    final controller = FocusTimerController(
      repository: repository,
      notifications: NotificationService(),
      settings: const AppSettings(pomodoroFocusMinutes: 1),
    );
    addTearDown(controller.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await controller.start();
    expect((await repository.loadActiveTimer())!.isRunning, isTrue);
    await controller.pause();
    final paused = await repository.loadActiveTimer();
    expect(paused!.isRunning, isFalse);
    expect(paused.remainingSeconds, inInclusiveRange(58, 60));
    await controller.resume();
    expect((await repository.loadActiveTimer())!.isRunning, isTrue);
  });

  test('完成番茄后生成 FocusSession 并清除 ActiveTimer', () async {
    final controller = FocusTimerController(
      repository: repository,
      notifications: NotificationService(),
      settings: const AppSettings(pomodoroFocusMinutes: 1),
    );
    addTearDown(controller.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await controller.start();
    await controller.completeCurrent();
    final start = DateTime.now().subtract(const Duration(days: 1));
    final end = DateTime.now().add(const Duration(days: 1));
    final sessions = await repository.getBetween(start, end);

    expect(sessions, hasLength(1));
    expect(sessions.single.completed, isTrue);
    expect(sessions.single.actualMinutes, 1);
    expect(await repository.loadActiveTimer(), isNull);
    expect(controller.state.phase, TimerPhase.shortBreak);
  });
}
