import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 배치
            crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 최대한
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/img/logo.svg',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 8.0),
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: PRIMARY_COLOR_80,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: onLoginPress,
                child: Text('로그인'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('계정이 없으신가요?'),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                        '가입하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Transform.translate(
                offset: Offset(0, -25),
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
                    ),
                  ),
                ),
              ),
            ],
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
    if (saveAndValidateForm()) {
      String text = await context.read<LoginProvider>().signIn(email, password);
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
