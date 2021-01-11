class UserModel {
  String userID;
  String userName;
  String userEmail;
  DateTime userCreateTime;
  String userPassword;
  String userPhotoNetwork;
  String userPhotoLocal;
  final String _firstProfileFotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/savepasswords-6c7f3.appspot.com/o/photo.jpg?alt=media&token=f2ae2177-6e31-477b-a38c-2565427b6e12";


  UserModel(this.userName, this.userID, this.userEmail, this.userCreateTime);


  UserModel.fromFireBase({this.userID, this.userEmail, this.userCreateTime});

  UserModel.forCreate(
      this.userName, this.userPassword, this.userEmail);


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['user_id'] = userID;
    map['user_name'] = userName;
    map['user_mail'] = userEmail;
    map['user_photo'] = userPhotoNetwork == null ? _firstProfileFotoUrl : userPhotoNetwork;
    map['user_create_date'] = userCreateTime.toString();

    return map;
  }

  UserModel.fromMap(Map<dynamic, dynamic> map) {
    this.userID = map['user_id'];
    this.userName = map['user_name'];
    this.userEmail = map['user_mail'];
    this.userPhotoNetwork = map['user_photo'] == null ? _firstProfileFotoUrl : map['user_photo'];
    this.userCreateTime =   DateTime.parse(map['user_create_date'].toString());
  }

  @override
  String toString() {
    return 'UserModel{userID: $userID, userName: $userName, userEmail: $userEmail, userCreateTime: $userCreateTime, userPassword: $userPassword}';
  }
}
