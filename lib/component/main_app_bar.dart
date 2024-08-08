import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:first_snow/component/send_recv_tab_bar.dart';
import 'package:first_snow/provider/bottom_nav_provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  MainAppBar({
    Key? key,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: WHITE_COLOR,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      title: Text(""),
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'asset/img/logo.svg',
              height: 32,
              semanticsLabel: 'main_logo',
            ),
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
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
