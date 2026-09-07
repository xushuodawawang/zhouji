import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/repositories/plan_task_repository.dart';

void main() {
  late AppDatabase database;
  late PlanTaskRepository repository;
  final monday = DateTime(2026, 7, 20);

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = PlanTaskRepository(database);
  });

  tearDown(() => database.close());

  PlanTaskDraft draft({
    int? id,
    DateTime? date,
    int start = 420,
    int end = 480,
    bool completed = false,
  }) {
    return PlanTaskDraft(
      id: id,
      title: '晨间复习',
      taskDate: date ?? monday,
      startMinutes: start,
      endMinutes: end,
      colorValue: 0xFF80A9A5,
      isCompleted: completed,
    );
  }

  test('创建07:00至08:00任务并按周读取', () async {
    await repository.save(draft());
    final tasks = await repository.watchWeek(monday).first;

    expect(tasks, hasLength(1));
    expect(tasks.single.startMinutes, 420);
    expect(tasks.single.endMinutes, 480);
  });

  test('阻止同一天的冲突任务', () async {
    await repository.save(draft());

    expect(
      () => repository.save(draft(start: 450, end: 510)),
      throwsA(isA<TaskConflictException>()),
    );
  });

  test('拖动任务到另一日期并调整结束时间', () async {
    final id = await repository.save(draft());
    await repository.save(
      draft(
        id: id,
        date: monday.add(const Duration(days: 2)),
        start: 540,
        end: 630,
      ),
    );

    final tasks = await repository.watchWeek(monday).first;
    expect(tasks.single.taskDate, monday.add(const Duration(days: 2)));
    expect(tasks.single.startMinutes, 540);
    expect(tasks.single.endMinutes, 630);
  });

  test('标记完成并删除任务', () async {
    final id = await repository.save(draft());
    await repository.setCompleted(id, true);
    var tasks = await repository.watchWeek(monday).first;
    expect(tasks.single.isCompleted, isTrue);

    await repository.delete(id);
    tasks = await repository.watchWeek(monday).first;
    expect(tasks, isEmpty);
  });

  test('允许精确到分钟且最短5分钟，拒绝空名称和过短任务', () async {
    await repository.save(draft(start: 423, end: 428));
    final tasks = await repository.watchWeek(monday).first;
    expect(tasks.single.durationMinutes, 5);

    expect(
      () => repository.save(
        PlanTaskDraft(
          title: ' ',
          taskDate: monday,
          startMinutes: 420,
          endMinutes: 480,
          colorValue: 0xFF80A9A5,
        ),
      ),
      throwsA(isA<RepositoryException>()),
    );
    expect(
      () => repository.save(draft(start: 420, end: 424)),
      throwsA(isA<RepositoryException>()),
    );
  });

  test('冲突错误包含已有任务名称，全天任务不参与冲突', () async {
    await repository.save(draft());
    await expectLater(
      repository.save(draft(start: 450, end: 510)),
      throwsA(
        isA<TaskConflictException>().having(
          (error) => error.toString(),
          '提示',
          contains('晨间复习'),
        ),
      ),
    );
    await repository.save(draft(start: 450, end: 510).copyWith(isAllDay: true));
    expect((await repository.watchWeek(monday).first), hasLength(2));
  });

  test('复制任务并保留分类和锁定状态', () async {
    final id = await repository.save(
      draft().copyWith(categoryId: 2, isLocked: true),
    );
    final source = (await repository.watchWeek(monday).first).singleWhere(
      (task) => task.id == id,
    );
    await repository.copy(source, date: monday.add(const Duration(days: 1)));
    final tasks = await repository.watchWeek(monday).first;

    expect(tasks, hasLength(2));
    expect(tasks.last.taskDate, monday.add(const Duration(days: 1)));
    expect(tasks.last.categoryId, 2);
    expect(tasks.last.isLocked, isTrue);
    expect(tasks.last.isCompleted, isFalse);
  });
}
