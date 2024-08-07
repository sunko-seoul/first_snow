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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'First Snow',
        home: Consumer<UserProvider>(
          builder: (context, user, child) {
            return user.status == Status.authenticated
              ? const HomeScreen()
              : const SignInView();
          },
        )
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () async {
              await userProvider.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Text("Welcome, ${userProvider.user?.email ?? 'Guest'}"), // user가 없으면 Guest로 표시
      ),

    );
  }
}



















