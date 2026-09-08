import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/plan_task.dart';
import '../utils/date_time_utils.dart';
import '../utils/app_colors.dart';
import '../utils/timeline_position_calculator.dart';
import 'task_title.dart';

/// A compact view of the configured study day.
class WeekOverview extends StatelessWidget {
  const WeekOverview({
    super.key,
    required this.weekStart,
    required this.tasks,
    required this.hourHeight,
    required this.onTaskTap,
    required this.onDayTap,
    this.timelineStartMinutes = 0,
    this.timelineEndMinutes = 1440,
  });

  final DateTime weekStart;
  final List<PlanTask> tasks;
  final double hourHeight;
  final ValueChanged<PlanTask> onTaskTap;
  final ValueChanged<DateTime> onDayTap;
  final int timelineStartMinutes;
  final int timelineEndMinutes;

  static const _axisWidth = 42.0;
  static const _headerHeight = 46.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveHourHeight = TimelinePositionCalculator.clampHourHeight(
          hourHeight,
        );
        final gridHeight = TimelinePositionCalculator.totalHeight(
          effectiveHourHeight,
          startMinutes: timelineStartMinutes,
          endMinutes: timelineEndMinutes,
        );
        final columnWidth = math.max(
          1.0,
          (constraints.maxWidth - _axisWidth) / 7,
        );
        final taskLayouts = _taskLayouts(effectiveHourHeight);
        return Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: Row(
                children: [
                  const SizedBox(width: _axisWidth),
                  for (var index = 0; index < 7; index++)
                    _DayHeader(
                      width: columnWidth,
                      date: weekStart.add(Duration(days: index)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: gridHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: _axisWidth,
                        child: _TimeAxis(
                          height: gridHeight,
                          hourHeight: effectiveHourHeight,
                          startMinutes: timelineStartMinutes,
                          endMinutes: timelineEndMinutes,
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _OverviewGridPainter(
                                  columnWidth: columnWidth,
                                  todayIndex: _dayIndex(DateTime.now()),
                                  lineColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                  todayColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer.withAlpha(45),
                                  hourHeight: effectiveHourHeight,
                                ),
                              ),
                            ),
                            for (var day = 0; day < 7; day++)
                              Positioned(
                                left: day * columnWidth,
                                top: 0,
                                width: columnWidth,
                                height: gridHeight,
                                child: InkWell(
                                  onTap:
                                      () => onDayTap(
                                        weekStart.add(Duration(days: day)),
                                      ),
                                ),
                              ),
                            for (final layout in taskLayouts)
                              if (_dayIndex(layout.task.taskDate)
                                  case final int day)
                                Positioned(
                                  left:
                                      day * columnWidth +
                                      1.5 +
                                      layout.lane *
                                          (columnWidth - 3) /
                                          layout.laneCount,
                                  top:
                                      TimelinePositionCalculator.topForMinutes(
                                        layout.task.startMinutes,
                                        effectiveHourHeight,
                                        startMinutes: timelineStartMinutes,
                                      ) +
                                      1,
                                  width: math.max(
                                    1,
                                    (columnWidth - 3) / layout.laneCount - 1,
                                  ),
                                  height: math.max(
                                    44,
                                    TimelinePositionCalculator.heightForRange(
                                          layout.task.startMinutes,
                                          layout.task.endMinutes,
                                          effectiveHourHeight,
                                        ) -
                                        2,
                                  ),
                                  child: Tooltip(
                                    message:
                                        '${layout.task.title}\n'
                                        '${AppDateUtils.formatMinutes(layout.task.startMinutes)}'
                                        '－${AppDateUtils.formatMinutes(layout.task.endMinutes)}',
                                    child: Material(
                                      color: AppColors.taskSurface(
                                        context,
                                        Color(layout.task.colorValue),
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () => onTaskTap(layout.task),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            3,
                                            3,
                                            3,
                                            2,
                                          ),
                                          child: LayoutBuilder(
                                            builder:
                                                (context, taskConstraints) =>
                                                    TaskTitle(
                                                      title: layout.task.title,
                                                      cardHeight:
                                                          taskConstraints
                                                              .maxHeight,
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                      fontSize: 11,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<_OverviewTaskLayout> _taskLayouts(double hourHeight) {
    final output = <_OverviewTaskLayout>[];
    for (var day = 0; day < 7; day++) {
      final dayTasks =
          tasks
              .where(
                (task) =>
                    !task.isAllDay &&
                    task.startMinutes >= timelineStartMinutes &&
                    task.endMinutes <= timelineEndMinutes &&
                    _dayIndex(task.taskDate) == day,
              )
              .toList()
            ..sort(
              (a, b) =>
                  a.startMinutes != b.startMinutes
                      ? a.startMinutes.compareTo(b.startMinutes)
                      : a.id.compareTo(b.id),
            );
      final pending = <({PlanTask task, int lane})>[];
      final laneEnds = <double>[];
      var groupEnd = -1.0;

      void flush() {
        if (pending.isEmpty) return;
        final laneCount = math.max(1, laneEnds.length);
        for (final item in pending) {
          output.add(
            _OverviewTaskLayout(
              task: item.task,
              lane: item.lane,
              laneCount: laneCount,
            ),
          );
        }
        pending.clear();
        laneEnds.clear();
        groupEnd = -1;
      }

      for (final task in dayTasks) {
        final top = TimelinePositionCalculator.topForMinutes(
          task.startMinutes,
          hourHeight,
          startMinutes: timelineStartMinutes,
        );
        final visualEnd =
            top +
            math.max(
              44,
              TimelinePositionCalculator.heightForRange(
                task.startMinutes,
                task.endMinutes,
                hourHeight,
              ),
            );
        if (pending.isNotEmpty && top >= groupEnd) flush();
        var lane = laneEnds.indexWhere((end) => end <= top);
        if (lane == -1) {
          lane = laneEnds.length;
          laneEnds.add(visualEnd);
        } else {
          laneEnds[lane] = visualEnd;
        }
        groupEnd = math.max(groupEnd, visualEnd);
        pending.add((task: task, lane: lane));
      }
      flush();
    }
    return output;
  }

  int? _dayIndex(DateTime date) {
    final value =
        AppDateUtils.dateOnly(
          date,
        ).difference(AppDateUtils.dateOnly(weekStart)).inDays;
    return value >= 0 && value < 7 ? value : null;
  }
}

class _OverviewTaskLayout {
  const _OverviewTaskLayout({
    required this.task,
    required this.lane,
    required this.laneCount,
  });

  final PlanTask task;
  final int lane;
  final int laneCount;
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.width, required this.date});

  final double width;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.isSameDate(date, DateTime.now());
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            today
                ? Theme.of(context).colorScheme.primaryContainer.withAlpha(90)
                : null,
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppDateUtils.weekdayShort(date.weekday),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Text(
              '${date.month}/${date.day}',
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeAxis extends StatelessWidget {
  const _TimeAxis({
    required this.height,
    required this.hourHeight,
    required this.startMinutes,
    required this.endMinutes,
  });

  final double height;
  final double hourHeight;
  final int startMinutes;
  final int endMinutes;

  @override
  Widget build(BuildContext context) {
    final labels = <int>[
      for (var value = startMinutes; value <= endMinutes; value += 6 * 60)
        value,
      if ((endMinutes - startMinutes) % (6 * 60) != 0) endMinutes,
    ];
    return Stack(
      children: [
        for (final minutes in labels)
          Positioned(
            right: 5,
            top: math.min(
              height - 12,
              math.max(
                0,
                TimelinePositionCalculator.topForMinutes(
                      minutes,
                      hourHeight,
                      startMinutes: startMinutes,
                    ) -
                    (minutes == startMinutes ? 0 : 5),
              ),
            ),
            child: Text(
              AppDateUtils.formatMinutes(minutes),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 8,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class _OverviewGridPainter extends CustomPainter {
  const _OverviewGridPainter({
    required this.columnWidth,
    required this.todayIndex,
    required this.lineColor,
    required this.todayColor,
    required this.hourHeight,
  });

  final double columnWidth;
  final int? todayIndex;
  final Color lineColor;
  final Color todayColor;
  final double hourHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final today = todayIndex;
    if (today != null) {
      canvas.drawRect(
        Rect.fromLTWH(today * columnWidth, 0, columnWidth, size.height),
        Paint()..color = todayColor,
      );
    }
    final line =
        Paint()
          ..color = lineColor.withAlpha(100)
          ..strokeWidth = 0.7;
    for (var day = 0; day <= 7; day++) {
      canvas.drawLine(
        Offset(day * columnWidth, 0),
        Offset(day * columnWidth, size.height),
        line,
      );
    }
    for (var hour = 0; hour <= size.height / hourHeight; hour++) {
      final y = hour * hourHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant _OverviewGridPainter oldDelegate) =>
      oldDelegate.columnWidth != columnWidth ||
      oldDelegate.todayIndex != todayIndex ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.todayColor != todayColor ||
      oldDelegate.hourHeight != hourHeight;
}
