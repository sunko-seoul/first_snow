import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/view/connect_screen.dart';

class ConnectStream extends StatelessWidget {
  const ConnectStream({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> connectedListStream = FirebaseFirestore.instance
        .collection('userLists')
        .doc(Provider.of<LoginProvider>(context).user!.uid)
        .snapshots();

    return StreamBuilder(
        stream: connectedListStream,
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

          final Map<String, dynamic> data = snapshot.data!.data()! as Map<String, dynamic>;
          Set<String> connectedList = Set<String>.from(data['connectedList'] ?? []);
          return connectScreen(connectedList);
        },

    );
  }
}
