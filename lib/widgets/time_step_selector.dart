import 'package:flutter/material.dart';

class TimeStepSelector extends StatelessWidget {
  const TimeStepSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('调整步长', style: Theme.of(context).textTheme.labelLarge),
        const Spacer(),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 5, label: Text('5分')),
            ButtonSegment(value: 15, label: Text('15分')),
            ButtonSegment(value: 30, label: Text('30分')),
          ],
          selected: {value},
          onSelectionChanged: (values) => onChanged(values.first),
        ),
      ],
    );
  }
}
