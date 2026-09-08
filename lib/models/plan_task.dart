enum TaskDisplayStatus { pending, completed, missed }

class PlanTask {
  const PlanTask({
    required this.id,
    required this.title,
    required this.taskDate,
    required this.startMinutes,
    required this.endMinutes,
    required this.colorValue,
    required this.note,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    this.isLocked = false,
    this.isAllDay = false,
    this.sortOrder = 0,
    this.completedAt,
    this.plannedDurationMinutes,
    this.focusMinutes,
  });

  final int id;
  final String title;
  final DateTime taskDate;
  final int startMinutes;
  final int endMinutes;
  final int colorValue;
  final String note;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? categoryId;
  final bool isLocked;
  final bool isAllDay;
  final int sortOrder;
  final DateTime? completedAt;
  final int? plannedDurationMinutes;
  final int? focusMinutes;

  int get durationMinutes =>
      plannedDurationMinutes ?? (endMinutes - startMinutes);

  DateTime get endDateTime => DateTime(
    taskDate.year,
    taskDate.month,
    taskDate.day,
  ).add(Duration(minutes: endMinutes));

  TaskDisplayStatus statusAt(DateTime now) {
    if (isCompleted) return TaskDisplayStatus.completed;
    if (!isAllDay && !now.isBefore(endDateTime)) {
      return TaskDisplayStatus.missed;
    }
    return TaskDisplayStatus.pending;
  }

  PlanTask copyWith({
    int? id,
    String? title,
    DateTime? taskDate,
    int? startMinutes,
    int? endMinutes,
    int? colorValue,
    String? note,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? categoryId,
    bool clearCategory = false,
    bool? isLocked,
    bool? isAllDay,
    int? sortOrder,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    int? plannedDurationMinutes,
    int? focusMinutes,
  }) {
    return PlanTask(
      id: id ?? this.id,
      title: title ?? this.title,
      taskDate: taskDate ?? this.taskDate,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      colorValue: colorValue ?? this.colorValue,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryId: clearCategory ? null : categoryId ?? this.categoryId,
      isLocked: isLocked ?? this.isLocked,
      isAllDay: isAllDay ?? this.isAllDay,
      sortOrder: sortOrder ?? this.sortOrder,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      focusMinutes: focusMinutes ?? this.focusMinutes,
    );
  }
}

class PlanTaskDraft {
  const PlanTaskDraft({
    this.id,
    required this.title,
    required this.taskDate,
    required this.startMinutes,
    required this.endMinutes,
    required this.colorValue,
    this.note = '',
    this.isCompleted = false,
    this.categoryId,
    this.isLocked = false,
    this.isAllDay = false,
    this.sortOrder = 0,
    this.completedAt,
    this.plannedDurationMinutes,
    this.focusMinutes,
  });

  factory PlanTaskDraft.fromTask(PlanTask task) => PlanTaskDraft(
    id: task.id,
    title: task.title,
    taskDate: task.taskDate,
    startMinutes: task.startMinutes,
    endMinutes: task.endMinutes,
    colorValue: task.colorValue,
    note: task.note,
    isCompleted: task.isCompleted,
    categoryId: task.categoryId,
    isLocked: task.isLocked,
    isAllDay: task.isAllDay,
    sortOrder: task.sortOrder,
    completedAt: task.completedAt,
    plannedDurationMinutes: task.plannedDurationMinutes,
    focusMinutes: task.focusMinutes,
  );

  final int? id;
  final String title;
  final DateTime taskDate;
  final int startMinutes;
  final int endMinutes;
  final int colorValue;
  final String note;
  final bool isCompleted;
  final int? categoryId;
  final bool isLocked;
  final bool isAllDay;
  final int sortOrder;
  final DateTime? completedAt;
  final int? plannedDurationMinutes;
  final int? focusMinutes;

  PlanTaskDraft copyWith({
    int? id,
    bool clearId = false,
    String? title,
    DateTime? taskDate,
    int? startMinutes,
    int? endMinutes,
    int? colorValue,
    String? note,
    bool? isCompleted,
    int? categoryId,
    bool clearCategory = false,
    bool? isLocked,
    bool? isAllDay,
    int? sortOrder,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    int? plannedDurationMinutes,
    int? focusMinutes,
  }) {
    return PlanTaskDraft(
      id: clearId ? null : id ?? this.id,
      title: title ?? this.title,
      taskDate: taskDate ?? this.taskDate,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      colorValue: colorValue ?? this.colorValue,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      categoryId: clearCategory ? null : categoryId ?? this.categoryId,
      isLocked: isLocked ?? this.isLocked,
      isAllDay: isAllDay ?? this.isAllDay,
      sortOrder: sortOrder ?? this.sortOrder,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      focusMinutes: focusMinutes ?? this.focusMinutes,
    );
  }
}
