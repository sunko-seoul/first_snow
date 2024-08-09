import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  Status _status = Status.uninitialized;
  User? _user;

  Status get status => _status;
  User? get user => _user;

  LoginProvider()
   : _auth = FirebaseAuth.instance
   , _user = FirebaseAuth.instance.currentUser
   , _status = FirebaseAuth.instance.currentUser != null
      ? Status.authenticated : Status.unauthenticated {
    _auth.authStateChanges().listen(_onAuthStateChanged); // 스트림을 반환
  }

  // 인증 상태가 변할때마다 호출되는 함수
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.authenticated;
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
















