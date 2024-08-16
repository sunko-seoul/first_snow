import 'package:first_snow/component/user_report_pop_up.dart';
import 'package:first_snow/const/color.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:first_snow/provider/user_list_provider.dart';
import 'package:first_snow/provider/card_select_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserCard extends StatelessWidget {
  final String userId;

  UserCard({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  UserCardFront(userId: userId);
  }
}

class UserCardFlip extends StatefulWidget {
  final String userId;
  final String selectedIndex;
  final PageName pageName;
  final String denyStr;
  final String acceptStr;
  final Function(String) onTap;

  UserCardFlip({
    required this.userId,
    required this.selectedIndex,
    required this.pageName,
    required this.denyStr,
    required this.acceptStr,
    required this.onTap,
    super.key,
  });

  @override
  State<UserCardFlip> createState() => _UserCardFlipState();
}

class _UserCardFlipState extends State<UserCardFlip> {
  bool _isBack = false;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    if (_angle != 0 && widget.selectedIndex != widget.userId) {
      _angle = (_angle + pi) % (2 * pi);
    }
    return GestureDetector(
      onTap: () => setState(() {
        if (widget.selectedIndex == "-1") {
          _angle = (_angle + pi) % (2 * pi);
        }
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
                  : UserCardFront(userId: widget.userId));
        },
      ),
    );
  }
}

class UserCardFront extends StatefulWidget {
  final String userId;

  const UserCardFront({
    super.key,
    required this.userId,
  });

  @override
  State<UserCardFront> createState() => _UserCardFrontState();
}

class _UserCardFrontState extends State<UserCardFront> {
  late Future<String?> _imageUrlFuture;

  // TODO: _getImagePath를 build 안에 future로 넣어보기? 또는 didUpdate에서?
  @override
  void initState() {
    super.initState();
    _imageUrlFuture = _getImagePath(widget.userId);
  }

  Future<String?> _getImagePath(String userId) async {
    final userListProvider = Provider.of<UserListProvider>(context, listen: false);
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc['profileImagePath'];
    } catch (e) {
      print("Error fetching image URL: $e");
      userListProvider.deleteUser(userId, PageName.near);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return SizedBox.shrink();
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: Offset(0, 0), // 그림자의 위치 조정
                        ),
                      ],
                    ),
                    child: PopupMenuButton<int>(
                      icon: Icon(Icons.more_vert, color: GREY_COLOR_10),
                      onSelected: (int result) {
                        print('result: $result');
                        if (result == 1) {
                          showDialog(
                              context: context,
                              barrierColor: Colors.grey.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: ReportPopUp(),
                                );
                              });
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        const PopupMenuItem(value: 1, child: Text('신고하기')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

Widget userCardBack(
    String userId, PageName pageName, String acceptStr, String denyStr) {
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
                          .updateIndex("-1");
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
                          .updateIndex("-1");
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
