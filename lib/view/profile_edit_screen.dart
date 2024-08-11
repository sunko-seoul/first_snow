import 'package:first_snow/provider/card_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/component/main_app_bar.dart';
import 'package:first_snow/component/profile_oval_image.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/provider/profile_oval_image_provider.dart';
import 'dart:io';



class ProfileEditScreen extends StatefulWidget {
  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final FocusNode _focusNode = FocusNode();
  bool _isButtonDisabled = false;
  final ScrollController _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _instagramIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<UserModel?> currentUser = Provider.of<UserProvider>(context).getUser(Provider.of<LoginProvider>(context).user!.uid);
    currentUser.then((value) {
      _nameController.text = value!.name!;
      _ageController.text = value.age.toString();
      _instagramIdController.text = value.instagramId!;
    });

    return Scaffold(
      appBar: MainAppBar(
        showBackButton: true,
        selectedIndex: Provider.of<CardSelectProvider>(context).selectedIndex,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 16),
              ProfileOvalImage(size: 200),
              SizedBox(height: 32),
              ProfileEditItem(label: "이름", controller: _nameController),
              ProfileEditItem(label: "나이", controller: _ageController), // TODO: 나이 숫자로 받아야 함
              ProfileEditItem(label: "인스타 아이디", controller: _instagramIdController),
              ElevatedButton(
                  // TODO: 버튼 업로드
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                          File? imageFile = Provider.of<ProfileOvalImageProvider>(context, listen: false).image;
                          String? uid = Provider.of<LoginProvider>(context, listen: false).user!.uid;
                          Future<String?> profileImagePath = Provider.of<UserProvider>(context, listen: false).updateImage(imageFile!, uid);
                          profileImagePath.then((value) {;
                            UserModel user = UserModel(
                              uid: uid,
                              name: _nameController.text,
                              age: int.parse(_ageController.text),
                              instagramId: _instagramIdController.text,
                              profileImagePath: value,
                              createdAt: DateTime.now(),
                            );
                            Provider.of<UserProvider>(context, listen: false).updateUser(user);
                          });
                       },
                      child: Text('저장하기')
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileEditItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  ProfileEditItem({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 0),
            ),
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }
}
