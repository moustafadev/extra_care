import 'dart:convert';

import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/reset.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/button.dart';
import 'package:extra_care/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../consts.dart';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  String userEmailText;
  bool isEnabled = false;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 23.0, right: 23.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: MediaQuery.of(context).size.height * .2,
                  child: Image.asset('assets/images/logo.png',
                      fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 40,
                ),
                forgetPasswordWidget(),
                SizedBox(
                  height: 30,
                ),
                textField(context, getTranslated(context, 'email'),
                    controller: emailController),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (emailController.value.text == "" ||
                        emailController.value.text == null) {
                    } else {
                      acceptTask();
                    }
                  },
                  child: button(
                      context,
                      getTranslated(context, 'send'),
                      emailController.value.text == "" ||
                              emailController.value.text == null
                          ? Colors.grey
                          : Constants.skyColor()),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgetPasswordWidget() {
    return Column(
      children: [
        Text(getTranslated(context, 'forgt'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: Constants.skyColor())),
        SizedBox(
          height: 10,
        ),
        Text(getTranslated(context, 'forgetText'),
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  resetDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Image.asset(
                    'assets/images/reset.png',
                    fit: BoxFit.fill,
                    color: Constants.skyColor(),
                    width: MediaQuery.of(context).size.width * .35,
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(getTranslated(context, 'reset'),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    getTranslated(context, 'confirm'),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen(
                                    mail: emailController.value.text,
                                  )),
                          (route) => false);
                    },
                    child: button(context, getTranslated(context, 'done'),
                        Constants.skyColor()),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> acceptRequest() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    //Reusable.showLoading(context);
    final bodyApi = {
      'email': emailController.value.text,
    };
    http.Response response = await http.post(
        Uri.parse(
            'https://chromateck.com/laurus/api/v1/send-pin-code?lang=$languageCode'),
        body: bodyApi);
    return response;
  }

  dynamic acceptTask() async {
    Reusable.showLoading(context);

    final response = await acceptRequest();
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      resetDialog(context);
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }
}
