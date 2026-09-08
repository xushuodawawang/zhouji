import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/app_settings.dart';
import 'package:zhouji/models/focus_session.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/providers/focus_timer_controller.dart';
import 'package:zhouji/repositories/focus_repository.dart';
import 'package:zhouji/repositories/plan_task_repository.dart';
import 'package:zhouji/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('全天默认与专注模板可持久化、修改、删除', () async {
    final settings = await db.getSettings();
    expect(settings.timelineStartMinutes, 0);
    expect(settings.timelineEndMinutes, 1440);
    final id = await db
        .into(db.focusPresets)
        .insert(
          FocusPresetsCompanion.insert(
            title: '数学',
            minutes: const drift.Value(60),
            colorValue: 0xFF719B87,
          ),
        );
    expect((await db.select(db.focusPresets).get()).single.minutes, 60);
    await (db.update(db.focusPresets)..where(
      (t) => t.id.equals(id),
    )).write(const FocusPresetsCompanion(minutes: drift.Value(0)));
    expect((await db.select(db.focusPresets).get()).single.minutes, 0);
    await (db.delete(db.focusPresets)..where((t) => t.id.equals(id))).go();
    expect(await db.select(db.focusPresets).get(), isEmpty);
  });

  test('跨午夜计划与次日凌晨任务检查绝对时间冲突', () async {
    final repo = PlanTaskRepository(db);
    final date = DateTime(2026, 9, 7);
    await repo.save(
      PlanTaskDraft(
        title: '夜间数学',
        taskDate: date,
        startMinutes: 1380,
        endMinutes: 1560,
        focusMinutes: 60,
        colorValue: 0xFF719B87,
      ),
    );
    expect(
      () => repo.save(
        PlanTaskDraft(
          title: '重叠任务',
          taskDate: date.add(const Duration(days: 1)),
          startMinutes: 60,
          endMinutes: 120,
          colorValue: 0xFF719B87,
        ),
      ),
      throwsA(isA<TaskConflictException>()),
    );
    await repo.save(
      PlanTaskDraft(
        title: '边界相接',
        taskDate: date.add(const Duration(days: 1)),
        startMinutes: 120,
        endMinutes: 180,
        colorValue: 0xFF719B87,
      ),
    );
    expect((await repo.watchDate(date).first).single.focusMinutes, 60);
  });

  test('60分钟计时重启保留总时长，完成后同步计划且只记录一次', () async {
    final tasks = PlanTaskRepository(db);
    final repo = FocusRepository(db);
    final date = DateTime.now();
    final id = await tasks.save(
      PlanTaskDraft(
        title: '数学',
        taskDate: date,
        startMinutes: 600,
        endMinutes: 660,
        focusMinutes: 60,
        colorValue: 0xFF719B87,
      ),
    );
    await repo.saveActiveTimer(
      ActiveTimer(
        mode: TimerMode.pomodoro,
        phase: TimerPhase.focus,
        startedAt: date.subtract(const Duration(minutes: 30)),
        expectedEndAt: date.add(const Duration(minutes: 30)),
        remainingSeconds: 1800,
        totalSeconds: 3600,
        isRunning: false,
        cycleCount: 0,
        taskId: id,
        title: '数学',
      ),
    );
    final controller = FocusTimerController(
      repository: repo,
      notifications: NotificationService(),
      settings: const AppSettings(autoCompleteTaskOnFocus: true),
      onTaskFocusCompleted: (id) => tasks.setCompleted(id, true),
    );
    addTearDown(controller.dispose);
    while (controller.state.restoring) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(controller.state.totalSeconds, 3600);
    expect(controller.state.title, '数学');
    await Future.wait([
      controller.completeCurrent(),
      controller.completeCurrent(),
    ]);
    expect((await tasks.watchDate(date).first).single.isCompleted, isTrue);
    final sessions = await repo.getBetween(
      DateTime(
        date.year,
        date.month,
        date.day,
      ).subtract(const Duration(days: 2)),
      date.add(const Duration(days: 1)),
    );
    expect(sessions, hasLength(1));
    expect(sessions.single.plannedMinutes, 60);
    expect(sessions.single.actualMinutes, 30);
    expect(sessions.single.note, '数学');
  });

  test('正向计时恢复、暂停继续和提前结束不自动完成计划', () async {
    final repo = FocusRepository(db);
    final date = DateTime.now();
    await repo.saveActiveTimer(
      ActiveTimer(
        mode: TimerMode.stopwatch,
        phase: TimerPhase.focus,
        startedAt: date.subtract(const Duration(minutes: 10)),
        expectedEndAt: date.subtract(const Duration(minutes: 10)),
        remainingSeconds: 600,
        totalSeconds: 0,
        isRunning: true,
        cycleCount: 0,
        taskId: 1,
        title: '计算机网络',
      ),
    );
    var completions = 0;
    final controller = FocusTimerController(
      repository: repo,
      notifications: NotificationService(),
      settings: const AppSettings(autoCompleteTaskOnFocus: true),
      onTaskFocusCompleted: (_) async {
        completions++;
      },
    );
    addTearDown(controller.dispose);
    while (controller.state.restoring) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(controller.state.isStopwatch, isTrue);
    await controller.pause();
    expect(controller.state.remainingSeconds, inInclusiveRange(600, 602));
    await controller.resume();
    await controller.endEarly();
    expect(completions, 0);
    final sessions = await repo.getBetween(
      DateTime(
        date.year,
        date.month,
        date.day,
      ).subtract(const Duration(days: 2)),
      date.add(const Duration(days: 1)),
    );
    expect(sessions.single.mode, TimerMode.stopwatch);
    expect(sessions.single.completed, isFalse);
    expect(sessions.single.actualMinutes, inInclusiveRange(10, 11));
  });
}
