import 'package:first_snow/provider/client_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:first_snow/view/signup_view.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/view/setup_view.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:first_snow/provider/bottom_nav_provider.dart';
import 'package:first_snow/provider/card_select_provider.dart';
import 'package:first_snow/provider/setting_provider.dart';
import 'package:first_snow/provider/profile_oval_image_provider.dart';
import 'package:first_snow/view/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_snow/database/bt_communicate.dart';
import 'package:first_snow/database/drift_test.dart';
import 'package:first_snow/background/background_service.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('fcmToken: $fcmToken');
  final btDatabase = BTDatabase();
  GetIt.I.registerSingleton<BTDatabase>(btDatabase);
  final testDatabase = TestDatabase();
  GetIt.I.registerSingleton<TestDatabase>(testDatabase);

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  Workmanager().registerPeriodicTask(
    'BTScanTask',
    'BTScanTask',
    frequency: Duration(minutes: 20),
  );

  Future<String?> getInitialRoute() async {
    FlutterLocalNotificationsPlugin localNotification =
        FlutterLocalNotificationsPlugin();

    NotificationAppLaunchDetails? details =
        await localNotification.getNotificationAppLaunchDetails();
    if (details != null) {
      if (details.didNotificationLaunchApp) {
        if (details.notificationResponse?.payload != null) {
          return details.notificationResponse!.payload!;
        }
      }
    }
    return null;
  }

  String? initialRoute = await getInitialRoute();
  if (initialRoute != null) {
    initialRoute = '/$initialRoute';
  }

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => BottomNavProvider()),
          ChangeNotifierProvider(create: (context) => CardSelectProvider()),
          ChangeNotifierProvider(create: (context) => SettingProvider()),
          ChangeNotifierProvider(create: (context) => TabControllerProvider()),
          ChangeNotifierProvider(create: (context) => UserListProvider()),
          ChangeNotifierProvider(create: (_) => ProfileOvalImageProvider()),
          ChangeNotifierProvider(create: (context) => ClientUserProvider()),
        ],
        child: MyApp(
          initialRoute: initialRoute,
        )),
  );
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  const MyApp({
    super.key,
    this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/receive': (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<BottomNavProvider>(context, listen: false)
                .updateIndex(2);
          });
          return HomeScreen();
        },
        '/alarm': (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<BottomNavProvider>(context, listen: false)
                .updateIndex(1);
          });
          return HomeScreen();
        },
      },
      title: 'First Snow',
      initialRoute: initialRoute ?? '/',
      home: Consumer<LoginProvider>(
        builder: (context, user, child) {
          if (user.status == Status.authenticated) {
            return SetupView();
          } else if (user.status == Status.profileCompleted) {
            return HomeScreen();
          } else {
            return SignUpView();
          }
        },
      ),
    );
  }
}
