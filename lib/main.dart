import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:first_snow/view/signin_view.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/view/setup_view.dart';
import 'package:first_snow/provider/user_provider.dart';

import 'package:first_snow/provider/bottom_nav_provider.dart';
import 'package:first_snow/provider/card_select_provider.dart';
import 'package:first_snow/provider/setting_provider.dart';
import 'package:first_snow/provider/profile_oval_image_provider.dart';
import 'package:first_snow/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => BottomNavProvider()),
      ChangeNotifierProvider(create: (context) => CardSelectProvider()),
      ChangeNotifierProvider(create: (context) => SettingsViewModel()),
      ChangeNotifierProvider(create: (context) => TabControllerProvider()),
      ChangeNotifierProvider(create: (context) => UserListProvider()),
      ChangeNotifierProvider(create: (_) => ProfileOvalImageProvider()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => UserProvider()
        ),
      ],
      child: MaterialApp(
        title: 'First Snow',
        home: Consumer<LoginProvider>(
          builder: (context, user, child) {
            return user.status == Status.authenticated
              ? const SetupView()
              : const SignInView();
          },
        )
      ),
    );
  }
}




















