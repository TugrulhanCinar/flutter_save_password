import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_button.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/extensions/string_extension.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/models/user_model.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String userName, userMail, userPassword, userPasswordAgain;
  final String userNameTextFormFieldLabelText = "Ad ve Soyad";
  final String userMailTextFormFieldLabelText = "Email";
  final String userPasswordTextFormFieldLabelText = "Şifre";
  final String createUserButtonText = "Kayıt ol";
  final bool obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loginAreaWidget,
    );
  }

  Container get loginAreaWidget =>
      Container(
        decoration: boxDecoration,
        padding: context.paddingAllhigh,
        child: signinItems,
      );

  Widget get signinItems =>
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userMailTextFormField,
            context.emptylowMediumValueWidget,
            userNameTextFormField,
            context.emptylowMediumValueWidget,
            userPasswordTextFormField,
            context.emptylowMediumValueWidget,
            userPasswordAgainTextFormField,
            context.emptylowMediumValueWidget,
            _createUserButton,
            context.emptylowMediumValueWidget,
          ],
        ),
      );

  Widget get _createUserButton =>
      MyCustomButton(
        onTap: _createUserButtonOnTap,
        buttonText: createUserButtonText,
      );

  TextFormField get userMailTextFormField =>
      TextFormField(
        style: textFormFieldTextStyle,
        keyboardType: TextInputType.emailAddress,
        validator: userMailValidator,
        onSaved: (text) {
          userMail = text;
        },
        decoration:
        context.customInputDecoration(userMailTextFormFieldLabelText),
      );

  TextFormField get userNameTextFormField =>
      TextFormField(
        style: textFormFieldTextStyle,
        validator: userNameValidator,
        onSaved: (text) {
          userName = text;
        },
        decoration:
        context.customInputDecoration(userNameTextFormFieldLabelText),
      );

  TextFormField get userPasswordTextFormField =>
      TextFormField(
        style: textFormFieldTextStyle,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureText,
        validator: userPasswordValidator,
        onSaved: (text) {
          userPassword = text;
        },
        decoration:
        context.customInputDecoration(userPasswordTextFormFieldLabelText),
      );


  TextFormField get userPasswordAgainTextFormField =>
      TextFormField(
        style: textFormFieldTextStyle,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureText,
        validator: (text){
          if(text.length < 1){
            return "Şifreyi yeniden giriniz";
          }else{
            return null;
          }
        },
        onSaved: (text) {
          userPasswordAgain = text;
        },
        decoration: context.customInputDecoration(
            userPasswordTextFormFieldLabelText + " Tekrar"),
      );

  TextStyle get textFormFieldTextStyle =>
      Theme
          .of(context)
          .textTheme
          .bodyText1.copyWith(color: Colors.white);

  BoxDecoration get boxDecoration =>
      BoxDecoration(gradient: linearGradient, boxShadow: boxShadow);

  LinearGradient get linearGradient =>
      LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        tileMode: TileMode.clamp,
        colors: gradientColorList,
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

  List<Color> get gradientColorList =>
      [
        Theme
            .of(context)
            .colorScheme
            .hexToColor("#272A4A"),
        Theme
            .of(context)
            .colorScheme
            .hexToColor("#396E97"),
        Theme
            .of(context)
            .colorScheme
            .hexToColor("#9BBEF3"),
      ];

  _createUserButtonOnTap() async{
    UserModel user;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (userPassword == userPasswordAgain) {
        try {
          var newUser = UserModel.forCreate(userName, userPassword,userMail);
          user = await Provider.of<UserViewModel>(context,listen: false).createUserWithEmailandPassword(newUser);

        } catch (e) {
          print("HATAAAAAAA::::");
          print(e.toString());
        }
      } else {
        showCustomDialog("Girilen şifreler farklı ");
      }
    }
    if(user != null){
      NavigationServices.instance.navigateToPageClear(path: NavigationConstans.LANDING_PAGE);
    }
  }

  showCustomDialog(String text) {
    MyCustomDialog(
      title: Text('Hata'),
      content: Text(text),
      actions: [
        MyCustomButton(
          buttonText: "Tamam",
          buttonColor: Colors.redAccent,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).goster(context);
  }

  String userMailValidator(String text){
    if (!text.isValidEmail()) {
      showCustomDialog(
          "Hatali mail formatı. Lütfen mail adresinizi kontrol edin");
    } else {
      return null;
    }
    return null;
  }

  String userNameValidator(String text) {
    String name = text.replaceAll(' ', '');
    if (name.length < 2) {
      showCustomDialog("Girilen isim en az 2 karakter olmalı");
      return "Girilen isim en az 2 karakter olmalı";
    } else {
      return null;
    }
  }

  String userPasswordValidator(String text) {
    if (text.length < 6) {
      showCustomDialog("Şifre en az 6 karakter olmalıdır.");
    } else if (text.length > 20) {
      showCustomDialog("Şifre en fazla 20 karakter olmalıdır.");
    } else {
      return null;
    }
    return null;
  }
}
