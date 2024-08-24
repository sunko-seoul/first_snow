import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class User {
  final String sex;
  final String userId;

  User({required this.sex, required this.userId});

  factory User.fromUuid(String uuidOrigin) {
    String uuid = uuidOrigin.replaceAll("-", "");
    return User(
      sex: String.fromCharCode(int.parse(uuid.substring(6, 8), radix: 16)),
      userId: uuid.substring(16),
    );
  }

  String getUserInfo() {
    return 'Sex: $sex userId: $userId \n';
  }
}

class TestAndroidNative extends StatefulWidget {
  const TestAndroidNative({super.key});

  @override
  State<TestAndroidNative> createState() => _TestAndroidNativeState();
}

class _TestAndroidNativeState extends State<TestAndroidNative> {
  static const platform = MethodChannel('com.example.first_snow/android');
  String _result = 'None';
  @override
  Widget build(BuildContext context) {
    platform.invokeMethod('BTAdvertising');
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () async {
                try {
                  print('before result');
                  String jsonBTString = await platform.invokeMethod('BTScanning');
                  final List<dynamic> jsonList = jsonDecode(jsonBTString);
                  final List<User> userList = jsonList.map((uuid) => User.fromUuid(uuid)).toList();
                  final String result = userList.map((user) => user.getUserInfo()).toList().join('');
                  print('result: $result');
                  setState(() {
                    _result = result;
                  });
                } on PlatformException catch (e) {
                  print('Failed to invoke: ${e.message}.');
                }
              },
              child: Text('get BLE UUID')),
          Text(_result),
        ],
      ),
    );
  }
}
