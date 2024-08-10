import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  profileCompleted,
}

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Status _status = Status.uninitialized;
  User? _user;

  Status get status => _status;
  User? get user => _user;

  LoginProvider()
   : _auth = FirebaseAuth.instance
   , _user = FirebaseAuth.instance.currentUser {
    if (_user == null) {
      _status = Status.unauthenticated;
    } else {
      setUserState();
    }
    _auth.authStateChanges().listen(_onAuthStateChanged); // 스트림을 반환
  }

  Future<void> setUserState() async {
    final userDoc = await _fireStore.collection('users').doc(_user!.uid).get();
    if (!userDoc.exists) {
      _status = Status.authenticated;
    } else {
      _status = Status.profileCompleted;
    }
  }

  // 인증 상태가 변할때마다 호출되는 함수
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      final userDoc = await _fireStore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) {
        _status = Status.authenticated;
      } else {
        _status = Status.profileCompleted;
      }
      _user = firebaseUser;
    }
    notifyListeners();
  }

  Future<String> signUp(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      if (e.message!.contains("weak-password")) {
        return 'The password provided is too weak.';
      } else if (e.message!.contains("email-already-in-use")) {
        return 'The account already exists for that email.';
      } else {
        return e.message!;
      }
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      if (e.message!.contains("user-not-found")) {
        return 'No user found for that email.';
      } else if (e.message!.contains("wrong-password")) {
        return 'Wrong password provided for that user.';
      } else {
        return e.message!;
      }
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _status = Status.unauthenticated;
    notifyListeners();
  }
}
















