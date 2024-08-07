import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'setting_model.dart';
import 'dart:ui';

class SettingsViewModel extends ChangeNotifier {
  final Settings _settings = Settings();

  Settings get settings => _settings;

  void toggleNotifications() {
    _settings.notificationsEnabled = !_settings.notificationsEnabled;
    notifyListeners();
  }

  void showLogoutPopup(BuildContext context) {
    _showPopup(
      context,
      '정말 로그아웃하시겠습니까?',
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.blue[50]!),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.blue[300]),
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
            child: OutlinedButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.blue[50]!),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                side: WidgetStateProperty.all(
                  BorderSide(
                    width: 2,
                    color: Colors.blue[300]!,
                  ),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.blue[300]),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.blue[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteAccountPopup(BuildContext context) {
    _showPopup(
      context,
      '정말 회원탈퇴하시겠습니까?',
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.blue[50]!),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                side: WidgetStateProperty.all(
                  BorderSide(
                    width: 2,
                    color: Colors.blue[300]!,
                  ),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.blue[300]),
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
            child: FilledButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.red[400]!),
                backgroundColor: WidgetStateProperty.all(Colors.red[300]),
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
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showPopup(BuildContext context, String content, Widget actions) {
  showDialog(
    context: context,
    barrierColor: Colors.grey.withOpacity(0.5),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: [actions],
        ),
      );
    },
  );
}
