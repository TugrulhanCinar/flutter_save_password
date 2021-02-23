import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_save_password/init/navigation/navigation_route.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/locator.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'app/pages/main_page/landing_page.dart';
import 'init/cache/locale_manager.dart';
import 'view_model/user_view_model.dart';

//todo genel renge karar ver

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  LocalManager.prefrencesInit();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: buildMaterialApp(context),
    );
  }

  MaterialApp buildMaterialApp(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationServices.instance.navigatorKey,
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        home: LandingPage(),
        theme: buildCopyWith(context),
      );

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<PasswordSaveViewModel>(
            create: (_) => PasswordSaveViewModel()),
       // StreamProvider<DataConnectionStatus>(create: (context) => ConnectivityService().controller.stream,),
      ];

  ThemeData buildCopyWith(BuildContext context) => Theme.of(context).copyWith(
        textTheme: buildTextTheme(context),
        iconTheme: buildIconTheme(context),
      );

  IconThemeData buildIconTheme(BuildContext context) =>
      Theme.of(context).iconTheme.copyWith(color: Colors.white);

  TextTheme buildTextTheme(BuildContext context) {
    return Theme.of(context).textTheme.copyWith(
          bodyText1: bodyText1,
          bodyText2: bodyText2,
        );
  }

  TextStyle get bodyText1 => TextStyle(color: Colors.red);

  TextStyle get bodyText2 => TextStyle(color: Colors.deepOrange);
}
/*
Lazy singeloton =>


  static LocalManager _instance = LocalManager._init();
  static LocalManager get instance => _instance;

  static LocalManager _init(){

  }



 */