import 'date_time_utils.dart';

abstract final class TimeSnapCalculator {
  static int nearest(
    int minutes, {
    int step = 15,
    int min = AppDateUtils.dayStartMinutes,
    int max = AppDateUtils.dayEndMinutes,
  }) {
    final value = (minutes / step).round() * step;
    return value.clamp(min, max);
  }

  static int ceil(
    int minutes, {
    int step = 15,
    int min = AppDateUtils.dayStartMinutes,
    int max = AppDateUtils.dayEndMinutes,
  }) {
    final value = ((minutes + step - 1) ~/ step) * step;
    return value.clamp(min, max);
  }

  static ({int start, int end}) defaultRange(DateTime now) {
    final current = now.hour * 60 + now.minute;
    final start = ceil(current, max: AppDateUtils.dayEndMinutes - 60);
    return (start: start, end: start + 60);
  }
}
