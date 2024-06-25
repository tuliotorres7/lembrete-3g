import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotification {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsDarwin =
        const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(
        android: androidInitialize, iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      DateTime? date}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'you_can_name_it_whatever1', 'chane1_name',
            playSound: true,
            importance: Importance.max,
            priority: Priority.max);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentSound: false,
    );

    var not = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    tz.initializeTimeZones();
    if (date != null) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id, title, body, tz.TZDateTime.from(date, tz.local), not,
          //androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } else {
      await flutterLocalNotificationsPlugin.show(0, title, body, not);
    }
  }

  // Future<void> setupTimezone() async {
  //   tz.initializeTimeZones();
  //   final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(timeZoneName));
  // }
}
