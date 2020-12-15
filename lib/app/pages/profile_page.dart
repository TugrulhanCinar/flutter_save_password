import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String appTitle = "Profil";
  final String userNameTextFormFieldLabelText = "User Name";
  final String userMailTextFormFieldLabelText = "Mail";
  String userName, userMail;

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    if (userName == null) {
      userName = _userViewModel.user.userName;
      userMail = _userViewModel.user.userEmail;
    }

    return Scaffold(
      appBar: CustomAppBar(appTitle),
      body: Padding(
        padding: context.paddingAllLowMedium,
        child: ListView(
          children: [
            buildCircleAvatar,
            context.emptylowMediumValueWidget,
            buildNameTextFormField,
            context.emptylowMediumValueWidget,
            buildMailTextFormField,
          ],
        ),
      ),
    );
  }

  CircleAvatar get buildCircleAvatar => CircleAvatar(
        backgroundColor: Colors.blue,
        radius: context.height / 10,
      );

  TextFormField get buildNameTextFormField => TextFormField(
        initialValue: userName,
        enabled: false,
        style: _textStyle,
        decoration: inputDecoration,
      );

  TextFormField get buildMailTextFormField => TextFormField(
        initialValue: userMail,
        enabled: false,
        style: _textStyle,
        decoration: inputDecoration,
      );

  TextStyle get _textStyle =>
      Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.redAccent);

  InputDecoration get inputDecoration => InputDecoration(
        labelStyle: TextStyle(color: Colors.redAccent),
        focusedBorder: _outlineInputBorder,
        enabledBorder: _outlineInputBorder,
        border: _outlineInputBorder,
      );

  OutlineInputBorder get _outlineInputBorder => OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: context.borderLowRadiusHCircular,
      );
}
