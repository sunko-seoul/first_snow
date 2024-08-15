import 'package:flutter/material.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:first_snow/component/user_card.dart';
import 'package:first_snow/provider/card_select_provider.dart';

GestureDetector receiveScreen(
    Set<String> userList, String selectedIndex, Function(String) onTab) {
  return GestureDetector(
    onTap: () => onTab("-1"),
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
