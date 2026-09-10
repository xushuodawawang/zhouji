import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../utils/app_colors.dart';

part 'app_database.g.dart';

@DataClassName('PlanTaskRow')
class PlanTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get taskDate => dateTime()();
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  IntColumn get colorValue => integer()();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // V2 fields are intentionally compatible with every V1 row.
  IntColumn get categoryId => integer().nullable()();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get plannedDurationMinutes => integer().nullable()();
  IntColumn get focusMinutes => integer().nullable()();
}

@DataClassName('ActivityRecordRow')
class ActivityRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordDate => dateTime()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  IntColumn get startMinutes => integer().nullable()();
  IntColumn get endMinutes => integer().nullable()();
  IntColumn get durationMinutes => integer()();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('DailySummaryRow')
class DailySummaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get summaryDate => dateTime().unique()();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('TaskCategoryRow')
class TaskCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40).unique()();
  IntColumn get colorValue => integer()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('FocusSessionRow')
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get sessionDate => dateTime()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get plannedMinutes => integer()();
  IntColumn get actualMinutes => integer()();
  TextColumn get mode => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get taskId => integer().nullable()();
  IntColumn get categoryId => integer().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('ActiveTimerRow')
class ActiveTimers extends Table {
  IntColumn get id => integer()();
  TextColumn get mode => text()();
  TextColumn get phase => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get expectedEndAt => dateTime()();
  IntColumn get remainingSeconds => integer()();
  IntColumn get totalSeconds => integer().nullable()();
  TextColumn get title => text().withDefault(const Constant(''))();
  BoolColumn get isRunning => boolean()();
  IntColumn get cycleCount => integer().withDefault(const Constant(0))();
  IntColumn get taskId => integer().nullable()();
  IntColumn get categoryId => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FocusPresetRow')
class FocusPresets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get minutes => integer().withDefault(const Constant(25))();
  IntColumn get colorValue => integer()();
}

@DataClassName('MonthlyGoalRow')
class MonthlyGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get yearMonth => text()();
  TextColumn get content => text().withLength(min: 1, max: 500)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {yearMonth, content},
  ];
}

@DataClassName('AppSettingsRow')
class AppSettingsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get weekViewMode => text().withDefault(const Constant('detail'))();
  TextColumn get scheduleZoom =>
      text().withDefault(const Constant('standard'))();
  RealColumn get detailHourHeight => real().withDefault(const Constant(56.0))();
  RealColumn get overviewHourHeight =>
      real().withDefault(const Constant(28.0))();
  IntColumn get pomodoroFocusMinutes =>
      integer().withDefault(const Constant(25))();
  IntColumn get shortBreakMinutes => integer().withDefault(const Constant(5))();
  IntColumn get longBreakMinutes => integer().withDefault(const Constant(15))();
  IntColumn get longBreakInterval => integer().withDefault(const Constant(4))();
  BoolColumn get notificationEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get autoCompleteTaskOnFocus =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get focusMusicEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get focusMusicUri => text().withDefault(const Constant(''))();
  TextColumn get focusMusicName => text().withDefault(const Constant(''))();
  BoolColumn get focusLockEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get completionSoundEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get timelineStartMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get timelineEndMinutes =>
      integer().withDefault(const Constant(1440))();
  BoolColumn get autoColorEnabled =>
      boolean().withDefault(const Constant(true))();
  RealColumn get taskCardOpacity => real().withDefault(const Constant(0.72))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TaskConflictException implements Exception {
  const TaskConflictException(
    this.conflictingTitle,
    this.startMinutes,
    this.endMinutes,
  );

  final String conflictingTitle;
  final int startMinutes;
  final int endMinutes;

  @override
  String toString() =>
      '该时间段与“$conflictingTitle”'
      '（${_formatMinutes(startMinutes)}－${_formatMinutes(endMinutes)}）冲突';

  static String _formatMinutes(int value) {
    if (value == 1440) return '24:00';
    return '${(value ~/ 60).toString().padLeft(2, '0')}:'
        '${(value % 60).toString().padLeft(2, '0')}';
  }
}

