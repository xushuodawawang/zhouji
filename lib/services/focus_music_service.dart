import 'package:flutter/services.dart';

class FocusMusicSelection {
  const FocusMusicSelection({required this.uri, required this.name});

  final String uri;
  final String name;
}

class FocusMusicService {
  static const _channel = MethodChannel('com.zhouji.zhouji/focus_music');

  Future<FocusMusicSelection?> pickAudio() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'pickAudio',
      );
      final uri = result?['uri'] as String?;
      if (uri == null || uri.isEmpty) return null;
      return FocusMusicSelection(
        uri: uri,
        name: result?['name'] as String? ?? '自定义音乐',
      );
    } on MissingPluginException {
      return null;
    }
  }

  Future<void> play(String uri) async {
    if (uri.isEmpty) return;
    try {
      await _channel.invokeMethod<void>('play', {'uri': uri});
    } on PlatformException {
      // A moved or deleted document should never prevent the focus timer.
    } on MissingPluginException {
      // Widget and repository tests run without an Android host.
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException {
      // Stopping an already released player is harmless.
    } on MissingPluginException {
      // Widget and repository tests run without an Android host.
    }
  }
}
