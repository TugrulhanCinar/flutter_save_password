class Account {
  String accountID;
  String accountName;
  String accountEmail;
  String accountPassword;
  String folderID;
  String folderName;
  DateTime accountCreateTime;
  DateTime accountUpdateFavoriteTime;
  bool favorite = false;
  bool offlineMod;


  Account(this.accountName, this.accountEmail, this.accountPassword,
      this.folderID, this.folderName);

  Account.withDate(this.accountName, this.accountEmail, this.accountPassword,
      this.accountCreateTime, this.folderID, this.folderName);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['account_name'] = accountName;
    map['folder_id'] = folderID;
    map['account_id'] = accountID;
    map['folder_name'] = folderName;
    map['account_mail'] = accountEmail;
    map['account_password'] = accountPassword;
    map['account_create_time'] = accountCreateTime.toString();
    map['account_update_favorite_time'] = accountUpdateFavoriteTime == null
        ? null
        : accountUpdateFavoriteTime.toString();
    map['favorite'] = favorite.toString();
    return map;
  }

  Account.fromMap(Map<dynamic, dynamic> map) {
    this.accountName = map['account_name'];
    this.folderName = map['folder_name'];
    this.accountID = map['account_id'];
    this.folderID = map['folder_id'];
    this.accountEmail = map['account_mail'];
    this.accountPassword = map['account_password'].toString();
    this.accountCreateTime =
        DateTime.parse(map['account_create_time'].toString());
    this.accountUpdateFavoriteTime = map['account_update_favorite_time'] == null
        ? this.accountUpdateFavoriteTime = null
        : this.accountUpdateFavoriteTime =
            DateTime.parse(map['account_update_favorite_time'].toString());
    this.favorite = map['favorite'] == "true" ? true : false;
  }



  Map<String, dynamic> toMapLocale() {
    var map = Map<String, dynamic>();
    map['account_name'] = accountName;
    map['folder_id'] = folderID;
    map['account_id'] = accountID;
    map['folder_name'] = folderName;
    map['account_mail'] = accountEmail;
    map['account_password'] = accountPassword;
    map['offline_mod'] = offlineMod.toString();
    map['account_create_time'] = accountCreateTime.toString();
    map['account_update_favorite_time'] = accountUpdateFavoriteTime == null
        ? null
        : accountUpdateFavoriteTime.toString();
    map['favorite'] = favorite.toString();
    return map;
  }


  Account.fromMapLocale(Map<dynamic, dynamic> map) {
    this.accountName = map['account_name'];
    this.folderName = map['folder_name'];
    this.accountID = map['account_id'];
    this.offlineMod = map['offline_mod'] == "true" ? true : false;
    this.folderID = map['folder_id'];
    this.accountEmail = map['account_mail'];
    this.accountPassword = map['account_password'].toString();
    this.accountCreateTime =
        DateTime.parse(map['account_create_time'].toString());
    this.accountUpdateFavoriteTime = map['account_update_favorite_time'] == null
        ? this.accountUpdateFavoriteTime = null
        : this.accountUpdateFavoriteTime =
        DateTime.parse(map['account_update_favorite_time'].toString());
    this.favorite = map['favorite'] == "true" ? true : false;
  }



  @override
  String toString() {
    return 'Account{accountID: $accountID, accountName: $accountName, accountEmail: $accountEmail, accountPassword: $accountPassword, folderID: $folderID, accountCreateTime: $accountCreateTime, accountUpdateFavoriteTime: $accountUpdateFavoriteTime, favorite: $favorite}';
  }
}
