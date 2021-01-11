import 'package:flutter/material.dart';
import 'package:flutter_save_password/models/account_model.dart';


class Folder {
  String folderID;
  String folderName;
  Color folderColor;
  DateTime folderCreateDate;
  DateTime folderUpdateDate;
  List<Account> accounts  = [];
  List<Account> favoriteAccounts  = [];


  Folder(this.folderName, this.folderColor);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["folder_id"] = folderID;
    map["folder_name"] = folderName;
    map["folder_color"] = folderColor.value.toString();
    map["folder_create_date"] = folderCreateDate.toString();
    map["folder_update_date"] =
        folderUpdateDate == null ? null : folderUpdateDate.toString();

    ///Dosyayi ilk oluştururken 'Accounts' olmayacağı için bu işleme gerek yok
    //map["accounts"] = accounts.map((e) => e.toMap());
    return map;
  }

  Folder.fromMap(Map<dynamic, dynamic> map) {
    this.folderName = map['folder_name'];
    this.folderID = map["folder_id"];
    this.folderColor = Color(int.parse(map["folder_color"].toString()));
    this.folderCreateDate =
        DateTime.parse(map['folder_create_date'].toString());
    this.folderUpdateDate = map['account_update_favorite_time'] == null
        ? this.folderUpdateDate = null
        : this.folderUpdateDate = DateTime.parse(map['account_update_favorite_time'].toString());

    if (map["accounts"] != null) {
      var mapList = List<Map<dynamic, dynamic>>.from(map["accounts"].values);
      for (var currentMap in mapList) {
        var currentAccount = Account.fromMap(currentMap);
        accounts.add(currentAccount);
      }
    }
    sortByFavorite();
  }

  sortByFavorite() {
    List<Account> unFavoriteAccounts  = [];
    favoriteAccounts.clear();
    for (var currentAccount in accounts) {
      if (currentAccount.favorite) {
        favoriteAccounts.add(currentAccount);
      } else {
        unFavoriteAccounts.add(currentAccount);
      }
    }
    accounts.clear();
    favoriteAccounts.sort((a, b) =>
        b.accountUpdateFavoriteTime.compareTo(a.accountUpdateFavoriteTime));
    unFavoriteAccounts
        .sort((a, b) => b.accountCreateTime.compareTo(a.accountCreateTime));
    accounts.addAll(favoriteAccounts);
    accounts.addAll(unFavoriteAccounts);
  }
  
 
}
