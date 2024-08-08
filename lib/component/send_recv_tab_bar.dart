import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/test.dart';
import 'package:first_snow/const/color.dart';

class SendRecvTabBar extends StatelessWidget {
  @override
  TabBar build(BuildContext context) {
    return TabBar(
      controller: Provider.of<TestProvider>(context).tabController,
      labelColor: BLACK_COLOR,
      unselectedLabelColor: GREY_COLOR_20,
      indicatorColor: BLACK_COLOR,
      indicator: BoxDecoration(),
      tabs: [
        Tab(
          child: Text(
            '내가 보낸',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Tab(
          child: Text(
            '내가 받은',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
