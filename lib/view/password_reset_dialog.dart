import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetDialog extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  PasswordResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('비밀번호 재설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('비밀번호 재설정할 이메일을 입력해주세요.'),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: '이메일',
              labelText: '이메일',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            _sendPasswordResetEmail(_emailController.text, context);
          },
          child: const Text('확인'),
        ),
      ],
    );
  }

  Future<void> _sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호 재설정 이메일을 보냈습니다.')),
        );
      });
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: ${e.toString()}')),
        );
      });
    }
  }
}

