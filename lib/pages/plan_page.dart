import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/lazy_page_stack.dart';
import '../widgets/zhouji_mark.dart';
import '../widgets/timeline_settings_sheet.dart';
import 'day_plan_page.dart';
import 'month_plan_page.dart';
import 'week_plan_page.dart';

class PlanPage extends ConsumerWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(planViewIndexProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
          child: Row(
            children: [
              const ZhoujiMark(size: 30),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '周迹',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                tooltip: '时间轴与配色',
                visualDensity: VisualDensity.compact,
                onPressed: () => showTimelineSettings(context),
                icon: const Icon(Icons.tune, size: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(0, 38)),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 0, label: Text('周计划')),
                ButtonSegment(value: 1, label: Text('月计划')),
                ButtonSegment(value: 2, label: Text('日计划')),
              ],
              selected: {index},
              onSelectionChanged:
                  (value) =>
                      ref.read(planViewIndexProvider.notifier).state =
                          value.first,
            ),
          ),
        ),
        Expanded(
          child: LazyPageStack(
            index: index,
            children: const [WeekPlanPage(), MonthPlanPage(), DayPlanPage()],
          ),
        ),
      ],
    );
  }
}
