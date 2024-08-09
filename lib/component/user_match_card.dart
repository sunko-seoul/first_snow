import 'package:first_snow/const/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserMatchCard extends StatelessWidget {
  final int userId;

  UserMatchCard({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WHITE_COLOR,
        borderRadius: BorderRadius.circular(10.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.4),
        //     spreadRadius: 1,
        //     blurRadius: 5,
        //     offset: Offset(-4, 4),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/user/user_$userId.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('name, 26',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 16.0),
                Text('눌러서 프로필 상세보기'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
