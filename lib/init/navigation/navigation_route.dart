import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_save_password/app/common__widget/not_found_widget.dart';
import 'package:flutter_save_password/app/pages/add/adding_account.dart';
import 'package:flutter_save_password/app/pages/add/adding_folder.dart';
import 'package:flutter_save_password/app/pages/auth_pages/log_in_page.dart';
import 'package:flutter_save_password/app/pages/auth_pages/sign_in_page.dart';
import 'package:flutter_save_password/app/pages/details/account_details_page.dart';
import 'package:flutter_save_password/app/pages/details/folder_detail_page.dart';
import 'package:flutter_save_password/app/pages/details/folder_settings_page.dart';
import 'package:flutter_save_password/app/pages/favorite_page.dart';
import 'package:flutter_save_password/app/pages/home_page.dart';
import 'package:flutter_save_password/app/pages/landing_page.dart';
import 'package:flutter_save_password/app/pages/profile_page.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';

class NavigationRoute {
  static NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args, {Object data}) {
    switch (args.name) {
      case NavigationConstans.HOME_PAGE:
        return normalNavigate(HomePage());
        break;

      case NavigationConstans.ADDING_FOLDER_PAGE:
        return normalNavigate(AddingFolderPage());
        break;

      case NavigationConstans.ADDING_ACCOUNT_PAGE:
        return normalNavigate(AddingAccountPage(folder: args.arguments));
        break;

      case NavigationConstans.LOG_IN_PAGE:
        return normalNavigate(LoginPage());
        break;

      case NavigationConstans.SIGN_IN_PAGE:
        return normalNavigate(SigninPage());
        break;

      case NavigationConstans.ACCOUNT_DETAIL_PAGE:
        return normalNavigate(AccountDetailPage(account: args.arguments));
        break;

      case NavigationConstans.FOLDER_DETAIL_PAGE:
        return normalNavigate(FolderDetailPage(folderIndex: args.arguments));
        break;

      case NavigationConstans.FOLDER_SETTINGS_PAGE:
        return normalNavigate(FolderSetingsPage(folder: args.arguments));
        break;

      case NavigationConstans.FAVORITE_PAGE:
        return normalNavigate(FavoritePage());
        break;

      case NavigationConstans.LANDING_PAGE:
        return normalNavigate(LandingPage());
        break;

      case NavigationConstans.PROFILE_PAGE:
        return normalNavigate(ProfilePage());
        break;

      default:
        return normalNavigate(NotFoundWidget());
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }
}
