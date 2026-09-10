import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/plan_task.dart';
import '../utils/app_colors.dart';
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

  Stream<List<PlanTask>> watchBetween(DateTime start, DateTime end) => _database
      .watchTasksBetween(start, end)
      .map((rows) => rows.map(_fromRow).toList());

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
          focusMinutes: Value(draft.focusMinutes),
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

  Future<int> placeFocusTask({
    required String title,
    required DateTime startedAt,
    required int plannedMinutes,
  }) async {
    final normalizedTitle = title.trim().isEmpty ? '自由专注' : title.trim();
    final date = AppDateUtils.dateOnly(startedAt);
    final start = AppDateUtils.minutesSinceMidnight(startedAt);
    final duration = plannedMinutes > 0 ? plannedMinutes : 15;
    final end =
        (start + duration)
            .clamp(
              start + AppDateUtils.manualMinimumMinutes,
              AppDateUtils.maximumTimelineMinutes,
            )
            .toInt();
    final now = DateTime.now();
    final color = AppColors.automaticTaskColor(normalizedTitle);
    final insertData = PlanTasksCompanion(
      title: Value(normalizedTitle),
      taskDate: Value(date),
      startMinutes: Value(start),
      endMinutes: Value(end),
      colorValue: Value(color),
      note: const Value(''),
      isCompleted: const Value(false),
      categoryId: const Value(null),
      isLocked: const Value(false),
      isAllDay: const Value(false),
      sortOrder: const Value(0),
      completedAt: const Value(null),
      plannedDurationMinutes: Value(end - start),
      focusMinutes: Value(plannedMinutes > 0 ? plannedMinutes : null),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    final updateData = insertData.copyWith(createdAt: const Value.absent());
    try {
      return await _database.replaceOverlappingTaskWithFocus(
        insertData: insertData,
        updateData: updateData,
        date: date,
        startMinutes: start,
        endMinutes: end,
      );
    } catch (error) {
      throw RepositoryException('同步专注到计划失败', error);
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
    if (draft.startMinutes < 0 ||
        draft.startMinutes >= AppDateUtils.maximumTimelineMinutes ||
        draft.endMinutes > AppDateUtils.maximumTimelineMinutes ||
        draft.endMinutes - draft.startMinutes <
            AppDateUtils.manualMinimumMinutes) {
      throw const RepositoryException('任务时间超出可用范围，或时长少于 5 分钟');
    }
    if (draft.focusMinutes != null &&
        (draft.focusMinutes! < 1 || draft.focusMinutes! > 240)) {
      throw const RepositoryException('单次专注时长须在 1 至 240 分钟之间');
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
    focusMinutes: row.focusMinutes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
