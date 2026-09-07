import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/monthly_goal.dart';
import '../utils/date_time_utils.dart';
import 'plan_task_repository.dart';

class GoalRepository {
  const GoalRepository(this._database);

  final AppDatabase _database;

  Stream<List<MonthlyGoal>> watchMonth(DateTime month) => _database
      .watchGoals(AppDateUtils.yearMonthKey(month))
      .map((rows) => rows.map(_fromRow).toList());

  Future<int> save({
    MonthlyGoal? goal,
    required DateTime month,
    required String content,
    bool isCompleted = false,
  }) {
    if (content.trim().isEmpty) {
      throw const RepositoryException('月目标不能为空');
    }
    final now = DateTime.now();
    return _database.saveGoal(
      MonthlyGoalsCompanion(
        yearMonth: Value(AppDateUtils.yearMonthKey(month)),
        content: Value(content.trim()),
        isCompleted: Value(isCompleted),
        createdAt: goal == null ? Value(now) : const Value.absent(),
        updatedAt: Value(now),
      ),
      goalId: goal?.id,
    );
  }

  Future<void> delete(int id) => _database.deleteGoal(id);

  MonthlyGoal _fromRow(MonthlyGoalRow row) => MonthlyGoal(
    id: row.id,
    yearMonth: row.yearMonth,
    content: row.content,
    isCompleted: row.isCompleted,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
