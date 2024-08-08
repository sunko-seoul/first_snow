import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:first_snow/const/color.dart';

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
      toolbarHeight: 56,
      elevation: 4.0,
      shadowColor: BLACK_COLOR,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
