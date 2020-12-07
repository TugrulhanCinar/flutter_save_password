import 'package:flutter_save_password/models/user_model.dart';
import 'auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> signInWithEmailandPassword(String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return  _userFromFirebase(user.user);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    print("Çalıştı firebase auth get current User");
    try {
      var user =  _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<UserModel> createUserWithEmailandPassword(String email, String sifre) {
    // TODO: implement createUserWithEmailandPassword
    //_firebaseAuth.createUserWithEmailAndPassword(email: null, password: null);

    throw UnimplementedError();
  }

  UserModel _userFromFirebase(User user) {

    if (user != null)
      return UserModel(user.email, user.uid, user.metadata.creationTime);
    else return null;
  }
}
