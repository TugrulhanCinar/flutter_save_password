import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_button.dart';
import 'package:flutter_save_password/app/exceptions/log_in_exceptions.dart';
import 'package:flutter_save_password/app/pages/auth_pages/sign_in_page.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  final signInText = "Hemen Kayıt ol";
  bool obscureTextPassword = true;
  final userNameLabelText = "Mail";
  final passwordLabelText = "Şifre";
  final _logInTextWidgetText = "Giriş";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: getViewModel(context).state == UserViewState.Busy
          ? CircularProgressIndicator()
          : loginAreaWidget,
    );
  }

  Container get loginAreaWidget => Container(
        decoration: boxDecoration,
        padding: context.paddingAllhigh,
//        margin: context.paddingAllLowMedium,
        child: loginItems,
      );

  Widget get loginItems => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logInTextWidget,
            context.emptylowMediumValueWidget,
            _userNameTextFormField,
            context.emptylowMediumValueWidget,
            _passwordTextFormField,
            context.emptylowMediumValueWidget,
            _logInButton,
            context.emptylowMediumValueWidget,
            dividersAndTextWidget,
            context.emptylowMediumValueWidget,
            _signInButton,
          ],
        ),
      );

  Row get dividersAndTextWidget => Row(
        children: [
          Expanded(child: buildDividercontainer),
          Text(
            "VEYA",
            style:
                context.theme.textTheme.bodyText1.copyWith(color: Colors.white),
          ),
          Expanded(child: buildDividercontainer),
        ],
      );

  Container get buildDividercontainer => Container(
        margin: context.paddingHorizontalLowValue,
        child: context.customHighDivider,
      );

  Widget get _logInTextWidget => Text(
        _logInTextWidgetText,
        style: context.theme.textTheme.headline2.copyWith(color: Colors.white),
      );

  Widget get _logInButton => Container(
        width: context.width,
        child: MyCustomButton(
          onTap: loginButtonOnTap,
          buttonText: "Giriş",
        ),
      );

  void loginButtonOnTap() async {
    if (_formKey.currentState.validate()) {
      final UserViewModel _userViewModel = getViewModel(context);
      _formKey.currentState.save();
      try {
        var result =
            await _userViewModel.signInWithEmailandPassword(email, password);
        if (result != null)
          NavigationServices.instance
              .navigateToPageClear(path: NavigationConstans.HOME_PAGE);
      } on FirebaseAuthException catch (e) {
        showCustomDialog(LoginExceptions.showException(e.message));
      } catch (e) {}
    }
  }

  showCustomDialog(String text) {
    MyCustomDialog(
      title: Center(child: Text("Hata")),
      content: Text(text),
      actions: [
        Container(
          padding: context.paddingAllLowMedium,
          width: context.width,
          child: RaisedButton(
            color: Colors.red,
            shape: roundedRectangleBorder,
            child: Text("Tamam"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    ).goster(context);
  }

  RoundedRectangleBorder get roundedRectangleBorder =>
      RoundedRectangleBorder(borderRadius: context.borderHighRadiusHCircular);

  Widget get _signInButton => GestureDetector(
        child: Text(
          signInText,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.lightBlueAccent),
        ),
        onTap: _signInButtonOnTap,
      );

  _signInButtonOnTap() => NavigationServices.instance
      .navigateToPage(path: NavigationConstans.SIGN_IN_PAGE);

  Widget get _userNameTextFormField => TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),
        decoration: context.customInputDecoration(userNameLabelText),
        onSaved: (currentMail) {
          email = currentMail;
        },
      );

  Widget get _passwordTextFormField => TextFormField(
        style: TextStyle(color: Colors.white),
        obscureText: obscureTextPassword,
        onSaved: (currentPass) {
          password = currentPass;
        },
        decoration: context.customInputDecoration(
          passwordLabelText,
          suffixIcon: textFieldIcon,
        ),
      );

  IconButton get textFieldIcon => IconButton(
        icon: obscureTextPassword
            ? Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              )
            : Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
        onPressed: passwordTextFieldOnTap,
      );

  passwordTextFieldOnTap() {
    setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }

  getViewModel(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return _userViewModel;
  }

  BoxDecoration get boxDecoration => BoxDecoration(
        gradient: linearGradient,
        boxShadow: boxShadow,
      );

  List<BoxShadow> get boxShadow {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ];
  }

  LinearGradient get linearGradient => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        tileMode: TileMode.clamp,
        colors: gradientColorList,
      );

  List<Color> get gradientColorList => [
        Theme.of(context).colorScheme.hexToColor("#272A4A"),
        Theme.of(context).colorScheme.hexToColor("#396E97"),
        Theme.of(context).colorScheme.hexToColor("#9BBEF3"),
      ];
}
