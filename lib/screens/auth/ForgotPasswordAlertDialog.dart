import 'package:extra_care/screens/auth/login.dart';
import 'package:extra_care/screens/auth/utilityMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../appConstatnt.dart';

class SingleActionAlert {
  int noOfPop;
  bool refreshOnPop; //To update UI after pop from alert
  final String message;
  final String buttonTitle;
  final Function buttonAction;
  final BuildContext context;

  SingleActionAlert(
      {this.message,
      this.buttonTitle,
      this.buttonAction,
      @required this.context,
      this.noOfPop,
      this.refreshOnPop}); //: assert(buttonAction == null || noOfPop == null);

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: alertView,
    );
  }

  Widget alertView(BuildContext context) {
    return Container(
      width: 100,
      height: 300,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        // title: Image.asset(
        //   'assets/ic_warningpopup.png',
        //   height: 60,
        //   width: 60,
        // ),
        content: alertContent(context),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      ),
    );
  }

  SingleChildScrollView alertContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          alertMessage(),
          SizedBox(height: 20),
          alertActions(context),
        ],
      ),
    );
  }

  Text alertMessage() {
    return Text(
      message ?? "",
      textAlign: TextAlign.center,
      style: normalTextStyle,
    );
  }

  Widget alertActions(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      child: Text(
        buttonTitle,
        style: getAlertButtonTextStyle(context),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        // (buttonAction != null) ? buttonAction() : handleMultiPopAction();
      },
    );
  }

  handleMultiPopAction() {
    noOfPop = noOfPop ?? 1;
    for (int i = 0; i < noOfPop; i++) {
      refreshOnPop == true
          ? Navigator.of(context, rootNavigator: true).pop(true)
          : Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
}
