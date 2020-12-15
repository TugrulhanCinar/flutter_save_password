class UserModel {
  String userID;
  String userName;
  String userEmail;
  DateTime userCreateTime;
  String userPassword;

  UserModel(this.userName, this.userID, this.userEmail, this.userCreateTime);


  UserModel.fromFireBase({this.userID, this.userEmail, this.userCreateTime});

  UserModel.forCreate(
      this.userName, this.userPassword, this.userEmail);


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['user_id'] = userID;
    map['user_name'] = userName;
    map['user_mail'] = userEmail;
    map['user_create_date'] = userCreateTime.toString();

    return map;
  }

  UserModel.fromMap(Map<dynamic, dynamic> map) {
    this.userID = map['user_id'];
    this.userName = map['user_name'];
    this.userEmail = map['user_mail'];
    //this.userCreateTime =   DateTime.parse(map['user_create_date'].toString());
  }

  @override
  String toString() {
    return 'UserModel{userID: $userID, userName: $userName, userEmail: $userEmail, userCreateTime: $userCreateTime, userPassword: $userPassword}';
  }
}
