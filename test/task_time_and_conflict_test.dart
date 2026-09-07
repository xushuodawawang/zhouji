import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/services/task_conflict_service.dart';
import 'package:zhouji/utils/time_snap_calculator.dart';

void main() {
  group('时间吸附', () {
    test('点击时间格吸附到最近15分钟', () {
      expect(TimeSnapCalculator.nearest(14 * 60 + 20), 14 * 60 + 15);
      expect(TimeSnapCalculator.nearest(14 * 60 + 23), 14 * 60 + 30);
    });

    test('默认开始时间向上取整并保留一小时', () {
      final range = TimeSnapCalculator.defaultRange(
        DateTime(2026, 7, 24, 9, 7),
      );
      expect(range.start, 9 * 60 + 15);
      expect(range.end, 10 * 60 + 15);
    });

    test('接近24点时仍生成当天范围内的一小时任务', () {
      final range = TimeSnapCalculator.defaultRange(
        DateTime(2026, 7, 24, 23, 57),
      );
      expect(range.start, 23 * 60);
      expect(range.end, 24 * 60);
    });
  });

  group('任务冲突', () {
    final date = DateTime(2026, 7, 24);
    final existing = PlanTask(
      id: 1,
      title: '已有任务',
      taskDate: date,
      startMinutes: 600,
      endMinutes: 660,
      colorValue: 0xFF80A9A5,
      note: '',
      isCompleted: false,
      createdAt: date,
      updatedAt: date,
    );

    test('首尾相接不冲突，时间相交才冲突', () {
      expect(
        TaskConflictService.overlaps(
          start: 540,
          end: 600,
          otherStart: 600,
          otherEnd: 660,
        ),
        isFalse,
      );
      expect(
        TaskConflictService.overlaps(
          start: 599,
          end: 620,
          otherStart: 600,
          otherEnd: 660,
        ),
        isTrue,
      );
    });

    test('忽略自身并返回冲突任务名称与时间', () {
      final conflict = TaskConflictService.findConflict(
        PlanTaskDraft(
          title: '新任务',
          taskDate: date,
          startMinutes: 630,
          endMinutes: 690,
          colorValue: 0xFF80A9A5,
        ),
        [existing],
      );
      expect(conflict?.id, existing.id);
      expect(
        TaskConflictService.message(
          title: existing.title,
          startMinutes: existing.startMinutes,
          endMinutes: existing.endMinutes,
        ),
        contains('已有任务'),
      );
      expect(
        TaskConflictService.message(
          title: existing.title,
          startMinutes: existing.startMinutes,
          endMinutes: existing.endMinutes,
        ),
        contains('10:00－11:00'),
      );

      final selfEdit = TaskConflictService.findConflict(
        PlanTaskDraft.fromTask(existing),
        [existing],
      );
      expect(selfEdit, isNull);
    });
  });
}
