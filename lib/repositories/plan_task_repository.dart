import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/plan_task.dart';
import '../utils/date_time_utils.dart';

class RepositoryException implements Exception {
  const RepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class PlanTaskRepository {
  const PlanTaskRepository(this._database);

  final AppDatabase _database;

  Stream<List<PlanTask>> watchWeek(DateTime weekStart) {
    final start = AppDateUtils.startOfWeek(weekStart);
    return _database
        .watchTasksBetween(start, start.add(const Duration(days: 7)))
        .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<List<PlanTask>> watchDate(DateTime date) {
    final normalized = AppDateUtils.dateOnly(date);
    return _database
        .watchTasksForDate(normalized)
        .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<List<PlanTask>> watchMonth(DateTime month) {
    final start = AppDateUtils.startOfMonth(month);
    final end = AppDateUtils.endOfMonthExclusive(month);
    return _database
        .watchTasksBetween(start, end)
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<PlanTask>> getBetween(DateTime start, DateTime end) async =>
      (await _database.getTasksBetween(start, end)).map(_fromRow).toList();

  Future<int> save(PlanTaskDraft draft) async {
    _validate(draft);
    final now = DateTime.now();
    try {
      return await _database.saveTask(
        PlanTasksCompanion(
          title: Value(draft.title.trim()),
          taskDate: Value(AppDateUtils.dateOnly(draft.taskDate)),
          startMinutes: Value(draft.startMinutes),
          endMinutes: Value(draft.endMinutes),
          colorValue: Value(draft.colorValue),
          note: Value(draft.note.trim()),
          isCompleted: Value(draft.isCompleted),
          categoryId: Value(draft.categoryId),
          isLocked: Value(draft.isLocked),
          isAllDay: Value(draft.isAllDay),
          sortOrder: Value(draft.sortOrder),
          completedAt: Value(draft.completedAt),
          plannedDurationMinutes: Value(
            draft.plannedDurationMinutes ??
                (draft.endMinutes - draft.startMinutes),
          ),
          createdAt: draft.id == null ? Value(now) : const Value.absent(),
          updatedAt: Value(now),
        ),
        taskId: draft.id,
      );
    } on TaskConflictException {
      rethrow;
    } catch (error) {
      throw RepositoryException('保存任务失败', error);
    }
  }

  Future<int> copy(PlanTask task, {required DateTime date, int? startMinutes}) {
    final start = startMinutes ?? task.startMinutes;
    return save(
      PlanTaskDraft.fromTask(task).copyWith(
        clearId: true,
        taskDate: date,
        startMinutes: start,
        endMinutes: start + task.durationMinutes,
        isCompleted: false,
        clearCompletedAt: true,
      ),
    );
  }

  Future<void> setCompleted(int id, bool value) async {
    try {
      await _database.setTaskCompleted(id, value);
    } catch (error) {
      throw RepositoryException('更新任务状态失败', error);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _database.deleteTask(id);
    } catch (error) {
      throw RepositoryException('删除任务失败', error);
    }
  }

  void _validate(PlanTaskDraft draft) {
    if (draft.title.trim().isEmpty) {
      throw const RepositoryException('任务名称不能为空');
    }
    if (draft.isAllDay) return;
    if (draft.startMinutes < AppDateUtils.dayStartMinutes ||
        draft.endMinutes > AppDateUtils.dayEndMinutes ||
        draft.endMinutes - draft.startMinutes <
            AppDateUtils.manualMinimumMinutes) {
      throw const RepositoryException('任务时间必须在 07:00 至 24:00，且不少于 5 分钟');
    }
  }

  PlanTask _fromRow(PlanTaskRow row) => PlanTask(
    id: row.id,
    title: row.title,
    taskDate: row.taskDate,
    startMinutes: row.startMinutes,
    endMinutes: row.endMinutes,
    colorValue: row.colorValue,
    note: row.note,
    isCompleted: row.isCompleted,
    categoryId: row.categoryId,
    isLocked: row.isLocked,
    isAllDay: row.isAllDay,
    sortOrder: row.sortOrder,
    completedAt: row.completedAt,
    plannedDurationMinutes: row.plannedDurationMinutes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
