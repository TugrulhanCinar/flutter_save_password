import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/helper/helper.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import '../locator.dart';
import '../services/repository/user_repository.dart';

enum PasswordState { Idle, Busy }

class PasswordSaveViewModel with ChangeNotifier {
  final UserRepository? _userRepository = locator<UserRepository>();
  PasswordState _state = PasswordState.Idle;

  //List<Folder> folders = List();
  List<Folder>? folders;
  final List<Account> allAccount = [];
  final List<Account> allFavoriteAccount =  [];
  //final List<Account> allAccount = List();
  //final List<Account> allFavoriteAccount = List();


  set state(PasswordState state) {
    _state = state;
    notifyListeners();
  }

  PasswordState get state => _state;

  Future<bool?> updateFavoriteState(Account account) async {
    var newAccount = account;
    newAccount.favorite = !account.favorite;
    int folderIndex = _findFolderIndex(account.folderID);
    folders![folderIndex].accounts.remove(account);
    if (account.favorite) {
      folders![folderIndex].accounts.insert(0, newAccount);
      allFavoriteAccount.add(account);
    } else {
      folders![folderIndex].accounts.add(newAccount);
      folders![folderIndex].favoriteAccounts.remove(account);
      folders![folderIndex]
          .accounts
          .sort((a, b) => b.accountCreateTime!.compareTo(a.accountCreateTime!));
      allFavoriteAccount.remove(account);
    }
    newAccount.accountUpdateFavoriteTime = Helper.getDateTimeNow;
    var result = await updateAccount(account, newAccount);
    return result;
  }

  Future<bool?> saveAccount(Account account) async {
    state = PasswordState.Busy;
    account.accountCreateTime = Helper.getDateTimeNow;
    account.accountID = createID(account.accountCreateTime);
    bool? result = await _userRepository!.saveAccount(account);
    folders![_findFolderIndex(account.folderID)].accounts.insert(0, account);
    allAccount.add(account);
    state = PasswordState.Idle;
    return result;
  }

  Future<bool?> deleteAccount(Account account) async {
    state = PasswordState.Busy;
    bool? result = await _userRepository!.deleteAccount(account);
    int folderIndex = _findFolderIndex(account.folderID);
    int accountIndex =
        _findAccountIndexInFolder(account.accountID, folders![folderIndex]);
    folders![folderIndex].accounts.removeAt(accountIndex);
    state = PasswordState.Idle;
    return result;
  }

  Future<bool?> updateAccount(Account account, Account newAccount) async {
    state = PasswordState.Busy;
    var result = await _userRepository!.updateAccount(account, newAccount);
    int folderIndex = _findFolderIndex(account.folderID);
    int accountIndexInFolder =
        _findAccountIndexInFolder(account.accountID, folders![folderIndex]);
    int accountIndexInAllAccount =
        _findAccountIndexInAllFolder(account.accountID);
    folders![folderIndex].accounts[accountIndexInFolder] = newAccount;
    allAccount[accountIndexInAllAccount] = newAccount;
    state = PasswordState.Idle;
    return result;
  }

  ///******************
  Future<bool> saveFolder(Folder folder) async {
    state = PasswordState.Busy;
    folder.folderCreateDate = Helper.getDateTimeNow;
    folder.folderID = createID(folder.folderCreateDate);
    _userRepository!.createFolder(folder);
    folders!.insert(0, folder);
    state = PasswordState.Idle;
    return true;
  }

  Future<List<Folder>?> fetchFolders() async {
    _state = PasswordState.Busy;
    folders = await _userRepository!.fetchFolders();
    _addAllAccount();
    state = PasswordState.Idle;
    return folders;
  }

  Future<bool?> updateFolder(Folder folder, Folder newFolder) async {
    state = PasswordState.Busy;
    int folderIndex = _findFolderIndex(folder.folderID);
    newFolder.folderUpdateDate = Helper.getDateTimeNow;
    folders![folderIndex] = newFolder;
    var result = await _userRepository!.updateFolder(folder, newFolder);
    state = PasswordState.Idle;
    return result;
  }

  Future<bool> deleteFolder(Folder? folder) async {
    state = PasswordState.Busy;
    var result = await (_userRepository!.deleteFolder(folder) as FutureOr<bool>);
    if (result) {
      folders!.remove(folder);
      allAccount.remove(folder!.accounts);
      allFavoriteAccount.remove(folder.favoriteAccounts);
    }
    state = PasswordState.Idle;
    return result;
  }

  ///**********************************************

  int _findFolderIndex(String? folderID) {
    for (int i = 0; i < folders!.length; i++) {
      if (folderID == folders![i].folderID) {
        return i;
      }
    }
    return -1;
  }

  int _findAccountIndexInFolder(String? accountID, Folder folder) {
    for (int i = 0; i < folder.accounts.length; i++) {
      if (accountID == folder.accounts[i].accountID) {
        return i;
      }
    }
    return -1;
  }

  int _findAccountIndexInAllFolder(String? accountID) {
    for (int i = 0; i < allAccount.length; i++) {
      if (accountID == allAccount[i].accountID) {
        return i;
      }
    }
    return -1;
  }

  String createID(DateTime? createTime) {
    String id = getRandomString(10) +
        createTime
            .toString()
            .replaceAll(' ', '')
            .replaceAll('-', "")
            .replaceAll(".", "")
            .replaceAll(":", "");

    return id;
  }


  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  void _addAllAccount() {
    allAccount.clear();
    allFavoriteAccount.clear();
    for (var currentFolder in folders!) {
      allFavoriteAccount.addAll(currentFolder.favoriteAccounts);
      allAccount.addAll(currentFolder.accounts);
    }
  }
}
