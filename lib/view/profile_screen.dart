import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_snow/component/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_snow/component/pop_up_message.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/user_report_pop_up.dart';
import 'dart:ui';

// TODO: firebase에서 유저 정보 가져오기
class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        showBackButton: true,
        selectedIndex: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return SizedBox.shrink();
          } else {
            final userData = snapshot.data!;
            print(userData);
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        userData['profileImagePath'],
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
                              '${userData['name']}, ${userData['age']}',
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
                            Clipboard.setData(ClipboardData(text: '${userData['instagramID']}'));
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
                              '${userData['instagramId']}',
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
            );
          }
        },
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
