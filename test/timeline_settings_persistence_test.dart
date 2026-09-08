import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/app_settings.dart';
import 'package:zhouji/repositories/settings_repository.dart';

void main() {
  test('关闭并重新打开应用数据库后恢复缩放和任务卡透明度', () async {
    final directory = await Directory.systemTemp.createTemp(
      'zhouji_timeline_settings_',
    );
    final file = File('${directory.path}/settings.sqlite');
    addTearDown(() async {
      if (directory.existsSync()) {
        await directory.delete(recursive: true);
      }
    });

    var database = AppDatabase.forTesting(NativeDatabase(file));
    await SettingsRepository(database).save(
      const AppSettings(
        detailHourHeight: 72,
        overviewHourHeight: 32,
        taskCardOpacity: 0.45,
      ),
    );
    await database.close();

    database = AppDatabase.forTesting(NativeDatabase(file));
    final restored = await SettingsRepository(database).get();
    expect(restored.detailHourHeight, 72);
    expect(restored.overviewHourHeight, 32);
    expect(restored.taskCardOpacity, 0.45);
    await database.close();
  });
}
