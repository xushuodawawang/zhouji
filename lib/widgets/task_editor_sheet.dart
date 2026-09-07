import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/plan_task.dart';
import '../providers/app_providers.dart';
import '../repositories/plan_task_repository.dart';
import '../utils/app_colors.dart';
import '../utils/date_time_utils.dart';
import '../utils/time_snap_calculator.dart';
import 'task_time_editor.dart';

enum TaskEditorAction { saved, deleted, copied }

class TaskEditorResult {
  const TaskEditorResult(this.action, {this.taskId});

  final TaskEditorAction action;
  final int? taskId;
}

Future<TaskEditorResult?> showTaskEditorSheet(
  BuildContext context, {
  PlanTask? task,
  DateTime? initialDate,
  int? initialStartMinutes,
  int? initialEndMinutes,
  bool initialAllDay = false,
}) {
  final range = TimeSnapCalculator.defaultRange(DateTime.now());
  return showModalBottomSheet<TaskEditorResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder:
        (context) => TaskEditorSheet(
          task: task,
          initialDate: initialDate,
          initialStartMinutes: initialStartMinutes ?? range.start,
          initialEndMinutes: initialEndMinutes ?? range.end,
          initialAllDay: initialAllDay,
        ),
  );
}

class TaskEditorSheet extends ConsumerStatefulWidget {
  const TaskEditorSheet({
    super.key,
    this.task,
    this.initialDate,
    required this.initialStartMinutes,
    required this.initialEndMinutes,
    this.initialAllDay = false,
  });

  final PlanTask? task;
  final DateTime? initialDate;
  final int initialStartMinutes;
  final int initialEndMinutes;
  final bool initialAllDay;

