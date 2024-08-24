import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:first_snow/const/color.dart';

class SendRecvTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: Provider.of<TabControllerProvider>(context).tabController,
        labelPadding: EdgeInsets.symmetric(vertical: 0),
        labelColor: BLACK_COLOR,
        unselectedLabelColor: GREY_COLOR_20,
        indicatorColor: BLACK_COLOR,
        indicator: BoxDecoration(),
        tabs: [
          Tab(
            child: Text(
              '내가 받은',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              '내가 보낸',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
