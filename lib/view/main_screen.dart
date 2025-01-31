import 'package:flutter/material.dart';
import 'package:first_snow/view/near_screen.dart';
import 'package:first_snow/view/alarm_screen.dart';
import 'package:first_snow/view/setting_screen.dart';
import 'package:first_snow/view/connect_screen.dart';
import 'package:first_snow/view/profile_screen.dart';
import 'package:first_snow/view/send_receive_screen.dart';

Widget mainScreen(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return NearScreen();
    case 1:
      return AlarmScreen();
    case 2:
      return SendReceiveScreen();
    case 3:
      return ConnectScreen();
    case 4:
      return SettingsPage();
    default:
      return NearScreen();
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
