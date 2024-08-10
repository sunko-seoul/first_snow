import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'login_provider.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toJson());
  }

  // TODO: 변경 안되는 값만 수정하도록 바꿔야 함
  Future<void> updateUser(UserModel user) async {
    DocumentSnapshot? doc = await _usersCollection.doc(user.uid).get();
    Map<String, dynamic> userJson = user.toJson();
    if (doc.exists) {
      UserModel oldUser = UserModel.fromJson(
          doc.data() as Map<String, dynamic>);
      if (oldUser.name == user.name) {
        userJson.remove('name');
      }
      if (oldUser.age == user.age) {
        userJson.remove('age');
      }
      if (oldUser.instagramId == user.instagramId) {
        userJson.remove('instagramId');
      }
    }
    userJson.removeWhere((key, value) => value == null);
    await _usersCollection.doc(user.uid).update(userJson);
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = _storage.ref();
      // 파일 업로드 경로 설정
      final imagesRef = storageRef.child('images/${DateTime.now().toIso8601String()}_${image.uri.pathSegments.last}');
      final uploadTask = imagesRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    catch (e) {
      return '';
    }
  }

  // TODO: json에 접근해서 수정해야 함
  Future<String> updateImage(File image) async {
    DocumentSnapshot userDoc = await _fireStore.collection('users').doc('uid').get();
    String? oldImageUrl = userDoc['profileImagePath'];

    if (oldImageUrl != null) {
      try {
        await _storage.refFromURL(oldImageUrl).delete();
      } catch (e) {
        print("Failed to delete old profile image: $e");
        return '';
      }
    }
    return await uploadImage(image);
  }

}


