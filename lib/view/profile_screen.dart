import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_snow/component/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_snow/component/pop_up_message.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/user_report_pop_up.dart';
import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  final int userId;
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        showBackButton: true,
        selectedIndex: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'asset/user/user_${userId}.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '김여자, 20',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierColor: Colors.grey.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: ReportPopUp(),
                                );
                              });
                        },
                        child: Icon(Icons.priority_high,
                            color: Colors.red, size: 32),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: '_yeojakim'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('클립보드에 복사되었습니다!')),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Text(
                        '_yeojakim',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ShowReportPopUp(BuildContext context) {
  PopUpMessage(
    context,
    '이 회원을 신고 하시겠습니까?',
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(PRIMARY_COLOR_10),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              foregroundColor: WidgetStateProperty.all(PRIMARY_COLOR_80),
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소'),
          ),
        ),
        SizedBox(width: 36),
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.red[100]!),
              foregroundColor: WidgetStateProperty.all(Colors.red[500]),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '신고하기',
            ),
          ),
        ),
      ],
    ),
  );
}
