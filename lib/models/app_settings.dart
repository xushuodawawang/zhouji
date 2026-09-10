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
    this.autoCompleteTaskOnFocus = false,
    this.focusMusicEnabled = false,
    this.focusMusicUri = '',
    this.focusMusicName = '',
    this.focusLockEnabled = false,
    this.completionSoundEnabled = true,
    this.timelineStartMinutes = 0,
    this.timelineEndMinutes = 24 * 60,
    this.autoColorEnabled = true,
    this.taskCardOpacity = 0.72,
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
  final bool autoCompleteTaskOnFocus;
  final bool focusMusicEnabled;
  final String focusMusicUri;
  final String focusMusicName;
  final bool focusLockEnabled;
  final bool completionSoundEnabled;
  final int timelineStartMinutes;
  final int timelineEndMinutes;
  final bool autoColorEnabled;
  final double taskCardOpacity;

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
    bool? autoCompleteTaskOnFocus,
    bool? focusMusicEnabled,
    String? focusMusicUri,
    String? focusMusicName,
    bool? focusLockEnabled,
    bool? completionSoundEnabled,
    int? timelineStartMinutes,
    int? timelineEndMinutes,
    bool? autoColorEnabled,
    double? taskCardOpacity,
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
    autoCompleteTaskOnFocus:
        autoCompleteTaskOnFocus ?? this.autoCompleteTaskOnFocus,
    focusMusicEnabled: focusMusicEnabled ?? this.focusMusicEnabled,
    focusMusicUri: focusMusicUri ?? this.focusMusicUri,
    focusMusicName: focusMusicName ?? this.focusMusicName,
    focusLockEnabled: focusLockEnabled ?? this.focusLockEnabled,
    completionSoundEnabled:
        completionSoundEnabled ?? this.completionSoundEnabled,
    timelineStartMinutes: timelineStartMinutes ?? this.timelineStartMinutes,
    timelineEndMinutes: timelineEndMinutes ?? this.timelineEndMinutes,
    autoColorEnabled: autoColorEnabled ?? this.autoColorEnabled,
    taskCardOpacity: taskCardOpacity ?? this.taskCardOpacity,
  );
}
