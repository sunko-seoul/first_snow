import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/view/near_screen.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:first_snow/component/user_card.dart';
import 'package:first_snow/provider/tab_controller_provider.dart';

class ConnectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserListProvider>(builder: (context, userProvider, child) {
      return connectScreen(userProvider.connectedUser);
    });
  }
}

GestureDetector connectScreen(Set<int> userList) {
  return GestureDetector(
    onTap: () {},
    child: CustomScrollView(slivers: [
      SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.5,
            mainAxisSpacing: 5,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return UserCard(
                userId: userList.toList()[index],
              );
            },
            childCount: userList.length,
          ),
        ),
      ),
    ]),
  );
}
