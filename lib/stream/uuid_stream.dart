import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/provider/uuid_provider.dart';

class UuidStream extends StatelessWidget {
  const UuidStream({super.key});

  Stream<Map<String, String>> getUuidMapStream() {
    return FirebaseFirestore.instance.collection('uuids').snapshots().map((querySnapshot) {
      Map<String, String> uuidMap = {};
      for (var doc in querySnapshot.docs) {
        uuidMap[doc.id] = doc['uid'];
      }
      return uuidMap;
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
        stream: getUuidMapStream(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data');
          }
          // TODO: UUID 리스트에서 사용자 근처에 존재하는 uid 찾아서 프로필 전달.
          return Provider<Map<String, String>>.value(
            value: snapshot.data!,
            child: Container(),
          );
        }
    );
  }
}
