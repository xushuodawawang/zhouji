import 'package:flutter/material.dart';

import '../utils/date_time_utils.dart';
import 'time_step_selector.dart';

class TaskTimeEditor extends StatelessWidget {
  const TaskTimeEditor({
    super.key,
    required this.startMinutes,
    required this.endMinutes,
    required this.stepMinutes,
    required this.onStartPicked,
    required this.onEndPicked,
    required this.onStartAdjusted,
    required this.onEndAdjusted,
    required this.onStepChanged,
    this.errorText,
  });

  final int startMinutes;
  final int endMinutes;
  final int stepMinutes;
  final VoidCallback onStartPicked;
  final VoidCallback onEndPicked;
  final ValueChanged<int> onStartAdjusted;
  final ValueChanged<int> onEndAdjusted;
  final ValueChanged<int> onStepChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TimeAdjustRow(
          label: '开始时间',
          minutes: startMinutes,
          step: stepMinutes,
          onPick: onStartPicked,
          onAdjust: onStartAdjusted,
        ),
        const SizedBox(height: 8),
        _TimeAdjustRow(
          label: '结束时间',
          minutes: endMinutes,
          step: stepMinutes,
          onPick: onEndPicked,
          onAdjust: onEndAdjusted,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.timelapse, size: 19),
              const SizedBox(width: 9),
              const Text('任务时长'),
              const Spacer(),
              Text(
                AppDateUtils.formatDuration(endMinutes - startMinutes),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 7, 8, 0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 12),
        TimeStepSelector(value: stepMinutes, onChanged: onStepChanged),
      ],
    );
  }
}

class _TimeAdjustRow extends StatelessWidget {
  const _TimeAdjustRow({
    required this.label,
    required this.minutes,
    required this.step,
    required this.onPick,
    required this.onAdjust,
  });

  final String label;
  final int minutes;
  final int step;
  final VoidCallback onPick;
  final ValueChanged<int> onAdjust;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
        IconButton.outlined(
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          tooltip: '减少 $step 分钟',
          onPressed: () => onAdjust(-step),
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withAlpha(105),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                AppDateUtils.formatMinutes(minutes),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 7),
        IconButton.outlined(
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          tooltip: '增加 $step 分钟',
          onPressed: () => onAdjust(step),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
