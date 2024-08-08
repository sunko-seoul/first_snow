import 'package:flutter/material.dart';

class TabControllerProvider with ChangeNotifier {
  late TabController _tabController;

  TabControllerProvider(TickerProvider vsync) {
    _tabController = TabController(length: 2, vsync: vsync);
  }

  TabController get tabController => _tabController;

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
