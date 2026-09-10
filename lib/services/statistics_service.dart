import '../models/activity_record.dart';
import '../models/focus_session.dart';
import '../models/plan_task.dart';
import '../utils/app_colors.dart';
import '../utils/date_time_utils.dart';

enum StatisticsRange { today, week, month }

class StatisticsPeriod {
  const StatisticsPeriod({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  static StatisticsPeriod forRange(StatisticsRange range, DateTime now) {
    final today = AppDateUtils.dateOnly(now);
    return switch (range) {
      StatisticsRange.today => StatisticsPeriod(
        start: today,
        end: today.add(const Duration(days: 1)),
      ),
      StatisticsRange.week => StatisticsPeriod(
        start: AppDateUtils.startOfWeek(today),
        end: AppDateUtils.endOfWeekExclusive(today),
      ),
      StatisticsRange.month => StatisticsPeriod(
        start: AppDateUtils.startOfMonth(today),
        end: AppDateUtils.endOfMonthExclusive(today),
      ),
    };
  }
}

class FocusSubjectStat {
  const FocusSubjectStat({
    required this.name,
    required this.minutes,
    required this.colorValue,
  });

  final String name;
  final int minutes;
  final int colorValue;
}

class TrendStat {
  const TrendStat({required this.label, required this.minutes});

  final String label;
  final int minutes;
}

class StatisticsData {
  const StatisticsData({
    required this.taskCount,
    required this.completedTaskCount,
    required this.plannedMinutes,
    required this.actualRecordMinutes,
    required this.focusMinutes,
    required this.focusCount,
    required this.completedPomodoros,
    required this.focusStats,
    required this.trend,
  });

  final int taskCount;
  final int completedTaskCount;
  final int plannedMinutes;
  final int actualRecordMinutes;
  final int focusMinutes;
  final int focusCount;
  final int completedPomodoros;
  final List<FocusSubjectStat> focusStats;
  final List<TrendStat> trend;

  double get completionRate =>
      taskCount == 0 ? 0 : completedTaskCount / taskCount;
}

class StatisticsService {
  const StatisticsService();

  StatisticsData calculate({
    required StatisticsRange range,
    required StatisticsPeriod period,
    required List<PlanTask> tasks,
    required List<ActivityRecord> records,
    required List<FocusSession> sessions,
  }) {
    final taskById = {for (final task in tasks) task.id: task};
    final grouped = <String, ({String name, int minutes})>{};
    for (final session in sessions) {
      final sessionTitle = session.note.trim();
      final taskTitle = taskById[session.taskId]?.title.trim() ?? '';
      final name =
          sessionTitle.isNotEmpty
              ? sessionTitle
              : taskTitle.isNotEmpty
              ? taskTitle
              : '自由专注';
      final key = name.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      final old = grouped[key];
      grouped[key] = (
        name: old?.name ?? name,
        minutes: (old?.minutes ?? 0) + session.actualMinutes,
      );
    }
    var focusStats =
        grouped.entries
            .map(
              (entry) => FocusSubjectStat(
                name: entry.value.name,
                minutes: entry.value.minutes,
                colorValue: 0,
              ),
            )
            .toList()
          ..sort((a, b) => b.minutes.compareTo(a.minutes));
    if (focusStats.length > 5) {
      final otherMinutes = focusStats
          .skip(5)
          .fold(0, (sum, item) => sum + item.minutes);
      focusStats = [
        ...focusStats.take(5),
        FocusSubjectStat(
          name: '其他',
          minutes: otherMinutes,
          colorValue: 0xFF83988E,
        ),
      ];
    }
    focusStats = [
      for (var index = 0; index < focusStats.length; index++)
        FocusSubjectStat(
          name: focusStats[index].name,
          minutes: focusStats[index].minutes,
          colorValue: AppColors.focusChartColor(index),
        ),
    ];

    return StatisticsData(
      taskCount: tasks.length,
      completedTaskCount: tasks.where((task) => task.isCompleted).length,
      plannedMinutes: tasks
          .where((task) => !task.isAllDay)
          .fold(0, (sum, task) => sum + task.durationMinutes),
      actualRecordMinutes: records
          .where((record) => record.isCompleted)
          .fold(0, (sum, record) => sum + record.durationMinutes),
      focusMinutes: sessions.fold(
        0,
        (sum, session) => sum + session.actualMinutes,
      ),
      focusCount: sessions.length,
      completedPomodoros:
          sessions
              .where(
                (session) =>
                    session.completed && session.mode == TimerMode.pomodoro,
              )
              .length,
      focusStats: focusStats,
      trend: _buildTrend(range, period, sessions),
    );
  }

  List<TrendStat> _buildTrend(
    StatisticsRange range,
    StatisticsPeriod period,
    List<FocusSession> sessions,
  ) {
    if (range == StatisticsRange.today) {
      return [
        for (var index = 0; index < sessions.length; index++)
          TrendStat(
            label: '${index + 1}',
            minutes: sessions[index].actualMinutes,
          ),
      ];
    }
    final days = period.end.difference(period.start).inDays;
    return [
      for (var index = 0; index < days; index++)
        TrendStat(
          label:
              range == StatisticsRange.week
                  ? AppDateUtils.weekdayShort(index + 1).replaceFirst('周', '')
                  : '${index + 1}',
          minutes: sessions
              .where(
                (session) => AppDateUtils.isSameDate(
                  session.sessionDate,
                  period.start.add(Duration(days: index)),
                ),
              )
              .fold(0, (sum, session) => sum + session.actualMinutes),
        ),
    ];
  }
}
