import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zhouji/app.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/providers/app_providers.dart';

void main() {
  setUpAll(() => initializeDateFormatting('zh_CN'));

  testWidgets('默认进入周计划并可切换到记录', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const ZhoujiApp(),
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('周计划'), findsWidgets);
    expect(find.text('点击或长按空白时间段创建计划'), findsOneWidget);
    await tester.tap(find.text('记录').last);
    await _pumpFrames(tester);
    expect(find.text('今日完成记录'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _disposeApp(tester, database);
  });

  testWidgets('计划页可切换周、月、日视图', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const ZhoujiApp(),
      ),
    );
    await _pumpFrames(tester);

    await tester.tap(find.text('月计划'));
    await _pumpFrames(tester);
    expect(find.text('本月'), findsOneWidget);
    await tester.tap(find.text('日计划'));
    await _pumpFrames(tester);
    expect(find.text('开始专注'), findsOneWidget);
    expect(find.text('全天安排'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _disposeApp(tester, database);
  });

  testWidgets('底栏可进入专注与统计页面', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const ZhoujiApp(),
      ),
    );
    await _pumpFrames(tester);

    await tester.tap(find.text('专注').last);
    await _pumpFrames(tester);
    expect(find.text('开始专注'), findsWidgets);
    expect(find.text('25 + 5'), findsOneWidget);

    await tester.tap(find.text('统计').last);
    await _pumpFrames(tester);
    expect(find.text('累计专注'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _disposeApp(tester, database);
  });

  testWidgets('窄屏浅色与横屏深色均无明显溢出', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const ZhoujiApp(),
      ),
    );
    await _pumpFrames(tester);
    expect(tester.takeException(), isNull);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    tester.view.physicalSize = const Size(900, 500);
    await _pumpFrames(tester);
    expect(find.text('周一'), findsOneWidget);
    expect(find.text('周日'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _disposeApp(tester, database);
  });
}

Future<void> _pumpFrames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _disposeApp(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
  await tester.runAsync(database.close);
}
