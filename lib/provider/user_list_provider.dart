import 'package:flutter/material.dart';

enum PageName {
  near,
  alarm,
  recv,
}

class UserListProvider with ChangeNotifier {
  Set<int> _nearUser = {1, 2, 3, 4, 5};
  Set<int> _alarmUser = {1, 2, 3, 4, 5};
  Set<int> _sendedUser = {};
  Set<int> _recvedUser = {1, 2, 3, 4, 5};
  Set<int> _connectedUser = {};

  Set<int> get nearUser => _nearUser;
  Set<int> get alarmUser => _alarmUser;
  Set<int> get sendedUser => _sendedUser;
  Set<int> get recvedUser => _recvedUser;
  Set<int> get connectedUser => _connectedUser;

  void deleteUser(int userId, PageName page) {
    if (page == PageName.near)
      _nearUser.remove(userId);
    else if (page == PageName.alarm)
      _alarmUser.remove(userId);
    else if (page == PageName.recv) _recvedUser.remove(userId);
    notifyListeners();
  }

  void sendUser(int userId, PageName page) {
    if (page == PageName.recv)
      _connectedUser.add(userId);
    else
      _sendedUser.add(userId);
    print(_recvedUser);
    deleteUser(userId, page);
  }
}
