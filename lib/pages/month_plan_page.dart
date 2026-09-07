import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/monthly_goal.dart';
import '../models/plan_task.dart';
import '../providers/app_providers.dart';
import '../utils/date_time_utils.dart';
import '../widgets/compact_create_task_button.dart';
import '../widgets/task_editor_sheet.dart';

class MonthPlanPage extends ConsumerStatefulWidget {
  const MonthPlanPage({super.key});

  @override
  ConsumerState<MonthPlanPage> createState() => _MonthPlanPageState();
}

class _MonthPlanPageState extends ConsumerState<MonthPlanPage> {
  @override
  Widget build(BuildContext context) {
    final month = ref.watch(selectedMonthProvider);
    final tasks = ref.watch(selectedMonthTasksProvider);
    final goals = ref.watch(selectedMonthGoalsProvider);
    return Column(
      children: [
        _MonthHeader(
          month: month,
          onPrevious: () => _setMonth(DateTime(month.year, month.month - 1)),
          onCurrent: () => _setMonth(DateTime.now()),
          onNext: () => _setMonth(DateTime(month.year, month.month + 1)),
          onCreate: () => _createDefaultTask(month),
        ),
        _GoalStrip(
          goals: goals.valueOrNull ?? const [],
          onAdd: () => _editGoal(month),
          onToggle:
              (goal) => _editGoal(
                month,
                goal: goal,
                completed: !goal.isCompleted,
                saveImmediately: true,
              ),
          onEdit: (goal) => _editGoal(month, goal: goal),
          onDelete: (goal) => ref.read(goalRepositoryProvider).delete(goal.id),
        ),
        const _WeekdayHeader(),
        Expanded(
          child: tasks.when(
            data:
                (items) => _MonthGrid(
                  month: month,
                  tasks: items,
                  onDayTap: _openDay,
                  onDayLongPress: (date) => _createTask(date, allDay: true),
                  onTaskTap: _editTask,
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('月计划加载失败')),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Text('轻触日期选择操作，长按日期快速创建全天任务', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  void _setMonth(DateTime value) {
    ref.read(selectedMonthProvider.notifier).state = AppDateUtils.startOfMonth(
      value,
    );
  }

  Future<void> _openDay(DateTime date) async {
    ref.read(selectedDateProvider.notifier).state = date;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  title: Text('${date.month}月${date.day}日'),
                  subtitle: Text(AppDateUtils.weekdayShort(date.weekday)),
                ),
                ListTile(
                  leading: const Icon(Icons.add_alarm_outlined),
                  title: const Text('新增指定时间任务'),
                  onTap: () => Navigator.pop(context, 'timed'),
                ),
                ListTile(
                  leading: const Icon(Icons.wb_sunny_outlined),
                  title: const Text('新增全天任务'),
                  onTap: () => Navigator.pop(context, 'allDay'),
                ),
                ListTile(
                  leading: const Icon(Icons.view_day_outlined),
                  title: const Text('查看日计划'),
                  onTap: () => Navigator.pop(context, 'view'),
                ),
              ],
            ),
          ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case 'timed':
        await _createTask(date);
      case 'allDay':
        await _createTask(date, allDay: true);
      case 'view':
        ref.read(planViewIndexProvider.notifier).state = 2;
    }
  }

  Future<void> _createTask(DateTime date, {bool allDay = false}) async {
    final result = await showTaskEditorSheet(
      context,
      initialDate: date,
      initialStartMinutes: 9 * 60,
      initialEndMinutes: 10 * 60,
      initialAllDay: allDay,
    );
    if (result != null && mounted) _message(_resultMessage(result.action));
  }

  Future<void> _createDefaultTask(DateTime month) async {
    final now = DateTime.now();
    final date =
        month.year == now.year && month.month == now.month ? now : month;
    final result = await showTaskEditorSheet(context, initialDate: date);
    if (result != null && mounted) _message(_resultMessage(result.action));
  }

  Future<void> _editTask(PlanTask task) async {
    final result = await showTaskEditorSheet(context, task: task);
    if (!mounted || result == null) return;
    _message(_resultMessage(result.action));
  }

  String _resultMessage(TaskEditorAction action) => switch (action) {
    TaskEditorAction.saved => '计划已保存',
    TaskEditorAction.deleted => '计划已删除',
    TaskEditorAction.copied => '计划已复制',
  };

  Future<void> _editGoal(
    DateTime month, {
    MonthlyGoal? goal,
    bool? completed,
    bool saveImmediately = false,
  }) async {
    var content = goal?.content ?? '';
    if (!saveImmediately) {
      final controller = TextEditingController(text: content);
      final result = await showDialog<String>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(goal == null ? '新增月目标' : '编辑月目标'),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLength: 100,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(hintText: '这个月想完成什么？'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed:
                      () => Navigator.pop(context, controller.text.trim()),
                  child: const Text('保存'),
                ),
              ],
            ),
      );
      controller.dispose();
      if (result == null || result.isEmpty) return;
      content = result;
    }
    await ref
        .read(goalRepositoryProvider)
        .save(
          goal: goal,
          month: month,
          content: content,
          isCompleted: completed ?? goal?.isCompleted ?? false,
        );
  }

  void _message(String text, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onCurrent,
    required this.onNext,
    required this.onCreate,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onCurrent;
  final VoidCallback onNext;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${month.year}年${month.month}月',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: '上个月',
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          TextButton(onPressed: onCurrent, child: const Text('本月')),
          IconButton(
            tooltip: '下个月',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
          CompactCreateTaskButton(showLabel: false, onPressed: onCreate),
        ],
      ),
    );
  }
}

