import 'package:flutter/material.dart';

class CompactCreateTaskButton extends StatelessWidget {
  const CompactCreateTaskButton({
    super.key,
    required this.onPressed,
    this.showLabel = true,
  });

  final VoidCallback onPressed;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return IconButton.filledTonal(
        tooltip: '新建任务',
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 20),
      );
    }
    return Tooltip(
      message: '新建任务',
      child: SizedBox(
        height: 44,
        child: FilledButton.tonalIcon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            minimumSize: const Size(44, 44),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('新建'),
        ),
      ),
    );
  }
}
