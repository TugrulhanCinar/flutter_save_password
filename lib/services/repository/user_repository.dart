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
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      currentUser = await _firebaseAuthService.getCurrentUser();
      if(currentUser != null){
        var userData = await _firestoreDBService.readUserData(currentUser.userID);
        currentUser.userName = userData.userName;
      }
      return currentUser;
    }
  }

  @override
  Future<UserModel> signInWithEmailandPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var userModel = await _firebaseAuthService.signInWithEmailandPassword(email, password);
      var userData = await _firestoreDBService.readUserData(userModel.userID);
      userModel.userName = userData.userName;
      currentUser = userModel;
      return userModel;
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var result = await _firebaseAuthService.signOut();
      currentUser = null;
      return result;
    }
  }

  @override
  Future<UserModel> createUserWithEmailandPassword(UserModel userModel) async{
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
       var newUser = await _firebaseAuthService.createUserWithEmailandPassword(userModel);
       userModel.userID = newUser.userID;
       userModel.userCreateTime = newUser.userCreateTime;
      _firestoreDBService.writeUserData(userModel);
      currentUser = userModel;
      return currentUser;
    }
  }

  ///***********************

  Future<List<Folder>> fetchFolders() async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var a = await _firestoreDBService.fetchFolders(currentUser.userID);
      return a;
    }
  }

  Future<bool> createFolder(Folder folder) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.createFolder(folder, currentUser.userID);
    }
  }

  Future<bool> updateFolder(Folder folder, Folder newFolder) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.updateFolder(
          folder, newFolder, currentUser.userID);
    }
  }

  Future<bool> deleteFolder(Folder folder) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.deleteFolder(folder, currentUser.userID);
    }
  }

  ///***********************

  Future<bool> updateAccount(Account account, Account newAccout) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.updateAccount(
          account, newAccout, currentUser.userID);
    }
  }

  Future<bool> saveAccount(Account account) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.saveAccount(account, currentUser.userID);
    }
  }

  Future<bool> deleteAccount(Account account) async {

    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firestoreDBService.deleteAccount(
          account, currentUser.userID);
    }
  }
}
