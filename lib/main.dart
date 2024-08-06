import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:first_snow/view/signin_view.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Snow',
      home: Consumer<UserProvider>(
        builder: (context, user, child) => user.status == Status.authenticated
          ? Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('로그인 성공'),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<UserProvider>().signOut();
                  },
                  child: const Text('로그아웃'),
                ),
              ],
            ),
          ),
        )
          : const signinView(),
      )
    );
  }
}