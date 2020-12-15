import 'package:flutter/material.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';

class MyCustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  const MyCustomButton({
    Key key,
    @required this.onTap,
    this.buttonText,
    this.buttonColor: Colors.white,
    this.textColor: Colors.redAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      child: buildRaisedButton(context),
    );
  }

  RaisedButton buildRaisedButton(BuildContext context) {
    return RaisedButton(
      onPressed: onTap,
      child: buildText(context),
      color: buttonColor,
      shape: roundedRectangleBorder(context),
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
