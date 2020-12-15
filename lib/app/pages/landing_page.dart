import 'package:flutter/material.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'auth_pages/log_in_page.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';

class LangingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel.state == UserViewState.Busy) {
      return buildCenterCircularProgressIndicator;
    } else {
      if (_userViewModel.user == null) {
        return LoginPage();
      } else {
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
