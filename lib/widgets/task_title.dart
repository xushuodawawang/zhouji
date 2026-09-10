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
    if (height < 26) return 1;
    if (height < 60) return 2;
    if (height < 78) return 3;
    return 4;
  }

  static double fontSizeForHeight(double height, {double maximum = 12}) {
    if (height < 16) return 7.5;
    if (height < 24) return 8.5;
    if (height < 36) return 9.5;
    if (height < 52) return 10.5;
    return maximum;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: trailing.isEmpty ? 1 : 15),
          child: Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: maxLinesForHeight(cardHeight),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: fontSizeForHeight(cardHeight, maximum: fontSize),
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
        ),
        if (trailing.isNotEmpty)
          Positioned(
            right: 0,
            child: Row(mainAxisSize: MainAxisSize.min, children: trailing),
          ),
      ],
    );
  }
}
