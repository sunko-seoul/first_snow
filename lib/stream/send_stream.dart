import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_snow/provider/login_provider.dart';
import 'package:first_snow/view/send_screen.dart';

class SendStream extends StatelessWidget {
  const SendStream({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> sendListStream = FirebaseFirestore.instance
        .collection('userLists')
        .doc(Provider.of<LoginProvider>(context).user!.uid)
        .snapshots();

    return StreamBuilder(
      stream: sendListStream,
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
        Set<String> sendList = Set<String>.from(data['sendList'] ?? []);
        return sendScreen(sendList);
      },
    );
  }
}