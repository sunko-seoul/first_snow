import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:first_snow/component/login_text_field.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/view/signup_view.dart';
import 'package:first_snow/view/password_reset_dialog.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 배치
                crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 최대한
                children: [
                  SizedBox(height: screenHeight * 0.15), // 상단 여백
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/img/logo.svg',
                      width: screenWidth * 0.5, // 로고 크기를 화면 너비에 맞춰 조정
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  LoginTextField(
                    onSaved: (String? value) => email = value!,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return '이메일을 입력해주세요';
                      }
                      RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!reg.hasMatch(value!)) {
                        return '이메일 형식이 아닙니다';
                      }
                      return null;
                    },
                    hintText: '이메일',
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  LoginTextField(
                    onSaved: (String? value) => password = value!,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return '비밀번호를 입력해주세요';
                      }
                      return null;
                    },
                    hintText: '비밀번호',
                    obscureText: true,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: PRIMARY_COLOR_80,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.011), // 버튼 높이 조정
                    ),
                    onPressed: onLoginPress,
                    child: Text(
                      '로그인',
                      style: TextStyle(fontSize: screenWidth * 0.038),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '계정이 없으신가요?',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUpView()),
                        ),
                        child: Text(
                          '가입하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Transform.translate(
                    offset: Offset(0, screenHeight * -0.03), // 화면 크기에 맞춰 위치 조정
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PasswordResetDialog();
                          },
                        );
                      },
                      child: Text(
                        '비밀번호를 잊으셨나요?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool saveAndValidateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void onLoginPress() async {
    final loginProvider = context.read<LoginProvider>();
    if (saveAndValidateForm()) {
      String text = await context.read<LoginProvider>().signIn(email, password);
      Navigator.of(context).pop();
      if (text != 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패하였습니다'),
            backgroundColor: Colors.grey,
          ),
        );
      }
    }
  }
}
