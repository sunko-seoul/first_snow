import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/send_recv_tab_bar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final int selectedIndex;
  final VoidCallback? onBackButtonPressed;

  MainAppBar({
    required this.selectedIndex,
    required this.showBackButton,
    this.onBackButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = Provider.of<BottomNavProvider>(context).selectedIndex;
    return AppBar(
      backgroundColor: WHITE_COLOR,
      leading: showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (onBackButtonPressed != null) {
            onBackButtonPressed!();
          }
          Navigator.pop(context);
        },
      )
          : null,
      flexibleSpace: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.0), // Adjust for top spacing
            Row(
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
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(48.0),
        child: Container(
          height: 48.0,
          alignment: Alignment.center,
          child: selectedIndex == 1
              ? Text(
            '오늘 스쳐지나간 사람들',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
              : selectedIndex == 2
              ? SendRecvTabBar()
              : Container(), // 빈 컨테이너로 기본값 설정
        ),
      ),
      elevation: 4.0,
      shadowColor: BLACK_COLOR,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      56.0 + (selectedIndex == 1 || selectedIndex == 2 ? 48.0 : 0));
}
