import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();

  Userr? _userFromFirebaseUser(User? user) {
    return user != null ? Userr(uid: user.uid) : null;
  }

  Stream<Userr?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      await _db.registerUser(user!.uid, name, email);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
