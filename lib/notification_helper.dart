import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// for local notification need these permission and also need permission_handler: ^11.3.1 for get alarm permission
// <uses-permission android:name="android.permission.VIBRATE" />
// <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
// <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
// <uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>
// <uses-permission android:name="android.permission.WAKE_LOCK" />
// <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
// <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
// <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
// <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
class NotificationHelper {
  final _notification = FlutterLocalNotificationsPlugin();

  init() {
    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
            '@mipmap/learnpro_logo_foreground'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<void> pushNotification(
      {required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'Reminder',
      'Reminder Notification',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
        android: androidDetails, iOS: iosDetails);
    await _notification.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate, // Change to tz.TZDateTime
  }) async {
    await _notification.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'Reminder',
              'Reminder Notification',
              channelDescription: 'channel_description',
              importance: Importance.max,
              priority: Priority.high)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}