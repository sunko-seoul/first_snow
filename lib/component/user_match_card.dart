import 'package:flutter/material.dart';

class UserMatchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/user/user_1.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Text('data'),
              Text(''),
            ],
          ),
        ],
      ),
    );
  }
}
