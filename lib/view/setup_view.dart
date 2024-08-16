import 'package:flutter/material.dart';
import 'package:first_snow/const/color.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:first_snow/view/home_screen.dart';

// TODO: 성별
class SetupView extends StatefulWidget {
  const SetupView({super.key});

  @override
  State<SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _instagramId = TextEditingController();
  XFile? profileImage;
  bool isProfileImageSetUp = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_validateFields);
    _age.addListener(_validateFields);
    _instagramId.addListener(_validateFields);
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _instagramId.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _name.text.isNotEmpty &&
          _age.text.isNotEmpty &&
          _instagramId.text.isNotEmpty;
    });
  }

  void onPickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        profileImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = loginProvider.user;

    return Scaffold(
      appBar: AppBar(
        // TODO: mainAppBar로 변경
        title: const Text('Image Setup'),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: isProfileImageSetUp
          ? SingleChildScrollView(
              child: Container(
                color: PRIMARY_COLOR,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 35.0),
                        Text(
                          '기본정보를 입력해주세요!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        CircleAvatar(
                          radius: 120.0,
                          backgroundImage: FileImage(File(profileImage!.path)),
                        ),
                        const SizedBox(height: 40.0),
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 67.0, right: 80.0),
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
                                      child: TextField(
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        textAlign: TextAlign.center,
                                        controller: _name,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 11.0),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 67.0, right: 80.0),
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
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        textAlign: TextAlign.center,
                                        controller: _age,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 11.0),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 67.0, right: 23.0),
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
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: _instagramId,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 11.0),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 37.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                minimumSize: Size(118.0, 56.0),
                              ),
                              onPressed: _isButtonEnabled
                                  ? () async {
                                      String? imagePath =
                                          await userProvider.uploadImage(
                                              File(profileImage!.path));
                                      final userInstance = UserModel(
                                        uid: loginProvider.user!.uid,
                                        email: user!.email,
                                        name: _name.text,
                                        age: int.tryParse(_age.text),
                                        instagramId: _instagramId.text,
                                        profileImagePath: imagePath,
                                        createdAt: DateTime.now(),
                                      );
                                      userProvider.createUser(userInstance);
                                      if (!mounted) return;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text(
                                '다음으로',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              color: PRIMARY_COLOR,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      '사진을 등록해주세요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '얼굴이 명확하게 보이는 사진을 등록해주세요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 130.0,
                          backgroundImage: profileImage != null
                              ? FileImage(File(profileImage!.path))
                              : AssetImage(
                                  'assets/img/minji.jpg',
                                ),
                        ),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                onPickImage();
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: PRIMARY_COLOR,
                                ),
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: profileImage != null
                          ? () {
                              setState(() {
                                isProfileImageSetUp = true;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        minimumSize: Size(118.0, 56.0),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(
                          fontSize: 20,
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
