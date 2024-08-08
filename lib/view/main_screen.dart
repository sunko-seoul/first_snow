import 'package:flutter/material.dart';
import 'package:first_snow/view/search_screen.dart';
import 'package:first_snow/view/setting_screen.dart';

Widget mainScreen(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return SearchScreen();
    case 1:
      return dummyScreen(2);
    case 2:
      return dummyScreen(3);
    case 3:
      return dummyScreen(4);
    case 4:
      return SettingsPage();
    default:
      return dummyScreen(1);
  }
}

Container dummyScreen(int idx) {
  return Container(
    child: Center(
      child: Text(
        'Tab$idx',
        style: TextStyle(color: Colors.grey, fontSize: 32),
      ),
    ),
  );
}
