import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/repositories/plan_task_repository.dart';

void main() {
  test('关闭数据库并重新打开后任务仍然存在', () async {
    final directory = await Directory.systemTemp.createTemp('zhouji_test_');
    addTearDown(() async {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    });
    final file = File(
      '${directory.path}${Platform.pathSeparator}zhouji.sqlite',
    );
    final date = DateTime(2026, 7, 20);

    var database = AppDatabase.forTesting(NativeDatabase(file));
    var repository = PlanTaskRepository(database);
    await repository.save(
      PlanTaskDraft(
        title: '持久化任务',
        taskDate: date,
        startMinutes: 420,
        endMinutes: 480,
        colorValue: 0xFF80A9A5,
      ),
    );
    await database.close();

    database = AppDatabase.forTesting(NativeDatabase(file));
    repository = PlanTaskRepository(database);
    final tasks = await repository.watchWeek(date).first;
    expect(tasks.single.title, '持久化任务');
    await database.close();
  });
}
