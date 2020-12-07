import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'package:flutter_save_password/services/auth/auth_base.dart';
import 'package:flutter_save_password/services/auth/firebase_auth.dart';
import 'package:flutter_save_password/services/storage/firebase_db_services.dart';
import 'package:flutter_save_password/locator.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseAuthServices _firebaseAuthService = locator<FirebaseAuthServices>();
  AppMode appMode = AppMode.RELEASE;
  UserModel currentUser;

  @override
  Future<UserModel> getCurrentUser() async {
    print("getCurrentUser");
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      currentUser = await _firebaseAuthService.getCurrentUser();
      print(" getCurrentUser _firebaseAuthService.getCurrentUser() ");
      return _firebaseAuthService.getCurrentUser();
    }
  }

  @override
  Future<UserModel> signInWithEmailandPassword(
      String email, String password) async {
    // TODO: implement
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var userModel = await _firebaseAuthService.signInWithEmailandPassword(
          email, password);
      currentUser = userModel;
      return userModel;
    }
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return null;
    }
  }

  @override
  Future<UserModel> createUserWithEmailandPassword(
      String email, String password) {
    // TODO: implement createUserWithEmailandPassword
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return null;
    }
  }

  ///***********************

  Future<List<Folder>> fetchFolders() async {
    // TODO: implement fetchFolders
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var a = await _firestoreDBService.fetchFolders(currentUser.userID);
      return a;
    }
  }

  Future<bool> createFolder(Folder folder) async {
    // TODO: implement saveFolder
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.createFolder(folder, currentUser.userID);
    }
  }

  Future<bool> updateFolder(Folder folder, Folder newFolder) async{
    // TODO: implement updateFolder
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {

      return await _firestoreDBService.updateFolder(folder, newFolder,currentUser.userID);
    }
  }

  Future<bool> deleteFolder(Folder folder) async{
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.deleteFolder(folder, currentUser.userID);
    }
  }

  ///***********************

  Future<bool> updateAccount(Account account, Account newAccout) async {
    // TODO: implement updateAccount
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
       return await _firestoreDBService.updateAccount(account,newAccout,currentUser.userID);
    }
  }

  Future<bool> saveAccount(Account account) async {
    // TODO: implement saveAccount
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.saveAccount(account, currentUser.userID);
    }
  }

  Future<bool> deleteAccount(Account account) async {
    // TODO: implement deleteAccount
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.deleteAccount(
          account, currentUser.userID);
    }
  }
}
