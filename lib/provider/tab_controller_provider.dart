import 'package:flutter/material.dart';

class TabControllerProvider extends ChangeNotifier {
  late TabController _tabController;

  void init(TickerProvider vsync, int length) {
    _tabController = TabController(length: length, vsync: vsync);
  }

  TabController get tabController => _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
