import 'package:flutter/material.dart';
import 'package:first_snow/component/user_match_card.dart';
import 'package:first_snow/stream/connect_stream.dart';


class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ConnectStream(); // firebase에서 받아와서 connectScreen에 전송
  }
}

GestureDetector connectScreen(Set<String> userList) {
  return GestureDetector(
    onTap: () {},
    child: CustomScrollView(slivers: [
      SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.75,
            mainAxisSpacing: 10,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return UserMatchCard(
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
