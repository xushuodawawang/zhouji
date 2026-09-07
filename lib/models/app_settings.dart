enum WeekViewMode { overview, detail }

enum ScheduleZoom { compact, standard, spacious }

class AppSettings {
  const AppSettings({
    this.themeMode = 'system',
    this.weekViewMode = WeekViewMode.detail,
    this.scheduleZoom = ScheduleZoom.standard,
    this.detailHourHeight = 56,
    this.overviewHourHeight = 28,
    this.pomodoroFocusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.longBreakInterval = 4,
    this.notificationEnabled = false,
  });

  final String themeMode;
  final WeekViewMode weekViewMode;
  final ScheduleZoom scheduleZoom;
  final double detailHourHeight;
  final double overviewHourHeight;
  final int pomodoroFocusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakInterval;
  final bool notificationEnabled;

  AppSettings copyWith({
    String? themeMode,
    WeekViewMode? weekViewMode,
    ScheduleZoom? scheduleZoom,
    double? detailHourHeight,
    double? overviewHourHeight,
    int? pomodoroFocusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? longBreakInterval,
    bool? notificationEnabled,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    weekViewMode: weekViewMode ?? this.weekViewMode,
    scheduleZoom: scheduleZoom ?? this.scheduleZoom,
    detailHourHeight: detailHourHeight ?? this.detailHourHeight,
    overviewHourHeight: overviewHourHeight ?? this.overviewHourHeight,
    pomodoroFocusMinutes: pomodoroFocusMinutes ?? this.pomodoroFocusMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    longBreakInterval: longBreakInterval ?? this.longBreakInterval,
    notificationEnabled: notificationEnabled ?? this.notificationEnabled,
  );
}
