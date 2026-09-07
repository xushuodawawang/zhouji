import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/utils/date_time_utils.dart';

void main() {
  group('日期与时间工具', () {
    test('正确计算周一到周日范围', () {
      final date = DateTime(2026, 7, 24);
      expect(AppDateUtils.startOfWeek(date), DateTime(2026, 7, 20));
      expect(AppDateUtils.endOfWeekExclusive(date), DateTime(2026, 7, 27));
      expect(AppDateUtils.weekRangeLabel(date), '7月20日－26日');
    });

    test('拖动时间吸附到15分钟并限制在07:00至24:00', () {
      expect(AppDateUtils.snapMinutes(421), 420);
      expect(AppDateUtils.snapMinutes(442), 435);
      expect(AppDateUtils.snapMinutes(443), 450);
      expect(AppDateUtils.snapMinutes(200), 420);
      expect(AppDateUtils.snapMinutes(1500), 1440);
      expect(AppDateUtils.formatMinutes(450), '07:30');
      expect(AppDateUtils.formatMinutes(1440), '24:00');
    });

    test('动态计算待完成、已完成和未完成状态', () {
      final base = PlanTask(
        id: 1,
        title: '复习',
        taskDate: DateTime(2026, 7, 24),
        startMinutes: 420,
        endMinutes: 480,
        colorValue: 0xFF80A9A5,
        note: '',
        isCompleted: false,
        createdAt: DateTime(2026, 7, 20),
        updatedAt: DateTime(2026, 7, 20),
      );
      expect(
        base.statusAt(DateTime(2026, 7, 24, 7, 30)),
        TaskDisplayStatus.pending,
      );
      expect(base.statusAt(DateTime(2026, 7, 24, 8)), TaskDisplayStatus.missed);
      expect(
        base.copyWith(isCompleted: true).statusAt(DateTime(2026, 7, 25)),
        TaskDisplayStatus.completed,
      );
    });
  });
}
