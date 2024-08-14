import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  void _initialization() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  NotificationDetails details = const NotificationDetails(
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
    android: AndroidNotificationDetails(
      "1",
      "test",
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  void init() async {
    tz.initializeTimeZones();

    _permissionWithNotification();
    _initialization();
    setPeriodicPushNotification(15, 2);
  }

  tz.TZDateTime _setDate(DateTime date) {
    Duration offSet = DateTime.now().timeZoneOffset;
    DateTime local = date.add(-offSet);

    return tz.TZDateTime(tz.local, local.year, local.month, local.day,
        local.hour, local.minute, local.second);
  }

  void setPeriodicPushNotification(int hour, int minute) async {
    DateTime now = DateTime.now();
    DateTime scheduleDate =
        DateTime(now.year, now.month, now.day, hour, minute);
    print(scheduleDate);
    tz.TZDateTime schedule = _setDate(scheduleDate);
    print(schedule);

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }

    print(schedule);
    await _local.zonedSchedule(
      1,
      "title",
      "body",
      schedule,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void showNotfication() {
    _local.show(1, "title", "body", details);
  }
}
