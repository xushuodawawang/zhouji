import 'package:flutter/material.dart';

abstract final class AppColors {
  static const seed = Color(0xFF176B5B);
  static const lightBackground = Color(0xFFF4F6F2);
  static const darkBackground = Color(0xFF111C18);

  static Color taskSurface(BuildContext context, Color color) =>
      Color.lerp(
        Theme.of(context).colorScheme.surface,
        color,
        Theme.of(context).brightness == Brightness.dark ? 0.30 : 0.76,
      )!;

  static const taskPalette = <Color>[
    Color(0xFFD3E8B7), // 芽绿
    Color(0xFFECF7E1), // 淡叶绿
    Color(0xFFCDE7FA), // 晴空蓝
    Color(0xFFFFF4B6), // 柔日黄
    Color(0xFFFCE8E6), // 雾粉
    Color(0xFFFFC6BC), // 珊瑚粉
    Color(0xFFD6DFEF), // 云灰蓝
    Color(0xFFA5CDE2), // 冰蓝
    Color(0xFFC9CEFE), // 薰衣草
    Color(0xFFCBE8DF), // 薄荷青
  ];

  static const focusPalette = <Color>[
    Color(0xFF007F6B),
    Color(0xFF29927E),
    Color(0xFF4A9E8F),
    Color(0xFF65AF9D),
    Color(0xFF82BEA9),
    Color(0xFF9CCBB8),
  ];

  static int automaticTaskColor(String title) =>
      taskPalette[_stableColorIndex(title, taskPalette.length)].toARGB32();

  static int automaticFocusColor(String title) =>
      focusPalette[_stableColorIndex(title, focusPalette.length)].toARGB32();

  static int _stableColorIndex(String title, int length) {
    var hash = 0;
    final normalized = title.trim().toLowerCase().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    for (final unit in normalized.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash % length;
  }
}
