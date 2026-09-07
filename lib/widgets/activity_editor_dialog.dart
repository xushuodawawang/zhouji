import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/activity_record.dart';
import '../utils/date_time_utils.dart';

enum ActivityEditorAction { save, delete }

class ActivityEditorResult {
  const ActivityEditorResult(this.action, [this.draft]);

  final ActivityEditorAction action;
  final ActivityRecordDraft? draft;
}

Future<ActivityEditorResult?> showActivityEditorDialog(
  BuildContext context, {
  required DateTime date,
  ActivityRecord? record,
}) {
  return showDialog<ActivityEditorResult>(
    context: context,
    builder: (context) => ActivityEditorDialog(date: date, record: record),
  );
}

class ActivityEditorDialog extends StatefulWidget {
  const ActivityEditorDialog({super.key, required this.date, this.record});

  final DateTime date;
  final ActivityRecord? record;

  @override
  State<ActivityEditorDialog> createState() => _ActivityEditorDialogState();
}

class _ActivityEditorDialogState extends State<ActivityEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _noteController;
  int? _startMinutes;
  int? _endMinutes;

  @override
  void initState() {
    super.initState();
    final record = widget.record;
    _titleController = TextEditingController(text: record?.title);
    _durationController = TextEditingController(
      text: record == null ? '' : record.durationMinutes.toString(),
    );
    _noteController = TextEditingController(text: record?.note);
    _startMinutes = record?.startMinutes;
    _endMinutes = record?.endMinutes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.record == null ? '新增完成记录' : '编辑完成记录'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: widget.record == null,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: '事项名称',
                    hintText: '今天实际完成了什么？',
                    prefixIcon: Icon(Icons.done_all_outlined),
                  ),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? '请输入事项名称'
                              : null,
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '记录日期',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    '${widget.date.year}年${widget.date.month}月'
                    '${widget.date.day}日',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        key: ValueKey('activity-start-$_startMinutes'),
                        initialValue: _startMinutes,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: '开始时间'),
                        items: _timeItems(isEnd: false),
                        onChanged: (value) {
                          setState(() {
                            _startMinutes = value;
                            if (value == null) {
                              _endMinutes = null;
                            } else if (_endMinutes == null ||
                                _endMinutes! <= value) {
                              _endMinutes = (value + AppDateUtils.slotMinutes)
                                  .clamp(
                                    AppDateUtils.slotMinutes,
                                    AppDateUtils.dayEndMinutes,
                                  );
                            }
                            _updateCalculatedDuration();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        key: ValueKey(
                          'activity-end-$_startMinutes-$_endMinutes',
                        ),
                        initialValue: _endMinutes,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: '结束时间'),
                        items: _timeItems(isEnd: true),
                        onChanged:
                            _startMinutes == null
                                ? null
                                : (value) {
                                  setState(() {
                                    _endMinutes = value;
                                    if (value == null) _startMinutes = null;
                                    _updateCalculatedDuration();
                                  });
                                },
                        validator: (_) {
                          if (_startMinutes != null &&
                              _endMinutes != null &&
                              _endMinutes! <= _startMinutes!) {
                            return '需晚于开始';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '实际用时（分钟）',
                    hintText: '可自动计算或手动填写',
                    prefixIcon: Icon(Icons.timelapse_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请填写实际用时';
                    }
                    return int.tryParse(value) == null ? '请输入整数分钟' : null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 5,
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
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (widget.record != null)
          IconButton(
            tooltip: '删除记录',
            onPressed:
                () => Navigator.pop(
                  context,
                  const ActivityEditorResult(ActivityEditorAction.delete),
                ),
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          )
        else
          const SizedBox.shrink(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _save, child: const Text('保存')),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<int?>> _timeItems({required bool isEnd}) {
    final start = isEnd ? AppDateUtils.slotMinutes : 0;
    final end =
        isEnd
            ? AppDateUtils.dayEndMinutes
            : AppDateUtils.dayEndMinutes - AppDateUtils.slotMinutes;
    return [
      const DropdownMenuItem<int?>(value: null, child: Text('不填写')),
      for (var value = start; value <= end; value += AppDateUtils.slotMinutes)
        DropdownMenuItem<int?>(
          value: value,
          child: Text(AppDateUtils.formatMinutes(value)),
        ),
    ];
  }

  void _updateCalculatedDuration() {
    final start = _startMinutes;
    final end = _endMinutes;
    if (start != null && end != null && end > start) {
      _durationController.text = (end - start).toString();
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ActivityEditorResult(
        ActivityEditorAction.save,
        ActivityRecordDraft(
          id: widget.record?.id,
          recordDate: widget.date,
          title: _titleController.text.trim(),
          startMinutes: _startMinutes,
          endMinutes: _endMinutes,
          durationMinutes: int.parse(_durationController.text),
          note: _noteController.text.trim(),
        ),
      ),
    );
  }
}
