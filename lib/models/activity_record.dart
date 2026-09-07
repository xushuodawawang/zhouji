class ActivityRecord {
  const ActivityRecord({
    required this.id,
    required this.recordDate,
    required this.title,
    required this.startMinutes,
    required this.endMinutes,
    required this.durationMinutes,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime recordDate;
  final String title;
  final int? startMinutes;
  final int? endMinutes;
  final int durationMinutes;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class ActivityRecordDraft {
  const ActivityRecordDraft({
    this.id,
    required this.recordDate,
    required this.title,
    this.startMinutes,
    this.endMinutes,
    required this.durationMinutes,
    this.note = '',
  });

  factory ActivityRecordDraft.fromRecord(ActivityRecord record) =>
      ActivityRecordDraft(
        id: record.id,
        recordDate: record.recordDate,
        title: record.title,
        startMinutes: record.startMinutes,
        endMinutes: record.endMinutes,
        durationMinutes: record.durationMinutes,
        note: record.note,
      );

  final int? id;
  final DateTime recordDate;
  final String title;
  final int? startMinutes;
  final int? endMinutes;
  final int durationMinutes;
  final String note;
}
