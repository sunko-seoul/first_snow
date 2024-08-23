import 'package:flutter/material.dart';

import 'package:first_snow/test/test_db_list.dart';
import 'package:first_snow/test/bluetooth_db_list.dart';
import 'package:first_snow/test/ios_bluetooth.dart';

class TestPageScreen extends StatelessWidget {
  const TestPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Background DB'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestDbList()),
            ),
          ),
          ListTile(
            title: Text('Bluetooth DB'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BluetoothDbList()),
            ),
          ),
          ListTile(
            title: Text('Ios Bluetooth'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IOSBlueTooth()),
            ),
          ),
        ],
      ),
    );
  }
}
