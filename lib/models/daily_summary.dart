class DailySummary {
  const DailySummary({
    required this.id,
    required this.summaryDate,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime summaryDate;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
}
