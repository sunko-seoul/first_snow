import 'package:flutter/material.dart';
import 'package:first_snow/view/search_screen.dart';
import 'package:first_snow/view/send_recv_screen.dart';
import 'package:first_snow/test.dart';

Widget mainScreen(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return SearchScreen();
    case 1:
      return TestScreen();
    case 2:
      return SendRecvScreen();
    case 3:
      return dummyScreen(4);
    case 4:
      return dummyScreen(5);
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
