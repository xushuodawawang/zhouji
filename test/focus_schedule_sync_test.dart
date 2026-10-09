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
  late FocusRepository focus;
  late PlanTaskRepository plans;
  late DateTime now;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    focus = FocusRepository(db);
    plans = PlanTaskRepository(db);
    now = DateTime(2026, 10, 9, 10);
  });
  tearDown(() => db.close());

  Future<FocusTimerController> controller() async {
    final timer = FocusTimerController(
      repository: focus,
      notifications: NotificationService(),
      settings: const AppSettings(),
      now: () => now,
    );
    addTearDown(timer.dispose);
    while (timer.state.restoring) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
    return timer;
  }

  test('两小时倒计时一小时提前结束，即使无界面刷新也回填60分钟', () async {
    final id = await plans.placeFocusTask(
      title: '数学',
      startedAt: now,
      plannedMinutes: 120,
    );
    final timer = await controller();
    timer.selectTask(taskId: id, title: '数学', focusMinutes: 120);
    await timer.start();
    now = now.add(const Duration(hours: 1));
    await Future.wait([timer.endEarly(), timer.endEarly()]);
    final plan = (await plans.watchDate(now).first).single;
    expect(plan.startMinutes, 600);
    expect(plan.endMinutes, 660);
    expect(plan.durationMinutes, 60);
    expect(plan.focusMinutes, 120);
    expect(plan.isCompleted, isFalse);
    final sessions = await focus.getBetween(
      DateTime(2026, 10, 9),
      DateTime(2026, 10, 10),
    );
    expect(sessions, hasLength(1));
    expect(sessions.single.actualMinutes, 60);
    expect(sessions.single.plannedMinutes, 120);
  });

  test('正向计时恢复时增长日程，暂停两小时不计入，继续后按实际时长结束', () async {
    final start = now;
    final id = await plans.placeFocusTask(
      title: '408',
      startedAt: start,
      plannedMinutes: 0,
    );
    await focus.saveActiveTimer(
      ActiveTimer(
        mode: TimerMode.stopwatch,
        phase: TimerPhase.focus,
        startedAt: start,
        expectedEndAt: start,
        remainingSeconds: 0,
        totalSeconds: 0,
        isRunning: true,
        cycleCount: 0,
        taskId: id,
      ),
    );
    now = start.add(const Duration(minutes: 20));
    final timer = await controller();
    await timer.pause();
    expect((await plans.watchDate(now).first).single.durationMinutes, 20);
    now = now.add(const Duration(hours: 2));
    expect((await plans.watchDate(now).first).single.durationMinutes, 20);
    await timer.resume();
    now = now.add(const Duration(minutes: 10));
    await timer.endEarly();
    expect((await plans.watchDate(now).first).single.durationMinutes, 30);
    expect(
      (await focus.getBetween(
        DateTime(2026, 10, 9),
        DateTime(2026, 10, 10),
      )).single.actualMinutes,
      30,
    );
  });

  test('正向计时超出相邻计划时保留相邻计划剩余部分，跨午夜正确回填', () async {
    now = DateTime(2026, 10, 9, 23, 50);
    final id = await plans.placeFocusTask(
      title: '数学',
      startedAt: now,
      plannedMinutes: 0,
    );
    await plans.save(
      PlanTaskDraft(
        title: '英语',
        taskDate: DateTime(2026, 10, 10),
        startMinutes: 0,
        endMinutes: 60,
        colorValue: 0xFF3569A8,
      ),
    );
    final timer = await controller();
    timer.selectTask(taskId: id, title: '数学', focusMinutes: 0);
    await timer.start();
    now = now.add(const Duration(minutes: 30));
    await timer.endEarly();
    final task = (await plans.watchDate(DateTime(2026, 10, 9)).first).single;
    expect(task.endMinutes, 1460);
    expect(task.durationMinutes, 30);
    final next = (await plans.watchDate(now).first).single;
    expect(next.title, '英语');
    expect(next.startMinutes, 20);
    expect(next.endMinutes, 60);
  });

  test('同一任务多次专注累计时长，重置也保存已专注时间', () async {
    final id = await plans.placeFocusTask(
      title: '数学',
      startedAt: now,
      plannedMinutes: 120,
    );
    final timer = await controller();
    timer.selectTask(taskId: id, title: '数学', focusMinutes: 120);
    await timer.start();
    now = now.add(const Duration(minutes: 10));
    await timer.endEarly();
    timer.selectTask(taskId: id, title: '数学', focusMinutes: 120);
    await timer.start();
    now = now.add(const Duration(minutes: 20));
    await timer.reset();
    expect((await plans.watchDate(now).first).single.durationMinutes, 30);
    expect(await focus.loadActiveTimer(), isNull);
  });

  test('替换为不同任务后，旧任务专注记录不计入新任务时长', () async {
    final id = await plans.placeFocusTask(
      title: '数学',
      startedAt: now,
      plannedMinutes: 120,
    );
    final timer = await controller();
    timer.selectTask(taskId: id, title: '数学', focusMinutes: 120);
    await timer.start();
    now = now.add(const Duration(minutes: 10));
    await timer.endEarly();
    // An overlapping temporary task reuses the existing plan row.
    now = now.subtract(const Duration(minutes: 5));
    final replacementId = await plans.placeFocusTask(
      title: '英语',
      startedAt: now,
      plannedMinutes: 60,
    );
    expect(replacementId, id);
    timer.selectTask(taskId: replacementId, title: '英语', focusMinutes: 60);
    await timer.start();
    now = now.add(const Duration(minutes: 20));
    await timer.endEarly();
    final plan = (await plans.watchDate(now).first).single;
    expect(plan.title, '英语');
    expect(plan.durationMinutes, 20);
    expect(plan.startMinutes, 605);
  });
}
