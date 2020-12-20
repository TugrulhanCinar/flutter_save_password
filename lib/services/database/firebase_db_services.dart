import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'db_base.dart';

class FirestoreDBService implements DBBase {
  final databaseReference = FirebaseDatabase.instance.reference();


  Future<bool> updateUserName(UserModel user,String userID) async{
    try{
     /* Map<dynamic,dynamic> map = Map();
      map["user_name"] = userName;*/
      await databaseReference
          .child('users')
          .child(userID)
          .child("user_data")
          .update(user.toMap());
      return true;
    }catch(e){
      print("updateUserName hata: " + e.toString());
      return false;
    }
  }
  /*

  Future<bool> updateUserName(String userName,String userID) async{
    try{
      Map<dynamic,dynamic> map = Map();
      map["user_name"] = userName;
      await databaseReference
          .child('users')
          .child(userID)
          .child("user_data")
          .update(map);
      return true;
    }catch(e){
      print("updateUserName hata: " + e.toString());
      return false;
    }
  }
   */

  Future<bool> writeUserData(UserModel userModel) async {
    try {
      await databaseReference
          .child('users')
          .child(userModel.userID)
          .child("user_data")
          .set(userModel.toMap());
      return true;
    } catch (e) {
      print("writeUserData hata: " + e.toString());
      return false;
    }
  }

  Future<UserModel> readUserData(String userID) async {
    UserModel user;
    try {
      var snapshot = await databaseReference
          .child("users")
          .child(userID)
          .child("user_data")
          .once();
      user = UserModel.fromMap(snapshot.value);
      return user;
    } catch (e) {
      print("readUserData hata: " + e.toString());
      return null;
    }
  }

  ///*********************************************

  @override
  Future<bool> createFolder(Folder folder, String userID) async {
    try {
      await databaseReference
          .child('users')
          .child(userID)
          .child("folders")
          .child(folder.folderID)
          .set(folder.toMap());
    } catch (e) {
      print(e.toString());
      print("Hata oluştu firebase_db_services");
      return false;
    }
    return true;
  }

  @override
  Future<List<Folder>> fetchFolders(String userID) async {
    var snapshot = await databaseReference
        .child("users")
        .child(userID)
        .child("folders")
        .once();
    List<Folder> folderList = List();
    if (snapshot.value != null) {
      var result = await snapshot.value.values as Iterable;
      for (var item in result) {
        folderList.add(Folder.fromMap(item));
      }
    }
    return folderList;
  }

  @override
  Future<bool> deleteFolder(Folder folder, String userID) async {
    try {
      await databaseReference
          .child('users')
          .child(userID)
          .child("folders")
          .child(folder.folderID)
          .remove();
    } catch (e) {
      print("Hata oluştu firebase_db_services");
      print(e.toString());
      return false;
    }
    return true;
  }

  @override
  Future<bool> updateFolder(
      Folder folder, Folder newFolder, String userID) async {
    try {
      await databaseReference
          .child('users')
          .child(userID)
          .child("folders")
          .child(folder.folderID)
          .update(newFolder.toMap());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///***********************************

  @override
  Future<bool> updateAccount(
      Account account, Account newAccount, String userID) async {
    try {
      await databaseReference
          .child('users')
          .child(userID)
          .child("folders")
          .child(account.folderID)
          .child('accounts')
          .child(account.accountID)
          .update(newAccount.toMap());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteAccount(Account account, String userID) async {
    try {
      await databaseReference
          .child('users')
          .child(userID)
          .child("folders")
          .child(account.folderID)
          .child('accounts')
          .child(account.accountID)
          .remove();
    } catch (e) {
      print("Hata oluştu firebase_db_services");
      print(e.toString());
      return false;
    }
    return true;
  }

  @override
  Future<bool> saveAccount(Account account, String userID) async {
    try {
      await databaseReference
          .child('users')
          .child(userID)
          .child("folders")
          .child(account.folderID)
          .child('accounts')
          .child(account.accountID)
          .set(account.toMap());
    } catch (e) {
      print("Hata oluştu firebase_db_services");
      print(e.toString());
      return false;
    }
    return true;
  }
}
