import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/activity_record.dart';
import '../models/app_settings.dart';
import '../models/daily_summary.dart';
import '../models/focus_session.dart';
import '../models/monthly_goal.dart';
import '../models/plan_task.dart';
import '../models/task_category.dart';
import '../repositories/activity_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/focus_repository.dart';
import '../repositories/goal_repository.dart';
import '../repositories/plan_task_repository.dart';
import '../repositories/settings_repository.dart';
import '../services/notification_service.dart';
import '../services/focus_music_service.dart';
import '../services/statistics_service.dart';
import '../utils/date_time_utils.dart';
import 'focus_timer_controller.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final planTaskRepositoryProvider = Provider<PlanTaskRepository>(
  (ref) => PlanTaskRepository(ref.watch(databaseProvider)),
);

final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => ActivityRepository(ref.watch(databaseProvider)),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(databaseProvider)),
);

final focusRepositoryProvider = Provider<FocusRepository>(
  (ref) => FocusRepository(ref.watch(databaseProvider)),
);

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(ref.watch(databaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final focusMusicServiceProvider = Provider<FocusMusicService>(
  (ref) => FocusMusicService(),
);

final focusTimerProvider =
    StateNotifierProvider<FocusTimerController, FocusTimerState>((ref) {
      final controller = FocusTimerController(
        repository: ref.watch(focusRepositoryProvider),
        notifications: ref.watch(notificationServiceProvider),
        music: ref.watch(focusMusicServiceProvider),
        loadSettings: ref.read(settingsRepositoryProvider).get,
        onTaskFocusCompleted:
            (taskId) =>
                ref.read(planTaskRepositoryProvider).setCompleted(taskId, true),
        settings:
            ref.read(appSettingsProvider).valueOrNull ?? const AppSettings(),
      );
      ref.listen<AsyncValue<AppSettings>>(appSettingsProvider, (_, next) {
        final settings = next.valueOrNull;
        if (settings != null) controller.updateSettings(settings);
      });
      return controller;
    });

final weekStartProvider = StateProvider<DateTime>(
  (ref) => AppDateUtils.startOfWeek(DateTime.now()),
);

final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => AppDateUtils.startOfMonth(DateTime.now()),
);

/// 计划页的 周/月/日 选项，切换到底栏其他页面时仍保留。
final planViewIndexProvider = StateProvider<int>((ref) => 0);

final bottomNavigationIndexProvider = StateProvider<int>((ref) => 0);

final selectedDateProvider = StateProvider<DateTime>(
  (ref) => AppDateUtils.dateOnly(DateTime.now()),
);

final currentMinuteProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream<DateTime>.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now(),
  );
});

final weekTasksProvider = StreamProvider<List<PlanTask>>((ref) {
  final weekStart = ref.watch(weekStartProvider);
  return ref.watch(planTaskRepositoryProvider).watchWeek(weekStart);
});

final selectedDateTasksProvider = StreamProvider<List<PlanTask>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  return ref.watch(planTaskRepositoryProvider).watchDate(selectedDate);
});

final todayTasksProvider = StreamProvider<List<PlanTask>>((ref) {
  ref.watch(currentMinuteProvider.select((v) => v.valueOrNull?.day));
  return ref.watch(planTaskRepositoryProvider).watchDate(DateTime.now());
});

final focusCandidateTasksProvider = StreamProvider<List<PlanTask>>((ref) {
  ref.watch(currentMinuteProvider.select((v) => v.valueOrNull?.day));
  final day = AppDateUtils.dateOnly(DateTime.now());
  return ref
      .watch(planTaskRepositoryProvider)
      .watchBetween(
        day.subtract(const Duration(days: 1)),
        day.add(const Duration(days: 1)),
      );
});

final allFocusSessionsProvider = StreamProvider<List<FocusSession>>(
  (ref) => ref
      .watch(focusRepositoryProvider)
      .watchBetween(DateTime(1970), DateTime(2200)),
);

final selectedMonthTasksProvider = StreamProvider<List<PlanTask>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(planTaskRepositoryProvider).watchMonth(month);
});

final categoriesProvider = StreamProvider<List<TaskCategory>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);

final appSettingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final selectedMonthGoalsProvider = StreamProvider<List<MonthlyGoal>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(goalRepositoryProvider).watchMonth(month);
});

final todayFocusSessionsProvider = StreamProvider<List<FocusSession>>((ref) {
  ref.watch(currentMinuteProvider.select((v) => v.valueOrNull?.day));
  final start = AppDateUtils.dateOnly(DateTime.now());
  return ref
      .watch(focusRepositoryProvider)
      .watchBetween(start, start.add(const Duration(days: 1)));
});

final statisticsDataProvider =
    FutureProvider.family<StatisticsData, StatisticsRange>((ref, range) async {
      final period = StatisticsPeriod.forRange(range, DateTime.now());
      final categories = await ref.watch(categoriesProvider.future);
      final tasks = await ref
          .watch(planTaskRepositoryProvider)
          .getBetween(period.start, period.end);
      final records = await ref
          .watch(activityRepositoryProvider)
          .getBetween(period.start, period.end);
      final sessions = await ref
          .watch(focusRepositoryProvider)
          .getBetween(period.start, period.end);
      return const StatisticsService().calculate(
        range: range,
        period: period,
        tasks: tasks,
        records: records,
        sessions: sessions,
        categories: categories,
      );
    });

final selectedDateRecordsProvider = StreamProvider<List<ActivityRecord>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  return ref.watch(activityRepositoryProvider).watchDate(selectedDate);
});

final todayRecordsProvider = StreamProvider<List<ActivityRecord>>((ref) {
  return ref.watch(activityRepositoryProvider).watchDate(DateTime.now());
});

final selectedDateSummaryProvider = StreamProvider<DailySummary?>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  return ref.watch(activityRepositoryProvider).watchSummary(selectedDate);
});
