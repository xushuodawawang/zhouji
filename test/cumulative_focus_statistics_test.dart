import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/models/app_settings.dart';
import 'package:zhouji/models/focus_session.dart';
import 'package:zhouji/services/cumulative_focus_statistics.dart';

FocusSession session(int day, int minutes) => FocusSession(
  id: day,
  sessionDate: DateTime(2026, 10, day),
  startedAt: DateTime(2026, 10, day, 10),
  endedAt: DateTime(2026, 10, day, 11),
  plannedMinutes: minutes,
  actualMinutes: minutes,
  mode: TimerMode.pomodoro,
  completed: true,
);

void main() {
  final now = DateTime(2026, 10, 9);
  final history = [
    session(1, 60),
    session(3, 30),
    session(9, 90),
    session(10, 50),
  ];
  test('全部历史统计排除未来记录，日均包含没有专注的日期', () {
    final data = CumulativeFocusStatistics(history, const AppSettings(), now);
    expect(data.count, 3);
    expect(data.minutes, 180);
    expect(data.days, 9);
    expect(data.dailyAverageMinutes, 20);
  });
  test('最近七天包含首尾两天，从指定日期起包含当天', () {
    final recent = CumulativeFocusStatistics(
      history,
      const AppSettings(focusStatisticsDays: 7),
      now,
    );
    expect(recent.start, DateTime(2026, 10, 3));
    expect(recent.count, 2);
    expect(recent.minutes, 120);
    expect(recent.days, 7);
    final from = CumulativeFocusStatistics(
      history,
      AppSettings(focusStatisticsStartDate: now),
      now,
    );
    expect(from.count, 1);
    expect(from.minutes, 90);
    expect(from.days, 1);
  });
  test('无记录与未来起始日期均显示零，日均不会除以零', () {
    final empty = CumulativeFocusStatistics([], const AppSettings(), now);
    expect(empty.dailyAverageMinutes, 0);
    final future = CumulativeFocusStatistics(
      history,
      AppSettings(focusStatisticsStartDate: DateTime(2026, 11)),
      now,
    );
    expect(future.count, 0);
    expect(future.minutes, 0);
    expect(future.dailyAverageMinutes, 0);
  });
}
