import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/utils/timeline_position_calculator.dart';

void main() {
  group('时间轴位置换算', () {
    test('任务顶部和高度统一由每小时高度计算', () {
      expect(TimelinePositionCalculator.topForMinutes(9 * 60, 56), 112);
      expect(
        TimelinePositionCalculator.heightForRange(9 * 60, 11 * 60, 56),
        112,
      );
      expect(
        TimelinePositionCalculator.heightForRange(9 * 60, 11 * 60, 112),
        224,
      );
    });

    test('坐标可以还原为分钟且缩放限制在28至120', () {
      final offset = TimelinePositionCalculator.topForMinutes(14 * 60 + 15, 64);
      expect(
        TimelinePositionCalculator.rawMinutesForOffset(offset, 64),
        14 * 60 + 15,
      );
      expect(TimelinePositionCalculator.clampHourHeight(8), 28);
      expect(TimelinePositionCalculator.clampHourHeight(160), 120);
    });

    test('适配整天按17小时计算', () {
      expect(TimelinePositionCalculator.fitHourHeight(17 * 40), 40);
      expect(TimelinePositionCalculator.fitHourHeight(200), 28);
      expect(TimelinePositionCalculator.fitHourHeight(3000), 120);
    });
  });
}
