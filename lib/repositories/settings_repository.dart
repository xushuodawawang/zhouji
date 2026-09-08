import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  const SettingsRepository(this._database);

  final AppDatabase _database;

  Stream<AppSettings> watch() => _database.watchSettings().map(_fromRow);

  Future<AppSettings> get() async => _fromRow(await _database.getSettings());

  Future<void> save(AppSettings settings) => _database.saveSettings(
    AppSettingsTableCompanion(
      themeMode: Value(settings.themeMode),
      weekViewMode: Value(settings.weekViewMode.name),
      scheduleZoom: Value(settings.scheduleZoom.name),
      detailHourHeight: Value(settings.detailHourHeight),
      overviewHourHeight: Value(settings.overviewHourHeight),
      pomodoroFocusMinutes: Value(settings.pomodoroFocusMinutes),
      shortBreakMinutes: Value(settings.shortBreakMinutes),
      longBreakMinutes: Value(settings.longBreakMinutes),
      longBreakInterval: Value(settings.longBreakInterval),
      notificationEnabled: Value(settings.notificationEnabled),
      autoCompleteTaskOnFocus: Value(settings.autoCompleteTaskOnFocus),
      focusMusicEnabled: Value(settings.focusMusicEnabled),
      focusMusicUri: Value(settings.focusMusicUri),
      focusMusicName: Value(settings.focusMusicName),
      timelineStartMinutes: Value(settings.timelineStartMinutes),
      timelineEndMinutes: Value(settings.timelineEndMinutes),
      autoColorEnabled: Value(settings.autoColorEnabled),
    ),
  );

  AppSettings _fromRow(AppSettingsRow row) => AppSettings(
    themeMode: row.themeMode,
    weekViewMode: WeekViewMode.values.byName(row.weekViewMode),
    scheduleZoom: ScheduleZoom.values.byName(row.scheduleZoom),
    detailHourHeight: row.detailHourHeight,
    overviewHourHeight: row.overviewHourHeight,
    pomodoroFocusMinutes: row.pomodoroFocusMinutes,
    shortBreakMinutes: row.shortBreakMinutes,
    longBreakMinutes: row.longBreakMinutes,
    longBreakInterval: row.longBreakInterval,
    notificationEnabled: row.notificationEnabled,
    autoCompleteTaskOnFocus: row.autoCompleteTaskOnFocus,
    focusMusicEnabled: row.focusMusicEnabled,
    focusMusicUri: row.focusMusicUri,
    focusMusicName: row.focusMusicName,
    timelineStartMinutes: row.timelineStartMinutes,
    timelineEndMinutes: row.timelineEndMinutes,
    autoColorEnabled: row.autoColorEnabled,
  );
}
