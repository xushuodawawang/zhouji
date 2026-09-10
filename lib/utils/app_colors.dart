import 'package:flutter/material.dart';

abstract final class AppColors {
  static const seed = Color(0xFF176B5B);
  static const lightBackground = Color(0xFFF4F6F2);
  static const darkBackground = Color(0xFF111C18);

  static Color taskSurface(BuildContext context, Color color) =>
      Color.lerp(
        Theme.of(context).colorScheme.surface,
        color,
        Theme.of(context).brightness == Brightness.dark ? 0.32 : 0.22,
      )!;

  static const taskPalette = <Color>[
    Color(0xFF80A9A5),
    Color(0xFF87A7C0),
    Color(0xFFA39AC3),
    Color(0xFFC29A9A),
    Color(0xFFC3AB78),
    Color(0xFF8FAF8A),
  ];

  static const focusPalette = <Color>[
    Color(0xFF247D68),
    Color(0xFF3F9270),
    Color(0xFF5AA477),
    Color(0xFF78B47D),
    Color(0xFF55958A),
    Color(0xFF7D9F8B),
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
