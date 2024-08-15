import 'package:flutter/material.dart';
import 'package:first_snow/const/color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:first_snow/component/login_text_field.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/view/signin_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String passwordConfirm = '';
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
                  if (value!.length < 8) {
                    return '비밀번호는 8자 이상이어야 합니다.';
                  }
                  RegExp reg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
                  if (!reg.hasMatch(value!)) {
                    return '영문자, 숫자, 특수문자를 각각 하나 이상 포함해야 합니다.';
                  }
                  return null;
                },
                hintText: '비밀번호',
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              LoginTextField(
                onSaved: (String? value) => passwordConfirm = value!,
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return '비밀번호를 입력해주세요';
                  }
                  if (passwordConfirm != password) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  if (value!.length < 8) {
                    return '비밀번호는 8자 이상이어야 합니다.';
                  }
                  RegExp reg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
                  if (!reg.hasMatch(value)) {
                    return '영문자, 숫자, 특수문자를 각각 하나 이상 포함해야 합니다.';
                  }
                  return null;
                },
                hintText: '비밀번호 확인',
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
                onPressed: onRegisterPress,
                child: Text('회원가입'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('이미 계정이 있으신가요?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignInView(),
                        ),
                      );
                    },
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
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
    );
  }

  bool saveAndValidateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }
  void onRegisterPress() async {
    if (saveAndValidateForm()) {
      String text = await context.read<LoginProvider>().signUp(email, password);
      if (text != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입에 실패했습니다.'),
            backgroundColor: Colors.grey,
          ),
        );
      }
    }
  }
}
