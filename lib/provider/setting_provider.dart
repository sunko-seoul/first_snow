import 'package:flutter/material.dart';
import 'package:first_snow/const/color.dart';
import 'dart:ui';
import 'package:first_snow/component/pop_up_message.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:provider/provider.dart';

class SettingProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void showLogoutPopup(BuildContext context) {
    PopUpMessage(
      context,
      '정말 로그아웃하시겠습니까?',
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
              child: Text(
                '취소',
              ),
            ),
          ),
          SizedBox(width: 36),
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
                Provider.of<LoginProvider>(context, listen: false).signOut();
                Navigator.pop(context);
              },
              child: Text(
                '로그아웃',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteAccountPopup(BuildContext context) {
    PopUpMessage(
      context,
      '정말 회원탈퇴하시겠습니까?',
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
                '탈퇴하기',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
