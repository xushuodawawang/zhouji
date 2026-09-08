import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity_record.dart';
import '../models/plan_task.dart';
import '../providers/app_providers.dart';
import '../repositories/plan_task_repository.dart';
import '../utils/date_time_utils.dart';
import '../widgets/activity_editor_dialog.dart';
import '../widgets/daily_summary_editor.dart';
import '../widgets/page_heading.dart';

class DailyRecordPage extends ConsumerStatefulWidget {
  const DailyRecordPage({super.key});

  @override
  ConsumerState<DailyRecordPage> createState() => _DailyRecordPageState();
}

class _DailyRecordPageState extends ConsumerState<DailyRecordPage> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    ref.watch(currentMinuteProvider);
    final tasks = ref.watch(selectedDateTasksProvider);
    final records = ref.watch(selectedDateRecordsProvider);
    final summary = ref.watch(selectedDateSummaryProvider);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: PageHeading(title: '记录', subtitle: '记下今天的行动，留一点时间给自己'),
        ),
        _DateHeader(
          selectedDate: selectedDate,
          onPrevious:
              () =>
                  ref.read(selectedDateProvider.notifier).state = selectedDate
                      .subtract(const Duration(days: 1)),
          onToday:
              () =>
                  ref
                      .read(selectedDateProvider.notifier)
                      .state = AppDateUtils.dateOnly(DateTime.now()),
          onNext:
              () =>
                  ref.read(selectedDateProvider.notifier).state = selectedDate
                      .add(const Duration(days: 1)),
          onPickDate: () => _pickDate(selectedDate),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SectionHeader(
                icon: Icons.event_note_outlined,
                title: '当日计划',
                trailing:
                    tasks.valueOrNull == null
                        ? null
                        : Text('${tasks.valueOrNull!.length}项'),
              ),
              const SizedBox(height: 8),
              tasks.when(
                data: (items) => _PlanList(tasks: items, onToggle: _toggleTask),
                loading: () => const _LoadingCard(),
                error: (_, __) => const _InlineError(message: '当日计划加载失败'),
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                icon: Icons.task_alt_outlined,
                title: '今日完成记录',
                trailing: FilledButton.tonalIcon(
                  onPressed: () => _editRecord(selectedDate),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('新增'),
                ),
              ),
              const SizedBox(height: 8),
              records.when(
                data:
                    (items) => _ActivityList(
                      records: items,
                      onTap:
                          (record) => _editRecord(selectedDate, record: record),
                    ),
                loading: () => const _LoadingCard(),
                error: (_, __) => const _InlineError(message: '完成记录加载失败'),
              ),
              const SizedBox(height: 24),
              summary.when(
                data:
                    (item) => DailySummaryEditor(
                      key: ValueKey(selectedDate),
                      initialContent: item?.content ?? '',
                      onSave:
                          (content) => ref
                              .read(activityRepositoryProvider)
                              .saveSummary(selectedDate, content),
                    ),
                loading: () => const _LoadingCard(height: 180),
                error: (_, __) => const _InlineError(message: '今日总结加载失败'),
              ),
              const SizedBox(height: 24),
              _SectionHeader(icon: Icons.insights_outlined, title: '简单统计'),
              const SizedBox(height: 8),
              _StatisticsCard(
                tasks: tasks.valueOrNull ?? const [],
                records: records.valueOrNull ?? const [],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(DateTime initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: '选择记录日期',
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  Future<void> _toggleTask(PlanTask task) async {
    try {
      await ref
          .read(planTaskRepositoryProvider)
          .setCompleted(task.id, !task.isCompleted);
      if (mounted) {
        _showMessage(task.isCompleted ? '已取消完成' : '任务已完成');
      }
    } on RepositoryException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  Future<void> _editRecord(DateTime date, {ActivityRecord? record}) async {
    final result = await showActivityEditorDialog(
      context,
      date: date,
      record: record,
    );
    if (!mounted || result == null) return;
    if (result.action == ActivityEditorAction.delete && record != null) {
      await _confirmDeleteRecord(record);
      return;
    }
    try {
      await ref.read(activityRepositoryProvider).save(result.draft!);
      if (mounted) _showMessage(record == null ? '记录已新增' : '记录已保存');
    } on RepositoryException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  Future<void> _confirmDeleteRecord(ActivityRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('删除完成记录？'),
            content: Text('“${record.title}”删除后无法恢复。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('删除'),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(activityRepositoryProvider).delete(record.id);
      if (mounted) _showMessage('记录已删除');
    } on RepositoryException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.selectedDate,
    required this.onPrevious,
    required this.onToday,
    required this.onNext,
    required this.onPickDate,
  });

  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onToday;
  final VoidCallback onNext;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppDateUtils.dateLabel(selectedDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _PlanList extends StatelessWidget {
  const _PlanList({required this.tasks, required this.onToggle});

  final List<PlanTask> tasks;
  final ValueChanged<PlanTask> onToggle;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const _EmptyCard(message: '当天还没有计划任务');
    }
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < tasks.length; index++) ...[
            _PlanTile(task: tasks[index], onToggle: onToggle),
            if (index != tasks.length - 1)
              const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.task, required this.onToggle});

  final PlanTask task;
  final ValueChanged<PlanTask> onToggle;

  @override
  Widget build(BuildContext context) {
    final status = task.statusAt(DateTime.now());
    final statusText = switch (status) {
      TaskDisplayStatus.pending => '待完成',
      TaskDisplayStatus.completed => '已完成',
      TaskDisplayStatus.missed => '未完成',
    };
    return ListTile(
      leading: Container(
        width: 10,
        height: 42,
        decoration: BoxDecoration(
          color: Color(task.colorValue),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration:
              task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        '${AppDateUtils.formatMinutes(task.startMinutes)}－'
        '${AppDateUtils.formatMinutes(task.endMinutes)} · $statusText',
      ),
      trailing: IconButton(
        tooltip: task.isCompleted ? '取消完成' : '快速标记完成',
        onPressed: () => onToggle(task),
        icon: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color:
              task.isCompleted ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.records, required this.onTap});

  final List<ActivityRecord> records;
  final ValueChanged<ActivityRecord> onTap;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const _EmptyCard(message: '记录今天实际完成的事情');
    }
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < records.length; index++) ...[
            ListTile(
              onTap: () => onTap(records[index]),
              leading: Icon(
                records[index].isCompleted
                    ? Icons.check_circle_outline
                    : Icons.pending_outlined,
                color:
                    records[index].isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                records[index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${_recordSubtitle(records[index])} · '
                '${records[index].isCompleted ? '已完成' : '未完成'}',
              ),
              trailing: const Icon(Icons.edit_outlined, size: 19),
            ),
            if (index != records.length - 1)
              const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }

  String _recordSubtitle(ActivityRecord record) {
    final time =
        record.startMinutes != null && record.endMinutes != null
            ? '${AppDateUtils.formatMinutes(record.startMinutes!)}－'
                '${AppDateUtils.formatMinutes(record.endMinutes!)} · '
            : '';
    return '$time实际 ${AppDateUtils.formatDuration(record.durationMinutes)}';
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.tasks, required this.records});

  final List<PlanTask> tasks;
  final List<ActivityRecord> records;

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.isCompleted).length;
    final plannedMinutes = tasks.fold<int>(
      0,
      (sum, task) => sum + task.durationMinutes,
    );
    final actualMinutes = records
        .where((record) => record.isCompleted)
        .fold<int>(0, (sum, record) => sum + record.durationMinutes);
    final rate = tasks.isEmpty ? 0 : (completed / tasks.length * 100).round();
    final items = [
      ('计划任务', '${tasks.length}项'),
      ('已完成', '$completed项'),
      ('计划时长', AppDateUtils.formatDuration(plannedMinutes)),
      ('实际时长', AppDateUtils.formatDuration(actualMinutes)),
      ('完成率', '$rate%'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth =
                constraints.maxWidth >= 620
                    ? (constraints.maxWidth - 32) / 5
                    : (constraints.maxWidth - 8) / 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in items)
                  SizedBox(
                    width: itemWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$1,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.$2,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({this.height = 88});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}
