import 'package:first_snow/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:first_snow/provider/card_select_provider.dart';
import 'package:first_snow/component/user_card.dart';

class AlarmScreen extends StatelessWidget {
  AlarmScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardSelectProvider>(
      builder: (context, cardSelectProvider, child) {
        void _onTap(int index) {
          cardSelectProvider.updateIndex(index);
        }

        return Consumer<UserListProvider>(
            builder: (context, userProvider, child) {
          return GestureDetector(
            onTap: () => _onTap(-1),
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
                        userId: userProvider.alarmUser.toList()[index],
                        selectedIndex: cardSelectProvider.selectedIndex,
                        pageName: PageName.alarm,
                        acceptStr: '첫눈 보내기',
                        denyStr: '삭제하기',
                        onTap: _onTap,
                      );
                    },
                    childCount: userProvider.alarmUser.length,
                  ),
                ),
              ),
            ]),
          );
        });
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(10),
  //     child: GridView(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 5,
  //         mainAxisSpacing: 5,
  //         childAspectRatio: 0.75,
  //       ),
  //       children: [
  //         UserCard(index: 1),
  //         UserCard(index: 2),
  //         UserCard(index: 3),
  //         UserCard(index: 4),
  //         UserCard(index: 5),
  //       ],
  //     ),
  //   );
  // }
}
