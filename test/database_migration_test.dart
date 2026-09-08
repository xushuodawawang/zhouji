import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/repositories/plan_task_repository.dart';

void main() {
  test('V1 数据库升级到 V4 后保留旧任务并补齐默认值', () async {
    final sqlite = sqlite3.openInMemory();
    sqlite.execute('''
      CREATE TABLE plan_tasks (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        task_date INTEGER NOT NULL,
        start_minutes INTEGER NOT NULL,
        end_minutes INTEGER NOT NULL,
        color_value INTEGER NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    sqlite.execute('''
      CREATE TABLE activity_records (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        record_date INTEGER NOT NULL,
        title TEXT NOT NULL,
        start_minutes INTEGER NULL,
        end_minutes INTEGER NULL,
        duration_minutes INTEGER NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    sqlite.execute('''
      CREATE TABLE daily_summaries (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        summary_date INTEGER NOT NULL UNIQUE,
        content TEXT NOT NULL DEFAULT '',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    sqlite.execute('''
      INSERT INTO plan_tasks (
        title, task_date, start_minutes, end_minutes, color_value,
        note, is_completed, created_at, updated_at
      ) VALUES (
        '旧版本任务', 1784505600, 420, 480, 4286618021,
        '不能丢失', 0, 1784505600, 1784505600
      )
    ''');
    sqlite.execute('PRAGMA user_version = 1');

    final executor = NativeDatabase.opened(sqlite);
    final database = AppDatabase.forTesting(executor);
    addTearDown(database.close);
    final tasks =
        await PlanTaskRepository(
          database,
        ).watchWeek(DateTime(2026, 7, 20)).first;

    expect(tasks, hasLength(1));
    expect(tasks.single.title, '旧版本任务');
    expect(tasks.single.note, '不能丢失');
    expect(tasks.single.isLocked, isFalse);
    expect(tasks.single.isAllDay, isFalse);
    expect((await database.watchCategories().first).length, 6);
    expect((await database.getSettings()).weekViewMode, 'detail');
    expect((await database.getSettings()).detailHourHeight, 56);
    expect((await database.getSettings()).overviewHourHeight, 28);
    expect((await database.getSettings()).taskCardOpacity, 0.72);
  });

  for (final oldVersion in [2, 3, 4]) {
    test('V$oldVersion 升级后保留任务与原设置，并补齐专注、缩放和日期索引', () async {
      final sqlite = sqlite3.openInMemory();
      sqlite.execute('''
      CREATE TABLE task_categories (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        color_value INTEGER NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');
      sqlite.execute('''
      CREATE TABLE app_settings_table (
        id INTEGER NOT NULL PRIMARY KEY,
        theme_mode TEXT NOT NULL DEFAULT 'system',
        week_view_mode TEXT NOT NULL DEFAULT 'detail',
        schedule_zoom TEXT NOT NULL DEFAULT 'standard',
        pomodoro_focus_minutes INTEGER NOT NULL DEFAULT 25,
        short_break_minutes INTEGER NOT NULL DEFAULT 5,
        long_break_minutes INTEGER NOT NULL DEFAULT 15,
        long_break_interval INTEGER NOT NULL DEFAULT 4,
        notification_enabled INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL
      )
    ''');
      sqlite.execute('''
      CREATE TABLE plan_tasks (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        task_date INTEGER NOT NULL,
        start_minutes INTEGER NOT NULL,
        end_minutes INTEGER NOT NULL,
        color_value INTEGER NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        category_id INTEGER NULL,
        is_locked INTEGER NOT NULL DEFAULT 0,
        is_all_day INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER NULL,
        planned_duration_minutes INTEGER NULL
      )
    ''');
      sqlite.execute('''
      INSERT INTO app_settings_table (
        id, theme_mode, week_view_mode, schedule_zoom, updated_at
      ) VALUES (1, 'dark', 'overview', 'compact', 1784505600)
    ''');
      sqlite.execute('''
      INSERT INTO plan_tasks (
        title, task_date, start_minutes, end_minutes, color_value,
        note, created_at, updated_at
      ) VALUES (
        'V2保留任务', 1784505600, 540, 600, 4286618021,
        '升级不能删除', 1784505600, 1784505600
      )
    ''');
      // V2 shipped both of these tables; include them in the historical fixture.
      sqlite.execute('''
      CREATE TABLE activity_records (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        record_date INTEGER NOT NULL, title TEXT NOT NULL,
        start_minutes INTEGER NULL, end_minutes INTEGER NULL,
        duration_minutes INTEGER NOT NULL, note TEXT NOT NULL DEFAULT '',
        created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
      )
    ''');
      sqlite.execute('''
      CREATE TABLE focus_sessions (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        session_date INTEGER NOT NULL, started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL, planned_minutes INTEGER NOT NULL,
        actual_minutes INTEGER NOT NULL, mode TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0, task_id INTEGER NULL,
        category_id INTEGER NULL, note TEXT NOT NULL DEFAULT '',
        created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
      )
    ''');
      if (oldVersion >= 3) {
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN detail_hour_height REAL NOT NULL DEFAULT 56.0',
        );
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN overview_hour_height REAL NOT NULL DEFAULT 28.0',
        );
      }
      if (oldVersion >= 4) {
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN auto_complete_task_on_focus INTEGER NOT NULL DEFAULT 0',
        );
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN focus_music_enabled INTEGER NOT NULL DEFAULT 0',
        );
        sqlite.execute(
          "ALTER TABLE app_settings_table ADD COLUMN focus_music_uri TEXT NOT NULL DEFAULT ''",
        );
        sqlite.execute(
          "ALTER TABLE app_settings_table ADD COLUMN focus_music_name TEXT NOT NULL DEFAULT ''",
        );
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN timeline_start_minutes INTEGER NOT NULL DEFAULT 0',
        );
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN timeline_end_minutes INTEGER NOT NULL DEFAULT 1440',
        );
        sqlite.execute(
          'ALTER TABLE app_settings_table ADD COLUMN auto_color_enabled INTEGER NOT NULL DEFAULT 1',
        );
        sqlite.execute(
          'ALTER TABLE plan_tasks ADD COLUMN focus_minutes INTEGER NULL',
        );
        sqlite.execute(
          'ALTER TABLE activity_records ADD COLUMN is_completed INTEGER NOT NULL DEFAULT 1',
        );
        sqlite.execute('''CREATE TABLE focus_presets (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL, minutes INTEGER NOT NULL DEFAULT 25,
          color_value INTEGER NOT NULL
        )''');
      }
      sqlite.execute('PRAGMA user_version = $oldVersion');
      sqlite.execute('''CREATE TABLE active_timers (
      id INTEGER NOT NULL PRIMARY KEY, mode TEXT NOT NULL, phase TEXT NOT NULL,
      started_at INTEGER NOT NULL, expected_end_at INTEGER NOT NULL,
      remaining_seconds INTEGER NOT NULL, is_running INTEGER NOT NULL,
      cycle_count INTEGER NOT NULL DEFAULT 0, task_id INTEGER NULL,
      category_id INTEGER NULL, updated_at INTEGER NOT NULL
    )''');
      if (oldVersion >= 4) {
        sqlite.execute(
          'ALTER TABLE active_timers ADD COLUMN total_seconds INTEGER NULL',
        );
        sqlite.execute(
          "ALTER TABLE active_timers ADD COLUMN title TEXT NOT NULL DEFAULT ''",
        );
      }

      final database = AppDatabase.forTesting(NativeDatabase.opened(sqlite));
      addTearDown(database.close);
      final settings = await database.getSettings();
      final tasks =
          await PlanTaskRepository(
            database,
          ).watchWeek(DateTime(2026, 7, 20)).first;

      expect(settings.themeMode, 'dark');
      expect(settings.timelineStartMinutes, 0);
      expect(settings.timelineEndMinutes, 1440);
      expect(settings.autoCompleteTaskOnFocus, isFalse);
      expect(settings.taskCardOpacity, 0.72);
      expect(await database.select(database.focusPresets).get(), isEmpty);
      expect(settings.weekViewMode, 'overview');
      expect(settings.detailHourHeight, 56);
      expect(settings.overviewHourHeight, 28);
      expect(tasks.single.title, 'V2保留任务');
      expect(tasks.single.note, '升级不能删除');
      final indexes =
          await database
              .customSelect(
                "SELECT name FROM sqlite_master WHERE type = 'index' AND name LIKE 'idx_%'",
              )
              .get();
      expect(
        indexes.map((row) => row.read<String>('name')),
        containsAll([
          'idx_plan_date_start',
          'idx_record_date',
          'idx_focus_date',
        ]),
      );
      final queryPlan =
          await database
              .customSelect(
                'EXPLAIN QUERY PLAN SELECT * FROM plan_tasks WHERE task_date >= 0 AND task_date < 2000000000',
              )
              .get();
      expect(
        queryPlan.map((row) => row.read<String>('detail')).join(' '),
        contains('idx_plan_date_start'),
      );
    });
  }
}
