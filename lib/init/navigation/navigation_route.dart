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
import 'package:flutter_save_password/app/pages/drawer_page/creat_password_page.dart';
import 'package:flutter_save_password/app/pages/drawer_page/profile_page.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/drawer_page/favorite_page.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/main_page/home_page.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/main_page/landing_page.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';

class NavigationRoute {
  static NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args, {Object? data}) {
    switch (args.name) {
      case NavigationConstans.HOME_PAGE:
        return normalNavigate(HomePage());
         

      case NavigationConstans.ADDING_FOLDER_PAGE:
        return normalNavigate(AddingFolderPage());


      case NavigationConstans.ADDING_ACCOUNT_PAGE:
        return normalNavigate(AddingAccountPage(folder: args.arguments as Folder?));
         

      case NavigationConstans.LOG_IN_PAGE:
        return normalNavigate(LoginPage());
         

      case NavigationConstans.SIGN_IN_PAGE:
        return normalNavigate(SigninPage());
         

      case NavigationConstans.ACCOUNT_DETAIL_PAGE:
        return normalNavigate(AccountDetailPage(account: args.arguments as Account?));
         

      case NavigationConstans.FOLDER_DETAIL_PAGE:
        return normalNavigate(FolderDetailPage(folderIndex: args.arguments as int?));
         

      case NavigationConstans.FOLDER_SETTINGS_PAGE:
        return normalNavigate(FolderSetingsPage(folder: args.arguments as Folder?));
         

      case NavigationConstans.FAVORITE_PAGE:
        return normalNavigate(FavoritePage());
         

      case NavigationConstans.LANDING_PAGE:
        return normalNavigate(LandingPage());
         

      case NavigationConstans.PROFILE_PAGE:
        return normalNavigate(ProfilePage());
         


      case NavigationConstans.CREATE_PASSWORD_PAGE:
        return normalNavigate(CreatePasswordPage());
         

      default:
        return normalNavigate(NotFoundWidget());
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }
}
