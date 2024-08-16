import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/setting_provider.dart';
import 'package:first_snow/view/profile_edit_screen.dart';
import 'dart:math';
import 'package:first_snow/provider/client_user_provider.dart';
import 'package:first_snow/const/color.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final clientUserProvider = Provider.of<ClientUserProvider>(context);
    return Padding(
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
              Padding(padding: EdgeInsets.only(top: 16)),
              Consumer<ClientUserProvider>(// update
                  builder: (context, clientUserProvider, child) {
                return ClipOval(
                  child: SizedBox(
                    width: 128.0,
                    height: 128.0,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: clientUserProvider.profileImage),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileEditScreen()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(PRIMARY_COLOR),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text(
                    '프로필 수정',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SwitchListTile(
                title: Text('푸시 알림', style: TextStyle(fontSize: 20)),
                value: settingProvider.notificationsEnabled,
                activeColor: PRIMARY_COLOR, // 색깔 추후 변경
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  settingProvider.toggleNotifications();
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
                  settingProvider.showLogoutPopup(context);
                },
                text: Text('로그아웃',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
              ),
              listElement(
                onTap: () {
                  settingProvider.showDeleteAccountPopup(context);
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
    );
  }
}

class listElement extends StatelessWidget {
  final VoidCallback onTap;
  final Widget? icon;
  final Widget? text;

  listElement({required this.onTap, this.icon, this.text, super.key});

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
