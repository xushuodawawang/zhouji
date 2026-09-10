import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zhouji/app.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/models/focus_session.dart';
import 'package:zhouji/repositories/focus_repository.dart';
import 'package:zhouji/pages/focus_page.dart';
import 'package:zhouji/pages/month_plan_page.dart';
import 'package:zhouji/pages/statistics_page.dart';
import 'package:zhouji/providers/app_providers.dart';
import 'package:zhouji/repositories/plan_task_repository.dart';
import 'package:zhouji/utils/app_colors.dart';
import 'package:zhouji/utils/date_time_utils.dart';

const _capture = bool.fromEnvironment('CAPTURE_UI');

void main() {
  setUpAll(() async {
    await initializeDateFormatting('zh_CN');
    if (_capture) {
      await (FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    }
    if (_capture && Platform.isWindows) {
      final bytes =
          await File(
            '${Platform.environment['WINDIR']}/Fonts/msyh.ttc',
          ).readAsBytes();
      await (FontLoader('Roboto')
        ..addFont(Future.value(ByteData.sublistView(bytes)))).load();
    }
  });

  testWidgets('页面按需加载，秒级计时不重建表单，切换后继续计时', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const ZhoujiApp()),
    );
    await _frames(tester);
    expect(find.byType(FocusPage, skipOffstage: false), findsNothing);
    expect(find.byType(MonthPlanPage, skipOffstage: false), findsNothing);
    expect(find.byType(StatisticsPage, skipOffstage: false), findsNothing);
    await tester.tap(find.text('专注').last);
    await _frames(tester);
    await tester.tap(find.text('开始专注'));
    await _frames(tester);
    final dropdown = tester.widget(find.byType(DropdownButtonFormField<int>));
    final before = container.read(focusTimerProvider).remainingSeconds;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1100)),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(
      container.read(focusTimerProvider).remainingSeconds,
      lessThan(before),
    );
    expect(
      identical(
        dropdown,
        tester.widget(find.byType(DropdownButtonFormField<int>)),
      ),
      isTrue,
    );
    await tester.tap(find.text('计划').last);
    await _frames(tester);
    final hiddenBefore = container.read(focusTimerProvider).remainingSeconds;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1100)),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('专注').last);
    await _frames(tester);
    expect(
      container.read(focusTimerProvider).remainingSeconds,
      lessThan(hiddenBefore),
    );
    expect(find.text('暂停'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(() async {
      container.dispose();
      await database.close();
    });
  });

  testWidgets('默认开始采用当前计划，自建正向计时卡片可直接开始', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
    final id = await tester.runAsync(
      () => PlanTaskRepository(database).save(
        PlanTaskDraft(
          title: '数学',
          taskDate: DateTime.now(),
          startMinutes: 0,
          endMinutes: 1440,
          focusMinutes: 60,
          colorValue: 0xFF719B87,
        ),
      ),
    );
    container.read(bottomNavigationIndexProvider.notifier).state = 1;
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const ZhoujiApp()),
    );
    await _frames(tester);
    await tester.ensureVisible(find.text('开始专注'));
    await _frames(tester);
    await tester.tap(find.text('开始专注'));
    await _frames(tester);
    expect(container.read(focusTimerProvider).taskId, id);
    expect(container.read(focusTimerProvider).totalSeconds, 3600);
    await tester.runAsync(
      () => container.read(focusTimerProvider.notifier).reset(),
    );
    await _frames(tester);
    expect(container.read(focusTimerProvider).isActive, isFalse);
    await tester.drag(find.byType(ListView).first, const Offset(0, 1600));
    await _frames(tester);
    await tester.ensureVisible(find.text('新建'));
    await _frames(tester);
    await tester.tap(find.text('新建'));
    await _frames(tester);
    await tester.enterText(find.byType(TextFormField).first, '专业课');
    await tester.tap(find.text('正向计时'));
    await _frames(tester);
    await tester.tap(find.text('保存'));
    await _frames(tester);
    final presets = await tester.runAsync(
      () => database.select(database.focusPresets).get(),
    );
    expect(presets!.single.title, '专业课');
    expect(presets.single.minutes, 0);
    final start = find.widgetWithText(TextButton, '开始');
    await tester.ensureVisible(start);
    await _frames(tester);
    await tester.tap(start);
    await _frames(tester);
    expect(container.read(focusTimerProvider).isStopwatch, isTrue);
    expect(container.read(focusTimerProvider).title, '专业课');
    final updatedPlans = await tester.runAsync(
      () => PlanTaskRepository(database).getBetween(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 1)),
      ),
    );
    expect(updatedPlans!.single.title, '专业课');
    expect(
      updatedPlans.single.startMinutes,
      lessThan(updatedPlans.single.endMinutes),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() async {
      container.dispose();
      await database.close();
    });
  });

  testWidgets('各主要页面在手机尺寸可呈现，可选导出真实界面截图', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final now = DateTime.now();
    await tester.runAsync(() async {
      final repository = PlanTaskRepository(database);
      for (final entry in [
        ('数学', 60),
        ('英语阅读', 30),
        ('计算机网络', 0),
        ('政治复习', 25),
      ]) {
        await database
            .into(database.focusPresets)
            .insert(
              FocusPresetsCompanion.insert(
                title: entry.$1,
                minutes: drift.Value(entry.$2),
                colorValue: AppColors.automaticTaskColor(entry.$1),
              ),
            );
      }
      for (var i = 0; i < 3; i++) {
        final start = DateTime(now.year, now.month, now.day, 8 + i * 2);
        await FocusRepository(database).addSession(
          startedAt: start,
          endedAt: start.add(Duration(minutes: 60 + i * 10)),
          plannedMinutes: 60 + i * 10,
          actualMinutes: 60 + i * 10,
          mode: TimerMode.pomodoro,
          completed: true,
          note: ['数学', '英语阅读', '计算机网络'][i],
        );
      }
      for (var i = 0; i < 4; i++) {
        await repository.save(
          PlanTaskDraft(
            title: ['英语阅读 · 精读训练', '高等数学 · 专项练习', '午后散步', '专业课 · 整理笔记'][i],
            taskDate: AppDateUtils.startOfWeek(now),
            startMinutes: 480 + i * 90,
            endMinutes: 540 + i * 90,
            colorValue: AppColors.automaticTaskColor(
              ['英语阅读', '高等数学', '午后散步', '专业课'][i],
            ),
          ),
        );
      }
    });
    final boundary = GlobalKey();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: RepaintBoundary(key: boundary, child: const ZhoujiApp()),
      ),
    );
    await _frames(tester);
    await _snapshot(tester, boundary, '01-plan');
    for (final item in [
      ('专注', '02-focus'),
      ('记录', '03-record'),
      ('统计', '04-statistics'),
    ]) {
      await tester.tap(find.text(item.$1).last);
      await _frames(tester);
      expect(tester.takeException(), isNull);
      await _snapshot(tester, boundary, item.$2);
    }
    await tester.tap(find.text('计划').last);
    await _frames(tester);
    await tester.tap(find.byKey(const ValueKey('plan-view-month')));
    await _frames(tester);
    await _snapshot(tester, boundary, '05-month');
    await tester.tap(find.byKey(const ValueKey('plan-view-day')));
    await _frames(tester);
    await _snapshot(tester, boundary, '06-day');
    await tester.tap(find.text('专注').last);
    await _frames(tester);
    await tester.drag(find.byType(ListView).first, const Offset(0, -1050));
    await _frames(tester);
    expect(find.text('专注时锁定手机'), findsOneWidget);
    expect(find.text('番茄完成铃声'), findsOneWidget);
    expect(find.text('专注背景音乐'), findsOneWidget);
    expect(find.text('导入本地歌单'), findsOneWidget);
    await _snapshot(tester, boundary, '08-focus-tools');
    await tester.drag(find.byType(ListView).first, const Offset(0, 1600));
    await _frames(tester);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await _snapshot(tester, boundary, '07-dark-focus');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(() async {
      container.dispose();
      await database.close();
    });
  });
}

Future<void> _frames(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _snapshot(WidgetTester tester, GlobalKey key, String name) async {
  if (!_capture) return;
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = Directory('build/ui-preview')
      ..createSync(recursive: true);
    await File(
      '${directory.path}/$name.png',
    ).writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}
