import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import 'compact_create_task_button.dart';

class PlanModeToolbar extends StatelessWidget {
  const PlanModeToolbar({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.onCreate,
  });

  final WeekViewMode mode;
  final ValueChanged<WeekViewMode> onModeChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showCreateLabel = constraints.maxWidth >= 390;
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: SegmentedButton<WeekViewMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: WeekViewMode.overview,
                    icon: Icon(Icons.view_week_outlined, size: 17),
                    label: Text('总览'),
                  ),
                  ButtonSegment(
                    value: WeekViewMode.detail,
                    icon: Icon(Icons.view_day_outlined, size: 17),
                    label: Text('详细'),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (value) => onModeChanged(value.first),
              ),
            ),
            const Spacer(),
            const SizedBox(width: 8),
            CompactCreateTaskButton(
              showLabel: showCreateLabel,
              onPressed: onCreate,
            ),
          ],
        );
      },
    );
  }
}
