import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;

  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  ThemeData get theme => Theme.of(this);
}

extension NumberExtension on BuildContext {
  double get lowValue => dynamicHeight(0.003);

  double get lowMediumValue => dynamicHeight(0.015);

  double get mediumValue => dynamicHeight(0.005);

  double get highValue => dynamicHeight(0.05);
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingAllLowValue => EdgeInsets.all(lowValue);

  EdgeInsets get paddingHorizontalLowValue =>
      EdgeInsets.symmetric(horizontal: lowMediumValue);

  EdgeInsets get paddingAllLowMedium => EdgeInsets.all(lowMediumValue);

  EdgeInsets get paddingAllhigh => EdgeInsets.all(highValue);

  EdgeInsets get paddingHighOnlyTop => EdgeInsets.only(top: highValue);

  EdgeInsets get titleTextPadding => EdgeInsets.only(left: lowMediumValue);
}

extension DividergExtension on BuildContext {
  Widget get customHighDivider => Divider(
        color: Colors.black,
        height: 30,
      );

  Widget get customLowDivider => Divider(
        color: Colors.black,
        height: lowValue,
      );
}

extension InputDecorationExtension on BuildContext {
  InputDecoration customInputDecoration(String labelText,
      {Widget suffixIcon,
      Color color: Colors.white,
      int errorMaxLines,
      Color enableBorderColor: Colors.deepOrange}) {
    return InputDecoration(
      errorMaxLines: errorMaxLines,
      labelStyle: TextStyle(color: color),
      labelText: labelText,
      alignLabelWithHint: true,
      //prefixIcon: icon,
      focusColor: color,
      suffixIcon: suffixIcon,
      focusedBorder: outlineInputBorder(color: enableBorderColor),
      enabledBorder: outlineInputBorder(color: color),
      border: outlineInputBorder(),
    );
  }

  OutlineInputBorder outlineInputBorder({Color color: Colors.white}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: borderLowRadiusHCircular,
    );
  }
}

extension BoxDecorationExtension on BuildContext {
  BoxDecoration get boxDecoration => BoxDecoration(
        color: Colors.white,
        /* gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.mirror,
              colors: [
                Theme.of(context).colorScheme.hexToColor("#0F2027"),
                Theme.of(context).colorScheme.hexToColor("#203A43"),
                Theme.of(context).colorScheme.hexToColor("#2C5364"),
              ],
            ),*/
        borderRadius: borderHighRadiusHCircular,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      );

  BorderRadius get borderHighRadiusHCircular => BorderRadius.circular(30.0);

  BorderRadius get borderLowRadiusHCircular => BorderRadius.circular(10.0);
}

extension EmptyWidget on BuildContext {
  Widget get emptylowMediumValueWidget => SizedBox(height: lowMediumValue);

  Widget get emptyMediumValueWidget => SizedBox(height: mediumValue);
}
