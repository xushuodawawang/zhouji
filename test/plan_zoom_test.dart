import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zhouji/app.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/providers/app_providers.dart';
import 'package:zhouji/repositories/plan_task_repository.dart';
import 'package:zhouji/repositories/settings_repository.dart';
import 'package:zhouji/utils/date_time_utils.dart';
import 'package:zhouji/utils/timeline_position_calculator.dart';
import 'package:zhouji/widgets/week_schedule.dart';

void main() {
  setUpAll(() => initializeDateFormatting('zh_CN'));

  testWidgets('紧凑新建按钮与模式切换同行，长任务标题按高度换行', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = PlanTaskRepository(database);
    final monday = AppDateUtils.startOfWeek(DateTime.now());
    final taskId = await repository.save(
      PlanTaskDraft(
        title: '考研第一轮数学复习与错题整理',
        taskDate: monday,
        startMinutes: 8 * 60,
        endMinutes: 10 * 60,
        colorValue: 0xFF80A9A5,
      ),
    );
    await _pumpApp(tester, database, size: const Size(1000, 900));

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byTooltip('新建任务'), findsOneWidget);
    final modeY = tester.getCenter(find.text('详细')).dy;
    final createY = tester.getCenter(find.byTooltip('新建任务')).dy;
    expect((modeY - createY).abs(), lessThan(3));

    await tester.ensureVisible(find.byKey(ValueKey(taskId)));
    await _settle(tester);
    final detailTitle = tester.widget<Text>(find.text('考研第一轮数学复习与错题整理'));
    expect(detailTitle.softWrap, isTrue);
    expect(detailTitle.maxLines, greaterThan(1));
    expect(detailTitle.maxLines, 4);

    await tester.tap(find.text('总览'));
    await _settle(tester);
    final overviewTitle = tester.widget<Text>(find.text('考研第一轮数学复习与错题整理'));
    expect(overviewTitle.softWrap, isTrue);
    expect(overviewTitle.maxLines, 2);
    expect(tester.takeException(), isNull);
    await _dispose(tester, database);
  });

  testWidgets('按钮、双指和适配整天缩放保持时间中心且不修改任务数据', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final taskRepository = PlanTaskRepository(database);
    final settingsRepository = SettingsRepository(database);
    final monday = AppDateUtils.startOfWeek(DateTime.now());
    final taskId = await taskRepository.save(
      PlanTaskDraft(
        title: '缩放位置测试',
        taskDate: monday,
        startMinutes: 14 * 60,
        endMinutes: 16 * 60,
        colorValue: 0xFF80A9A5,
      ),
    );
    await _pumpApp(tester, database, size: const Size(1000, 900));

    expect(find.text('100%'), findsOneWidget);
    final vertical = _verticalScheduleState(tester);
    vertical.position.jumpTo(260.0.clamp(0, vertical.position.maxScrollExtent));
    await tester.pump();
    final oldCenterMinutes =
        (vertical.position.pixels + vertical.position.viewportDimension / 2) /
        TimelinePositionCalculator.defaultDetailHourHeight *
        60;

    final oldTaskHeight = tester.getSize(find.byKey(ValueKey(taskId))).height;
    await tester.tap(find.byKey(const ValueKey('detail-zoom-out')));
    await _settle(tester);
    expect(find.text('86%'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(ValueKey(taskId))).height,
      lessThan(oldTaskHeight),
    );
    await tester.tap(find.byKey(const ValueKey('detail-zoom-in')));
    await _settle(tester);
    expect(find.text('100%'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('detail-zoom-in')));
    await _settle(tester);
    expect(find.text('114%'), findsOneWidget);
    final newCenterMinutes =
        (vertical.position.pixels + vertical.position.viewportDimension / 2) /
        64 *
        60;
    expect((newCenterMinutes - oldCenterMinutes).abs(), lessThan(2));
    expect(
      tester.getSize(find.byKey(ValueKey(taskId))).height,
      greaterThan(oldTaskHeight),
    );

    final scheduleRect = tester.getRect(find.byType(WeekSchedule));
    final focal = scheduleRect.center + const Offset(0, 40);
    final first = await tester.createGesture(pointer: 11);
    final second = await tester.createGesture(pointer: 12);
    await first.down(focal - const Offset(35, 0));
    await second.down(focal + const Offset(35, 0));
    await tester.pump();
    await first.moveTo(focal - const Offset(65, 0));
    await second.moveTo(focal + const Offset(65, 0));
    await tester.pump(const Duration(milliseconds: 100));
    await first.up();
    await second.up();
    await _settle(tester);
    final afterPinch = await settingsRepository.get();
    expect(afterPinch.detailHourHeight, greaterThan(64));

    await tester.tap(find.byKey(const ValueKey('detail-zoom-fit-day')));
    await _settle(tester);
    expect(vertical.position.maxScrollExtent, lessThan(1));
    final fitted = await settingsRepository.get();
    expect(
      fitted.detailHourHeight,
      inInclusiveRange(
        TimelinePositionCalculator.minHourHeight,
        TimelinePositionCalculator.maxHourHeight,
      ),
    );

    final task =
        (await taskRepository.getBetween(
          monday,
          monday.add(const Duration(days: 7)),
        )).single;
    expect(task.startMinutes, 14 * 60);
    expect(task.endMinutes, 16 * 60);
    expect(tester.takeException(), isNull);
    await _dispose(tester, database);
  });

  testWidgets('小屏幕模式工具栏自动使用图标新建且不溢出', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await _pumpApp(tester, database, size: const Size(360, 640));
    expect(find.byTooltip('新建任务'), findsOneWidget);
    expect(find.text('新建'), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(tester.takeException(), isNull);
    await _dispose(tester, database);
  });
}

ScrollableState _verticalScheduleState(WidgetTester tester) {
  final finder = find.descendant(
    of: find.byType(WeekSchedule),
    matching: find.byType(Scrollable),
  );
  for (var index = 0; index < finder.evaluate().length; index++) {
    final state = tester.state<ScrollableState>(finder.at(index));
    if (axisDirectionToAxis(state.position.axisDirection) == Axis.vertical) {
      return state;
    }
  }
  throw StateError('未找到周时间表纵向滚动器');
}

Future<void> _pumpApp(
  WidgetTester tester,
  AppDatabase database, {
  required Size size,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const ZhoujiApp(),
    ),
  );
  await _settle(tester);
}

Future<void> _dispose(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 100));
  await database.close();
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pump();
}
