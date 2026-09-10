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
    Color(0xFF457635), // 森林绿
    Color(0xFF6B9136), // 橄榄绿
    Color(0xFF97B365), // 嫩叶绿
    Color(0xFFDFD352), // 油画黄
    Color(0xFFF8EBBD), // 奶油黄
    Color(0xFFB1C5C9), // 雾霾蓝
    Color(0xFFDFC5BF), // 灰豆粉
    Color(0xFF68A8CC), // 湖蓝
    Color(0xFF9A86C8), // 鸢尾紫
    Color(0xFFD98272), // 珊瑚红
    Color(0xFFD6A24F), // 琥珀橙
    Color(0xFF62A58E), // 青瓷绿
  ];

  static const focusPalette = <Color>[
    Color(0xFF457635),
    Color(0xFFDFD352),
    Color(0xFF68A8CC),
    Color(0xFFD98272),
    Color(0xFF9A86C8),
    Color(0xFF6B9136),
    Color(0xFFB1C5C9),
    Color(0xFFD6A24F),
    Color(0xFF62A58E),
    Color(0xFFDFC5BF),
  ];

  static int automaticTaskColor(String title) =>
      taskPalette[_stableColorIndex(title, taskPalette.length)].toARGB32();

  static int automaticFocusColor(String title) =>
      focusPalette[_stableColorIndex(title, focusPalette.length)].toARGB32();

  static int focusChartColor(int index) =>
      focusPalette[index % focusPalette.length].toARGB32();

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
