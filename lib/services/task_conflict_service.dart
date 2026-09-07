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
      if (task.id == draft.id ||
          task.isAllDay ||
          !AppDateUtils.isSameDate(task.taskDate, draft.taskDate)) {
        continue;
      }
      if (overlaps(
        start: draft.startMinutes,
        end: draft.endMinutes,
        otherStart: task.startMinutes,
        otherEnd: task.endMinutes,
      )) {
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
