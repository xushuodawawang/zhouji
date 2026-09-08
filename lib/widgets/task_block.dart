import 'package:flutter/material.dart';

import '../models/plan_task.dart';
import '../utils/date_time_utils.dart';
import '../utils/app_colors.dart';
import 'task_title.dart';

class TaskBlock extends StatelessWidget {
  const TaskBlock({
    super.key,
    required this.task,
    required this.onTap,
    required this.onLongPress,
    required this.onMoveStart,
    required this.onMoveUpdate,
    required this.onMoveEnd,
    required this.onMoveCancel,
    required this.onResizeTopStart,
    required this.onResizeTopUpdate,
    required this.onResizeTopEnd,
    required this.onResizeTopCancel,
    required this.onResizeBottomStart,
    required this.onResizeBottomUpdate,
    required this.onResizeBottomEnd,
    required this.onResizeBottomCancel,
    required this.actualHeight,
    this.isPreview = false,
    this.isSelected = false,
    this.isDimmed = false,
    this.backgroundOpacity = 0.72,
  });

  final PlanTask task;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final GestureDragStartCallback onMoveStart;
  final GestureDragUpdateCallback onMoveUpdate;
  final GestureDragEndCallback onMoveEnd;
  final VoidCallback onMoveCancel;
  final GestureDragStartCallback onResizeTopStart;
  final GestureDragUpdateCallback onResizeTopUpdate;
  final GestureDragEndCallback onResizeTopEnd;
  final VoidCallback onResizeTopCancel;
  final GestureDragStartCallback onResizeBottomStart;
  final GestureDragUpdateCallback onResizeBottomUpdate;
  final GestureDragEndCallback onResizeBottomEnd;
  final VoidCallback onResizeBottomCancel;
  final double actualHeight;
  final bool isPreview;
  final bool isSelected;
  final bool isDimmed;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    final status = task.statusAt(DateTime.now());
    final original = Color(task.colorValue);
    final color = switch (status) {
      TaskDisplayStatus.completed => Color.lerp(original, Colors.grey, 0.42)!,
      TaskDisplayStatus.missed => Color.lerp(original, Colors.grey, 0.58)!,
      TaskDisplayStatus.pending => original,
    };
    final foreground = Theme.of(context).colorScheme.onSurface;
    final interactive = !isPreview && !task.isLocked;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isPreview ? 0.68 : (isDimmed ? 0.68 : 1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(45),
                      blurRadius: 6,
                    ),
                  ]
                  : null,
        ),
        child: Material(
          key: const ValueKey('task-block-surface'),
          color: AppColors.taskSurface(
            context,
            color,
          ).withValues(alpha: backgroundOpacity.clamp(0.25, 1)),
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: TaskHitArea(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 7,
                  bottom: 7,
                  width: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 4, interactive ? 42 : 6, 4),
                    child: LayoutBuilder(
                      builder:
                          (context, constraints) => Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TaskTitle(
                                    title: task.title,
                                    cardHeight:
                                        constraints.maxHeight >= 72
                                            ? constraints.maxHeight - 24
                                            : constraints.maxHeight,
                                    color: foreground,
                                    fontSize: 12,
                                    trailing: [
                                      if (task.isLocked)
                                        Icon(
                                          Icons.lock,
                                          size: 13,
                                          color: foreground,
                                        ),
                                      if (status == TaskDisplayStatus.completed)
                                        Icon(
                                          Icons.check_circle,
                                          size: 13,
                                          color: foreground,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              if (constraints.maxHeight >= 72)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Text(
                                    '${AppDateUtils.formatMinutes(task.startMinutes)}'
                                    '－${AppDateUtils.formatMinutes(task.endMinutes)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: foreground.withAlpha(215),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                    ),
                  ),
                ),
                if (actualHeight < 47)
                  Positioned(
                    top: actualHeight.clamp(8, 45),
                    left: 4,
                    right: 4,
                    child: IgnorePointer(
                      child: Container(
                        height: 1.5,
                        color: foreground.withAlpha(155),
                      ),
                    ),
                  ),
                if (interactive)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 48,
                    height: 18,
                    child: TaskResizeHandle(
                      edge: TaskResizeEdge.top,
                      foreground: foreground,
                      onTap: onTap,
                      onLongPress: onLongPress,
                      onStart: onResizeTopStart,
                      onUpdate: onResizeTopUpdate,
                      onEnd: onResizeTopEnd,
                      onCancel: onResizeTopCancel,
                    ),
                  ),
                if (interactive)
                  Positioned(
                    right: 0,
                    top: 0,
                    width: 48,
                    height: 48,
                    child: TaskDragHandle(
                      foreground: foreground,
                      onTap: onTap,
                      onLongPress: onLongPress,
                      onStart: onMoveStart,
                      onUpdate: onMoveUpdate,
                      onEnd: onMoveEnd,
                      onCancel: onMoveCancel,
                    ),
                  ),
                if (interactive)
                  Positioned(
                    left: 0,
                    right: 48,
                    bottom: 0,
                    height: 18,
                    child: TaskResizeHandle(
                      edge: TaskResizeEdge.bottom,
                      foreground: foreground,
                      onTap: onTap,
                      onLongPress: onLongPress,
                      onStart: onResizeBottomStart,
                      onUpdate: onResizeBottomUpdate,
                      onEnd: onResizeBottomEnd,
                      onCancel: onResizeBottomCancel,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskHitArea extends StatelessWidget {
  const TaskHitArea({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.child,
  });

  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      splashFactory: InkRipple.splashFactory,
      child: GestureDetector(behavior: HitTestBehavior.opaque, child: child),
    );
  }
}

class TaskDragHandle extends StatelessWidget {
  const TaskDragHandle({
    super.key,
    required this.foreground,
    required this.onTap,
    required this.onLongPress,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.onCancel,
  });

  final Color foreground;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final GestureDragStartCallback onStart;
  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '拖动任务',
      child: _PointerDragSurface(
        onTap: onTap,
        onLongPress: onLongPress,
        onStart: onStart,
        onUpdate: onUpdate,
        onEnd: onEnd,
        onCancel: onCancel,
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.drag_indicator,
              size: 16,
              color: foreground.withAlpha(185),
            ),
          ),
        ),
      ),
    );
  }
}

