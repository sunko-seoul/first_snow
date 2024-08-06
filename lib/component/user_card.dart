import 'package:first_snow/const/color.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserCard extends StatefulWidget {
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  UserCard({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    Key? key,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isBack = false;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    if (_angle != 0 && widget.selectedIndex != widget.index)
      _angle = (_angle + pi) % (2 * pi);
    return GestureDetector(
      onTap: () => setState(() {
        if (widget.selectedIndex == -1) _angle = (_angle + pi) % (2 * pi);
        widget.onTap(widget.index);
      }),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _angle),
        duration: Duration(milliseconds: 100),
        builder: (BuildContext con, double val, _) {
          _isBack = (val < (pi / 2)) ? false : true;
          return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: _isBack ? userCardBack() : userCardFront(widget.index));
        },
      ),
    );
  }
}

Widget userCardFront(int index) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      image: DecorationImage(
        image: AssetImage('asset/user/user_$index.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget userCardBack() {
  return Container(
    decoration: BoxDecoration(
      // border: Border.all(
      //   color: GREY_COLOR,
      //   width: 2.0,
      // ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(-8, 8),
        ),
      ],
    ),
    child: Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => print('deny'),
                child: Container(
                  color: PRIMARY_COLOR_10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '거절하기',
                        style: TextStyle(
                          color: GREY_COLOR_20,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => print('ok'),
                child: Container(
                  color: PRIMARY_COLOR,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '첫눈\n보내기',
                        style: TextStyle(
                          color: WHITE_COLOR,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
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
