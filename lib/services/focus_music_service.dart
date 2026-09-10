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

  Future<bool> play(String uri) async {
    if (uri.isEmpty) return false;
    try {
      await _channel.invokeMethod<void>('play', {'uri': uri});
      return true;
    } on PlatformException {
      // A moved or deleted document should never prevent the focus timer.
      return false;
    } on MissingPluginException {
      // Widget and repository tests run without an Android host.
      return false;
    }
  }

  Future<bool> preview(String uri) async {
    if (uri.isEmpty) return false;
    try {
      await _channel.invokeMethod<void>('preview', {'uri': uri});
      return true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> pause() async {
    try {
      await _channel.invokeMethod<void>('pause');
    } on PlatformException {
      // The selected document may have been moved or the player released.
    } on MissingPluginException {
      // Widget and controller tests run without an Android host.
    }
  }

  Future<bool> resume() async {
    try {
      return await _channel.invokeMethod<bool>('resume') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
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

  Future<void> playCompletionSound() async {
    try {
      await _channel.invokeMethod<void>('playCompletionSound');
    } on PlatformException {
      // A sound failure should never prevent a completed session being saved.
    } on MissingPluginException {
      // Widget and controller tests run without an Android host.
    }
  }
}
