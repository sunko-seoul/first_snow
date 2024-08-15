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
import 'package:first_snow/provider/client_user_provider.dart';
import 'package:first_snow/const/color.dart';


class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});
  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool _isButtonDisabled = true;
  final ScrollController _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _instagramIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // TextEdit 초기화
    final clientInfoProvider = Provider.of<ClientUserProvider>(context, listen: false);
    _nameController.text = clientInfoProvider.name;
    _ageController.text = clientInfoProvider.age.toString();
    _instagramIdController.text = clientInfoProvider.instagramId;

    _nameController.addListener(_checkButtonDisabled);
    _ageController.addListener(_checkButtonDisabled);
    _instagramIdController.addListener(_checkButtonDisabled);

    final profileProvider = Provider.of<ProfileOvalImageProvider>(context, listen: false);
    profileProvider.addListener(_checkButtonDisabled);
  }
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _instagramIdController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final profileProvider = Provider.of<ProfileOvalImageProvider>(context, listen: false);
    final clientInfoProvider = Provider.of<ClientUserProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String uid  = Provider.of<LoginProvider>(context, listen: false).user!.uid;

    try {
      if (profileProvider.imageFile != null) {
        File imageFile = profileProvider.imageFile!;
        final profileImagePath = await userProvider.updateImage(imageFile, uid);
        final user = UserModel(
          uid: uid,
          name: _nameController.text,
          age: int.parse(_ageController.text),
          instagramId: _instagramIdController.text,
          profileImagePath: profileImagePath,
          createdAt: DateTime.now(),
        );
        await userProvider.updateUser(user);
        clientInfoProvider.updateClientInfo(
          uid: uid,
          name: _nameController.text,
          age: int.parse(_ageController.text),
          instagramId: _instagramIdController.text,
          profileImage: Image.file(imageFile),
        );
      } else {
        final user = UserModel(
          uid: uid,
          name: _nameController.text,
          age: int.parse(_ageController.text),
          instagramId: _instagramIdController.text,
          createdAt: DateTime.now(),
        );
        await userProvider.updateUser(user);
        clientInfoProvider.updateClientInfo(
          uid: uid,
          name: _nameController.text,
          age: int.parse(_ageController.text),
          instagramId: _instagramIdController.text,
          profileImage: clientInfoProvider.profileImage,
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    }
  }

  void _checkButtonDisabled() {
    if (!mounted) return;
    final clientInfoProvider = Provider.of<ClientUserProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileOvalImageProvider>(context, listen: false);
    print('name: ${_nameController.text}, age: ${_ageController.text}, instagramId: ${_instagramIdController.text}, imageFile: ${profileProvider.imageFile}');
    if (_nameController.text == clientInfoProvider.name &&
        _ageController.text == clientInfoProvider.age.toString() &&
        _instagramIdController.text == clientInfoProvider.instagramId &&
        profileProvider.imageFile == null) {
      setState(() {
        _isButtonDisabled = true;
      });
    }
    else {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientInfoProvider = Provider.of<ClientUserProvider>(context);
    final profileProvider = Provider.of<ProfileOvalImageProvider>(context, listen: false);

    return Scaffold(
      appBar: MainAppBar(
        showBackButton: true,
        selectedIndex: Provider.of<CardSelectProvider>(context).selectedIndex,
        onBackButtonPressed: () => profileProvider.imageFile = null,
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
              const SizedBox(height: 32),
              ElevatedButton(
                  onPressed: (_isButtonDisabled)
                      ? null : () {
                        _saveProfile();
                        if (mounted) {
                          profileProvider.imageFile = null;
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                          '저장하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
    super.key,
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
