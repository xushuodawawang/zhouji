import 'package:intl/intl.dart';

abstract final class AppDateUtils {
  static const int dayStartMinutes = 0;
  static const int dayEndMinutes = 24 * 60;
  static const int maximumTimelineMinutes = 30 * 60;
  static const int slotMinutes = 15;
  static const int manualMinimumMinutes = 5;
  static const int dragMinimumMinutes = 15;

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime startOfWeek(DateTime value) {
    final date = dateOnly(value);
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  static DateTime endOfWeekExclusive(DateTime value) =>
      startOfWeek(value).add(const Duration(days: 7));

  static bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static int snapMinutes(
    int minutes, {
    int interval = slotMinutes,
    int min = dayStartMinutes,
    int max = dayEndMinutes,
  }) {
    final snapped = (minutes / interval).round() * interval;
    return snapped.clamp(min, max);
  }

  static int minutesSinceMidnight(DateTime value) =>
      value.hour * 60 + value.minute;

  static DateTime atMinutes(DateTime date, int minutes) =>
      dateOnly(date).add(Duration(minutes: minutes));

  static DateTime startOfMonth(DateTime value) =>
      DateTime(value.year, value.month);

  static DateTime endOfMonthExclusive(DateTime value) =>
      DateTime(value.year, value.month + 1);

  static String yearMonthKey(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}';

  static String formatMinutes(int minutes) {
    if (minutes == dayEndMinutes) return '24:00';
    final nextDay = minutes > dayEndMinutes;
    final normalized = minutes % dayEndMinutes;
    final hour = normalized ~/ 60;
    final minute = normalized % 60;
    final clock =
        '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
    return nextDay ? '次日 $clock' : clock;
  }

  static String formatDuration(int minutes) {
    if (minutes <= 0) return '0分钟';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    if (hours == 0) return '$rest分钟';
    if (rest == 0) return '$hours小时';
    return '$hours小时$rest分钟';
  }

  static String weekRangeLabel(DateTime weekStart) {
    final start = startOfWeek(weekStart);
    final end = start.add(const Duration(days: 6));
    if (start.year != end.year) {
      return '${DateFormat('yyyy年M月d日').format(start)}－'
          '${DateFormat('yyyy年M月d日').format(end)}';
    }
    if (start.month != end.month) {
      return '${DateFormat('M月d日').format(start)}－'
          '${DateFormat('M月d日').format(end)}';
    }
    return '${start.month}月${start.day}日－${end.day}日';
  }

  static String dateLabel(DateTime value) =>
      DateFormat('M月d日 EEEE', 'zh_CN').format(value);

  static String weekdayShort(int weekday) =>
      const ['周一', '周二', '周三', '周四', '周五', '周六', '周日'][weekday - 1];
}
