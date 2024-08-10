import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

void PopUpMessage(BuildContext context, String content, Widget actions) {
  showDialog(
    context: context,
    barrierColor: Colors.grey.withOpacity(0.5),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: [actions],
        ),
      );
    },
  );
}
