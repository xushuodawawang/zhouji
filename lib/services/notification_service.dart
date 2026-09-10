import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();

  static const _timerNotificationId = 4100;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(
          '@drawable/ic_launcher_foreground',
        ),
      ),
    );
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await initialize();
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return true;
    return await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<void> scheduleTimerEnd({
    required DateTime endAt,
    required bool isBreak,
  }) async {
    await initialize();
    await cancelTimer();
    await _plugin.zonedSchedule(
      id: _timerNotificationId,
      title: isBreak ? '休息结束' : '专注完成',
      body: isBreak ? '准备开始下一段专注吧' : '做得不错，起来活动一下吧',
      scheduledDate: tz.TZDateTime.from(endAt.toUtc(), tz.UTC),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_timer',
          '专注计时提醒',
          channelDescription: '番茄专注与休息结束提醒',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelTimer() async {
    if (!_initialized) return;
    await _plugin.cancel(id: _timerNotificationId);
  }
}
