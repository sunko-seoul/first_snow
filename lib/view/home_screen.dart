import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:first_snow/provider/client_user_provider.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:first_snow/provider/uuid_provider.dart';

// TODO: 새로고침시 리스트 초기화하기
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late NotificationProvider _notificationProvider;

  void setUserInfo() {
    final clientUserProvider = Provider.of<ClientUserProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false); // 서버 접근
    final user = Provider.of<LoginProvider>(context, listen: false).user; // UID
    final userListProvider = Provider.of<UserListProvider>(context, listen: false);
    final uuidProvider = Provider.of<UuidProvider>(context, listen: false);
    Future<UserModel> userModel = userProvider.getUser(user!.uid);
    userModel.then((value) {
      clientUserProvider.setClientInfo(
        uid: user.uid,
        name: value.name!,
        age: value.age!,
        instagramId: value.instagramId!,
        profileImage: Image.network(value.profileImagePath!),
      );
      userListProvider.uid = user.uid;
      uuidProvider.verifyUuidMatch(user.uid);
    }).catchError((e) {
      print("Error fetching user: $e");
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationProvider = NotificationProvider();
    _notificationProvider.init(context);
    _notificationProvider.showNotfication('init', 'init');
    final userListProvider = Provider.of<UserListProvider>(context, listen: false);
    setUserInfo();
    userListProvider.fetchNearUsers(); // 서버 전체 유저 가져오는 함수
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
              _notificationProvider.showNotfication('tab', 'tab');
            },
          );
        },
      ),
    );
  }
}
