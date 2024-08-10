import 'package:first_snow/provider/card_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/component/main_app_bar.dart';
import 'package:first_snow/component/profile_oval_image.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
              ProfileEditItem(label: "이름", value: "김여자"),
              ProfileEditItem(label: "나이", value: "20"),
              ProfileEditItem(label: "인스타 아이디", value: "_yeojakim"),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileEditItem extends StatelessWidget {
  final String label;
  final String value;

  ProfileEditItem({
    required this.label,
    required this.value,
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
            controller: TextEditingController(text: value),
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
