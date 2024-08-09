import 'package:first_snow/const/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainBottomNavBar extends StatelessWidget {
  final screenWidth;
  final index;
  final onTap;

  MainBottomNavBar({
    required this.screenWidth,
    required this.index,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: screenWidth > 900
          ? EdgeInsets.symmetric(horizontal: screenWidth * 0.30)
          : screenWidth > 600
              ? EdgeInsets.symmetric(horizontal: screenWidth * 0.20)
              : EdgeInsets.zero,
      decoration: BoxDecoration(color: WHITE_COLOR, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 0),
        ),
      ]),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: index,
        onTap: onTap,
        elevation: 0,
        backgroundColor: WHITE_COLOR,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'asset/icon/arround.svg',
              semanticsLabel: 'arround_icon',
              height: 24,
              color: 0 == index ? PRIMARY_COLOR : GREY_COLOR_10,
            ),
            label: '근처 찾기',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'asset/icon/clock.svg',
              semanticsLabel: 'alarm_icon',
              height: 24,
              color: 1 == index ? PRIMARY_COLOR : GREY_COLOR_10,
            ),
            label: '오늘 스친 사람',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'asset/icon/logo.svg',
              semanticsLabel: 'logo_icon',
              height: 24,
              color: 2 == index ? PRIMARY_COLOR : GREY_COLOR_10,
            ),
            label: '보내기/받기',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'asset/icon/connect.svg',
              semanticsLabel: 'connect_icon',
              height: 24,
              color: 3 == index ? PRIMARY_COLOR : GREY_COLOR_10,
            ),
            label: '매칭',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'asset/icon/user.svg',
              semanticsLabel: 'user_icon',
              height: 24,
              color: 4 == index ? PRIMARY_COLOR : GREY_COLOR_10,
            ),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}
