import 'dart:io';
import 'package:flutter_save_password/enums/locale/app_cons.dart';
import 'package:flutter_save_password/enums/locale/preferences_keys.dart';
import 'package:flutter_save_password/init/cache/locale_manager.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'package:flutter_save_password/services/auth/auth_base.dart';
import 'package:flutter_save_password/services/auth/firebase_auth.dart';
import 'package:flutter_save_password/locator.dart';
import 'package:flutter_save_password/services/database/firebase_db_services.dart';
import 'package:flutter_save_password/services/database/local_db.dart';
import 'package:flutter_save_password/services/storage/firebase_storage_service.dart';


enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseAuthServices _firebaseAuthService = locator<FirebaseAuthServices>();
  FirebaseStorageService _service = locator<FirebaseStorageService>();
  AppMode appMode = AppMode.RELEASE;
  UserModel currentUser;
  final LocalDbHelper localDbHelper = LocalDbHelper();

  Future<bool> updateUserData(UserModel user) async {
    var result  = await _firestoreDBService.updateUserName(user, currentUser.userID);
    await localDbHelper.updateUserName(user, " ");
    return result;

  }

  Future<String> updateUserImage(File _image) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var result = await _service.saveUserPhoto(currentUser.userID, AppCons.IMAGE_FILE_TYPE, _image);
      currentUser.userPhotoNetwork = result;
      updateUserData(currentUser);
      localDbHelper.updateUserName(currentUser, "");
      return result;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      if(await checkInternetConnection()){
        currentUser = await _firebaseAuthService.getCurrentUser();
        if (currentUser != null) {
          var userData = await _firestoreDBService.readUserData(currentUser.userID);
          currentUser = userData;
          _offlineFolderWriteWeb();
        }
      }else{
        currentUser = await localDbHelper.readUserData(" ");
      }
      return currentUser;
    }
  }

  @override
  Future<UserModel> signInWithEmailandPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var userModel = await _firebaseAuthService.signInWithEmailandPassword(email, password);
      var userData = await _firestoreDBService.readUserData(userModel.userID);
      userModel.userName = userData.userName;
      await localDbHelper.writeUserData(userModel);
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
      await LocalManager.instance.setBoolValue(PreferencesKeys.WRITE_ALL_DATA, false);
      await localDbHelper.deleteDB();
      return result;
    }
  }

  @override
  Future<UserModel> createUserWithEmailandPassword(UserModel userModel) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var newUser =
          await _firebaseAuthService.createUserWithEmailandPassword(userModel);
      userModel.userID = newUser.userID;
      userModel.userCreateTime = newUser.userCreateTime;
      userModel.userPhotoNetwork = userModel.userPhotoNetwork == null ?  userModel.firstProfileFotoUrl : userModel.userPhotoNetwork;

      _firestoreDBService.writeUserData(userModel);
      currentUser = userModel;
      localDbHelper.writeUserData(userModel);
      return currentUser;
    }
  }

  ///***********************

  Future<List<Folder>> fetchFolders() async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var list;
      if(await checkInternetConnection()){
        list = await _firestoreDBService.fetchFolders(currentUser.userID);
        var control = LocalManager.instance.getBoolValue(PreferencesKeys.WRITE_ALL_DATA);
        if(!control){
          await localDbHelper.writeAllData(list);
          LocalManager.instance.setBoolValue(PreferencesKeys.WRITE_ALL_DATA, true);
        }

      }else{
        list =await localDbHelper.fetchFolders("userID");
      }
      return list;
    }
  }

  Future<bool> createFolder(Folder folder) async {
    //todo offline mode
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      bool con = await checkInternetConnection();
      await localDbHelper.createFolder(folder, "",connection: con);
      if(!con)
        LocalManager.instance.setBoolValue(PreferencesKeys.OFFLINE_FOLDERS_VALUE, true);

      return await _firestoreDBService.createFolder(folder, currentUser.userID);
    }
  }

  Future<bool> updateFolder(Folder folder, Folder newFolder) async {
    //todo offline mode
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {

      var result = await _firestoreDBService.updateFolder(folder, newFolder, currentUser.userID);
      localDbHelper.updateFolder(folder, newFolder, "");
      return result;
    }
  }

  Future<void> _offlineFolderWriteWeb() async{
    ///Folder:
    var offlineMode = LocalManager.instance.getBoolValue(PreferencesKeys.OFFLINE_FOLDERS_VALUE);
    if(offlineMode){
      var offlineFolderList = await localDbHelper.getOfflineFolderList();
      for(Folder f in offlineFolderList){
        createFolder(f);
       // LocalManager.instance.removeOfflineFolderValue(PreferencesKeys.OFFLINE_FOLDERS_VALUE);
      }
      LocalManager.instance.setBoolValue(PreferencesKeys.OFFLINE_FOLDERS_VALUE, false);
    }
    ///Account:
    offlineMode = LocalManager.instance.getBoolValue(PreferencesKeys.OFFLINE_ACCOUNTS_VALUE);
    if(offlineMode){
      var offlineAccountList =await localDbHelper.getOfflineAccount();
      for(Account a in offlineAccountList){
        saveAccount(a);
      }
      LocalManager.instance.setBoolValue(PreferencesKeys.OFFLINE_ACCOUNTS_VALUE, false);
    }
  }

  Future<bool> deleteFolder(Folder folder) async {
    //todo offline mode
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      await localDbHelper.deleteFolder(folder, "");
      return await _firestoreDBService.deleteFolder(folder, currentUser.userID);
    }
  }

  ///***********************

  Future<bool> updateAccount(Account account, Account newAccout) async {
    //todo offline mode
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      await localDbHelper.updateAccount(account, newAccout, "");
      return await _firestoreDBService.updateAccount(account, newAccout, currentUser.userID);
    }
  }

  Future<bool> saveAccount(Account account) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      bool con = await checkInternetConnection();
      if(!con){
        LocalManager.instance.setBoolValue(PreferencesKeys.OFFLINE_FOLDERS_VALUE, true);
        print("offline ");
      }

      await localDbHelper.saveAccount(account,"",connection: con);
      return await _firestoreDBService.saveAccount(account, currentUser.userID);
    }
  }

  Future<bool> deleteAccount(Account account) async {
    //todo offline mode
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      await localDbHelper.deleteAccount(account,"");
      return await _firestoreDBService.deleteAccount(
          account, currentUser.userID);
    }
  }


  Future<bool> checkInternetConnection() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }


}
