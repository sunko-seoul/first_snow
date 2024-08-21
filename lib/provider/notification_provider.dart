import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:first_snow/provider/bottom_nav_provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'dart:io';
import 'package:first_snow/model/notification_payload_model.dart';

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  void _initialization(BuildContext context) async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    bool? initStatus = await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload == "alarm") {
          Provider.of<BottomNavProvider>(context, listen: false).updateIndex(1);
        } else if (response.payload == "receive") {
          Provider.of<BottomNavProvider>(context, listen: false).updateIndex(2);
        } else if (response.payload == "match") {
          Provider.of<BottomNavProvider>(context, listen: false).updateIndex(3);
        }
      },
    );
    print(initStatus);
  }

  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied ||
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
      "first_snow",
      "첫눈",
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  void init(BuildContext context) async {
    tz.initializeTimeZones();

    _permissionWithNotification();
    _initialization(context);
    setPeriodicPushNotification(22, 0); // 10시 알림
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
      "첫눈",
      "어제 하루동안 스친 사람들을 확인해보세요!",
      schedule,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "alarm",
    );
  }

  void showNotfication(String title, String body, String payload) {
    _local.show(1, title, body, details, payload: payload);
  }

  Future<String?> postMessage(NotificationPayload payload) async {
    try {
      final url =
          "https://us-central1-first-snow-1347c.cloudfunctions.net/sendPushNotification";

      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(payload.toJson()));
      if (response.statusCode == 200) {
        return null;
      } else {
        return "Faliure";
      }
    } on HttpException catch (error) {
      print(error.message);
      return error.message;
    }
  }
}
