import 'dart:io';
import 'package:first_snow/provider/client_user_provider.dart';
import 'package:first_snow/provider/notification_provider.dart';
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
import 'package:first_snow/provider/uuid_provider.dart';
import 'package:first_snow/background/foreground_service.dart';
import 'package:first_snow/view/skeleton_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmToken: $fcmToken');
  final btDatabase = BTDatabase();
  GetIt.I.registerSingleton<BTDatabase>(btDatabase);
  final testDatabase = TestDatabase();
  GetIt.I.registerSingleton<TestDatabase>(testDatabase);

  await initializeBTService();
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false,
  // );

  // Workmanager().registerPeriodicTask(
  //   'BTScanTask',
  //   'BTScanTask',
  //   frequency: Duration(minutes: 20),
  // );

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

  FirebaseMessaging.onMessageOpenedApp.listen(
    // fcm background case
    (RemoteMessage message) {
      print('Message: ${message.notification!.title}');
      if (message.data['payload'] != null) {
        if (message.data['payload'] == 'alarm') {
          Navigator.of(navigatorKey.currentContext!).pushNamed('/alarm');
        } else if (message.data['payload'] == 'receive') {
          Navigator.of(navigatorKey.currentContext!).pushNamed('/recieve');
          print('receive');
        } else if (message.data['payload'] == 'match') {
          Navigator.of(navigatorKey.currentContext!).pushNamed('/match');
          print('match');
        }
      }
      print('payload: ${message.data['payload']}');
    },
  );

  String? initialRoute = await getInitialRoute();

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //fcm terminated case
    if (message != null) {
      if (message.notification != null) {
        if (message.data['payload'] != null) {
          if (message.data['payload'] == 'alarm') {
            // initialRoute = 'alarm';
          } else if (message.data['payload'] == 'receive') {
            // initialRoute = 'receive';
          } else if (message.data['payload'] == 'match') {
            // initialRoute = 'match';
          }
        }
      }
    }
  });

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
          ChangeNotifierProvider(create: (context) => UuidProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider())
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
      navigatorKey: navigatorKey,
      routes: {
        '/alarm': (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<BottomNavProvider>(context, listen: false)
                .updateIndex(1);
          });
          return HomeScreen();
        },
        '/receive': (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<BottomNavProvider>(context, listen: false)
                .updateIndex(2);
          });
          return HomeScreen();
        },
        '/match': (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<BottomNavProvider>(context, listen: false)
                .updateIndex(3);
          });
          return HomeScreen();
        }
      },
      title: 'First Snow',
      initialRoute: initialRoute ?? '/',
      home: Consumer<LoginProvider>(
        builder: (context, user, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (initialRoute != null) {
              NotificationProvider()
                  .showNotfication("initial Route", initialRoute!, "");
            }
          });
          if (user.status == Status.authenticated) {
            return SetupView();
          } else if (user.status == Status.profileCompleted) {
            return HomeScreen();
          } else if (user.status == Status.unauthenticated) {
            return SignUpView();
          } else {
            return SkeletonScreen();
          }
        },
      ),
    );
  }
}
