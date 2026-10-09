import 'dart:math' as math;

import '../models/app_settings.dart';
import '../models/focus_session.dart';
import '../utils/date_time_utils.dart';

class CumulativeFocusStatistics {
  CumulativeFocusStatistics(
    List<FocusSession> sessions,
    AppSettings settings,
    DateTime now,
  ) {
    final today = AppDateUtils.dateOnly(now);
    final end = today.add(const Duration(days: 1));
    final history = sessions.where((s) => s.sessionDate.isBefore(end)).toList();
    start =
        settings.focusStatisticsStartDate != null
            ? AppDateUtils.dateOnly(settings.focusStatisticsStartDate!)
            : settings.focusStatisticsDays > 0
            ? today.subtract(Duration(days: settings.focusStatisticsDays - 1))
            : history.isEmpty
            ? today
            : history
                .map((s) => s.sessionDate)
                .reduce((a, b) => a.isBefore(b) ? a : b);
    final included =
        history.where((s) => !s.sessionDate.isBefore(start)).toList();
    count = included.length;
    minutes = included.fold(0, (sum, s) => sum + s.actualMinutes);
    days = math.max(1, today.difference(start).inDays + 1);
  }

  late final DateTime start;
  late final int count;
  late final int minutes;
  late final int days;
  int get dailyAverageMinutes => (minutes / days).round();
}