class _GoalStrip extends StatelessWidget {
  const _GoalStrip({
    required this.goals,
    required this.onAdd,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final List<MonthlyGoal> goals;
  final VoidCallback onAdd;
  final ValueChanged<MonthlyGoal> onToggle;
  final ValueChanged<MonthlyGoal> onEdit;
  final ValueChanged<MonthlyGoal> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: 19,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child:
                    goals.isEmpty
                        ? const Text('本月还没有目标', style: TextStyle(fontSize: 12))
                        : SizedBox(
                          height: 34,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: goals.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 6),
                            itemBuilder: (context, index) {
                              final goal = goals[index];
                              return GestureDetector(
                                onLongPress: () => onEdit(goal),
                                child: InputChip(
                                  avatar: Icon(
                                    goal.isCompleted
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    size: 17,
                                  ),
                                  label: Text(
                                    goal.content,
                                    style: TextStyle(
                                      decoration:
                                          goal.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                  onPressed: () => onToggle(goal),
                                  onDeleted: () => onDelete(goal),
                                ),
                              );
                            },
                          ),
                        ),
              ),
              IconButton(
                tooltip: '新增月目标',
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final value in const ['一', '二', '三', '四', '五', '六', '日'])
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.tasks,
    required this.onDayTap,
    required this.onDayLongPress,
    required this.onTaskTap,
  });

  final DateTime month;
  final List<PlanTask> tasks;
  final ValueChanged<DateTime> onDayTap;
  final ValueChanged<DateTime> onDayLongPress;
  final ValueChanged<PlanTask> onTaskTap;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final gridStart = first.subtract(Duration(days: first.weekday - 1));
    final tasksByDate = <DateTime, List<PlanTask>>{};
    for (final task in tasks) {
      (tasksByDate[AppDateUtils.dateOnly(task.taskDate)] ??= []).add(task);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth / 7;
        final cellHeight = math.max(76.0, constraints.maxHeight / 6);
        return GridView.builder(
          physics: const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: cellWidth / cellHeight,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final date = gridStart.add(Duration(days: index));
            final dayTasks = tasksByDate[date] ?? const <PlanTask>[];
            return _MonthCell(
              date: date,
              inMonth: date.month == month.month,
              tasks: dayTasks,
              onTap: () => onDayTap(date),
              onLongPress: () => onDayLongPress(date),
              onTaskTap: onTaskTap,
            );
          },
        );
      },
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.date,
    required this.inMonth,
    required this.tasks,
    required this.onTap,
    required this.onLongPress,
    required this.onTaskTap,
  });

  final DateTime date;
  final bool inMonth;
  final List<PlanTask> tasks;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<PlanTask> onTaskTap;

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.isSameDate(date, DateTime.now());
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color:
              today
                  ? Theme.of(context).colorScheme.primaryContainer.withAlpha(80)
                  : null,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: today ? FontWeight.w800 : FontWeight.w500,
                color:
                    inMonth
                        ? null
                        : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withAlpha(100),
              ),
            ),
            const SizedBox(height: 1),
            for (final task in tasks.take(2))
              Expanded(
                child: GestureDetector(
                  onTap: () => onTaskTap(task),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Color(task.colorValue).withAlpha(190),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172421),
                      ),
                    ),
                  ),
                ),
              ),
            if (tasks.length > 2)
              Text('+${tasks.length - 2}', style: const TextStyle(fontSize: 8)),
          ],
        ),
      ),
    );
  }
}