  @override
  ConsumerState<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends ConsumerState<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late DateTime _date;
  late int _startMinutes;
  late int _endMinutes;
  late int _colorValue;
  late bool _isAllDay;
  late bool _isCompleted;
  late bool _isLocked;
  int? _categoryId;
  int _stepMinutes = 15;
  String? _timeError;
  bool _dirty = false;
  bool _allowPop = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title);
    _noteController = TextEditingController(text: task?.note);
    _date = AppDateUtils.dateOnly(
      task?.taskDate ?? widget.initialDate ?? DateTime.now(),
    );
    _startMinutes = task?.startMinutes ?? widget.initialStartMinutes;
    _endMinutes = task?.endMinutes ?? widget.initialEndMinutes;
    _colorValue = task?.colorValue ?? AppColors.taskPalette.first.toARGB32();
    _categoryId = task?.categoryId;
    _isAllDay = task?.isAllDay ?? widget.initialAllDay;
    _isCompleted = task?.isCompleted ?? false;
    _isLocked = task?.isLocked ?? false;
    _titleController.addListener(_markDirty);
    _noteController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _titleController
      ..removeListener(_markDirty)
      ..dispose();
    _noteController
      ..removeListener(_markDirty)
      ..dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  void _change(VoidCallback change) {
    setState(() {
      change();
      _dirty = true;
      _timeError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final screen = MediaQuery.sizeOf(context);
    final sheetHeight = math.max(
      240.0,
      math.min(screen.height * 0.93, screen.height - viewInsets.bottom - 12),
    );
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: PopScope<TaskEditorResult>(
        canPop: _allowPop || !_dirty,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _requestClose();
        },
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: sheetHeight,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 10, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.task == null ? '新增任务' : '编辑任务',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      IconButton(
                        tooltip: '关闭',
                        onPressed: _requestClose,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            autofocus: widget.task == null,
                            maxLength: 50,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: '任务名称',
                              hintText: '准备做什么？',
                              prefixIcon: Icon(Icons.edit_outlined),
                            ),
                            validator:
                                (value) =>
                                    value == null || value.trim().isEmpty
                                        ? '请输入任务名称'
                                        : null,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _pickDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: '日期',
                                      prefixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                      ),
                                    ),
                                    child: Text(
                                      '${_date.year}年${_date.month}月'
                                      '${_date.day}日',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 112,
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  title: const Text('全天'),
                                  value: _isAllDay,
                                  onChanged:
                                      (value) =>
                                          _change(() => _isAllDay = value),
                                ),
                              ),
                            ],
                          ),
                          if (!_isAllDay) ...[
                            const SizedBox(height: 14),
                            TaskTimeEditor(
                              startMinutes: _startMinutes,
                              endMinutes: _endMinutes,
                              stepMinutes: _stepMinutes,
                              errorText: _timeError,
                              onStartPicked: () => _pickTime(isStart: true),
                              onEndPicked: () => _pickTime(isStart: false),
                              onStartAdjusted: _adjustStart,
                              onEndAdjusted: _adjustEnd,
                              onStepChanged:
                                  (value) =>
                                      _change(() => _stepMinutes = value),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed:
                                    () => _change(() => _endMinutes = 1440),
                                child: const Text('结束设为 24:00'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            key: ValueKey('category-${_categoryId ?? 0}'),
                            initialValue: _categoryId ?? 0,
                            decoration: const InputDecoration(
                              labelText: '任务分类',
                              prefixIcon: Icon(Icons.label_outline),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: 0,
                                child: Text('未分类'),
                              ),
                              for (final category in categories)
                                DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                            ],
                            onChanged:
                                (value) => _change(() {
                                  _categoryId = value == 0 ? null : value;
                                  if (_categoryId != null) {
                                    _colorValue =
                                        categories
                                            .firstWhere(
                                              (item) => item.id == _categoryId,
                                            )
                                            .colorValue;
                                  }
                                }),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '任务颜色',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 10,
                            children: [
                              for (final color in AppColors.taskPalette)
                                Semantics(
                                  label: '选择任务颜色',
                                  selected: color.toARGB32() == _colorValue,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap:
                                        () => _change(
                                          () => _colorValue = color.toARGB32(),
                                        ),
                                    child: SizedBox.square(
                                      dimension: 48,
                                      child: Center(
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                            border:
                                                color.toARGB32() == _colorValue
                                                    ? Border.all(
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                      width: 2,
                                                    )
                                                    : null,
                                          ),
                                          child:
                                              color.toARGB32() == _colorValue
                                                  ? const Icon(
                                                    Icons.check,
                                                    size: 19,
                                                  )
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  title: const Text('已完成'),
                                  value: _isCompleted,
                                  onChanged:
                                      (value) =>
                                          _change(() => _isCompleted = value),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  title: const Text('锁定时间'),
                                  value: _isLocked,
                                  onChanged:
                                      (value) =>
                                          _change(() => _isLocked = value),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _noteController,
                            minLines: 3,
                            maxLines: 6,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              labelText: '备注（选填）',
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _ActionBar(
                  hasTask: widget.task != null,
                  saving: _saving,
                  onDelete: _delete,
                  onCopy: _copy,
                  onCancel: _requestClose,
                  onSave: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: '选择任务日期',
    );
    if (value != null) _change(() => _date = value);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _startMinutes : _endMinutes.clamp(0, 1439);
    final value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
      helpText: isStart ? '选择开始时间' : '选择结束时间',
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
    );
    if (value == null) return;
    final minutes = value.hour * 60 + value.minute;
    if (isStart) {
      if (minutes >= _endMinutes) {
        setState(() => _timeError = '开始时间必须早于结束时间');
        return;
      }
      _change(() => _startMinutes = minutes);
    } else {
      if (minutes <= _startMinutes) {
        setState(() => _timeError = '结束时间必须晚于开始时间');
        return;
      }
      _change(() => _endMinutes = minutes);
    }
  }

  void _adjustStart(int delta) {
    final value = _startMinutes + delta;
    if (value < AppDateUtils.dayStartMinutes ||
        value >
            AppDateUtils.dayEndMinutes - AppDateUtils.manualMinimumMinutes ||
        value >= _endMinutes) {
      setState(() => _timeError = '开始时间须在 07:00 后且早于结束时间');
      return;
    }
    _change(() => _startMinutes = value);
  }

  void _adjustEnd(int delta) {
    final value = _endMinutes + delta;
    if (value > AppDateUtils.dayEndMinutes ||
        value <
            AppDateUtils.dayStartMinutes + AppDateUtils.manualMinimumMinutes ||
        value <= _startMinutes) {
      setState(() => _timeError = '结束时间须在 24:00 前且晚于开始时间');
      return;
    }
    _change(() => _endMinutes = value);
  }

  PlanTaskDraft? _draft() {
    if (!_formKey.currentState!.validate()) return null;
    if (!_isAllDay &&
        (_startMinutes < AppDateUtils.dayStartMinutes ||
            _endMinutes > AppDateUtils.dayEndMinutes ||
            _endMinutes - _startMinutes < AppDateUtils.manualMinimumMinutes)) {
      setState(() {
        _timeError = '时间须在 07:00－24:00，且任务不少于 5 分钟';
      });
      return null;
    }
    final old = widget.task;
    return PlanTaskDraft(
      id: old?.id,
      title: _titleController.text.trim(),
      taskDate: _date,
      startMinutes: _isAllDay ? AppDateUtils.dayStartMinutes : _startMinutes,
      endMinutes: _isAllDay ? AppDateUtils.dayStartMinutes + 5 : _endMinutes,
      colorValue: _colorValue,
      note: _noteController.text.trim(),
      isCompleted: _isCompleted,
      categoryId: _categoryId,
      isLocked: _isLocked,
      isAllDay: _isAllDay,
      sortOrder: old?.sortOrder ?? 0,
      completedAt: _isCompleted ? old?.completedAt ?? DateTime.now() : null,
      plannedDurationMinutes: _isAllDay ? null : _endMinutes - _startMinutes,
    );
  }

  Future<void> _save() async {
    final draft = _draft();
    if (draft == null) return;
    setState(() => _saving = true);
    try {
      final id = await ref.read(planTaskRepositoryProvider).save(draft);
      if (!mounted) return;
      _closeWithResult(TaskEditorResult(TaskEditorAction.saved, taskId: id));
    } on TaskConflictException catch (error) {
      setState(() {
        _saving = false;
        _timeError = error.toString();
      });
    } on RepositoryException catch (error) {
      setState(() {
        _saving = false;
        _timeError = error.message;
      });
    }
  }

  Future<void> _copy() async {
    if (widget.task == null) return;
    final draft = _draft();
    if (draft == null) return;
    final date = await showDatePicker(
      context: context,
      initialDate: _date.add(const Duration(days: 1)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: '复制任务到哪一天？',
    );
    if (date == null || !mounted) return;
    setState(() => _saving = true);
    try {
      final id = await ref
          .read(planTaskRepositoryProvider)
          .save(
            draft.copyWith(
              clearId: true,
              taskDate: date,
              isCompleted: false,
              clearCompletedAt: true,
            ),
          );
      if (!mounted) return;
      _closeWithResult(TaskEditorResult(TaskEditorAction.copied, taskId: id));
    } on TaskConflictException catch (error) {
      setState(() {
        _saving = false;
        _timeError = error.toString();
      });
    } on RepositoryException catch (error) {
      setState(() {
        _saving = false;
        _timeError = error.message;
      });
    }
  }

  Future<void> _delete() async {
    final task = widget.task;
    if (task == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('删除任务？'),
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
    setState(() => _saving = true);
    await ref.read(planTaskRepositoryProvider).delete(task.id);
    if (!mounted) return;
    _closeWithResult(
      TaskEditorResult(TaskEditorAction.deleted, taskId: task.id),
    );
  }

  Future<void> _requestClose() async {
    if (!_dirty) {
      _closeWithResult(null);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('退出编辑？'),
            content: const Text('当前修改尚未保存，确定退出吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('继续编辑'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('确定退出'),
              ),
            ],
          ),
    );
    if (confirmed == true && mounted) {
      _closeWithResult(null);
    }
  }

  void _closeWithResult(TaskEditorResult? result) {
    if (!mounted) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context, result);
    });
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.hasTask,
    required this.saving,
    required this.onDelete,
    required this.onCopy,
    required this.onCancel,
    required this.onSave,
  });

  final bool hasTask;
  final bool saving;
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
              tooltip: '删除',
              onPressed: hasTask && !saving ? onDelete : null,
              icon: Icon(
                Icons.delete_outline,
                color: hasTask ? Theme.of(context).colorScheme.error : null,
              ),
            ),
            TextButton.icon(
              onPressed: hasTask && !saving ? onCopy : null,
              icon: const Icon(Icons.copy_outlined, size: 18),
              label: const Text('复制'),
            ),
            const Spacer(),
            TextButton(
              onPressed: saving ? null : onCancel,
              child: const Text('取消'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: saving ? null : onSave,
              child:
                  saving
                      ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
