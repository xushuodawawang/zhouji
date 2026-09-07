class MonthlyGoal {
  const MonthlyGoal({
    required this.id,
    required this.yearMonth,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String yearMonth;
  final String content;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
}