@DriftDatabase(
  tables: [
    PlanTasks,
    ActivityRecords,
    DailySummaries,
    TaskCategories,
    FocusSessions,
    ActiveTimers,
    MonthlyGoals,
    AppSettingsTable,
    FocusPresets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(taskCategories);
        await migrator.createTable(focusSessions);
        await migrator.createTable(activeTimers);
        await migrator.createTable(monthlyGoals);
        await migrator.createTable(appSettingsTable);
        await migrator.addColumn(planTasks, planTasks.categoryId);
        await migrator.addColumn(planTasks, planTasks.isLocked);
        await migrator.addColumn(planTasks, planTasks.isAllDay);
        await migrator.addColumn(planTasks, planTasks.sortOrder);
        await migrator.addColumn(planTasks, planTasks.completedAt);
        await migrator.addColumn(planTasks, planTasks.plannedDurationMinutes);
      }
      if (from >= 2 && from < 3) {
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.detailHourHeight,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.overviewHourHeight,
        );
      }
      if (from < 4) {
        await migrator.createTable(focusPresets);
        await migrator.addColumn(planTasks, planTasks.focusMinutes);
        await migrator.addColumn(activityRecords, activityRecords.isCompleted);
      }
      if (from >= 2 && from < 4) {
        await migrator.addColumn(activeTimers, activeTimers.totalSeconds);
        await migrator.addColumn(activeTimers, activeTimers.title);
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.autoCompleteTaskOnFocus,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.focusMusicEnabled,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.focusMusicUri,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.focusMusicName,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.timelineStartMinutes,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.timelineEndMinutes,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.autoColorEnabled,
        );
      }
      if (from >= 2 && from < 5) {
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.taskCardOpacity,
        );
      }
      if (from >= 2 && from < 6) {
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.focusLockEnabled,
        );
        await migrator.addColumn(
          appSettingsTable,
          appSettingsTable.completionSoundEnabled,
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Additive indexes also cover databases created by earlier app versions.
      // Date-range queries should not scan years of unrelated history.
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_plan_date_start ON plan_tasks(task_date, start_minutes)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_record_date ON activity_records(record_date)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_focus_date ON focus_sessions(session_date)',
      );
      await _seedV2Defaults();
      await _normalizeAutomaticTaskColors();
    },
  );

  Future<void> _seedV2Defaults() async {
    final now = DateTime.now();
    const defaults = <(String, int)>[
      ('学习', 0xFF6B8FAD),
      ('工作', 0xFF719B87),
      ('生活', 0xFFC09A76),
      ('运动', 0xFF7F9E8A),
      ('阅读', 0xFF8C86A8),
      ('其他', 0xFF8B929A),
    ];
    await batch((batch) {
      batch.insertAll(taskCategories, [
        for (final item in defaults)
          TaskCategoriesCompanion.insert(
            name: item.$1,
            colorValue: item.$2,
            isDefault: const Value(true),
            createdAt: now,
          ),
      ], mode: InsertMode.insertOrIgnore);
      batch.insert(
        appSettingsTable,
        AppSettingsTableCompanion.insert(id: const Value(1), updatedAt: now),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Stream<List<PlanTaskRow>> watchTasksBetween(DateTime start, DateTime end) {
    final query =
        select(planTasks)
          ..where(
            (row) =>
                row.taskDate.isBiggerOrEqualValue(start) &
                row.taskDate.isSmallerThanValue(end),
          )
          ..orderBy([
            (row) => OrderingTerm.asc(row.taskDate),
            (row) => OrderingTerm.desc(row.isAllDay),
            (row) => OrderingTerm.asc(row.sortOrder),
            (row) => OrderingTerm.asc(row.startMinutes),
          ]);
    return query.watch();
  }

  Future<List<PlanTaskRow>> getTasksBetween(DateTime start, DateTime end) =>
      (select(planTasks)..where(
        (row) =>
            row.taskDate.isBiggerOrEqualValue(start) &
            row.taskDate.isSmallerThanValue(end),
      )).get();

  Stream<List<PlanTaskRow>> watchTasksForDate(DateTime date) =>
      watchTasksBetween(date, date.add(const Duration(days: 1)));

  Future<int> saveTask(PlanTasksCompanion data, {int? taskId}) {
    return transaction(() async {
      final isAllDay = data.isAllDay.present && data.isAllDay.value;
      if (!isAllDay) {
        final date = data.taskDate.value;
        final start = data.startMinutes.value;
        final end = data.endMinutes.value;
        final conflictQuery = select(planTasks)..where((row) {
          var predicate =
              row.taskDate.isBiggerOrEqualValue(
                date.subtract(const Duration(days: 2)),
              ) &
              row.taskDate.isSmallerOrEqualValue(
                date.add(const Duration(days: 2)),
              ) &
              row.isAllDay.equals(false);
          if (taskId != null) {
            predicate = predicate & row.id.equals(taskId).not();
          }
          return predicate;
        });
        final candidates = await conflictQuery.get();
        final absoluteStart = date.add(Duration(minutes: start));
        final absoluteEnd = date.add(Duration(minutes: end));
        final conflict =
            candidates
                .where(
                  (row) =>
                      row.taskDate
                          .add(Duration(minutes: row.startMinutes))
                          .isBefore(absoluteEnd) &&
                      row.taskDate
                          .add(Duration(minutes: row.endMinutes))
                          .isAfter(absoluteStart),
                )
                .firstOrNull;
        if (conflict != null) {
          throw TaskConflictException(
            conflict.title,
            conflict.startMinutes,
            conflict.endMinutes,
          );
        }
      }

      if (taskId == null) {
        return into(planTasks).insert(data);
      }
      await (update(planTasks)
        ..where((row) => row.id.equals(taskId))).write(data);
      return taskId;
    });
  }

  Future<void> _normalizeAutomaticTaskColors() async {
    final settings = await getSettings();
    if (!settings.autoColorEnabled) return;
    final rows = await select(planTasks).get();
    await batch((batch) {
      for (final row in rows) {
        final color = AppColors.automaticTaskColor(row.title);
        if (color == row.colorValue) continue;
        batch.update(
          planTasks,
          PlanTasksCompanion(colorValue: Value(color)),
          where: (table) => table.id.equals(row.id),
        );
      }
    });
  }

  /// Places an unplanned focus block on the timeline. Any plan occupying the
  /// same real time is replaced so the schedule reflects what is being done.
  Future<int> replaceOverlappingTaskWithFocus({
    required PlanTasksCompanion insertData,
    required PlanTasksCompanion updateData,
    required DateTime date,
    required int startMinutes,
    required int endMinutes,
  }) {
    return transaction(() async {
      final absoluteStart = date.add(Duration(minutes: startMinutes));
      final absoluteEnd = date.add(Duration(minutes: endMinutes));
      final candidates =
          await (select(planTasks)..where(
            (row) =>
                row.taskDate.isBiggerOrEqualValue(
                  date.subtract(const Duration(days: 1)),
                ) &
                row.taskDate.isSmallerOrEqualValue(
                  date.add(const Duration(days: 1)),
                ) &
                row.isAllDay.equals(false),
          )).get();
      final overlaps =
          candidates.where((row) {
            final rowStart = row.taskDate.add(
              Duration(minutes: row.startMinutes),
            );
            final rowEnd = row.taskDate.add(Duration(minutes: row.endMinutes));
            return rowStart.isBefore(absoluteEnd) &&
                rowEnd.isAfter(absoluteStart);
          }).toList();

      if (overlaps.isEmpty) return into(planTasks).insert(insertData);

      final primary = overlaps.firstWhere((row) {
        final rowStart = row.taskDate.add(Duration(minutes: row.startMinutes));
        final rowEnd = row.taskDate.add(Duration(minutes: row.endMinutes));
        return !absoluteStart.isBefore(rowStart) &&
            absoluteStart.isBefore(rowEnd);
      }, orElse: () => overlaps.first);
      final redundantIds = [
        for (final row in overlaps)
          if (row.id != primary.id) row.id,
      ];
      if (redundantIds.isNotEmpty) {
        await (delete(planTasks)
          ..where((row) => row.id.isIn(redundantIds))).go();
      }
      await (update(planTasks)
        ..where((row) => row.id.equals(primary.id))).write(updateData);
      return primary.id;
    });
  }

  Future<void> setTaskCompleted(int id, bool completed) async {
    final now = DateTime.now();
    await (update(planTasks)..where((row) => row.id.equals(id))).write(
      PlanTasksCompanion(
        isCompleted: Value(completed),
        completedAt: Value(completed ? now : null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> deleteTask(int id) =>
      (delete(planTasks)..where((row) => row.id.equals(id))).go();

  Stream<List<ActivityRecordRow>> watchRecordsForDate(DateTime date) {
    final query =
        select(activityRecords)
          ..where((row) => row.recordDate.equals(date))
          ..orderBy([
            (row) => OrderingTerm.asc(row.startMinutes),
            (row) => OrderingTerm.asc(row.createdAt),
          ]);
    return query.watch();
  }

  Future<List<ActivityRecordRow>> getRecordsBetween(
    DateTime start,
    DateTime end,
  ) =>
      (select(activityRecords)..where(
        (row) =>
            row.recordDate.isBiggerOrEqualValue(start) &
            row.recordDate.isSmallerThanValue(end),
      )).get();

  Future<int> saveRecord(ActivityRecordsCompanion data, {int? recordId}) async {
    if (recordId == null) return into(activityRecords).insert(data);
    await (update(activityRecords)
      ..where((row) => row.id.equals(recordId))).write(data);
    return recordId;
  }

  Future<void> deleteRecord(int id) =>
      (delete(activityRecords)..where((row) => row.id.equals(id))).go();

  Stream<DailySummaryRow?> watchSummaryForDate(DateTime date) =>
      (select(dailySummaries)
        ..where((row) => row.summaryDate.equals(date))).watchSingleOrNull();

  Future<void> upsertSummary(DateTime date, String content) async {
    final now = DateTime.now();
    await into(dailySummaries).insert(
      DailySummariesCompanion.insert(
        summaryDate: date,
        content: Value(content),
        createdAt: now,
        updatedAt: now,
      ),
      onConflict: DoUpdate(
        (_) => DailySummariesCompanion(
          content: Value(content),
          updatedAt: Value(now),
        ),
        target: [dailySummaries.summaryDate],
      ),
    );
  }

  Stream<List<TaskCategoryRow>> watchCategories() =>
      (select(taskCategories)..orderBy([
        (row) => OrderingTerm.desc(row.isDefault),
        (row) => OrderingTerm.asc(row.id),
      ])).watch();

  Future<int> saveCategory({
    int? id,
    required String name,
    required int colorValue,
  }) async {
    final data = TaskCategoriesCompanion(
      name: Value(name),
      colorValue: Value(colorValue),
      createdAt: id == null ? Value(DateTime.now()) : const Value.absent(),
    );
    if (id == null) return into(taskCategories).insert(data);
    await (update(taskCategories)
      ..where((row) => row.id.equals(id))).write(data);
    return id;
  }

  Future<void> deleteCategory(int id) async {
    await transaction(() async {
      await (update(planTasks)..where(
        (row) => row.categoryId.equals(id),
      )).write(const PlanTasksCompanion(categoryId: Value(null)));
      await (delete(taskCategories)..where((row) => row.id.equals(id))).go();
    });
  }

  Stream<List<FocusSessionRow>> watchFocusSessionsBetween(
    DateTime start,
    DateTime end,
  ) =>
      (select(focusSessions)
            ..where(
              (row) =>
                  row.sessionDate.isBiggerOrEqualValue(start) &
                  row.sessionDate.isSmallerThanValue(end),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]))
          .watch();

  Future<List<FocusSessionRow>> getFocusSessionsBetween(
    DateTime start,
    DateTime end,
  ) =>
      (select(focusSessions)..where(
        (row) =>
            row.sessionDate.isBiggerOrEqualValue(start) &
            row.sessionDate.isSmallerThanValue(end),
      )).get();

  Future<int> insertFocusSession(FocusSessionsCompanion data) =>
      into(focusSessions).insert(data);

  Future<ActiveTimerRow?> getActiveTimer() =>
      (select(activeTimers)
        ..where((row) => row.id.equals(1))).getSingleOrNull();

  Future<void> saveActiveTimer(ActiveTimersCompanion data) =>
      into(activeTimers).insertOnConflictUpdate(data);

  Future<void> clearActiveTimer() =>
      (delete(activeTimers)..where((row) => row.id.equals(1))).go();

  Stream<List<MonthlyGoalRow>> watchGoals(String yearMonth) =>
      (select(monthlyGoals)
            ..where((row) => row.yearMonth.equals(yearMonth))
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .watch();

  Future<int> saveGoal(MonthlyGoalsCompanion data, {int? goalId}) async {
    if (goalId == null) return into(monthlyGoals).insert(data);
    await (update(monthlyGoals)
      ..where((row) => row.id.equals(goalId))).write(data);
    return goalId;
  }

  Future<void> deleteGoal(int id) =>
      (delete(monthlyGoals)..where((row) => row.id.equals(id))).go();

  Stream<AppSettingsRow> watchSettings() =>
      (select(appSettingsTable)
        ..where((row) => row.id.equals(1))).watchSingle();

  Future<AppSettingsRow> getSettings() =>
      (select(appSettingsTable)..where((row) => row.id.equals(1))).getSingle();

  Future<void> saveSettings(AppSettingsTableCompanion data) =>
      (update(appSettingsTable)..where(
        (row) => row.id.equals(1),
      )).write(data.copyWith(updatedAt: Value(DateTime.now())));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final file = File(p.join(supportDirectory.path, 'zhouji.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
