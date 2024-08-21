import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class UuidProvider with ChangeNotifier {
  final CollectionReference _uuidCollection = FirebaseFirestore.instance.collection('uuids');

  void verifyUuidMatch(String uid) async {
    String? uuid = await getDeviceUUID();
    if (uuid == null) {
      print('Failed to get uuid');
      return;
    }
    try {
      QuerySnapshot querySnapshot = await _uuidCollection.where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        if (doc.id != uuid) {
          updateUuid(uid, uuid);
        }
      } else {
        print('No uuid found for uid: $uid');
        // 프로필 생성했을 때 uuid 코드가 없는 경우
        createUuidMapUid(uid, uuid);
      }
    } catch (e) {
      print('Failed to verify uuid match: $e');
    }
  }

  // 프로필 설정 페이지에서 사용함
  Future<void> createUuidMapUid(String uid, String uuid) async {
    try {
      // uuid(key) - uid(value)
      await _uuidCollection.doc(uuid).set({
        'uid': uid,
      });
    } catch (e) {
      print('Failed to create uuid $e');
    }
  }

  // 새로운 UUID 문서를 생성하고 uid 값을 넣어줌
  Future<void> updateUuid(String uid, String newUuid) async {
    try {
      QuerySnapshot querySnapshot = await _uuidCollection.where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        await _uuidCollection.doc(newUuid).set(data);
        deleteUuid(doc.id);
      } else {
        print('No uuid found for uid: $uid');
      }
    } catch (e) {
      print('Failed to update uuid: $e');
    }
  }

  Future<void> deleteUuid(String uuid) async {
    await _uuidCollection.doc(uuid).delete();
  }

  // Stream을 통해 변경생길 때 알림
  Future<Map<String, String>> getUuidMapStream() async {
    try {
      QuerySnapshot querySnapshot = await _uuidCollection.get();
      Map<String, String> uuidMap = {};

      for (DocumentSnapshot doc in querySnapshot.docs) {
        uuidMap[doc.id] = doc['uid'];
      }
      return uuidMap;
    } catch (e) {
      print('Failed to get document key: $e');
      return {};
    }
  }

  Future<String?> getDeviceUUID() async {
    try {
      if (Platform.isIOS) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        return '';
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to get Device UUID: $e');
      return null;
    }

  }
}