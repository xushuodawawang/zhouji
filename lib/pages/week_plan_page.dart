import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/app_settings.dart';
import '../models/plan_task.dart';
import '../providers/app_providers.dart';
import '../repositories/plan_task_repository.dart';
import '../utils/date_time_utils.dart';
import '../utils/time_snap_calculator.dart';
import '../utils/timeline_position_calculator.dart';
import '../widgets/compact_create_task_button.dart';
import '../widgets/task_editor_sheet.dart';
import '../widgets/task_quick_action_menu.dart';
import '../widgets/week_schedule.dart';
import '../widgets/week_overview.dart';

class WeekPlanPage extends ConsumerStatefulWidget {
  const WeekPlanPage({super.key});

  @override
  ConsumerState<WeekPlanPage> createState() => _WeekPlanPageState();
}

class _WeekPlanPageState extends ConsumerState<WeekPlanPage> {
  double? _detailHourHeight;
  double _detailViewportHeight = 0;
  bool _settingsInitialized = false;

  @override
  Widget build(BuildContext context) {
    final weekStart = ref.watch(weekStartProvider);
    ref.watch(currentMinuteProvider);
    final tasks = ref.watch(weekTasksProvider);
    final settingsValue = ref.watch(appSettingsProvider);
    final settings = settingsValue.valueOrNull ?? const AppSettings();
    if (!_settingsInitialized && settingsValue.hasValue) {
      _detailHourHeight = TimelinePositionCalculator.clampHourHeight(
        settings.detailHourHeight,
      );
      _settingsInitialized = true;
    }
    final detailHourHeight =
        _detailHourHeight ??
        TimelinePositionCalculator.clampHourHeight(settings.detailHourHeight);
    return Column(
      children: [
        _WeekHeader(
          weekStart: weekStart,
          settings: settings,
          onPrevious:
              () =>
                  ref.read(weekStartProvider.notifier).state = weekStart
                      .subtract(const Duration(days: 7)),
          onToday:
              () =>
                  ref
                      .read(weekStartProvider.notifier)
                      .state = AppDateUtils.startOfWeek(DateTime.now()),
          onNext:
              () =>
                  ref.read(weekStartProvider.notifier).state = weekStart.add(
                    const Duration(days: 7),
                  ),
          onModeChanged:
              (mode) => _saveSettings(settings.copyWith(weekViewMode: mode)),
          onCreate: () => _createDefaultTask(weekStart),
          detailHourHeight: detailHourHeight,
          onZoomOut:
              () =>
                  _adjustDetailHourHeight(-TimelinePositionCalculator.zoomStep),
          onZoomIn:
              () =>
                  _adjustDetailHourHeight(TimelinePositionCalculator.zoomStep),
          onFitDay: _fitDetailDay,
        ),
        Expanded(
          child: tasks.when(
            data: (items) {
              // Keep every timed task visible, including overnight tasks.
              final visibleStart = items
                  .where((t) => !t.isAllDay)
                  .fold(
                    settings.timelineStartMinutes,
                    (a, t) =>
                        t.startMinutes < a ? (t.startMinutes ~/ 60) * 60 : a,
                  );
              final visibleEnd = items
                  .where((t) => !t.isAllDay)
                  .fold(
                    settings.timelineEndMinutes,
                    (a, t) =>
                        t.endMinutes > a ? ((t.endMinutes + 59) ~/ 60) * 60 : a,
                  );
              if (settings.weekViewMode == WeekViewMode.overview) {
                return WeekOverview(
                  weekStart: weekStart,
                  tasks: items,
                  hourHeight: settings.overviewHourHeight,
                  onTaskTap: _editTask,
                  onDayTap: (date) {
                    ref.read(selectedDateProvider.notifier).state = date;
                    ref.read(planViewIndexProvider.notifier).state = 2;
                  },
                  timelineStartMinutes: visibleStart,
                  timelineEndMinutes: visibleEnd,
                );
              }
              return WeekSchedule(
                weekStart: weekStart,
                tasks: items,
                hourHeight: detailHourHeight,
                onHourHeightChanged: _updateDetailHourHeight,
                onHourHeightChangeEnd: _persistDetailHourHeight,
                onViewportHeightChanged:
                    (height) => _detailViewportHeight = height,
                timelineStartMinutes: visibleStart,
                timelineEndMinutes: visibleEnd,
                onCreateTask: _createTask,
                onTapEmpty: _createTask,
                onEditTask: _editTask,
                onTaskMenu: _showTaskMenu,
                onTaskChanged: _saveDraggedTask,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) => _ErrorState(
                  onRetry: () => ref.invalidate(weekTasksProvider),
                ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveSettings(AppSettings settings) async {
    await ref.read(settingsRepositoryProvider).save(settings);
  }

  void _updateDetailHourHeight(double value) {
    final next = TimelinePositionCalculator.clampHourHeight(value);
    if (_detailHourHeight == next) return;
    setState(() => _detailHourHeight = next);
  }

  Future<void> _persistDetailHourHeight() async {
    final height =
        _detailHourHeight ?? TimelinePositionCalculator.defaultDetailHourHeight;
    final current =
        ref.read(appSettingsProvider).valueOrNull ?? const AppSettings();
    await _saveSettings(current.copyWith(detailHourHeight: height));
  }

  void _adjustDetailHourHeight(double delta) {
    final current =
        _detailHourHeight ?? TimelinePositionCalculator.defaultDetailHourHeight;
    _updateDetailHourHeight(current + delta);
    _persistDetailHourHeight();
  }

  void _fitDetailDay() {
    final available =
        _detailViewportHeight > 0
            ? _detailViewportHeight
            : MediaQuery.sizeOf(context).height * 0.6;
    final settings =
        ref.read(appSettingsProvider).valueOrNull ?? const AppSettings();
    _updateDetailHourHeight(
      TimelinePositionCalculator.fitHourHeight(
        available,
        startMinutes: settings.timelineStartMinutes,
        endMinutes: settings.timelineEndMinutes,
      ),
    );
    _persistDetailHourHeight();
  }

  Future<void> _createDefaultTask(DateTime weekStart) async {
    final now = DateTime.now();
    final weekEnd = weekStart.add(const Duration(days: 7));
    final date =
        !now.isBefore(weekStart) && now.isBefore(weekEnd)
            ? AppDateUtils.dateOnly(now)
            : weekStart;
    final range = TimeSnapCalculator.defaultRange(now);
    await _createTask(date, range.start, range.end);
  }

  Future<void> _createTask(
    DateTime date,
    int startMinutes,
    int endMinutes,
  ) async {
    final result = await showTaskEditorSheet(
      context,
      initialDate: date,
      initialStartMinutes: startMinutes,
      initialEndMinutes: endMinutes,
    );
    if (!mounted || result == null) return;
    _showMessage(_editorResultMessage(result.action));
  }

  Future<void> _editTask(PlanTask task) async {
    final result = await showTaskEditorSheet(context, task: task);
    if (!mounted || result == null) return;
    _showMessage(_editorResultMessage(result.action));
  }

  String _editorResultMessage(TaskEditorAction action) => switch (action) {
    TaskEditorAction.saved => '计划已保存',
    TaskEditorAction.deleted => '计划已删除',
    TaskEditorAction.copied => '计划已复制',
  };

  Future<void> _showTaskMenu(PlanTask task) async {
    final action = await showTaskQuickActionMenu(context, task);
    if (!mounted || action == null) return;
    switch (action) {
      case TaskQuickAction.edit:
        await _editTask(task);
      case TaskQuickAction.complete:
        await _toggleCompleted(task);
      case TaskQuickAction.copyToDay:
        final date = await showDatePicker(
          context: context,
          initialDate: task.taskDate.add(const Duration(days: 1)),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          helpText: '复制计划到哪一天？',
        );
        if (date != null) await _copyTask(task, date);
      case TaskQuickAction.copyNextWeek:
        await _copyTask(task, task.taskDate.add(const Duration(days: 7)));
      case TaskQuickAction.lock:
        await _saveTask(
          PlanTaskDraft.fromTask(task).copyWith(isLocked: !task.isLocked),
          successMessage: task.isLocked ? '已解除锁定' : '任务已锁定',
        );
      case TaskQuickAction.delete:
        await _confirmDelete(task);
    }
  }

  Future<void> _copyTask(PlanTask task, DateTime date) async {
    try {
      await ref.read(planTaskRepositoryProvider).copy(task, date: date);
      if (mounted) _showMessage('计划已复制');
    } on TaskConflictException catch (error) {
      if (mounted) _showMessage(error.toString(), isError: true);
    } on RepositoryException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  Future<void> _saveDraggedTask(PlanTaskDraft draft) async {
    await _saveTask(draft, successMessage: '计划时间已更新');
  }

  Future<void> _saveTask(
    PlanTaskDraft draft, {
    required String successMessage,
  }) async {
    try {
      await ref.read(planTaskRepositoryProvider).save(draft);
      if (mounted) _showMessage(successMessage);
    } on TaskConflictException catch (error) {
      if (mounted) _showMessage(error.toString(), isError: true);
    } on RepositoryException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  Future<void> _toggleCompleted(PlanTask task) async {
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

  Future<void> _confirmDelete(PlanTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('删除计划？'),
            content: Text('“${task.title}”删除后无法恢复。'),
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
      await ref.read(planTaskRepositoryProvider).delete(task.id);
      if (mounted) _showMessage('计划已删除');
    } on RepositoryException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.weekStart,
    required this.settings,
    required this.onPrevious,
    required this.onToday,
    required this.onNext,
    required this.onModeChanged,
    required this.onCreate,
    required this.detailHourHeight,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.onFitDay,
  });

  final DateTime weekStart;
  final AppSettings settings;
  final VoidCallback onPrevious;
  final VoidCallback onToday;
  final VoidCallback onNext;
  final ValueChanged<WeekViewMode> onModeChanged;
  final VoidCallback onCreate;
  final double detailHourHeight;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;
  final VoidCallback onFitDay;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 2, 8, 3),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppDateUtils.weekRangeLabel(weekStart),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '上一周',
                  visualDensity: VisualDensity.compact,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    minimumSize: const Size(48, 36),
                  ),
                  onPressed: onToday,
                  child: const Text('本周'),
                ),
                IconButton(
                  tooltip: '下一周',
                  visualDensity: VisualDensity.compact,
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  SegmentedButton<WeekViewMode>(
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(0, 36)),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 9),
                      ),
                    ),
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: WeekViewMode.overview,
                        label: Text('总览'),
                      ),
                      ButtonSegment(
                        value: WeekViewMode.detail,
                        label: Text('详细'),
                      ),
                    ],
                    selected: {settings.weekViewMode},
                    onSelectionChanged: (value) => onModeChanged(value.first),
                  ),
                  const Spacer(),
                  if (settings.weekViewMode == WeekViewMode.detail) ...[
                    IconButton.outlined(
                      key: const ValueKey('detail-zoom-out'),
                      tooltip: '缩小时间表',
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 36,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed:
                          detailHourHeight >
                                  TimelinePositionCalculator.minHourHeight
                              ? onZoomOut
                              : null,
                      icon: const Icon(Icons.remove, size: 18),
                    ),
                    SizedBox(
                      width: 42,
                      child: Text(
                        '${TimelinePositionCalculator.zoomPercentage(detailHourHeight)}%',
                        key: const ValueKey('detail-zoom-percentage'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    IconButton.outlined(
                      key: const ValueKey('detail-zoom-in'),
                      tooltip: '放大时间表',
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 36,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed:
                          detailHourHeight <
                                  TimelinePositionCalculator.maxHourHeight
                              ? onZoomIn
                              : null,
                      icon: const Icon(Icons.add, size: 18),
                    ),
                    IconButton(
                      key: const ValueKey('detail-zoom-fit-day'),
                      tooltip: '适配整天',
                      constraints: const BoxConstraints.tightFor(
                        width: 38,
                        height: 38,
                      ),
                      onPressed: onFitDay,
                      icon: const Icon(Icons.fit_screen_outlined, size: 19),
                    ),
                  ],
                  CompactCreateTaskButton(
                    showLabel: false,
                    onPressed: onCreate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 36),
          const SizedBox(height: 12),
          const Text('计划加载失败'),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}
