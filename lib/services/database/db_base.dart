import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/models/user_model.dart';


abstract class DBBase {

  Future<bool> saveAccount(Account account,String userID);
  Future<bool> deleteAccount(Account account,String userID);
  Future<bool> updateAccount(Account account, Account newAccount,String userID);
  ///
  Future<bool> createFolder(Folder folder,String userID);
  Future<bool> updateFolder(Folder folder,Folder newFolder,String userID);
  Future<bool> deleteFolder(Folder folder,String userID);
  Future<List<Folder>> fetchFolders(String userID);

  ///
  Future<UserModel?> readUserData(String userID);
  Future<bool> writeUserData(UserModel userModel);
  Future<bool> updateUserName(UserModel user,String userID);


}