enum TaskResizeEdge { top, bottom }

class TaskResizeHandle extends StatelessWidget {
  const TaskResizeHandle({
    super.key,
    required this.edge,
    required this.foreground,
    required this.onTap,
    required this.onLongPress,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.onCancel,
  });

  final TaskResizeEdge edge;
  final Color foreground;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final GestureDragStartCallback onStart;
  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: edge == TaskResizeEdge.top ? '调整开始时间' : '调整结束时间',
      child: _PointerDragSurface(
        onTap: onTap,
        onLongPress: onLongPress,
        onStart: onStart,
        onUpdate: onUpdate,
        onEnd: onEnd,
        onCancel: onCancel,
        vertical: true,
        child: Align(
          alignment:
              edge == TaskResizeEdge.top
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: foreground.withAlpha(160),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _PointerDragSurface extends StatefulWidget {
  const _PointerDragSurface({
    required this.onTap,
    required this.onLongPress,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.onCancel,
    required this.child,
    this.vertical = false,
  });

  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final GestureDragStartCallback onStart;
  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;
  final VoidCallback onCancel;
  final Widget child;
  final bool vertical;

  @override
  State<_PointerDragSurface> createState() => _PointerDragSurfaceState();
}

class _PointerDragSurfaceState extends State<_PointerDragSurface> {
  bool _moved = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!_moved) widget.onTap();
      },
      onLongPress: widget.onLongPress,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          _moved = false;
          widget.onStart(
            DragStartDetails(
              sourceTimeStamp: event.timeStamp,
              globalPosition: event.position,
              localPosition: event.localPosition,
              kind: event.kind,
            ),
          );
        },
        onPointerMove: (event) {
          _moved = true;
          widget.onUpdate(
            DragUpdateDetails(
              sourceTimeStamp: event.timeStamp,
              globalPosition: event.position,
              localPosition: event.localPosition,
              delta: event.delta,
              primaryDelta: widget.vertical ? event.delta.dy : null,
            ),
          );
        },
        onPointerUp: (_) => widget.onEnd(DragEndDetails()),
        onPointerCancel: (_) => widget.onCancel(),
        child: widget.child,
      ),
    );
  }
}
