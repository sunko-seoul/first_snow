import 'package:flutter/material.dart';

import 'package:first_snow/test/test_db_list.dart';
import 'package:first_snow/test/bluetooth_db_list.dart';
import 'package:first_snow/test/test_android_native.dart';
import 'package:first_snow/test/ios_bluetooth.dart';

class TestPageScreen extends StatelessWidget {
  const TestPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          generateListTile(context, 'Background DB', () => TestDbList()),
          generateListTile(context, 'Bluetooth DB', () => BluetoothDbList()),
          generateListTile(context, 'Ios Bluetooth', () => IOSBlueTooth()),
          generateListTile(
              context, 'Android Native', () => TestAndroidNative()),
        ],
      ),
    );
  }
}

ListTile generateListTile(
    BuildContext context, String title, Widget Function() pageBuilder) {
  return ListTile(
    title: Text(title),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageBuilder()),
    ),
  );
}
