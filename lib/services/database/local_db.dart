import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'package:flutter_save_password/services/database/db_base.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper extends DBBase {
  static const DB_VERSION = 1;

  static LocalDbHelper _sqliteDbServices;
  static const DB_NAME = "save_password";
  static Database _database;

  ///Folder db
  final String _folder = "folder";
  final String _folderID = "folder_id";
  final String _folderIDLocale = "folder_id_locale";
  final String _folderName = "folder_name";
  final String _folderColor = "folder_color";
  final String _folderCreateDate = "folder_create_date";
  final String _folderUpdateDate = "folder_update_date";
  final String _offlineModFolder = "offline_mod";

  ///Account db :
  final String _account = "account";
  final String _accountID = "account_id";
  final String _accountIDLocale = "account_id_locale";
  final String _accountName = "account_name";
  final String _accountEmail = "account_mail";
  final String _accountPassword = "account_password";
  final String _accountCreateTime = "account_create_time";
  final String _accountUpdateFavoriteTime = "account_update_favorite_time";
  final String _offlineModAccount = "offline_mod";
  final String _favorite = "favorite";

  ///User db
  final String _user = "user";
  final String _userdID = "user_id";
  final String _userName = "user_name";
  final String _userEmail = "user_mail";
  final String _userCreateTime = "user_create_date";
  final String _userPhoto = "user_photo";

  factory LocalDbHelper() {
    if (_sqliteDbServices == null) {
      _sqliteDbServices = LocalDbHelper._internal();
      return _sqliteDbServices;
    } else {
      return _sqliteDbServices;
    }
  }

  Future<Database> _getDataBase() async {
    if (_database == null) {
      _database = await initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  LocalDbHelper._internal();

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String dbPath = join(await getDatabasesPath(), DB_NAME);
    var notesDb =
        await openDatabase(dbPath, version: DB_VERSION, onCreate: createDb);
    return notesDb;
  }

  ///********************************************
  void createDb(Database db, int version) async {
    await db.execute(
        "Create table $_user($_userdID text primary key, $_userName text, $_userEmail text, $_userCreateTime text, $_userPhoto text )");
    await db.execute(
        "Create table $_folder($_folderIDLocale integer primary key, $_folderID text, $_folderName text, $_folderColor text, $_offlineModFolder text, $_folderCreateDate text, $_folderUpdateDate text )");
    await db.execute(
        "Create table $_account($_folderIDLocale integer primary key, $_accountID text, $_accountName text, $_offlineModAccount text, $_folderID text, $_folderName text, $_accountEmail text,$_accountPassword text, $_accountCreateTime text, $_accountUpdateFavoriteTime text, $_favorite text )");
  }

  ///****************************
  @override
  Future<bool> createFolder(Folder folder, String userID,
      {bool connection}) async {
    var db = await _getDataBase();
    folder.offlineMod = connection;
    var result = db.insert(_folder, folder.toMapLocal());
    return result != null ? true : false;
  }

  @override
  Future<bool> deleteFolder(Folder folder, String userID) async {
    var db = await _getDataBase();
    var result =
        await db.delete(_folder, where: "$_folderID = ${folder.folderID}");
    return result != null ? true : false;
  }

  @override
  Future<List<Folder>> fetchFolders(String userID) async {
    var db = await _getDataBase();
    var resultMap = await db.rawQuery("Select * From $_folder");
    List<Folder> list = [];
    for (Map map in resultMap) {
      list.add(Folder.fromMapLocal(map));
    }
    list = folderInAccount(list, await _fetchAccounts());
    return list;
  }

  @override
  Future<bool> updateFolder(
      Folder folder, Folder newFolder, String userID) async {
    var db = await _getDataBase();
    var result = await db.update(_account, newFolder.toMap(),
        where: "$_folderID = ${folder.folderID}");
    return result != null ? true : false;
  }

  Future<List<Folder>> getOfflineFolderList() async {
    var db = await _getDataBase();
    List<Folder> folders = [];
    var resultMap = await db.query(_folder, where: "$_offlineModFolder = true");
    for (Map map in resultMap) {
      folders.add(Folder.fromMapLocal(map));
    }
    return folders;
  }

  ///************************

  @override
  Future<bool> saveAccount(Account account, String userID,
      {bool connection}) async {
    var db = await _getDataBase();

    print("yazıladak acc id "  + account.accountID);
    account.offlineMod = connection;

    var result = await db.insert(_account, account.toMap());

    return result != null ? true : false;
  }

  Future<List<Account>> _fetchAccounts() async {
    var db = await _getDataBase();
    var resultMap = await db.rawQuery("Select * From $_account");
    List<Account> list = [];
    for (Map map in resultMap) {
      list.add(Account.fromMap(map));
    }
    return list;
  }

  @override
  Future<bool> updateAccount(
      Account account, Account newAccount, String userID) async {
    var db = await _getDataBase();
    var result = await db.update(_account, newAccount.toMap(),
        where: "$_accountID = ${account.accountID}");
    return result != null ? true : false;
  }

  @override
  Future<bool> deleteAccount(Account account, String userID) async {
    var db = await _getDataBase();
    var result =
        await db.delete(_account, where: "$_accountID = ${account.accountID}");
    return result != null ? true : false;
  }

  Future<List<Account>> getOfflineAccount() async {
    //todo
    var db = await _getDataBase();
    var resultMap =
        await db.query(_account, where: "$_offlineModAccount = false");
    List<Account> accounts = [];
    for (Map map in resultMap) {
      accounts.add(Account.fromMapLocale(map));
    }
    return accounts;
  }

  ///************************

  @override
  Future<UserModel> readUserData(String userID) async {
    var db = await _getDataBase();
    var resultMap = await db.rawQuery("Select * From $_user");
    var user;
    for (Map map in resultMap) {
      user = UserModel.fromMap(map);
    }
    return user;
  }

  @override
  Future<bool> updateUserName(UserModel user, String userID) async {
    var db = await _getDataBase();
    var result = await db.update(_user, user.toMap(),
        where: "$_userdID = ${user.userID}");
    return result != null ? true : false;
  }

  @override
  Future<bool> writeUserData(UserModel userModel) async {
    var db = await _getDataBase();
    var result = await db.insert(_user, userModel.toMap());
    return result != null ? true : false;
  }

  ///**********************
  Future<void> deleteDB() async {
    print("Deleted db");
    await deleteDatabase(join(await getDatabasesPath(), DB_NAME));
  }

  List<Folder> folderInAccount(List<Folder> folders, List<Account> accounts) {
    List<Folder> folderList = [];
    for (Folder f in folders) {
      for (Account acc in accounts) {
        if (f.folderID == acc.folderID) {
          f.accounts.add(acc);
        }
      }
      folderList.add(f);
    }
    return folderList;
  }

  Future<bool> writeAllData(List<Folder> allFolder) async{
    var db = await _getDataBase();
    List<Account> list= getFoldersInAllAccounts(allFolder);

    if(list.length>0){
      for(var account in list){
        saveAccount(account, "",connection: true);
        await db.insert(_account,account.toMapLocale());
      }
    }
    if(allFolder.length>0){
      for(var f in allFolder){
        await createFolder(f,"",connection: true);
      }
    }
  }

  List<Account> getFoldersInAllAccounts(List<Folder> allFolder){
    List<Account> list= [];

    for(Folder f in allFolder){
      list.addAll(f.accounts);
    }
    return list;
  }


}
