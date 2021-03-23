import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/common__widget/custom_button.dart';
import 'package:flutter_save_password/app/helper/random_password.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';

class CreatePasswordPage extends StatefulWidget {
  @override
  _CreatePasswordPageState createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final String appBarTitle = "Şifre Yarat";
  final passwordLabelText = "Şifre";
  int textFormFieldMaxLength = 40;
  String randomPassword = "asfsadfsafdfasdsfda";
  bool passwordIsNull = true;
  final controller = TextEditingController();
  final RandomPasswordGenarator _genarator = RandomPasswordGenarator();

  @override
  void initState() {
    super.initState();
    _createPasswordButtonOnPressed();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar as PreferredSizeWidget?,
      body: _buildBody,
    );
  }

  Widget get _appBar => CustomAppBar(appBarTitle);

  Widget get _buildBody => Container(
        padding: context.paddingAllLowMedium,
        child: Column(
          children: [
            randomTextFormField,
            createPasswordButton,
          ],
        ),
      );

  MyCustomButton get createPasswordButton {
    return MyCustomButton(
            buttonText: "Yeni Şifre Oluştur",
            buttonColor: Theme.of(context).colorScheme.genelRenk,
            textColor: Theme.of(context).colorScheme.genelTextColorRenk,
            onTap: _createPasswordButtonOnPressed,
          );
  }


  Widget get randomTextFormField => TextField(
    controller: controller,
      maxLength: textFormFieldMaxLength,
      style: textFormFieldTextStyle,
      decoration: _customInputDecoration,
  );

  Widget get _copyPasswordIconButton => IconButton(
        icon: Icon(Icons.copy),
        onPressed: _copyPasswordIconButtonOnPressed,
      );

  InputDecoration get _customInputDecoration {
    return context.customInputDecoration(
      passwordLabelText,
      suffixIcon: _copyPasswordIconButton,
    );
  }

  TextStyle? get textFormFieldTextStyle => Theme.of(context).textTheme.bodyText2;

  _createPasswordButtonOnPressed() {
    controller.text = _genarator.getRandomString(16);
  }

  _copyPasswordIconButtonOnPressed() {
   Clipboard.setData(ClipboardData(text: controller.text));
  }
}
