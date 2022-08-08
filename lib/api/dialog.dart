import 'package:flutter/material.dart';

class Dialogs {
  static showErrorDialog(BuildContext context,
      {@required String message, @required int code}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
          title: Text('error $code'),
          content: Text(message ?? 'Your Request is failed'),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
