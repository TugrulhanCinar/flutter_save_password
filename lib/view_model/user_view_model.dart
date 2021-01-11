import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'package:flutter_save_password/services/repository/user_repository.dart';
import 'package:flutter_save_password/locator.dart';

enum UserViewState { Idle, Busy }

class UserViewModel with ChangeNotifier {
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _user;
  UserViewState _state = UserViewState.Idle;

  set state(UserViewState state) {
    _state = state;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  UserViewState get state => _state;

  UserModel get user => _user;

  Future<UserModel> currentUser() async {
    try {
      state = UserViewState.Busy;
      _user = await _userRepository.getCurrentUser();

      if (_user != null) {
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = UserViewState.Idle;
    }
  }

  Future<UserModel> signInWithEmailandPassword(String email, String password) async {
    try {
      state = UserViewState.Busy;
      _user = await _userRepository.signInWithEmailandPassword(email, password);
      return _user;
    }  finally {
      state = UserViewState.Idle;
    }
  }

  Future<bool> updateUserData(UserModel user) async{
    state = UserViewState.Busy;
    var result = await _userRepository.updateUserData(user);
    _user.userName = user.userName;
    state = UserViewState.Idle;
    return result;
  }

  /*

  Future<bool> updateUserName(String userName) async{
    state = UserViewState.Busy;
    var result = await _userRepository.updateUserData(userName);

    _user.userName = userName;
    state = UserViewState.Idle;
    return result;
  }
   */

  Future<String> updateUserImage(File _image) async{
    state = UserViewState.Busy;
    var result = await _userRepository.updateUserImage(_image);
    _user.userPhotoNetwork = result;
    state = UserViewState.Idle;
    return result;
  }

  Future<UserModel> createUserWithEmailandPassword(UserModel user) async{
    state = UserViewState.Busy;
    var result = await _userRepository.createUserWithEmailandPassword(user);
    _user = result;
    _user.userName = user.userName;
    state = UserViewState.Idle;
    return result;
  }

  Future<bool> signOut() async {
    state = UserViewState.Busy;
    bool result = await _userRepository.signOut();
    _user = null;
    state = UserViewState.Idle;
    return result;
  }
}
