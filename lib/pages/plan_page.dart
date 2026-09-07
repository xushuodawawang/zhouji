import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/lazy_page_stack.dart';
import '../widgets/zhouji_mark.dart';
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
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            children: [
              const ZhoujiMark(size: 38),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '周迹',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '让每一天，留下足迹',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.view_week_outlined, size: 18),
                  label: Text('周计划'),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.calendar_month_outlined, size: 18),
                  label: Text('月计划'),
                ),
                ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.view_day_outlined, size: 18),
                  label: Text('日计划'),
                ),
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
