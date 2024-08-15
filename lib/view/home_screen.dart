import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/component/main_app_bar.dart';
import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:first_snow/view/main_screen.dart';
import 'package:first_snow/provider/bottom_nav_provider.dart';
import 'package:first_snow/provider/client_user_provider.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:first_snow/provider/user_list_provider.dart';


// TODO: UserCard 파이어베이스 key, value로 수정하기, 새로고침시 리스트 초기화하기
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    final clientUserProvider = Provider.of<ClientUserProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = Provider.of<LoginProvider>(context, listen: false).user;
    final userListProvider = Provider.of<UserListProvider>(context, listen: false);
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
    }).catchError((e) {
      print("Error fetching user: $e");
      // TODO: 어떤 에러처리?
    });
    userListProvider.fetchNearUsers();
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
            },
          );
        },
      ),
    );
  }
}
