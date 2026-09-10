import 'package:flutter/services.dart';

/// Uses Android screen pinning while a focus session is running.
///
/// Android displays its own confirmation the first time. The user can always
/// leave screen pinning with the system navigation gesture or key combination.
class FocusLockService {
  static const _channel = MethodChannel('com.zhouji.zhouji/focus_lock');

  Future<bool> activate() async {
    try {
      return await _channel.invokeMethod<bool>('activate') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> deactivate() async {
    try {
      await _channel.invokeMethod<void>('deactivate');
    } on PlatformException {
      // The user may already have left screen pinning with the system gesture.
    } on MissingPluginException {
      // Widget and controller tests run without an Android host.
    }
  }
}
