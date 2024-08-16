import 'dart:ui';

import 'package:flutter/material.dart';

class ClientUserProvider with ChangeNotifier {
  late String _uid;
  late String _name;
  late int _age;
  late String _instagramId;
  late Image _profileImage;

  String get uid => _uid;
  String get name => _name;
  int get age => _age;
  String get instagramId => _instagramId;
  Image get profileImage => _profileImage;

  void setClientInfo({
    required String uid,
    required String name,
    required int age,
    required String instagramId,
    required Image profileImage,
  }) {
    _uid = uid;
    _name = name;
    _age = age;
    _instagramId = instagramId;
    _profileImage = profileImage;
  }

  void updateClientInfo({
    required String uid,
    required String name,
    required int age,
    required String instagramId,
    required Image profileImage,
  }) {
    _uid = uid;
    _name = name;
    _age = age;
    _instagramId = instagramId;
    _profileImage = profileImage;
    notifyListeners();
  }

}