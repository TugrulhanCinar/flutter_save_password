import 'package:flutter_save_password/models/user_model.dart';
import 'auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> signInWithEmailandPassword(
      String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(user.user);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      var user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> createUserWithEmailandPassword(UserModel userModel) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: userModel.userEmail,
      password: userModel.userPassword,
    );
    return _userFromFirebase(result.user);
  }

  UserModel _userFromFirebase(User user) {
    if (user != null)
      return UserModel.fromFireBase(
        userCreateTime: user.metadata.creationTime,
        userEmail: user.email,
        userID: user.uid,
      );
    else
      return null;
  }
}
