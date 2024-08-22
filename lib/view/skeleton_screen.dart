import 'package:flutter/material.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/component/main_bottom_nav_bar.dart';
import 'package:first_snow/component/main_app_bar.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MainAppBar(
        showBackButton: false,
        selectedIndex: 0,
      ),
      body: Container(),
      bottomNavigationBar: MainBottomNavBar(
        screenWidth: screenWidth,
        index: 0,
        onTap: (index) {},
      ),
    );
  }
}
