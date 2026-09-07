import 'package:flutter/material.dart';

import '../models/plan_task.dart';

enum TaskQuickAction { edit, complete, copyToDay, copyNextWeek, lock, delete }

Future<TaskQuickAction?> showTaskQuickActionMenu(
  BuildContext context,
  PlanTask task,
) => showModalBottomSheet<TaskQuickAction>(
  context: context,
  showDragHandle: true,
  builder:
      (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('编辑任务'),
              onTap: () => Navigator.pop(context, TaskQuickAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('复制任务'),
              onTap: () => Navigator.pop(context, TaskQuickAction.copyToDay),
            ),
            ListTile(
              leading: Icon(
                task.isCompleted
                    ? Icons.radio_button_unchecked
                    : Icons.check_circle_outline,
              ),
              title: Text(task.isCompleted ? '取消完成' : '标记完成'),
              onTap: () => Navigator.pop(context, TaskQuickAction.complete),
            ),
            ListTile(
              leading: Icon(
                task.isLocked ? Icons.lock_open : Icons.lock_outline,
              ),
              title: Text(task.isLocked ? '解除锁定' : '锁定任务'),
              onTap: () => Navigator.pop(context, TaskQuickAction.lock),
            ),
            ListTile(
              leading: const Icon(Icons.next_week_outlined),
              title: const Text('复制到下周'),
              onTap: () => Navigator.pop(context, TaskQuickAction.copyNextWeek),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                '删除任务',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () => Navigator.pop(context, TaskQuickAction.delete),
            ),
          ],
        ),
      ),
);
