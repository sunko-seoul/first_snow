import 'package:first_snow/provider/card_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:first_snow/component/user_card.dart';
import 'package:first_snow/provider/tab_controller_provider.dart';

class SendRecvScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller:
                Provider.of<TabControllerProvider>(context).tabController,
            children: [
              Consumer<UserListProvider>(
                  builder: (context, userProvider, child) {
                return sendScreen(userProvider.sendedUser);
              }),
              Consumer2<CardSelectProvider, UserListProvider>(
                  builder: (context, cardSelectProvider, userProvider, child) {
                void _onTap(int index) {
                  cardSelectProvider.updateIndex(index);
                }

                return recvScreen(userProvider.recvedUser,
                    cardSelectProvider.selectedIndex, _onTap);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

GestureDetector sendScreen(Set<int> userList) {
  return GestureDetector(
    onTap: () {},
    child: CustomScrollView(slivers: [
      SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 5,
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

GestureDetector recvScreen(
    Set<int> userList, int selectedIndex, Function(int) onTab) {
  return GestureDetector(
    onTap: () => onTab(-1),
    child: CustomScrollView(slivers: [
      SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return UserCardFlip(
                userId: userList.toList()[index],
                selectedIndex: selectedIndex,
                pageName: PageName.recv,
                acceptStr: '첫눈 받기',
                denyStr: '삭제하기',
                onTap: onTab,
              );
            },
            childCount: userList.length,
          ),
        ),
      ),
    ]),
  );
}
