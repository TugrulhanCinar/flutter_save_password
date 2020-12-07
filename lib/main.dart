import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_save_password/locator.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';
import 'app/pages/landing_page.dart';
import 'view_model/user_view_model.dart';


//todo
//todo tasarımsal değişiklikleri hallet

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  /*SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
        MyApp(),
    ),
  );*/
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<PasswordSaveViewModel>(create: (_) => PasswordSaveViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LangingPage(),
        theme: Theme.of(context).copyWith(
          textTheme:
              Theme.of(context).textTheme.copyWith(bodyText2: buildTextStyle),
        ),
      ),
    );
  }

  TextStyle get buildTextStyle => TextStyle(color: Colors.grey[700]);
}
