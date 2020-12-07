import 'package:flutter_save_password/models/user_model.dart';

import 'auth_base.dart';

enum AppMode { DEBUG, RELEASE }

class FakeAuthenticationService implements AuthBase {
  AppMode appMode = AppMode.RELEASE;


  @override
  Future<UserModel> getCurrentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithEmailandPassword(String email, String sifre) {
    // TODO: implement signInWithEmailandPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<UserModel> createUserWithEmailandPassword(String email, String sifre) {
    // TODO: implement createUserWithEmailandPassword
    throw UnimplementedError();
  }

}