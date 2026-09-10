import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/models/activity_record.dart';
import 'package:zhouji/models/focus_session.dart';
import 'package:zhouji/models/plan_task.dart';
import 'package:zhouji/services/statistics_service.dart';

void main() {
  test('统计总时长、完成率与任务名称环图之和一致', () {
    final date = DateTime(2026, 7, 20);
    final tasks = [
      _task(1, date, completed: true, start: 420, end: 480),
      _task(2, date, completed: false, start: 510, end: 600),
    ];
    final sessions = List.generate(
      6,
      (index) => FocusSession(
        id: index + 1,
        sessionDate: date,
        startedAt: date.add(Duration(hours: 8 + index)),
        endedAt: date.add(Duration(hours: 8 + index, minutes: 10 + index)),
        plannedMinutes: 25,
        actualMinutes: 10 + index,
        mode: TimerMode.pomodoro,
        completed: index.isEven,
        note: '科目${index + 1}',
      ),
    );
    final records = [
      ActivityRecord(
        id: 1,
        recordDate: date,
        title: '记录',
        startMinutes: 600,
        endMinutes: 645,
        durationMinutes: 45,
        note: '',
        createdAt: date,
        updatedAt: date,
      ),
    ];
    final data = const StatisticsService().calculate(
      range: StatisticsRange.week,
      period: StatisticsPeriod(
        start: date,
        end: date.add(const Duration(days: 7)),
      ),
      tasks: tasks,
      records: records,
      sessions: sessions,
    );

    expect(data.taskCount, 2);
    expect(data.completedTaskCount, 1);
    expect(data.completionRate, 0.5);
    expect(data.plannedMinutes, 150);
    expect(data.actualRecordMinutes, 45);
    expect(
      data.focusMinutes,
      sessions.fold(0, (sum, item) => sum + item.actualMinutes),
    );
    expect(
      data.focusStats.fold(0, (sum, item) => sum + item.minutes),
      data.focusMinutes,
    );
    expect(data.focusStats.length, 6); // 前5项 + 其他
    expect(data.focusStats.first.name, '科目6');
    expect(data.trend, hasLength(7));
  });
}

PlanTask _task(
  int id,
  DateTime date, {
  required bool completed,
  required int start,
  required int end,
}) => PlanTask(
  id: id,
  title: '任务$id',
  taskDate: date,
  startMinutes: start,
  endMinutes: end,
  colorValue: 0xFF708F88,
  note: '',
  isCompleted: completed,
  createdAt: date,
  updatedAt: date,
);
