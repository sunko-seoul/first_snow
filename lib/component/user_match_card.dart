import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_snow/const/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:first_snow/view/profile_screen.dart';

class UserMatchCard extends StatefulWidget {
  final String userId;

  UserMatchCard({
    super.key,
    required this.userId,
  });

  @override
  State<UserMatchCard> createState() => _UserMatchCardState();
}

class _UserMatchCardState extends State<UserMatchCard> {
  late Future<DocumentSnapshot?> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = _getUserInfo(widget.userId);
  }

  Future<DocumentSnapshot?> _getUserInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc;
    } catch (e) {
      print("Error fetching user data $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot?>(
      future: _userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return SizedBox.shrink();
        } else {
          final userDoc = snapshot.data!;
          String name = userDoc['name'] ?? 'Unkown';
          int age = userDoc['age'] ?? 'N/A';
          String profileImagePath = userDoc['profileImagePath'];
          return GestureDetector(
            onTap: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: widget.userId),
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                color: WHITE_COLOR,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(profileImagePath),
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
                        Text('$name, $age',
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
            ),
          );
        }
      }
    );
  }
}
