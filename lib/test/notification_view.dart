import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:first_snow/provider/notification_provider.dart';
import 'package:first_snow/model/notification_payload_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationTestView extends StatelessWidget {
  const NotificationTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 120),
          ElevatedButton(
            onPressed: () {
              sleep(Duration(seconds: 5));
              NotificationProvider()
                  .showNotfication("첫눈소식이 도착했어요!", "누군가 당신을 좋아하고 있어요!", "");
            },
            child: Text('Trigger Receive 5s'),
          ),
          ElevatedButton(
            onPressed: () {
              sleep(Duration(seconds: 10));
              NotificationProvider()
                  .showNotfication("첫눈소식이 도착했어요!", "누군가 당신을 좋아하고 있어요!", "");
            },
            child: Text('Trigger Receive 10s'),
          ),
          ElevatedButton(
            onPressed: () {
              sleep(Duration(seconds: 5));
              NotificationProvider()
                  .showNotfication("첫눈소식이 도착했어요! ", "매칭되었습니다! 지금 확인해 보세요!", "");
            },
            child: Text('Trigger Send 5s'),
          ),
          ElevatedButton(
            onPressed: () {
              sleep(Duration(seconds: 10));
              NotificationProvider()
                  .showNotfication("첫눈소식이 도착했어요!", "매칭되었습니다! 지금 확인해 보세요!", "");
            },
            child: Text('Trigger Send 10s'),
          ),
        ],
      ),
    );
  }
}
