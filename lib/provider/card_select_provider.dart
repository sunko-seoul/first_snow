import 'package:flutter/material.dart';

class CardSelectProvider with ChangeNotifier {
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = _selectedIndex == -1 ? index : -1;
    print('selInd: $_selectedIndex');
    notifyListeners();
  }
}
