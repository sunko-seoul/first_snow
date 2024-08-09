import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.uid).update(user.toJson());
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
      print(e);
      return '';
    }
  }
}