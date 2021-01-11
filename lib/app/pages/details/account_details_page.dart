import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class AccountDetailPage extends StatefulWidget {
  final Account account;

  const AccountDetailPage({Key key, @required this.account}) : super(key: key);

  @override
  _AccountDetailPageState createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  final String appBarTitle = "Hesap Ekle";
  bool obscureTextPassword = true;
  final buttonText = "Güncelle";
  final mailLabelText = "Mail";
  final accountNameText = "Hesap Adı";
  final passwordLabelText = "Şifre";
  final String textTooLong = "Girilen metin fazla uzun";
  final String textTooShort = "En az 1 karakter girmelisiniz";
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String accountName, accountMail, accountPass;
  int textFormFieldMaxLength = 40;
  int textFormFieldMinLength = 1;

  @override
  void initState() {
    super.initState();
    accountName = widget.account.accountName;
    accountMail = widget.account.accountEmail;
    accountPass = widget.account.accountPassword;
  }

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

  Widget get _accountName => TextFormField(
        maxLength: textFormFieldMaxLength,
        initialValue: accountName,
        style: textFormFieldTextStyle,
        decoration: _customInputDecorationTextField(accountNameText),
        onSaved: (text) {
          accountName = text;
        },
      );

  Widget get _emailTextField => TextFormField(
        maxLength: textFormFieldMaxLength,
        initialValue: accountMail,
        style: textFormFieldTextStyle,
        decoration: _customInputDecorationTextField(mailLabelText),
        validator: textFormFieldValidator,
        onSaved: (text) {
          accountMail = text;
        },
      );

  Widget get _passwordTextField => TextFormField(
        maxLength: textFormFieldMaxLength,
        initialValue: accountPass,
        obscureText: obscureTextPassword,
        validator: textFormFieldValidator,
        style: textFormFieldTextStyle,
        decoration: _customInputDecorationPasswordTextField,
        onSaved: (text) {
          accountPass = text;
        },
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

  Widget get _createButtonContainerText => Text(
        buttonText,
        style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white),
      );

  InputDecoration get _customInputDecorationPasswordTextField {
    return context.customInputDecoration(
      passwordLabelText,
      color: Theme.of(context).colorScheme.genelRenk,
      suffixIcon: textFieldIcon,
    );
  }

  String textFormFieldValidator(String text) {
    if (text.length < textFormFieldMinLength) {
      return textTooShort;
    } else if (text.length > textFormFieldMaxLength) {
      return textTooLong;
    } else {
      return null;
    }
  }

  InputDecoration _customInputDecorationTextField(String text) {
    return context.customInputDecoration(
      text,
      color: Theme.of(context).colorScheme.genelRenk,
    );
  }

  TextStyle get textFormFieldTextStyle => Theme.of(context).textTheme.bodyText1;

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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Account newAccount = widget.account;
      newAccount.accountName = accountName;
      newAccount.accountPassword = accountPass;
      newAccount.accountEmail = accountMail;
      await Provider.of<PasswordSaveViewModel>(context, listen: false)
          .updateAccount(widget.account, newAccount);
      Navigator.pop(context);
    }
  }
}
