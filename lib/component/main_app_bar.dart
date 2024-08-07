import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:first_snow/component/send_recv_tab_bar.dart';
import 'package:first_snow/provider/bottom_nav_provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = Provider.of<BottomNavProvider>(context).selectedIndex;
    List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'asset/img/logo.svg',
            height: 32,
            semanticsLabel: 'main_logo',
          ),
        ],
      ),
    ];
    return AppBar(
      backgroundColor: WHITE_COLOR,
      title: Column(
        children: children,
      ),
      bottom: selectedIndex == 1
          ? PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Text(
                '오늘 스쳐지나간 사람들',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ))
          : selectedIndex == 2
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: SendRecvTabBar(),
                )
              : null,
      elevation: 4.0,
      shadowColor: BLACK_COLOR,
      toolbarHeight: 104,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
