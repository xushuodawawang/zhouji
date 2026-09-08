enum TimerMode { pomodoro, stopwatch }

enum TimerPhase { focus, shortBreak, longBreak }

class FocusSession {
  const FocusSession({
    required this.id,
    required this.sessionDate,
    required this.startedAt,
    required this.endedAt,
    required this.plannedMinutes,
    required this.actualMinutes,
    required this.mode,
    required this.completed,
    this.taskId,
    this.categoryId,
    this.note = '',
  });

  final int id;
  final DateTime sessionDate;
  final DateTime startedAt;
  final DateTime endedAt;
  final int plannedMinutes;
  final int actualMinutes;
  final TimerMode mode;
  final bool completed;
  final int? taskId;
  final int? categoryId;
  final String note;
}

class ActiveTimer {
  const ActiveTimer({
    required this.mode,
    required this.phase,
    required this.startedAt,
    required this.expectedEndAt,
    required this.remainingSeconds,
    required this.isRunning,
    required this.cycleCount,
    this.taskId,
    this.categoryId,
    this.totalSeconds,
    this.title = '',
  });

  final TimerMode mode;
  final TimerPhase phase;
  final DateTime startedAt;
  final DateTime expectedEndAt;
  final int remainingSeconds;
  final bool isRunning;
  final int cycleCount;
  final int? taskId;
  final int? categoryId;
  final int? totalSeconds;
  final String title;
}
