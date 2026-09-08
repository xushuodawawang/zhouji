import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/utils/timeline_position_calculator.dart';

void main() {
  group('时间轴位置换算', () {
    test('任务顶部和高度统一由每小时高度计算', () {
      expect(TimelinePositionCalculator.topForMinutes(9 * 60, 56), 504);
      expect(
        TimelinePositionCalculator.topForMinutes(
          9 * 60,
          56,
          startMinutes: 7 * 60,
        ),
        112,
      );
      expect(
        TimelinePositionCalculator.heightForRange(9 * 60, 11 * 60, 56),
        112,
      );
      expect(
        TimelinePositionCalculator.heightForRange(9 * 60, 11 * 60, 112),
        224,
      );
    });

    test('坐标可以还原为分钟且缩放限制在12至120', () {
      final offset = TimelinePositionCalculator.topForMinutes(14 * 60 + 15, 64);
      expect(
        TimelinePositionCalculator.rawMinutesForOffset(offset, 64),
        14 * 60 + 15,
      );
      expect(TimelinePositionCalculator.clampHourHeight(8), 12);
      expect(TimelinePositionCalculator.clampHourHeight(160), 120);
    });

    test('适配整天按24小时计算，支持自定义范围', () {
      expect(TimelinePositionCalculator.fitHourHeight(24 * 40), 40);
      expect(
        TimelinePositionCalculator.fitHourHeight(
          24 * 40,
          startMinutes: 360,
          endMinutes: 1800,
        ),
        40,
      );
      expect(TimelinePositionCalculator.fitHourHeight(200), 12);
      expect(TimelinePositionCalculator.fitHourHeight(3000), 120);
    });
  });
}
