import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zhouji/app.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/providers/app_providers.dart';
import 'package:zhouji/repositories/settings_repository.dart';

Future<void> frames(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 2)),
    );
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('zh_CN'));
  testWidgets('手机尺寸下主题色即时生效，统计范围可保存，自定义取消后保持原范围', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    container.read(bottomNavigationIndexProvider.notifier).state = 3;
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const ZhoujiApp()),
    );
    await frames(tester);
    final before =
        tester
            .widget<MaterialApp>(find.byType(MaterialApp))
            .theme!
            .colorScheme
            .primary;
    await tester.tap(find.byTooltip('设置'));
    await frames(tester);
    await tester.tap(find.text('青绿'));
    await frames(tester);
    await tester.tap(find.text('湖蓝').last);
    await frames(tester);
    final after =
        tester
            .widget<MaterialApp>(find.byType(MaterialApp))
            .theme!
            .colorScheme
            .primary;
    expect(after, isNot(before));
    expect(
      (await tester.runAsync(() => SettingsRepository(db).get()))!.themeColor,
      0xFF3569A8,
    );
    await tester.ensureVisible(find.text('全部历史'));
    await tester.tap(find.text('全部历史'));
    await frames(tester);
    await tester.tap(find.text('最近 7 天').last);
    await frames(tester);
    expect(
      (await tester.runAsync(
        () => SettingsRepository(db).get(),
      ))!.focusStatisticsDays,
      7,
    );
    await tester.tap(find.text('最近 7 天'));
    await frames(tester);
    await tester.tap(find.text('自定义天数…').last);
    await frames(tester);
    await tester.tap(find.text('取消'));
    await frames(tester);
    expect(find.text('最近 7 天'), findsOneWidget);
    expect(
      (await tester.runAsync(
        () => SettingsRepository(db).get(),
      ))!.focusStatisticsDays,
      7,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    final close = db.close();
    await frames(tester);
    await close;
  });
}
