import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_snow/provider/client_user_provider.dart';
import 'package:provider/provider.dart';

enum PageName {
  near,
  alarm,
  recv,
}

// 금일 22시 ~ 익일 22시까지 스친사람
class UserListProvider with ChangeNotifier {
  late String _uid;
  Set<String> _nearUser = {};
  Set<String> _alarmUser = {};
  Set<String> _connectedUser = {};

  Set<String> get nearUser => _nearUser;
  Set<String> get alarmUser => _alarmUser;
  Set<String> get connectedUser => _connectedUser;

  // home_screen 진입시, firebase에서 얻어옴
 set uid(String uid) => _uid = uid;

  Future<void> fetchNearUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      _nearUser = querySnapshot.docs.map((doc) => doc.id).toSet();
      print("nearUser: ${_nearUser.length}");
      _nearUser.remove(_uid);
      print("nearUser: ${_nearUser.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching near users: $e");
    }
  }

  void deleteUser(String userId, PageName page) async {
    if (page == PageName.near) {
      _nearUser.remove(userId);
    }
    else if (page == PageName.alarm) {
      _alarmUser.remove(userId);
    }
    else if (page == PageName.recv) { // 상대방이 보낸 첫눈을 지움
      try {
        // 1. 내 recvList에서 상대방의 uid를 삭제
        await FirebaseFirestore.instance.collection('userLists').doc(_uid).update({
          'receiveList': FieldValue.arrayRemove([userId]),
        });
      } catch (e) {
        print("Error deleting user: $e");
      }
    }
      notifyListeners();
  }

  void localDeleteUser(String userId, PageName page) {
    if (page == PageName.near) {
      _nearUser.remove(userId);
    }
    else if (page == PageName.alarm) { // 아직 고려 안해봤음
      _alarmUser.remove(userId);
    }
  }

  // void sendUser(String userId, PageName page) {
  //   if (page == PageName.recv) { // 매칭 성공
  //     // 1. 상대방의 sendList에서 내 uid를 삭제
  //     // 2. 내 recvList에서 상대방의 uid를 삭제
  //     // 3. 내 connectedList에 상대방의 uid를 추가
  //     // 4. 상대방의 connectedList에 내 uid를 추가
  //     _connectedUser.add(userId);
  //   }
  //   else {
  //     // 1. 내 sendList에 상대방의 uid를 추가
  //     // 2. 상대방의 receiveList에 내 uid를 추가
  //     _sendedUser.add(userId);
  //   }
  //   deleteUser(userId, page);
  // }

  Future<void> sendUser(String userId, PageName page) async {
    if (page == PageName.recv) { // 내가 받은 페이지에서 수락을 눌렀음
      try {
        // 1. 내 receiveList에서 상대방의 uid를 삭제
        // 2. 내 connectedList에 상대방의 uid를 추가
        await FirebaseFirestore.instance.collection('userLists').doc(_uid).update({
          'receiveList': FieldValue.arrayRemove([userId]),
          'connectedList': FieldValue.arrayUnion([userId]),
        });
        // 1. 상대방의 sendList에서 내 uid를 삭제
        // 2. 상대방의 connectedList에 내 uid를 추가
        await FirebaseFirestore.instance.collection('userLists').doc(userId).update({
          'sendList': FieldValue.arrayRemove([_uid]),
          'connectedList': FieldValue.arrayUnion([_uid]),
        });
      } catch (e) {
        print("Error sending user: $e");
      }
    } else if (page == PageName.near) {
      try {
        // 내 sendList에 상대방의 uid를 추가
        await FirebaseFirestore.instance.collection('userLists').doc(_uid).update({
          'sendList': FieldValue.arrayUnion([userId]),
        });
        // 상대방의 receiveList에 내 uid를 추가
        await FirebaseFirestore.instance.collection('userLists').doc(userId).update({
          'receiveList': FieldValue.arrayUnion([_uid]),
        });
      } catch (e) {
        print("Error sending user: $e");
      }
    }
    localDeleteUser(userId, page);
  }
}


































