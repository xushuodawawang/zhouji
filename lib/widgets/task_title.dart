import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  const TaskTitle({
    super.key,
    required this.title,
    required this.cardHeight,
    required this.color,
    required this.fontSize,
    this.trailing = const [],
  });

  final String title;
  final double cardHeight;
  final Color color;
  final double fontSize;
  final List<Widget> trailing;

  static int maxLinesForHeight(double height) {
    if (height < 32) return 1;
    if (height < 56) return 2;
    if (height < 86) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            softWrap: true,
            maxLines: maxLinesForHeight(cardHeight),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
        if (trailing.isNotEmpty) ...[const SizedBox(width: 2), ...trailing],
      ],
    );
  }
}
