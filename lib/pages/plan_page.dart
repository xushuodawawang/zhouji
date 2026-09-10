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
          padding: const EdgeInsets.fromLTRB(10, 3, 8, 2),
          child: SizedBox(
            height: 38,
            child: Row(
              children: [
                const ZhoujiMark(size: 27),
                const SizedBox(width: 7),
                Expanded(
                  child: SegmentedButton<int>(
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(0, 34)),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('周表', key: ValueKey('plan-view-week')),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('月表', key: ValueKey('plan-view-month')),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text('日表', key: ValueKey('plan-view-day')),
                      ),
                    ],
                    selected: {index},
                    onSelectionChanged:
                        (value) =>
                            ref.read(planViewIndexProvider.notifier).state =
                                value.first,
                  ),
                ),
                IconButton(
                  tooltip: '时间轴与配色',
                  constraints: const BoxConstraints.tightFor(
                    width: 38,
                    height: 38,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => showTimelineSettings(context),
                  icon: const Icon(Icons.tune, size: 19),
                ),
              ],
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
