import 'package:first_snow/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// TODO: 이름, 나이, 인스타 아이디, 프로필 사진 공백시 넘어가지 않도록 해야 함
class UserProfileSetUpView extends StatefulWidget {
  const UserProfileSetUpView({super.key});

  @override
  State<UserProfileSetUpView> createState() => _UserProfileSetUpViewState();
}

class _UserProfileSetUpViewState extends State<UserProfileSetUpView> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _instagramId = TextEditingController();
  XFile? profileImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _instagramId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = loginProvider.user;

    return Scaffold(
        appBar: AppBar(
          title: const Text('첫눈'),
          backgroundColor: PRIMARY_COLOR,
        ),
        backgroundColor: PRIMARY_COLOR,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 71.0),
                Text(
                    '기본정보를 입력해주세요!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                ),
                const SizedBox(height: 100.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 67.0, right: 80.0),
                            child: Text(
                                '이름',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 33.0),
                              child: SizedBox(
                                width: 167.0,
                                height: 40.0,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '이름을 입력해주세요';
                                    }
                                    return null;
                                  },
                                  textAlignVertical: TextAlignVertical.top,
                                  textAlign: TextAlign.center,
                                  controller: _name,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 11.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 67.0, right: 80.0),
                            child: Text(
                              '나이',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 33.0),
                              child: SizedBox(
                                width: 167.0,
                                height: 40.0,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '나이를 입력해주세요';
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  controller: _age,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 11.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 67.0, right: 23.0),
                            child: Text(
                              '인스타 아이디',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 33.0),
                              child: SizedBox(
                                width: 167.0,
                                height: 40.0,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '인스타 아이디를 입력해주세요';
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  controller: _instagramId,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 11.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          minimumSize: Size(118.0, 56.0),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate() || profileImage == null) {
                            if (profileImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('프로필 사진을 선택해주세요'),
                                ),
                              );
                            }
                            return;
                          }
                          final userInstance = UserModel(
                            name: _name.text,
                            age: int.tryParse(_age.text),
                            instagramId: _instagramId.text,
                          );
                          userProvider.updateUser(userInstance);
                        },
                        child: Text(
                          '다음으로',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
  }
}
