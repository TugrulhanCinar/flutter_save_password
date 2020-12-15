import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/common__widget/custom_button.dart';

import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class AddingAccountPage extends StatefulWidget {
  final Folder folder;

  const AddingAccountPage({Key key, @required this.folder}) : super(key: key);

  @override
  _AddingAccountPageState createState() => _AddingAccountPageState();
}

class _AddingAccountPageState extends State<AddingAccountPage> {
  final String appBarTitle = "Hesap Ekle";
  final String textTooLong = "Girilen metin fazla uzun";
  final String textTooShort = "En az 1 karakter girmelisiniz";
  bool obscureTextPassword = true;
  final buttonText = "Oluştur";
  final mailLabelText = "Mail";
  final accountNameText = "Hesap Adı";
  final passwordLabelText = "Şifre";
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int textFormFieldMaxLength = 40;
  int textFormFieldMinLength = 1;
  String accountName, accountMail, accountPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: appBar,
      body: _columnBody,
    );
  }

  Widget get appBar => CustomAppBar(appBarTitle);

  Widget get _columnBody => Container(
        padding: context.paddingAllLowMedium,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              context.emptylowMediumValueWidget,
              _accountName,
              context.emptylowMediumValueWidget,
              _emailTextField,
              context.emptylowMediumValueWidget,
              _passwordTextField,
              context.emptylowMediumValueWidget,
              _createButton,
            ],
          ),
        ),
      );

  Widget get _createButton => MyCustomButton(
    buttonColor: Theme.of(context).colorScheme.genelRenk,
    textColor: Colors.white,
    buttonText: buttonText,
    onTap: _createButtonOnTap,
  );


  Widget get _accountName => TextFormField(
        maxLength: textFormFieldMaxLength,
        style: textFormFieldTextStyle,
        decoration: _customInputDecorationTextField(accountNameText),
        validator: textFormFieldValidator,
        onSaved: (text) {
          accountName = text;
        },
      );

  Widget get _emailTextField => TextFormField(
        maxLength: textFormFieldMaxLength,
        style: textFormFieldTextStyle,
        decoration: _customInputDecorationTextField(mailLabelText),
        validator: textFormFieldValidator,
        onSaved: (text) {
          accountMail = text;
        },
      );

  Widget get _passwordTextField => TextFormField(
        maxLength: textFormFieldMaxLength,
        maxLengthEnforced: true,
        obscureText: obscureTextPassword,
        style: textFormFieldTextStyle,
        decoration: _customInputDecorationPasswordTextField,
        validator: textFormFieldValidator,
        onSaved: (text) {
          accountPass = text;
        },
      );

  TextStyle get textFormFieldTextStyle => Theme.of(context).textTheme.bodyText1;

  InputDecoration get _customInputDecorationPasswordTextField {
    return context.customInputDecoration(
      passwordLabelText,
      color: Theme.of(context).colorScheme.genelRenk,
      suffixIcon: textFieldIcon,
    );
  }

  InputDecoration _customInputDecorationTextField(String text) {
    return context.customInputDecoration(
      text,
      color: Theme.of(context).colorScheme.genelRenk,
    );
  }

  IconButton get textFieldIcon {
    return IconButton(
      icon: obscureTextPassword
          ? Icon(Icons.remove_red_eye)
          : Icon(Icons.lock_outline),
      onPressed: passwordTextFieldOnTap,
    );
  }

  passwordTextFieldOnTap() {
    setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }

  void _createButtonOnTap() async{
    final _passwordSave =
        Provider.of<PasswordSaveViewModel>(context, listen: false);
    bool result = false;
    Account account;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      account = Account(accountName, accountMail, accountPass,
          widget.folder.folderID, widget.folder.folderName);
      result = await _passwordSave.saveAccount(account);

      if(result){
        Navigator.pop(context);
      }
    }

  }

  String textFormFieldValidator(text) {
    if (text.length < textFormFieldMinLength) {
      return textTooShort;
    } else if (text.length > textFormFieldMaxLength) {
      return textTooLong;
    } else {
      return null;
    }
  }
}
