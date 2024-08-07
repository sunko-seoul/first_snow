import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/const/color.dart';
import 'package:first_snow/view/search_screen.dart';
import 'package:first_snow/test.dart';

class SendRecvScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: Provider.of<TestProvider>(context).tabController,
            children: [
              SearchScreen(),
              Center(child: Text('Page 2')),
            ],
          ),
        ),
      ],
    );
  }
}
