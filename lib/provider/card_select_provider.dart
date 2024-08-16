import 'package:flutter/material.dart';

class CardSelectProvider with ChangeNotifier {
  String _selectedIndex = "-1";

  String get selectedIndex => _selectedIndex;

  void updateIndex(String index) {
    _selectedIndex = _selectedIndex == "-1" ? index : "-1";
    print('selectedIndex: $_selectedIndex');
    notifyListeners();
  }
}
