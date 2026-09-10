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
import 'package:zhouji/utils/date_time_utils.dart';
import 'package:zhouji/utils/timeline_position_calculator.dart';
import 'package:zhouji/widgets/task_block.dart';
import 'package:zhouji/widgets/task_editor_sheet.dart';

void main() {
  setUpAll(() => initializeDateFormatting('zh_CN'));

  testWidgets('普通、锁定和15分钟任务点击均打开编辑面板，长按打开快捷菜单', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = PlanTaskRepository(database);
    final monday = AppDateUtils.startOfWeek(DateTime.now());
    final normalId = await repository.save(_draft('普通任务', monday, 450, 510));
    final lockedId = await repository.save(
      _draft('锁定任务', monday, 540, 600).copyWith(isLocked: true),
    );
    final shortId = await repository.save(_draft('短任务', monday, 630, 645));
    final adjacentShortId = await repository.save(
      _draft('相邻短任务', monday, 645, 660),
    );
    await _pumpApp(tester, database, size: const Size(1000, 900));

    for (final entry
        in {
          normalId: '普通任务',
          lockedId: '锁定任务',
          shortId: '短任务',
          adjacentShortId: '相邻短任务',
        }.entries) {
      await tester.ensureVisible(find.byKey(ValueKey(entry.key)));
      await tester.tap(find.byKey(ValueKey(entry.key)), warnIfMissed: false);
      await _settle(tester);
      expect(find.text('编辑任务'), findsOneWidget);
      await tester.tap(find.byTooltip('关闭'));
      await _settle(tester);
    }

    expect(
      find.descendant(
        of: find.byKey(ValueKey(lockedId)),
        matching: find.byType(TaskDragHandle),
      ),
      findsNothing,
    );
    final lockBadge = find.descendant(
      of: find.byKey(ValueKey(lockedId)),
      matching: find.byKey(const ValueKey('task-lock-badge')),
    );
    expect(lockBadge, findsOneWidget);
    final lockRect = tester.getRect(lockBadge);
    final lockedTitleRect = tester.getRect(find.text('锁定任务'));
    expect(lockRect.bottom, lessThanOrEqualTo(lockedTitleRect.top));
    expect(
      find.descendant(
        of: find.byKey(ValueKey(normalId)),
        matching: find.byType(TaskDragHandle),
      ),
      findsOneWidget,
    );
    expect(tester.getSize(find.byKey(ValueKey(shortId))).height, 12);
    expect(tester.getSize(find.byKey(ValueKey(adjacentShortId))).height, 12);
    expect(
      tester.getSize(find.byKey(ValueKey(shortId))).width,
      closeTo(tester.getSize(find.byKey(ValueKey(normalId))).width, 0.01),
    );

    await tester.ensureVisible(find.byKey(ValueKey(normalId)));
    final normalRect = tester.getRect(find.byKey(ValueKey(normalId)));
    await tester.dragFrom(
      normalRect.centerLeft + const Offset(24, 0),
      const Offset(0, -120),
    );
    await _settle(tester);
    expect(find.text('编辑任务'), findsNothing);

    await tester.ensureVisible(find.byKey(ValueKey(normalId)));
    await _settle(tester);
    await tester.longPress(find.byKey(ValueKey(normalId)), warnIfMissed: false);
    await _settle(tester);
    expect(find.text('编辑任务'), findsOneWidget);
    expect(find.text('复制任务'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await _settle(tester);
    await _dispose(tester, database);
  });

  testWidgets('窄屏任务编辑面板可滚动且底部保存操作始终可见', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await _pumpApp(tester, database, size: const Size(360, 640));

    await tester.tap(find.byTooltip('新建任务'));
    await _settle(tester);
    expect(find.text('开始时间'), findsOneWidget);
    expect(find.text('结束时间'), findsOneWidget);
    expect(find.text('任务分类'), findsNothing);
    expect(find.text('保存'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('备注（选填）'),
      240,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('保存'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('关闭'));
    await _settle(tester);
    await _dispose(tester, database);
  });

  testWidgets('紧凑新建按钮、空白时间格和时间步长均可创建任务', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = PlanTaskRepository(database);
    final monday = AppDateUtils.startOfWeek(DateTime.now());
    await _pumpApp(tester, database, size: const Size(1000, 900));
    await tester.tap(find.byTooltip('新建任务'));
    await _settle(tester);
    expect(find.text('新增任务'), findsWidgets);
    await tester.enterText(find.byType(TextFormField).first, '加号创建');
    await tester.tap(find.text('5分'));
    await tester.pump();
    await tester.tap(find.byTooltip('增加 5 分钟').first);
    await tester.pump();
    expect(find.text('调整步长'), findsOneWidget);
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await _settle(tester);
    expect(
      (await repository.getBetween(
        monday,
        monday.add(const Duration(days: 7)),
      )).any((task) => task.title == '加号创建'),
      isTrue,
    );

    final timeLabel = find.text('09:00');
    expect(timeLabel, findsOneWidget);
    await tester.tapAt(tester.getCenter(timeLabel) + const Offset(90, 0));
    await _settle(tester);
    expect(find.text('新增任务'), findsWidgets);
    await tester.tap(find.byTooltip('关闭'));
    await _settle(tester);
    await _dispose(tester, database);
  });

  testWidgets('完全不拖动即可保存09:07至09:42，并在冲突时留在面板', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = PlanTaskRepository(database);
    final date = AppDateUtils.dateOnly(DateTime.now());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => Column(
                    children: [
                      FilledButton(
                        onPressed:
                            () => showTaskEditorSheet(
                              context,
                              initialDate: date,
                              initialStartMinutes: 547,
                              initialEndMinutes: 582,
                            ),
                        child: const Text('精确时间'),
                      ),
                      FilledButton(
                        onPressed:
                            () => showTaskEditorSheet(
                              context,
                              initialDate: date,
                              initialStartMinutes: 600,
                              initialEndMinutes: 660,
                            ),
                        child: const Text('冲突时间'),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('精确时间'));
    await _settle(tester);
    await tester.enterText(find.byType(TextFormField).first, '精确任务');
    await tester.tap(find.text('保存'));
    await _settle(tester);
    final exact =
        (await repository.getBetween(
          date,
          date.add(const Duration(days: 1)),
        )).single;
    expect(exact.startMinutes, 547);
    expect(exact.endMinutes, 582);

    await repository.save(_draft('已有任务', date, 600, 660));
    await tester.tap(find.text('冲突时间'));
    await _settle(tester);
    await tester.enterText(find.byType(TextFormField).first, '冲突任务');
    await tester.tap(find.text('保存'));
    await _settle(tester);
    expect(find.textContaining('已有任务'), findsOneWidget);
    expect(find.textContaining('10:00－11:00'), findsOneWidget);
    expect(find.text('编辑任务'), findsNothing);
    expect(find.text('新增任务'), findsOneWidget);
    await tester.tap(find.byTooltip('关闭'));
    await _settle(tester);
    expect(find.text('当前修改尚未保存，确定退出吗？'), findsOneWidget);
    await tester.tap(find.text('确定退出'));
    await _settle(tester);
    await _dispose(tester, database);
  });

  testWidgets('独立移动与上下缩放手柄按15分钟更新，取消不会写入', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = PlanTaskRepository(database);
    final monday = AppDateUtils.startOfWeek(DateTime.now());
    final id = await repository.save(_draft('手柄任务', monday, 480, 540));
    await _pumpApp(tester, database, size: const Size(1000, 900));

    Finder handle(Type type) => find.descendant(
      of: find.byKey(ValueKey(id)),
      matching: find.byType(type),
    );

    await tester.ensureVisible(find.byKey(ValueKey(id)));
    await _settle(tester);
    expect(handle(TaskDragHandle).hitTestable(), findsOneWidget);
    final slotHeight = TimelinePositionCalculator.slotHeight(
      TimelinePositionCalculator.defaultDetailHourHeight,
    );
    final cancelledGesture = await tester.startGesture(
      tester.getCenter(handle(TaskDragHandle)),
    );
    await cancelledGesture.moveBy(Offset(0, slotHeight));
    await tester.pump(const Duration(milliseconds: 60));
    await cancelledGesture.cancel();
    await _settle(tester);
    var task = (await repository.getBetween(
      monday,
      monday.add(const Duration(days: 7)),
    )).singleWhere((item) => item.id == id);
    expect(task.startMinutes, 480);
    expect(task.endMinutes, 540);

    final moveGesture = await tester.startGesture(
      tester.getCenter(handle(TaskDragHandle)),
    );
    await moveGesture.moveBy(Offset(0, slotHeight / 2));
    await tester.pump(const Duration(milliseconds: 60));
    await moveGesture.moveBy(Offset(0, slotHeight / 2));
    await tester.pump(const Duration(milliseconds: 60));
    await moveGesture.up();
    await _settle(tester);
    task = (await repository.getBetween(
      monday,
      monday.add(const Duration(days: 7)),
    )).singleWhere((item) => item.id == id);
    expect(task.startMinutes, 495);
    expect(task.endMinutes, 555);

    await tester.ensureVisible(find.byKey(ValueKey(id)));
    await _settle(tester);
    expect(handle(TaskDragHandle).hitTestable(), findsOneWidget);
    final moveToNextDay = await tester.startGesture(
      tester.getCenter(handle(TaskDragHandle)),
    );
    await moveToNextDay.moveBy(const Offset(180, 0));
    await tester.pump(const Duration(milliseconds: 60));
    await moveToNextDay.up();
    await _settle(tester);
    task = (await repository.getBetween(
      monday,
      monday.add(const Duration(days: 7)),
    )).singleWhere((item) => item.id == id);
    expect(task.taskDate, monday.add(const Duration(days: 1)));

    final resizeHandles = handle(TaskResizeHandle);
    await tester.ensureVisible(find.byKey(ValueKey(id)));
    await tester.drag(resizeHandles.first, Offset(0, slotHeight));
    await _settle(tester);
    task = (await repository.getBetween(
      monday,
      monday.add(const Duration(days: 7)),
    )).singleWhere((item) => item.id == id);
    expect(task.startMinutes, 510);

    await tester.ensureVisible(find.byKey(ValueKey(id)));
    await tester.drag(resizeHandles.last, Offset(0, slotHeight));
    await _settle(tester);
    task = (await repository.getBetween(
      monday,
      monday.add(const Duration(days: 7)),
    )).singleWhere((item) => item.id == id);
    expect(task.endMinutes, 570);
    await _dispose(tester, database);
  });
}

PlanTaskDraft _draft(String title, DateTime date, int start, int end) =>
    PlanTaskDraft(
      title: title,
      taskDate: date,
      startMinutes: start,
      endMinutes: end,
      colorValue: 0xFF80A9A5,
    );

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
  // Modal routes and implicit animations finish within this deterministic
  // window. Avoid pumpAndSettle here because the weekly grid owns live timers.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pump();
}
