import 'package:flutter/material.dart';

class Helper {
  static DateTime get getDateTimeNow => DateTime.now();

  static showDefaultSnackBar(BuildContext context, String txt) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Row(
          children: <Widget>[
            Icon(Icons.thumb_up),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(txt),
            ),
          ],
        ),
      ),
    );

}
