import 'package:flutter/material.dart';

class CreateTaskFloatingButton extends StatelessWidget {
  const CreateTaskFloatingButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'create-task',
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text('新增任务'),
    );
  }
}
