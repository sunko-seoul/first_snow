import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:first_snow/component/main_app_bar.dart';
import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:first_snow/view/main_screen.dart';
import 'package:first_snow/provider/bottom_nav_provider.dart';
import 'package:first_snow/provider/notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();

    _notificationProvider = NotificationProvider();
    _notificationProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TabControllerProvider>(context).init(this, 2);

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MainAppBar(
        showBackButton: false,
        selectedIndex: Provider.of<BottomNavProvider>(context).selectedIndex,
      ),
      body: Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, child) {
          return mainScreen(bottomNavProvider.selectedIndex);
        },
      ),
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, child) {
          return MainBottomNavBar(
            screenWidth: screenWidth,
            index: bottomNavProvider.selectedIndex,
            onTap: (int index) {
              bottomNavProvider.updateIndex(index);
              // _notificationProvider.showNotfication();
            },
          );
        },
      ),
    );
  }
}
