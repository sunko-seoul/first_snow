import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_snow/provider/card_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/view/receive_screen.dart';

class ReceiveStream extends StatelessWidget {

  const ReceiveStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final Stream<DocumentSnapshot> receiveStream = FirebaseFirestore.instance
        .collection('userLists')
        .doc(Provider.of<LoginProvider>(context).user!.uid)
        .snapshots();

    return StreamBuilder(
      stream: receiveStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
          return Text('No data');
        }
        Map<String, dynamic> data = snapshot.data!.data()! as Map<String, dynamic>;
        Set<String> receiveList = Set<String>.from(data['receiveList'] ?? []);
        return Consumer<CardSelectProvider>(
         builder: (context, cardSelectProvider, child) {
           void onTab(String index) {
             cardSelectProvider.updateIndex(index);
           }
           return receiveScreen(
               receiveList,
               cardSelectProvider.selectedIndex,
               onTab,
            );
          },
        );
      },
    );
  }
}
