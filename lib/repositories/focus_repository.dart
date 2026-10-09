import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/focus_session.dart';
import '../utils/date_time_utils.dart';

class FocusRepository {
  const FocusRepository(this._database);

  final AppDatabase _database;

  Stream<List<FocusSession>> watchBetween(DateTime start, DateTime end) =>
      _database
          .watchFocusSessionsBetween(start, end)
          .map((rows) => rows.map(_sessionFromRow).toList());

  Future<List<FocusSession>> getBetween(DateTime start, DateTime end) async =>
      (await _database.getFocusSessionsBetween(
        start,
        end,
      )).map(_sessionFromRow).toList();

  Future<int> addSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedMinutes,
    required int actualMinutes,
    required TimerMode mode,
    required bool completed,
    int? taskId,
    int? categoryId,
    String note = '',
  }) {
    final now = DateTime.now();
    return _database.transaction(() async {
      final id = await _database.insertFocusSession(
        FocusSessionsCompanion.insert(
          sessionDate: AppDateUtils.dateOnly(startedAt),
          startedAt: startedAt,
          endedAt: endedAt,
          plannedMinutes: plannedMinutes,
          actualMinutes: actualMinutes,
          mode: mode.name,
          completed: Value(completed),
          taskId: Value(taskId),
          categoryId: Value(categoryId),
          note: Value(note),
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (taskId != null) {
        await syncTaskDuration(
          taskId: taskId,
          startedAt: startedAt,
          liveMinutes: 0,
        );
      }
      return id;
    });
  }

  /// Includes earlier sessions of the same task, without counting the live
  /// session twice once it has been saved.
  Future<void> syncTaskDuration({
    required int taskId,
    required DateTime startedAt,
    required int liveMinutes,
  }) => _database.transaction(() async {
    final task =
        await (_database.select(_database.planTasks)
          ..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (task == null) return;
    String normalized(String title) =>
        title.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final sessions =
        await (_database.select(_database.focusSessions)
          ..where((s) => s.taskId.equals(taskId))).get();
    var first = startedAt;
    var minutes = liveMinutes;
    for (final session in sessions) {
      // Placing a different focus task may reuse the overlapping plan's ID.
      if (session.note.isNotEmpty &&
          normalized(session.note) != normalized(task.title)) {
        continue;
      }
      if (session.startedAt.isBefore(first)) first = session.startedAt;
      minutes += session.actualMinutes;
    }
    await _database.syncFocusTaskDuration(taskId, first, minutes);
  });

  Future<ActiveTimer?> loadActiveTimer() async {
    final row = await _database.getActiveTimer();
    if (row == null) return null;
    return ActiveTimer(
      mode: TimerMode.values.byName(row.mode),
      phase: TimerPhase.values.byName(row.phase),
      startedAt: row.startedAt,
      expectedEndAt: row.expectedEndAt,
      remainingSeconds: row.remainingSeconds,
      totalSeconds: row.totalSeconds,
      title: row.title,
      isRunning: row.isRunning,
      cycleCount: row.cycleCount,
      taskId: row.taskId,
      categoryId: row.categoryId,
    );
  }

  Future<void> saveActiveTimer(ActiveTimer timer) => _database.saveActiveTimer(
    ActiveTimersCompanion.insert(
      id: const Value(1),
      mode: timer.mode.name,
      phase: timer.phase.name,
      startedAt: timer.startedAt,
      expectedEndAt: timer.expectedEndAt,
      remainingSeconds: timer.remainingSeconds,
      totalSeconds: Value(timer.totalSeconds),
      title: Value(timer.title),
      isRunning: timer.isRunning,
      cycleCount: Value(timer.cycleCount),
      taskId: Value(timer.taskId),
      categoryId: Value(timer.categoryId),
      updatedAt: DateTime.now(),
    ),
  );

  Future<void> clearActiveTimer() => _database.clearActiveTimer();

  FocusSession _sessionFromRow(FocusSessionRow row) => FocusSession(
    id: row.id,
    sessionDate: row.sessionDate,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
    plannedMinutes: row.plannedMinutes,
    actualMinutes: row.actualMinutes,
    mode: TimerMode.values.byName(row.mode),
    completed: row.completed,
    taskId: row.taskId,
    categoryId: row.categoryId,
    note: row.note,
  );
}
