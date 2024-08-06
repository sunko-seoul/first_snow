import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int _selectedIndex = 0;

  // getter of _selectedIndex
  int get selectedIndex => _selectedIndex;

  // update Function of _selectedIndex
  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
