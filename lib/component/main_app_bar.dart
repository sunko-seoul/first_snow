import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/send_recv_tab_bar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  MainAppBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = Provider.of<BottomNavProvider>(context).selectedIndex;
    return AppBar(
      backgroundColor: WHITE_COLOR,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'asset/img/logo.svg',
            height: 32,
            semanticsLabel: 'main_logo',
          ),
        ],
      ),
      bottom: selectedIndex == 1
          ? PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                  height: 48.0,
                  alignment: Alignment.center,
                  child: Text(
                    '오늘 스쳐지나간 사람들',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )))
          : selectedIndex == 2
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: SendRecvTabBar(),
                )
              : null,
      elevation: 4.0,
      shadowColor: BLACK_COLOR,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      56.0 + (selectedIndex == 1 || selectedIndex == 2 ? 48.0 : 0));
}
