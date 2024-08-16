import 'package:first_snow/provider/card_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/provider/tab_controller_provider.dart';
import 'package:first_snow/stream/send_stream.dart';
import 'package:first_snow/stream/receive_stream.dart';

class SendReceiveScreen extends StatelessWidget {

  SendReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller:
                Provider.of<TabControllerProvider>(context).tabController,
            children: [
                SendStream(),
                ReceiveStream(),
            ],
          ),
        ),
      ],
    );
  }
}