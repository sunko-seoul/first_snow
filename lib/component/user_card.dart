import 'package:first_snow/const/color.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:first_snow/provider/card_select_provider.dart';

class UserCard extends StatelessWidget {
  final int userId;

  UserCard({
    required this.userId,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return userCardFront(userId);
  }
}

class UserCardFlip extends StatefulWidget {
  final int userId;
  final int selectedIndex;
  final PageName pageName;
  final String denyStr;
  final String acceptStr;
  final Function(int) onTap;

  UserCardFlip({
    required this.userId,
    required this.selectedIndex,
    required this.pageName,
    required this.denyStr,
    required this.acceptStr,
    required this.onTap,
    Key? key,
  });

  @override
  State<UserCardFlip> createState() => _UserCardFlipState();
}

class _UserCardFlipState extends State<UserCardFlip> {
  bool _isBack = false;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    if (_angle != 0 && widget.selectedIndex != widget.userId)
      _angle = (_angle + pi) % (2 * pi);
    return GestureDetector(
      onTap: () => setState(() {
        if (widget.selectedIndex == -1) _angle = (_angle + pi) % (2 * pi);
        widget.onTap(widget.userId);
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
              child: _isBack
                  ? userCardBack(widget.userId, widget.pageName,
                      widget.acceptStr, widget.denyStr)
                  : userCardFront(widget.userId));
        },
      ),
    );
  }
}

Widget userCardFront(int userId) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      image: DecorationImage(
        image: AssetImage('asset/user/user_$userId.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget userCardBack(
    int userId, PageName pageName, String acceptStr, String denyStr) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(-2, 2),
        ),
      ],
    ),
    child: Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Consumer<UserListProvider>(
          builder: (context, userListProvider, child) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      userListProvider.deleteUser(userId, pageName);
                      Provider.of<CardSelectProvider>(context, listen: false)
                          .updateIndex(-1);
                    },
                    child: Container(
                      color: PRIMARY_COLOR_10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            denyStr,
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
                    onTap: () {
                      userListProvider.sendUser(userId, pageName);
                      Provider.of<CardSelectProvider>(context, listen: false)
                          .updateIndex(-1);
                    },
                    child: Container(
                      color: PRIMARY_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            acceptStr,
                            style: TextStyle(
                              color: WHITE_COLOR,
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
              ],
            );
          },
        ),
      ),
    ),
  );
}
