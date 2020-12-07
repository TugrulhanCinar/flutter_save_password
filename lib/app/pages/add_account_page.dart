import 'package:flutter/material.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class AddAccountPage extends StatefulWidget {
  final Folder folder;

  const AddAccountPage({Key key, this.folder}) : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final String appBarTitle = "Hesap Ekle";
  bool obscureTextPassword = true;
  final buttonText = "Oluştur";
  final mailLabelText = "Mail";
  final accountNameText = "Hesap Adı";
  final passwordLabelText = "Şifre";
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String accountName, accountMail, accountPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: context.appBar(appBarTitle),
      body: _columnBody,
    );
  }

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

  Widget get _createButton => RaisedButton(
        color: Theme.of(context).colorScheme.genelRenk,
        onPressed: _createButtonOnTap,
        child: _createButtonContainer,
      );

  Widget get _createButtonContainer => Container(
        width: context.width,
        alignment: Alignment.center,
        child: _createButtonContainerText,
      );

  Widget get _createButtonContainerText => Text(buttonText,
      style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white));

  Widget get _accountName => TextFormField(
        maxLength: 10,
        style: TextStyle(color: Colors.blueAccent),
        decoration: _customInputDecorationTextField(accountNameText),
        onSaved: (text) {
          accountName = text;
        },
      );

  Widget get _emailTextField => TextFormField(
        maxLength: 10,
        style: TextStyle(color: Colors.blueAccent),
        decoration: _customInputDecorationTextField(mailLabelText),
        onSaved: (text) {
          accountMail = text;
        },
      );

  Widget get _passwordTextField => TextFormField(
        maxLength: 10,
        maxLengthEnforced: true,
        obscureText: obscureTextPassword,
        style: TextStyle(color: Colors.blueAccent),
        decoration: _customInputDecorationPasswordTextField,
        onSaved: (text) {
          accountPass = text;
        },
      );

  InputDecoration get _customInputDecorationPasswordTextField {
    return context.customInputDecoration(
      passwordLabelText,
      color: Theme.of(context).colorScheme.genelRenk,
      errorMaxLines: 10,
      suffixIcon: textFieldIcon,
    );
  }

  InputDecoration _customInputDecorationTextField(String text) {
    return context.customInputDecoration(
      text,
      color: Theme.of(context).colorScheme.genelRenk,
      errorMaxLines: 10,
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

  void _createButtonOnTap() {

    final _passwordSave =
        Provider.of<PasswordSaveViewModel>(context, listen: false);
    Account account;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      account = Account(
        accountName,
        accountMail,
        accountPass,
        DateTime.now(),
        widget.folder.folderID,
        widget.folder.folderName
      );
      _passwordSave.saveAccount(account);
    }
  }
}
