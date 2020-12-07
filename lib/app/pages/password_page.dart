import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  final Account account;

  const PasswordPage({Key key, this.account}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String accountName, accountPass, accountMail;
  final String title = "Pass Name";
  final String passwordLabetText = "Şifre";
  final String accountNameLabetText = "Hesap Adi";
  final String mailLabetText = "Mail";
  final String buttonText = "Değişikliği kaydet";
  bool obscureTextPassword = true;
  bool chance = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountName = widget.account.accountName;
    accountPass = widget.account.accountPassword;
    accountMail = widget.account.accountEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.appBar(
        title,
        leading: _appBarLeading,
      ),
      body: Padding(
        padding: context.paddingAllLowMedium,
        child: _body,
      ),
    );
  }

  Widget get _body => Form(
        key: _formKey,
        child: Column(
          children: [
            _accountNameTextField,
            context.emptylowMediumValueWidget,
            _mailTextField,
            context.emptylowMediumValueWidget,
            _passwordTextField,
            context.emptylowMediumValueWidget,
            _createButton,
          ],
        ),
      );

  Widget get _appBarLeading => IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: onWillPop,
      );

  Text get _createButtonContainerText => Text(buttonText,
      style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white));

  Widget get _createButton => RaisedButton(
        color: Theme.of(context).colorScheme.genelRenk,
        onPressed: _saveChanceButtonOnTap,
        child: _createButtonContainer,
      );

  Widget get _createButtonContainer => Container(
        width: context.width,
        alignment: Alignment.center,
        child: _createButtonContainerText,
      );

  TextFormField get _accountNameTextField => TextFormField(
        decoration: _inputDecoration(accountNameLabetText),
        initialValue: accountName,
        onSaved: (String txt) {
          accountName = txt;
        },
        onChanged: (String txt) => chance = true,
      );

  TextFormField get _mailTextField => TextFormField(
        decoration: _inputDecoration(mailLabetText),
        initialValue: accountMail,
        onSaved: (String txt) {
          accountMail = txt;
        },
        onChanged: (String txt) => chance = true,
      );

  TextFormField get _passwordTextField => TextFormField(
        initialValue: accountPass,
        obscureText: obscureTextPassword,
        onSaved: (String txt) {
          accountPass = txt;
        },
        onChanged: (String txt) => chance = true,
        decoration:
            _inputDecoration(passwordLabetText, suffixIcon: textFieldIcon),
      );

  InputDecoration _inputDecoration(String text, {Widget suffixIcon}) =>
      context.customInputDecoration(
        text,
        color: Theme.of(context).colorScheme.genelRenk,
        errorMaxLines: 10,
        suffixIcon: suffixIcon,
      );

  IconButton get textFieldIcon => IconButton(
        icon: obscureTextPassword
            ? getIcon(
                Icons.remove_red_eye,
              )
            : getIcon(Icons.lock_outline),
        onPressed: passwordTextFieldOnTap,
      );

  Icon getIcon(IconData icon) => Icon(
        icon,
        color: Theme.of(context).colorScheme.genelRenk,
      );

  onWillPop() {
    if (chance) {
      MyCustomDialog(
        content: Text(
            "Değişikliği kaydetmediniz çıkmak istemediğinize emin misiniz"),
        actions: onWillPopButtonBar,
      ).goster(context);
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  List<Widget> get onWillPopButtonBar {
    final String comeBackButtonText = "Kaydetmeden Çık";
    final String cancelButtonText = "Vazgeç";
    return [
      ButtonBar(
        children: [
          ButtonBar(
            children: [
              RaisedButton(
                child: Text(comeBackButtonText),
                color: Theme.of(context).colorScheme.genelRenk,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text(cancelButtonText),
                color: Theme.of(context).colorScheme.genelRenk,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    ];
  }

  passwordTextFieldOnTap() {
    setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }

  _saveChanceButtonOnTap() {
    final _passwordViewModel =
        Provider.of<PasswordSaveViewModel>(context, listen: false);
    if (chance) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        _passwordViewModel.updateAccount(
          widget.account,
          Account(
            accountName,
            accountMail,
            accountPass,
            widget.account.accountCreateTime,
            widget.account.folderID,
            widget.account.folderName,
          ),
        );
      }
    }
  }
}
