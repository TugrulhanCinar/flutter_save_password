import 'package:flutter/material.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';

class LangingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    final _p =Provider.of<PasswordSaveViewModel>(context);
    if (_userViewModel.state == UserViewState.Busy) {
      return buildCenterCircularProgressIndicator;
    } else {
      if (_userViewModel.user == null) {
        return LoginPage();
      } else {
        _userViewModel.dispose();
        _p.fetchFolders();
        _p.dispose();
        return HomePage();
      }
    }
  }

  Widget get buildCenterCircularProgressIndicator {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
