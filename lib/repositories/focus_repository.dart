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
    return _database.insertFocusSession(
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
  }

  Future<ActiveTimer?> loadActiveTimer() async {
    final row = await _database.getActiveTimer();
    if (row == null) return null;
    return ActiveTimer(
      mode: TimerMode.values.byName(row.mode),
      phase: TimerPhase.values.byName(row.phase),
      startedAt: row.startedAt,
      expectedEndAt: row.expectedEndAt,
      remainingSeconds: row.remainingSeconds,
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
