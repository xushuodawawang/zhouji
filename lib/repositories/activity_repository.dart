import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/activity_record.dart';
import '../models/daily_summary.dart';
import '../utils/date_time_utils.dart';
import 'plan_task_repository.dart';

class ActivityRepository {
  const ActivityRepository(this._database);

  final AppDatabase _database;

  Stream<List<ActivityRecord>> watchDate(DateTime date) {
    final normalized = AppDateUtils.dateOnly(date);
    return _database
        .watchRecordsForDate(normalized)
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<ActivityRecord>> getBetween(DateTime start, DateTime end) async =>
      (await _database.getRecordsBetween(start, end)).map(_fromRow).toList();

  Stream<DailySummary?> watchSummary(DateTime date) {
    final normalized = AppDateUtils.dateOnly(date);
    return _database
        .watchSummaryForDate(normalized)
        .map(
          (row) =>
              row == null
                  ? null
                  : DailySummary(
                    id: row.id,
                    summaryDate: row.summaryDate,
                    content: row.content,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt,
                  ),
        );
  }

  Future<int> save(ActivityRecordDraft draft) async {
    _validate(draft);
    final now = DateTime.now();
    try {
      return await _database.saveRecord(
        ActivityRecordsCompanion(
          recordDate: Value(AppDateUtils.dateOnly(draft.recordDate)),
          title: Value(draft.title.trim()),
          startMinutes: Value(draft.startMinutes),
          endMinutes: Value(draft.endMinutes),
          durationMinutes: Value(draft.durationMinutes),
          note: Value(draft.note.trim()),
          createdAt: draft.id == null ? Value(now) : const Value.absent(),
          updatedAt: Value(now),
        ),
        recordId: draft.id,
      );
    } catch (error) {
      throw RepositoryException('保存完成记录失败', error);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _database.deleteRecord(id);
    } catch (error) {
      throw RepositoryException('删除完成记录失败', error);
    }
  }

  Future<void> saveSummary(DateTime date, String content) async {
    try {
      await _database.upsertSummary(
        AppDateUtils.dateOnly(date),
        content.trimRight(),
      );
    } catch (error) {
      throw RepositoryException('保存今日总结失败', error);
    }
  }

  void _validate(ActivityRecordDraft draft) {
    if (draft.title.trim().isEmpty) {
      throw const RepositoryException('事项名称不能为空');
    }
    if (draft.durationMinutes < 0) {
      throw const RepositoryException('实际用时不能小于0');
    }
    final start = draft.startMinutes;
    final end = draft.endMinutes;
    if ((start == null) != (end == null)) {
      throw const RepositoryException('开始时间和结束时间需要同时填写');
    }
    if (start != null && end != null && end <= start) {
      throw const RepositoryException('结束时间必须晚于开始时间');
    }
  }

  ActivityRecord _fromRow(ActivityRecordRow row) => ActivityRecord(
    id: row.id,
    recordDate: row.recordDate,
    title: row.title,
    startMinutes: row.startMinutes,
    endMinutes: row.endMinutes,
    durationMinutes: row.durationMinutes,
    note: row.note,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
