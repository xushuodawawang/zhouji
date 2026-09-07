import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/app_settings.dart';
import 'package:zhouji/repositories/category_repository.dart';
import 'package:zhouji/repositories/goal_repository.dart';
import 'package:zhouji/repositories/settings_repository.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('创建、完成和删除月目标', () async {
    final repository = GoalRepository(database);
    final month = DateTime(2026, 7);
    final id = await repository.save(month: month, content: '完成 V2');
    var goals = await repository.watchMonth(month).first;
    expect(goals.single.content, '完成 V2');

    await repository.save(
      goal: goals.single,
      month: month,
      content: goals.single.content,
      isCompleted: true,
    );
    goals = await repository.watchMonth(month).first;
    expect(goals.single.isCompleted, isTrue);
    await repository.delete(id);
    expect(await repository.watchMonth(month).first, isEmpty);
  });

  test('默认分类、自定义分类与设置均持久化', () async {
    final categories = CategoryRepository(database);
    final defaults = await categories.watchAll().first;
    expect(defaults.length, 6);
    final id = await categories.save(name: '备考', colorValue: 0xFF718C88);
    var all = await categories.watchAll().first;
    expect(all.any((item) => item.id == id && item.name == '备考'), isTrue);
    await categories.delete(all.singleWhere((item) => item.id == id));
    all = await categories.watchAll().first;
    expect(all.length, 6);

    final settings = SettingsRepository(database);
    await settings.save(
      const AppSettings(
        themeMode: 'dark',
        weekViewMode: WeekViewMode.overview,
        scheduleZoom: ScheduleZoom.compact,
        detailHourHeight: 72,
        overviewHourHeight: 32,
        pomodoroFocusMinutes: 50,
        shortBreakMinutes: 10,
      ),
    );
    final loaded = await settings.get();
    expect(loaded.themeMode, 'dark');
    expect(loaded.weekViewMode, WeekViewMode.overview);
    expect(loaded.pomodoroFocusMinutes, 50);
    expect(loaded.detailHourHeight, 72);
    expect(loaded.overviewHourHeight, 32);
  });
}
