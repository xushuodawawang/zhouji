import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/plan_task.dart';
import '../providers/app_providers.dart';
import '../utils/date_time_utils.dart';
import '../widgets/compact_create_task_button.dart';
import '../widgets/daily_summary_editor.dart';
import '../widgets/task_editor_sheet.dart';

class DayPlanPage extends ConsumerStatefulWidget {
  const DayPlanPage({super.key});

  @override
  ConsumerState<DayPlanPage> createState() => _DayPlanPageState();
}

class _DayPlanPageState extends ConsumerState<DayPlanPage> {
  @override
  Widget build(BuildContext context) {
    final date = ref.watch(selectedDateProvider);
    final tasks = ref.watch(selectedDateTasksProvider);
    final records = ref.watch(selectedDateRecordsProvider);
    final summary = ref.watch(selectedDateSummaryProvider);
    final items = tasks.valueOrNull ?? const <PlanTask>[];
    final allDay = items.where((task) => task.isAllDay).toList();
    final timed = items.where((task) => !task.isAllDay).toList();
    return Column(
      children: [
        _DayHeader(
          date: date,
          onPrevious: () => _setDate(date.subtract(const Duration(days: 1))),
          onToday: () => _setDate(DateTime.now()),
          onNext: () => _setDate(date.add(const Duration(days: 1))),
          onPick: () => _pickDate(date),
          onCreate: () => _createDefaultTask(date),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 104),
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        ref.read(bottomNavigationIndexProvider.notifier).state =
                            1;
                      },
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text('开始专注'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionTitle(
                icon: Icons.wb_sunny_outlined,
                title: '全天安排',
                count: allDay.length,
              ),
              const SizedBox(height: 6),
              _TaskList(
                tasks: allDay,
                emptyText: '今天没有全天安排',
                onTap: _editTask,
                onToggle: _toggleTask,
                onEmptyTap: () => _createTask(date, allDay: true),
              ),
              const SizedBox(height: 18),
              _SectionTitle(
                icon: Icons.schedule_outlined,
                title: '日程',
                count: timed.length,
              ),
              const SizedBox(height: 6),
              tasks.isLoading
                  ? const LinearProgressIndicator()
                  : _TaskList(
                    tasks: timed,
                    emptyText: '今天还没有定时计划',
                    onTap: _editTask,
                    onToggle: _toggleTask,
                    onEmptyTap: () => _createTask(date),
                  ),
              const SizedBox(height: 18),
              _SectionTitle(
                icon: Icons.task_alt_outlined,
                title: '完成记录',
                count: records.valueOrNull?.length ?? 0,
              ),
              const SizedBox(height: 6),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.fact_check_outlined),
                  title: Text(
                    records.valueOrNull?.isEmpty ?? true
                        ? '今天还没有实际完成记录'
                        : '已记录 ${records.valueOrNull!.length} 项，'
                            '共 ${AppDateUtils.formatDuration(records.valueOrNull!.fold(0, (sum, item) => sum + item.durationMinutes))}',
                  ),
                  subtitle: const Text('在“记录”页新增、编辑或删除'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(bottomNavigationIndexProvider.notifier).state = 2;
                  },
                ),
              ),
              const SizedBox(height: 18),
              summary.when(
                data:
                    (value) => DailySummaryEditor(
                      key: ValueKey(date),
                      initialContent: value?.content ?? '',
                      onSave:
                          (content) => ref
                              .read(activityRepositoryProvider)
                              .saveSummary(date, content),
                    ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('总结加载失败'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _setDate(DateTime value) {
    ref.read(selectedDateProvider.notifier).state = AppDateUtils.dateOnly(
      value,
    );
    ref.read(selectedMonthProvider.notifier).state = AppDateUtils.startOfMonth(
      value,
    );
  }

  Future<void> _pickDate(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: '选择日期',
    );
    if (date != null) _setDate(date);
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

  Future<void> _createDefaultTask(DateTime date) async {
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

  Future<void> _toggleTask(PlanTask task) async {
    await ref
        .read(planTaskRepositoryProvider)
        .setCompleted(task.id, !task.isCompleted);
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

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.date,
    required this.onPrevious,
    required this.onToday,
    required this.onNext,
    required this.onPick,
    required this.onCreate,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onToday;
  final VoidCallback onNext;
  final VoidCallback onPick;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppDateUtils.dateLabel(date),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: '上一天',
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          TextButton(onPressed: onToday, child: const Text('今天')),
          IconButton(
            tooltip: '下一天',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
          IconButton(
            tooltip: '选择日期',
            onPressed: onPick,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          CompactCreateTaskButton(showLabel: false, onPressed: onCreate),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 7),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Text('$count 项'),
      ],
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.emptyText,
    required this.onTap,
    required this.onToggle,
    this.onEmptyTap,
  });

  final List<PlanTask> tasks;
  final String emptyText;
  final ValueChanged<PlanTask> onTap;
  final ValueChanged<PlanTask> onToggle;
  final VoidCallback? onEmptyTap;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEmptyTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text(emptyText)),
                if (onEmptyTap != null) const Icon(Icons.add_circle_outline),
              ],
            ),
          ),
        ),
      );
    }
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < tasks.length; index++) ...[
            ListTile(
              onTap: () => onTap(tasks[index]),
              leading: Container(
                width: 5,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(tasks[index].colorValue),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              title: Text(
                tasks[index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                tasks[index].isAllDay
                    ? '全天'
                    : '${AppDateUtils.formatMinutes(tasks[index].startMinutes)}'
                        '－${AppDateUtils.formatMinutes(tasks[index].endMinutes)}',
              ),
              trailing: IconButton(
                tooltip: tasks[index].isCompleted ? '取消完成' : '标记完成',
                onPressed: () => onToggle(tasks[index]),
                icon: Icon(
                  tasks[index].isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
            ),
            if (index != tasks.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
