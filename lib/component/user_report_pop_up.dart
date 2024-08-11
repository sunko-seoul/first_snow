import 'package:flutter/material.dart';
import 'package:first_snow/const/color.dart';
import 'custom_dropdown_button.dart';

class ReportPopUp extends StatelessWidget {
  const ReportPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('신고하기'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('신고사유를 선택하세요:'),
          CustomDropdownButton(reasonList: ['스팸', '부적절한 내용', '기타']),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(PRIMARY_COLOR_10),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  foregroundColor: WidgetStateProperty.all(PRIMARY_COLOR_80),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('취소'),
              ),
            ),
            SizedBox(width: 36),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.red[100]!),
                  foregroundColor: WidgetStateProperty.all(Colors.red[500]),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
