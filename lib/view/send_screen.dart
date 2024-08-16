import 'package:flutter/material.dart';
import 'package:first_snow/component/user_card.dart';



GestureDetector sendScreen(Set<String> userList) {
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