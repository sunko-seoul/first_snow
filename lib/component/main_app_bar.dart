import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:first_snow/const/color.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      toolbarHeight: 56,
      elevation: 4.0,
      shadowColor: BLACK_COLOR,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
