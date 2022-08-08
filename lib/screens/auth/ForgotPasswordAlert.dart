import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordAlert extends StatefulWidget {
  @override
  ForgotPasswordAlertState createState() => ForgotPasswordAlertState();
}

class ForgotPasswordAlertState extends State<ForgotPasswordAlert> {
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    // ignore: unused_element
    showAlert(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(children: [
              Image.network(
                'https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              Text('  Alert Dialog Title. ')
            ]),
            content: Text("Are You Sure Want To Proceed?"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("YES"),
                onPressed: () {
                  //Put your code here which you want to execute on Yes button click.
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("CANCEL"),
                onPressed: () {
                  //Put your code here which you want to execute on Cancel button click.
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
