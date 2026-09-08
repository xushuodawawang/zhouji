import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/plan_task.dart';
import '../utils/date_time_utils.dart';
import '../utils/time_snap_calculator.dart';
import '../utils/timeline_position_calculator.dart';
import 'task_block.dart';

class WeekSchedule extends StatefulWidget {
  const WeekSchedule({
    super.key,
    required this.weekStart,
    required this.tasks,
    required this.onCreateTask,
    required this.onTapEmpty,
    required this.onEditTask,
    required this.onTaskMenu,
    required this.onTaskChanged,
    required this.hourHeight,
    required this.onHourHeightChanged,
    required this.onHourHeightChangeEnd,
    required this.onViewportHeightChanged,
    this.timelineStartMinutes = 0,
    this.timelineEndMinutes = 1440,
    this.taskCardOpacity = 0.72,
  });

  final DateTime weekStart;
  final List<PlanTask> tasks;
  final void Function(DateTime date, int startMinutes, int endMinutes)
  onCreateTask;
  final void Function(DateTime date, int startMinutes, int endMinutes)
  onTapEmpty;
  final Future<void> Function(PlanTask) onEditTask;
  final Future<void> Function(PlanTask) onTaskMenu;
  final Future<void> Function(PlanTaskDraft draft) onTaskChanged;
  final double hourHeight;
  final ValueChanged<double> onHourHeightChanged;
  final VoidCallback onHourHeightChangeEnd;
  final ValueChanged<double> onViewportHeightChanged;
  final int timelineStartMinutes;
  final int timelineEndMinutes;
  final double taskCardOpacity;

  @override
  State<WeekSchedule> createState() => _WeekScheduleState();
}

enum _DragMode { move, resizeTop, resizeBottom }

class _WeekScheduleState extends State<WeekSchedule> {
  static const _timeAxisWidth = 56.0;
  static const _headerHeight = 46.0;
  int get _slotCount =>
      (widget.timelineEndMinutes - widget.timelineStartMinutes) ~/
      AppDateUtils.slotMinutes;

  double get _slotHeight => TimelinePositionCalculator.slotHeight(
    widget.hourHeight,
    slotMinutes: AppDateUtils.slotMinutes,
  );

  double get _gridHeight => TimelinePositionCalculator.totalHeight(
    widget.hourHeight,
    startMinutes: widget.timelineStartMinutes,
    endMinutes: widget.timelineEndMinutes,
  );

  List<_TaskLayout>? _cachedTaskLayouts;

  final _verticalController = ScrollController();
  final _headerHorizontalController = ScrollController();
  final _gridHorizontalController = ScrollController();
  bool _syncingHorizontal = false;
  Timer? _autoScrollTimer;
  double _autoScrollVelocity = 0;

  int? _creationDay;
  int? _creationStart;
  int? _creationEnd;

  PlanTask? _activeTask;
  PlanTaskDraft? _activeDraft;
  Offset? _dragOrigin;
  _DragMode? _dragMode;
  double _resizeDelta = 0;
  int? _selectedTaskId;
  late double _columnWidth;
  final Map<int, Offset> _scalePointers = {};
  bool _isPinching = false;
  double _pinchInitialDistance = 0;
  double _pinchInitialHourHeight =
      TimelinePositionCalculator.defaultDetailHourHeight;
  double _lastReportedViewportHeight = 0;

  @override
  void initState() {
    super.initState();
    _headerHorizontalController.addListener(_syncFromHeader);
    _gridHorizontalController.addListener(_syncFromGrid);
  }

