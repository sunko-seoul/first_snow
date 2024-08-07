import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'setting_view_model.dart';
import 'dart:math';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsViewModel = Provider.of<SettingsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(children: [
                  ClipOval(
                    child: Image.asset(
                      'asset/img/chuu.jpg',
                      width: 128,
                      height: 128,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400]!,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Container(
                          width: 32,
                          height: 32,
                          color: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(
                      '프로필 수정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.blue[100]),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SwitchListTile(
                  title: Text('푸시 알림', style: TextStyle(fontSize: 20)),
                  value: settingsViewModel.settings.notificationsEnabled,
                  activeColor: Colors.blue[100], // 색깔 추후 변경
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    settingsViewModel.toggleNotifications();
                  },
                ),
                Container(
                    height: 1.0,
                    width: 500.0,
                    color: Colors.grey[300]), //색깔 추후 변경
                listElement(
                  onTap: () {},
                  text: Text('약관 확인',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                  icon: Transform.rotate(
                    angle: 45 * pi / 180,
                    child: Icon(
                      Icons.link,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                  ),
                ),
                listElement(
                  onTap: () {
                    settingsViewModel.showLogoutPopup(context);
                  },
                  text: Text('로그아웃',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                ),
                listElement(
                  onTap: () {
                    settingsViewModel.showDeleteAccountPopup(context);
                  },
                  text: Text('회원 탈퇴',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class listElement extends StatelessWidget {
  final VoidCallback onTap;
  final Widget? icon;
  final Widget? text;

  listElement({required this.onTap, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: text,
                    ),
                  ),
                  icon != null ? icon! : Container(),
                ],
              ),
            ),
          ),
        ),
        Container(
            height: 1.0, width: 500.0, color: Colors.grey[300]), //색깔 추후 변경
      ],
    );
  }
}
