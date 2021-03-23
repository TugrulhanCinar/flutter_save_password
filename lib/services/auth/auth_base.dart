import 'package:flutter_save_password/models/user_model.dart';

abstract class AuthBase {
  Future<UserModel?> getCurrentUser();
  Future<bool?> signOut();
  Future<UserModel?> signInWithEmailandPassword(String email, String sifre);
  Future<UserModel?> createUserWithEmailandPassword(UserModel userModel);
 // Future<User> createUserWithEmailandPassword(String email, String sifre);
}