  @override
  void didUpdateWidget(covariant WeekSchedule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tasks != widget.tasks ||
        oldWidget.weekStart != widget.weekStart ||
        oldWidget.hourHeight != widget.hourHeight ||
        oldWidget.timelineStartMinutes != widget.timelineStartMinutes ||
        oldWidget.timelineEndMinutes != widget.timelineEndMinutes) {
      _cachedTaskLayouts = null;
    }
    if (oldWidget.weekStart != widget.weekStart) {
      _cancelInteraction();
    }
    if (oldWidget.hourHeight != widget.hourHeight &&
        _verticalController.hasClients) {
      final oldOffset = _verticalController.offset;
      final viewport = _verticalController.position.viewportDimension;
      final centerMinutes =
          (oldOffset + viewport / 2) /
          TimelinePositionCalculator.clampHourHeight(oldWidget.hourHeight) *
          60;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_verticalController.hasClients) return;
        final target = centerMinutes / 60 * widget.hourHeight - viewport / 2;
        final position = _verticalController.position;
        _verticalController.jumpTo(target.clamp(0.0, position.maxScrollExtent));
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _headerHorizontalController
      ..removeListener(_syncFromHeader)
      ..dispose();
    _gridHorizontalController
      ..removeListener(_syncFromGrid)
      ..dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onScalePointerDown,
      onPointerMove: _onScalePointerMove,
      onPointerUp: _onScalePointerUp,
      onPointerCancel: _onScalePointerCancel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _reportViewportHeight(
            math.max(0, constraints.maxHeight - _headerHeight - 1),
          );
          final dateViewportWidth = math.max(
            0.0,
            constraints.maxWidth - _timeAxisWidth,
          );
          _columnWidth =
              dateViewportWidth >= 7 * 88
                  ? dateViewportWidth / 7
                  : math.max(108, dateViewportWidth / 3.15);
          final contentWidth = _columnWidth * 7;
          return Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: _timeAxisWidth,
                      child: Center(
                        child: Text(
                          '时间',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _headerHorizontalController,
                        scrollDirection: Axis.horizontal,
                        physics:
                            _activeTask == null && !_isPinching
                                ? const ClampingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          width: contentWidth,
                          child: _buildDateHeader(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _verticalController,
                  physics:
                      _activeTask == null && !_isPinching
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: _gridHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: _timeAxisWidth,
                          height: _gridHeight,
                          child: _buildTimeAxis(context),
                        ),
                        Expanded(
                          child: ClipRect(
                            child: SingleChildScrollView(
                              controller: _gridHorizontalController,
                              scrollDirection: Axis.horizontal,
                              physics:
                                  _activeTask == null && !_isPinching
                                      ? const ClampingScrollPhysics()
                                      : const NeverScrollableScrollPhysics(),
                              child: SizedBox(
                                width: contentWidth,
                                height: _gridHeight,
                                child: _buildGrid(context, contentWidth),
                              ),
                            ),
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
      ),
    );
  }

  void _reportViewportHeight(double height) {
    if ((height - _lastReportedViewportHeight).abs() < 0.5) return;
    _lastReportedViewportHeight = height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onViewportHeightChanged(height);
    });
  }

  void _onScalePointerDown(PointerDownEvent event) {
    _scalePointers[event.pointer] = event.localPosition;
    if (_scalePointers.length == 2) {
      final points = _scalePointers.values.take(2).toList();
      final distance = (points.first - points.last).distance;
      if (distance <= 0) return;
      _stopAutoScroll();
      setState(() {
        _isPinching = true;
        _pinchInitialDistance = distance;
        _pinchInitialHourHeight = widget.hourHeight;
        _creationDay = null;
        _creationStart = null;
        _creationEnd = null;
        _activeTask = null;
        _activeDraft = null;
        _dragOrigin = null;
        _dragMode = null;
        _resizeDelta = 0;
        _selectedTaskId = null;
      });
    }
  }

  void _onScalePointerMove(PointerMoveEvent event) {
    if (!_scalePointers.containsKey(event.pointer)) return;
    _scalePointers[event.pointer] = event.localPosition;
    if (!_isPinching || _scalePointers.length < 2) return;
    final points = _scalePointers.values.take(2).toList();
    final distance = (points.first - points.last).distance;
    if (_pinchInitialDistance <= 0) return;
    widget.onHourHeightChanged(
      TimelinePositionCalculator.clampHourHeight(
        _pinchInitialHourHeight * distance / _pinchInitialDistance,
      ),
    );
  }

  void _onScalePointerUp(PointerUpEvent event) {
    _finishScalePointer(event.pointer);
  }

  void _onScalePointerCancel(PointerCancelEvent event) {
    _finishScalePointer(event.pointer);
  }

  void _finishScalePointer(int pointer) {
    _scalePointers.remove(pointer);
    if (!_isPinching || _scalePointers.length >= 2) return;
    setState(() => _isPinching = false);
    widget.onHourHeightChangeEnd();
  }

  Widget _buildDateHeader(BuildContext context) {
    final today = DateTime.now();
    return Row(
      children: List.generate(7, (index) {
        final date = widget.weekStart.add(Duration(days: index));
        final isToday = AppDateUtils.isSameDate(today, date);
        return Container(
          width: _columnWidth,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color:
                isToday
                    ? Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withAlpha(105)
                    : null,
            border: Border(
              left: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withAlpha(80),
              ),
            ),
          ),
          child: Column(
            children: [
              Text(
                AppDateUtils.weekdayShort(date.weekday),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isToday ? Theme.of(context).colorScheme.primary : null,
                  fontWeight: isToday ? FontWeight.w700 : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.month}/${date.day}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isToday ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimeAxis(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (var slot = 0; slot <= _slotCount; slot++)
          Positioned(
            top:
                slot == 0
                    ? 4
                    : math.min(slot * _slotHeight - 7, _gridHeight - 16),
            right: 8,
            child: Text(
              slot % (60 ~/ AppDateUtils.slotMinutes) == 0
                  ? AppDateUtils.formatMinutes(
                    widget.timelineStartMinutes +
                        slot * AppDateUtils.slotMinutes,
                  )
                  : '',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, double contentWidth) {
    final now = DateTime.now();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: _tapEmptySlot,
            onLongPressStart: _startCreation,
            onLongPressMoveUpdate: _updateCreation,
            onLongPressEnd: _endCreation,
            child: CustomPaint(
              painter: _ScheduleGridPainter(
                color: Theme.of(context).colorScheme.outlineVariant,
                currentDayIndex: _dayIndexForDate(now),
                currentDayColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withAlpha(36),
                columnWidth: _columnWidth,
                slotHeight: _slotHeight,
                slotCount: _slotCount,
              ),
            ),
          ),
        ),
        if (widget.tasks.isEmpty)
          Positioned(
            top: 24,
            left: 16,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer.withAlpha(230),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Text('点击或长按空白时间段创建计划'),
                ),
              ),
            ),
          ),
        if (_currentTimePosition(now) case final current?)
          Positioned(
            left: current.dayIndex * _columnWidth,
            top:
                (current.minutes - widget.timelineStartMinutes) /
                AppDateUtils.slotMinutes *
                _slotHeight,
            width: _columnWidth,
            child: IgnorePointer(
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Keep the source card mounted while dragging or resizing. Removing it
        // here destroys the recognizer that owns the active pointer and turns a
        // valid drag into an onPanCancel before the preview can be updated.
        for (final layout in _taskLayouts()) _positionedTask(layout),
        if (_creationDay != null &&
            _creationStart != null &&
            _creationEnd != null)
          _positionedCreationPreview(context),
        if (_activeTask != null && _activeDraft != null)
          _positionedDraftPreview(_activeTask!, _activeDraft!),
      ],
    );
  }

  Widget _positionedTask(_TaskLayout layout) {
    final task = layout.task;
    final day = _dayIndexForDate(task.taskDate);
    if (day == null) return const SizedBox.shrink();
    final laneWidth = (_columnWidth - 6) / layout.laneCount;
    final actualHeight =
        _heightForRange(task.startMinutes, task.endMinutes) - 4;
    return Positioned(
      left: day * _columnWidth + 3 + layout.lane * laneWidth,
      top: _topForMinutes(task.startMinutes) + 2,
      width: laneWidth - 2,
      height: math.max(48, actualHeight),
      child: TaskBlock(
        key: ValueKey(task.id),
        task: task,
        actualHeight: actualHeight,
        isSelected: _selectedTaskId == task.id,
        isDimmed: _selectedTaskId != null && _selectedTaskId != task.id,
        backgroundOpacity: widget.taskCardOpacity,
        onTap: () => _openTask(task),
        onLongPress: () => _openTaskMenu(task),
        onMoveStart: (details) => _startMove(task, details.globalPosition),
        onMoveUpdate: (details) => _updateMove(details.globalPosition, details),
        onMoveEnd: (_) => _finishTaskInteraction(),
        onMoveCancel: _cancelTaskInteraction,
        onResizeTopStart: (_) => _startResize(task, top: true),
        onResizeTopUpdate: _updateResize,
        onResizeTopEnd: (_) => _finishTaskInteraction(),
        onResizeTopCancel: _cancelTaskInteraction,
        onResizeBottomStart: (_) => _startResize(task, top: false),
        onResizeBottomUpdate: _updateResize,
        onResizeBottomEnd: (_) => _finishTaskInteraction(),
        onResizeBottomCancel: _cancelTaskInteraction,
      ),
    );
  }

  Widget _positionedDraftPreview(PlanTask source, PlanTaskDraft draft) {
    final preview = source.copyWith(
      taskDate: draft.taskDate,
      startMinutes: draft.startMinutes,
      endMinutes: draft.endMinutes,
    );
    final day = _dayIndexForDate(draft.taskDate) ?? 0;
    final actualHeight =
        _heightForRange(draft.startMinutes, draft.endMinutes) - 4;
    return Positioned(
      left: day * _columnWidth + 3,
      top: _topForMinutes(draft.startMinutes) + 2,
      width: _columnWidth - 6,
      height: math.max(48, actualHeight),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: TaskBlock(
              task: preview,
              actualHeight: actualHeight,
              isPreview: true,
              backgroundOpacity: widget.taskCardOpacity,
              onTap: () {},
              onLongPress: () {},
              onMoveStart: (_) {},
              onMoveUpdate: (_) {},
              onMoveEnd: (_) {},
              onMoveCancel: () {},
              onResizeTopStart: (_) {},
              onResizeTopUpdate: (_) {},
              onResizeTopEnd: (_) {},
              onResizeTopCancel: () {},
              onResizeBottomStart: (_) {},
              onResizeBottomUpdate: (_) {},
              onResizeBottomEnd: (_) {},
              onResizeBottomCancel: () {},
            ),
          ),
          Positioned(
            top: -30,
            left: 0,
            child: IgnorePointer(
              child: Material(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Text(
                    '${AppDateUtils.formatMinutes(draft.startMinutes)}－'
                    '${AppDateUtils.formatMinutes(draft.endMinutes)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _positionedCreationPreview(BuildContext context) {
    final start = math.min(_creationStart!, _creationEnd!);
    final end = math.max(_creationStart!, _creationEnd!);
    return Positioned(
      left: _creationDay! * _columnWidth + 3,
      top: _topForMinutes(start) + 2,
      width: _columnWidth - 6,
      height: math.max(48, _heightForRange(start, end) - 4),
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(125),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          child: Text(
            '${AppDateUtils.formatMinutes(start)}－'
            '${AppDateUtils.formatMinutes(end)}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  void _tapEmptySlot(TapUpDetails details) {
    final day = (details.localPosition.dx / _columnWidth).floor().clamp(0, 6);
    var start = TimeSnapCalculator.nearest(
      _rawMinutesForY(details.localPosition.dy),
      min: widget.timelineStartMinutes,
      max: widget.timelineEndMinutes,
    );
    if (start > widget.timelineEndMinutes - 60) {
      start = widget.timelineEndMinutes - 60;
    }
    widget.onTapEmpty(
      widget.weekStart.add(Duration(days: day)),
      start,
      start + 60,
    );
  }

  Future<void> _openTask(PlanTask task) async {
    setState(() => _selectedTaskId = task.id);
    await Future<void>.delayed(const Duration(milliseconds: 90));
    await widget.onEditTask(task);
    if (mounted) setState(() => _selectedTaskId = null);
  }

  Future<void> _openTaskMenu(PlanTask task) async {
    setState(() => _selectedTaskId = task.id);
    await widget.onTaskMenu(task);
    if (mounted) setState(() => _selectedTaskId = null);
  }

  List<_TaskLayout> _taskLayouts() =>
      _cachedTaskLayouts ??= _calculateTaskLayouts();

  List<_TaskLayout> _calculateTaskLayouts() {
    final output = <_TaskLayout>[];
    for (var day = 0; day < 7; day++) {
      final tasks =
          widget.tasks
              .where(
                (task) =>
                    !task.isAllDay &&
                    task.startMinutes >= widget.timelineStartMinutes &&
                    task.endMinutes <= widget.timelineEndMinutes &&
                    _dayIndexForDate(task.taskDate) == day,
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

      void flushGroup() {
        if (pending.isEmpty) return;
        final count = math.max(1, laneEnds.length);
        for (final item in pending) {
          output.add(
            _TaskLayout(task: item.task, lane: item.lane, laneCount: count),
          );
        }
        pending.clear();
        laneEnds.clear();
        groupEnd = -1;
      }

      for (final task in tasks) {
        final top = _topForMinutes(task.startMinutes) + 2;
        final visualEnd =
            top +
            math.max(
              48,
              _heightForRange(task.startMinutes, task.endMinutes) - 4,
            );
        if (pending.isNotEmpty && top >= groupEnd) flushGroup();
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
      flushGroup();
    }
    return output;
  }

  void _startCreation(LongPressStartDetails details) {
    final day = (details.localPosition.dx / _columnWidth).floor().clamp(0, 6);
    final start = _minutesForY(details.localPosition.dy).clamp(
      widget.timelineStartMinutes,
      widget.timelineEndMinutes - AppDateUtils.slotMinutes,
    );
    setState(() {
      _creationDay = day;
      _creationStart = start;
      _creationEnd = start + AppDateUtils.slotMinutes;
    });
    _updateAutoScroll(details.globalPosition);
  }

  void _updateCreation(LongPressMoveUpdateDetails details) {
    if (_creationStart == null) return;
    final raw = _minutesForY(details.localPosition.dy);
    var end = raw;
    if (end <= _creationStart!) {
      end = _creationStart! + AppDateUtils.slotMinutes;
    }
    setState(() {
      _creationEnd = end.clamp(
        _creationStart! + AppDateUtils.slotMinutes,
        widget.timelineEndMinutes,
      );
    });
    _updateAutoScroll(details.globalPosition);
  }

  void _endCreation(LongPressEndDetails details) {
    _stopAutoScroll();
    final day = _creationDay;
    final start = _creationStart;
    final end = _creationEnd;
    setState(() {
      _creationDay = null;
      _creationStart = null;
      _creationEnd = null;
    });
    if (day == null || start == null || end == null) return;
    widget.onCreateTask(
      widget.weekStart.add(Duration(days: day)),
      math.min(start, end),
      math.max(start, end),
    );
  }

  void _startMove(PlanTask task, Offset globalPosition) {
    setState(() {
      _selectedTaskId = task.id;
      _activeTask = task;
      _activeDraft = PlanTaskDraft.fromTask(task);
      _dragOrigin = globalPosition;
      _dragMode = _DragMode.move;
    });
  }

  void _updateMove(Offset globalPosition, DragUpdateDetails details) {
    final task = _activeTask;
    final origin = _dragOrigin;
    if (task == null || origin == null || _dragMode != _DragMode.move) return;
    final delta = globalPosition - origin;
    final originalDay = _dayIndexForDate(task.taskDate) ?? 0;
    final targetDay = (originalDay + (delta.dx / _columnWidth).round()).clamp(
      0,
      6,
    );
    final deltaMinutes =
        (delta.dy / _slotHeight).round() * AppDateUtils.slotMinutes;
    final duration = task.durationMinutes;
    final newStart = (task.startMinutes + deltaMinutes).clamp(
      widget.timelineStartMinutes,
      widget.timelineEndMinutes - duration,
    );
    setState(() {
      _activeDraft = PlanTaskDraft.fromTask(task).copyWith(
        taskDate: widget.weekStart.add(Duration(days: targetDay)),
        startMinutes: newStart,
        endMinutes: newStart + duration,
      );
    });
    _updateAutoScroll(globalPosition);
  }

  void _startResize(PlanTask task, {required bool top}) {
    setState(() {
      _selectedTaskId = task.id;
      _activeTask = task;
      _activeDraft = PlanTaskDraft.fromTask(task);
      _dragMode = top ? _DragMode.resizeTop : _DragMode.resizeBottom;
      _resizeDelta = 0;
    });
  }

  void _updateResize(DragUpdateDetails details) {
    final task = _activeTask;
    final mode = _dragMode;
    if (task == null ||
        (mode != _DragMode.resizeTop && mode != _DragMode.resizeBottom)) {
      return;
    }
    _resizeDelta += details.delta.dy;
    final deltaMinutes =
        (_resizeDelta / _slotHeight).round() * AppDateUtils.slotMinutes;
    setState(() {
      if (mode == _DragMode.resizeTop) {
        final start = (task.startMinutes + deltaMinutes).clamp(
          widget.timelineStartMinutes,
          task.endMinutes - AppDateUtils.dragMinimumMinutes,
        );
        _activeDraft = PlanTaskDraft.fromTask(task).copyWith(
          startMinutes: start,
          plannedDurationMinutes: task.endMinutes - start,
        );
      } else {
        final end = (task.endMinutes + deltaMinutes).clamp(
          task.startMinutes + AppDateUtils.dragMinimumMinutes,
          widget.timelineEndMinutes,
        );
        _activeDraft = PlanTaskDraft.fromTask(task).copyWith(
          endMinutes: end,
          plannedDurationMinutes: end - task.startMinutes,
        );
      }
    });
    _updateAutoScroll(details.globalPosition);
  }

  Future<void> _finishTaskInteraction() async {
    _stopAutoScroll();
    final draft = _activeDraft;
    setState(() {
      _activeTask = null;
      _activeDraft = null;
      _dragOrigin = null;
      _dragMode = null;
      _resizeDelta = 0;
      _selectedTaskId = null;
    });
    if (draft != null) await widget.onTaskChanged(draft);
  }

  void _cancelTaskInteraction() {
    _stopAutoScroll();
    setState(() {
      _activeTask = null;
      _activeDraft = null;
      _dragOrigin = null;
      _dragMode = null;
      _resizeDelta = 0;
      _selectedTaskId = null;
    });
  }

  int _minutesForY(double y) {
    final slot = (y / _slotHeight).round().clamp(0, _slotCount);
    return widget.timelineStartMinutes + slot * AppDateUtils.slotMinutes;
  }

  int _rawMinutesForY(double y) =>
      TimelinePositionCalculator.rawMinutesForOffset(
        y,
        widget.hourHeight,
        startMinutes: widget.timelineStartMinutes,
      );

  double _topForMinutes(int minutes) =>
      TimelinePositionCalculator.topForMinutes(
        minutes,
        widget.hourHeight,
        startMinutes: widget.timelineStartMinutes,
      );

  ({int dayIndex, int minutes})? _currentTimePosition(DateTime now) {
    var date = AppDateUtils.dateOnly(now);
    var minutes = now.hour * 60 + now.minute;
    if (minutes < widget.timelineStartMinutes &&
        widget.timelineEndMinutes > AppDateUtils.dayEndMinutes) {
      date = date.subtract(const Duration(days: 1));
      minutes += AppDateUtils.dayEndMinutes;
    }
    if (minutes < widget.timelineStartMinutes ||
        minutes > widget.timelineEndMinutes) {
      return null;
    }
    final dayIndex = _dayIndexForDate(date);
    return dayIndex == null ? null : (dayIndex: dayIndex, minutes: minutes);
  }

  double _heightForRange(int start, int end) =>
      TimelinePositionCalculator.heightForRange(start, end, widget.hourHeight);

  int? _dayIndexForDate(DateTime date) {
    final difference =
        AppDateUtils.dateOnly(
          date,
        ).difference(AppDateUtils.dateOnly(widget.weekStart)).inDays;
    return difference >= 0 && difference < 7 ? difference : null;
  }

  void _syncFromHeader() {
    if (_syncingHorizontal || !_gridHorizontalController.hasClients) return;
    _syncingHorizontal = true;
    _gridHorizontalController.jumpTo(_headerHorizontalController.offset);
    _syncingHorizontal = false;
  }

  void _syncFromGrid() {
    if (_syncingHorizontal || !_headerHorizontalController.hasClients) return;
    _syncingHorizontal = true;
    _headerHorizontalController.jumpTo(_gridHorizontalController.offset);
    _syncingHorizontal = false;
  }

  void _updateAutoScroll(Offset globalPosition) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;
    final local = renderObject.globalToLocal(globalPosition);
    final height = renderObject.size.height;
    if (local.dy < _headerHeight + 70) {
      _autoScrollVelocity = -8;
    } else if (local.dy > height - 60) {
      _autoScrollVelocity = 8;
    } else {
      _stopAutoScroll();
      return;
    }
    _autoScrollTimer ??= Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_verticalController.hasClients) return;
      final position = _verticalController.position;
      final next = (_verticalController.offset + _autoScrollVelocity).clamp(
        0.0,
        position.maxScrollExtent,
      );
      _verticalController.jumpTo(next);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _autoScrollVelocity = 0;
  }

  void _cancelInteraction() {
    _stopAutoScroll();
    _creationDay = null;
    _creationStart = null;
    _creationEnd = null;
    _activeTask = null;
    _activeDraft = null;
    _selectedTaskId = null;
  }
}

class _TaskLayout {
  const _TaskLayout({
    required this.task,
    required this.lane,
    required this.laneCount,
  });

  final PlanTask task;
  final int lane;
  final int laneCount;
}

class _ScheduleGridPainter extends CustomPainter {
  const _ScheduleGridPainter({
    required this.color,
    required this.currentDayIndex,
    required this.currentDayColor,
    required this.columnWidth,
    required this.slotHeight,
    required this.slotCount,
  });

  final Color color;
  final int? currentDayIndex;
  final Color currentDayColor;
  final double columnWidth;
  final double slotHeight;
  final int slotCount;

  @override
  void paint(Canvas canvas, Size size) {
    final current = currentDayIndex;
    if (current != null) {
      canvas.drawRect(
        Rect.fromLTWH(current * columnWidth, 0, columnWidth, size.height),
        Paint()..color = currentDayColor,
      );
    }
    for (var day = 0; day <= 7; day++) {
      final x = day * columnWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = color.withAlpha(100)
          ..strokeWidth = 0.7,
      );
    }
    for (var slot = 0; slot <= slotCount; slot++) {
      final y = slot * slotHeight;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = color.withAlpha(
            slot % (60 ~/ AppDateUtils.slotMinutes) == 0 ? 125 : 45,
          )
          ..strokeWidth =
              slot % (60 ~/ AppDateUtils.slotMinutes) == 0 ? 0.8 : 0.4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScheduleGridPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.currentDayIndex != currentDayIndex ||
      oldDelegate.currentDayColor != currentDayColor ||
      oldDelegate.columnWidth != columnWidth ||
      oldDelegate.slotHeight != slotHeight ||
      oldDelegate.slotCount != slotCount;
}
