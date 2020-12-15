import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_save_password/locator.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'app/pages/landing_page.dart';
import 'view_model/user_view_model.dart';

//todo favoriye eklendiğinde baze en yukarıya çıkmıyor onu düzelt
//todo otomatik şifre oluşturucu ekle


void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then(
    (value) => runApp(MyApp()),
  );
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
        home: LangingPage(),
        theme: buildCopyWith(context),
      );

  List<SingleChildWidget> get providers {
    return [
      ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
      ChangeNotifierProvider<PasswordSaveViewModel>(
          create: (_) => PasswordSaveViewModel()),
    ];
  }

  ThemeData buildCopyWith(BuildContext context) => Theme.of(context).copyWith(
        textTheme: buildTextTheme(context),
        iconTheme: buildIconTheme(context),
      );

  IconThemeData buildIconTheme(BuildContext context) {
    return Theme.of(context).iconTheme.copyWith(
          color: Colors.white,
        );
  }

  TextTheme buildTextTheme(BuildContext context) {
    return Theme.of(context).textTheme.copyWith(
          bodyText1: bodyText1,
          bodyText2: bodyText2,
        );
  }

  TextStyle get bodyText1 => TextStyle(color: Colors.red);

  TextStyle get bodyText2 => TextStyle(color: Colors.white);
}
