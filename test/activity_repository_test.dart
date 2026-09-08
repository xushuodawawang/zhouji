import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/activity_record.dart';
import 'package:zhouji/repositories/activity_repository.dart';

void main() {
  late AppDatabase database;
  late ActivityRepository repository;
  final date = DateTime(2026, 7, 24);

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ActivityRepository(database);
  });

  tearDown(() => database.close());

  test('新增、编辑、删除每日完成记录', () async {
    final id = await repository.save(
      ActivityRecordDraft(
        recordDate: date,
        title: '背单词',
        startMinutes: 540,
        endMinutes: 600,
        durationMinutes: 60,
      ),
    );
    var records = await repository.watchDate(date).first;
    expect(records.single.title, '背单词');

    await repository.save(
      ActivityRecordDraft(
        id: id,
        recordDate: date,
        title: '背单词并复盘',
        durationMinutes: 75,
        isCompleted: false,
      ),
    );
    records = await repository.watchDate(date).first;
    expect(records.single.title, '背单词并复盘');
    expect(records.single.durationMinutes, 75);
    expect(records.single.isCompleted, isFalse);

    await repository.delete(id);
    records = await repository.watchDate(date).first;
    expect(records, isEmpty);
  });

  test('同一天的总结只保留一条并可更新', () async {
    await repository.saveSummary(date, '第一版总结');
    await repository.saveSummary(date, '更新后的总结');

    final summary = await repository.watchSummary(date).first;
    expect(summary?.content, '更新后的总结');
    final rows = await database.select(database.dailySummaries).get();
    expect(rows, hasLength(1));
  });
}
