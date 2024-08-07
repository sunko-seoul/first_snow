import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:first_snow/test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:first_snow/provider/bottom_nav_provider.dart';
import 'package:first_snow/provider/card_select_provider.dart';
import 'package:first_snow/view/home_screen.dart';
import 'package:first_snow/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BottomNavProvider()),
          ChangeNotifierProvider(create: (context) => CardSelectProvider()),
          ChangeNotifierProvider(create: (context) => TestProvider()),
          // ChangeNotifierProvider(
          //     create: (context) =>
          //         TabControllerProvider(TickerProviderStateMixin())),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
