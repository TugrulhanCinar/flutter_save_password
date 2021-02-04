import 'package:flutter/material.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';

class MyCustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Widget child;
  final Color buttonColor;
  final Color textColor;
  final RoundedRectangleBorder shapeBorder;

  const MyCustomButton({
    Key key,
    @required this.onTap,
    this.buttonText,
    this.buttonColor: Colors.white,
    this.textColor: Colors.redAccent,
    this.shapeBorder,
    this.child,
  }) : assert(
          child == null || buttonText == null,
          "Both Child and Button Text cannot be used at the same time.",
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      child: buildRaisedButton(context),
    );
  }

  Widget buildRaisedButton(BuildContext context) {

    return MaterialButton(
      child: child == null ? buildText(context) : child,
      onPressed: onTap,
      color: buttonColor,
      //todo shape seçeneği ekle

    );
  }

  Text buildText(BuildContext context) {
    return Text(
      buttonText,
      style: buildTextStyle(context),
    );
  }

  TextStyle buildTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        );
  }

  RoundedRectangleBorder roundedRectangleBorder(BuildContext context) =>
      RoundedRectangleBorder(borderRadius: context.borderHighRadiusHCircular);
}
