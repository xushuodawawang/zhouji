import '../models/plan_task.dart';
import '../utils/date_time_utils.dart';

abstract final class TaskConflictService {
  static bool overlaps({
    required int start,
    required int end,
    required int otherStart,
    required int otherEnd,
  }) => start < otherEnd && end > otherStart;

  static PlanTask? findConflict(
    PlanTaskDraft draft,
    Iterable<PlanTask> existing,
  ) {
    if (draft.isAllDay) return null;
    for (final task in existing) {
      if (task.id == draft.id || task.isAllDay) {
        continue;
      }
      if (AppDateUtils.atMinutes(
            draft.taskDate,
            draft.startMinutes,
          ).isBefore(AppDateUtils.atMinutes(task.taskDate, task.endMinutes)) &&
          AppDateUtils.atMinutes(
            draft.taskDate,
            draft.endMinutes,
          ).isAfter(AppDateUtils.atMinutes(task.taskDate, task.startMinutes))) {
        return task;
      }
    }
    return null;
  }

  static String message({
    required String title,
    required int startMinutes,
    required int endMinutes,
  }) =>
      '该时间段与“$title”'
      '（${AppDateUtils.formatMinutes(startMinutes)}－'
      '${AppDateUtils.formatMinutes(endMinutes)}）冲突';
}
