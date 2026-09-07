import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/lazy_page_stack.dart';
import 'daily_record_page.dart';
import 'focus_page.dart';
import 'plan_page.dart';
import 'statistics_page.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavigationIndexProvider);
    // Restore persisted timers even before the focus tab is opened.
    ref.read(focusTimerProvider);
    return Scaffold(
      body: SafeArea(
        child: LazyPageStack(
          index: index,
          children: const [
            PlanPage(),
            FocusPage(),
            DailyRecordPage(),
            StatisticsPage(),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withAlpha(100),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          animationDuration: const Duration(milliseconds: 200),
          onDestinationSelected:
              (value) =>
                  ref.read(bottomNavigationIndexProvider.notifier).state =
                      value,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: '计划',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: '专注',
            ),
            NavigationDestination(
              icon: Icon(Icons.fact_check_outlined),
              selectedIcon: Icon(Icons.fact_check),
              label: '记录',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: '统计',
            ),
          ],
        ),
      ),
    );
  }
}
