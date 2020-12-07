import 'package:flutter/material.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'package:flutter_save_password/services/repository/user_repository.dart';
import 'package:flutter_save_password/locator.dart';

enum UserViewState { Idle, Busy }

class UserViewModel with ChangeNotifier {
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _user;
  UserViewState _state = UserViewState.Idle;

  set state(UserViewState state){

    print("UserViewState set state çalıştı");
    print("UserViewState eski state:" + _state.toString() );
    print("UserViewState yeni state:" + state.toString() );
    _state = state;
    notifyListeners();
  }


  UserViewModel(){
    currentUser();
  }

  UserViewState get state => _state;

  UserModel get user => _user;


  Future<UserModel> currentUser() async {

    try {
      state = UserViewState.Busy;
      _user = await _userRepository.getCurrentUser();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = UserViewState.Idle;
    }
  }

  Future<UserModel> signInWithEmailandPassword(String email, String password) async {
    state = UserViewState.Busy;
    _user = await _userRepository.signInWithEmailandPassword(email, password);
    state = UserViewState.Idle;
    print(_user.toString());
    return _user;
  }

  Future<UserModel> createUserWithEmailandPassword(String email, String sifre) {
    // TODO: implement createUserWithEmailandPassword
    state = UserViewState.Busy;


    state = UserViewState.Idle;
    return null;
  }

  Future<bool> signOut(){
    // TODO: implement
    state = UserViewState.Busy;



    state = UserViewState.Idle;
    return null;
  }



}
