import 'package:flutter/cupertino.dart';
import 'package:flutter_save_password/init/navigation/my_navigation_services.dart';

class NavigationServices implements MyNavigationServices {
  static NavigationServices _instance = NavigationServices._init();

  static NavigationServices get instance => _instance;

  NavigationServices._init();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final removeAllOldRoutes = (Route<dynamic> route) => false;

  @override
  Future<void> navigateToPage({String path, Object data,}) async {

     await navigatorKey.currentState.pushNamed(path, arguments: data);
  }

  @override
  Future<void> navigateToPageClear({String path, Object data}) async {
    await navigatorKey.currentState
        .pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: data);
  }
}
