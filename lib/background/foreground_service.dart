import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:first_snow/database/bt_communicate.dart';
import 'package:first_snow/database/drift_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:drift/drift.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeBTService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
      foregroundServiceNotificationId: 888,
      foregroundServiceType: AndroidForegroundType.connectedDevice,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  service.on("stop").listen((event) {
    service.stopSelf();
    debugPrint("background process is now stopped");
  });

  service.on("start").listen((event) {});

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bluetooth 관련 innitialize
  final database = BTDatabase();
  final testDatabase = TestDatabase();
  FlutterBluePlus.scanResults.listen((results) {
    results.forEach((r) {
      database.createBTCommunicate(
        BTCommunicateCompanion(
          data: Value(r.device.remoteId.str),
          date: Value(DateTime.now()),
        ),
      );
    });
  });

  int idx = 0;

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    idx++;
    print('repeated Idx: $idx');
    if (idx == 20) {
      idx = 0;
      database.removeDuplicates();
      testDatabase.createDriftTestWDuplicate(
        DriftTestCompanion(
          date: Value(DateTime.now()),
          data: Value('drift_test'),
        ),
      );
    }
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          '첫눈',
          '첫눈이 주변에 내리고 있어요',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'bt_foreground',
              'GET BLUETOOTH UUID',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
      // run foreground service
      try {
        print('Executing BTScanTask');
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      } catch (e) {
        debugPrint('Error while createing BTCommunicate');
      }
    }
  });
}

// Future<void> initializeBTService() async {
//   final service = FlutterBackgroundService();

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'bt_foreground',
//     'BT FOREGROUND SERVICE',
//     description: 'used to get BT uuid',
//     importance: Importance.none,
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   if (Platform.isAndroid || Platform.isIOS) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         // notification setting
//         iOS: DarwinInitializationSettings(),
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }

// void foregroundServiceConfigure(FlutterBackgroundService service) async {
//   await service.configure(
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//     androidConfiguration: AndroidConfiguration(
//       autoStart: true,
//       onStart: onStart,
//       isForegroundMode: true,
//       notificationChannelId: 'bt_foreground',
//       initialNotificationTitle: 'GET BLUETOOTH UUID',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,
//       foregroundServiceType: AndroidForegroundType.connectedDevice,
//     ),
//   );
// }

