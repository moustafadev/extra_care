import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/login.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mail;

  const ResetPasswordScreen({Key key, this.mail}) : super(key: key);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String errorMessage = '';

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: null,
          //  new IconButton(
          //   icon: new Icon(Icons.arrow_back, color: Colors.black),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        backgroundColor: Colors.white,
        key: _scaffoldkey,
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        height: MediaQuery.of(context).size.height * .2,
                        child: Image.asset('assets/images/logo.png',
                            fit: BoxFit.contain),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        getTranslated(context, 'reseet'),
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                pinCode(),
                                SizedBox(height: 10),
                                PasswordWidget(),
                                SizedBox(height: 10),
                                ConfirmPasswordWidget(),
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    if (pinController.value.text != '1111') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          getTranslated(context, 'false'),
                                          textAlign: TextAlign.center,
                                          style: Constants.fontLight(
                                              color: Colors.white),
                                        ),
                                      ));
                                    } else if (pinController
                                            .value.text.isEmpty ||
                                        passwordController.text.isEmpty ||
                                        confirmPasswordController
                                            .text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          getTranslated(context, 'fields'),
                                          textAlign: TextAlign.center,
                                          style: Constants.fontLight(
                                              color: Colors.white),
                                        ),
                                      ));
                                    } else {
                                      acceptTask();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: (pinController.value.text == "" ||
                                              passwordController.text == "" ||
                                              confirmPasswordController.text ==
                                                  "")
                                          ? Colors.grey
                                          : Constants.skyColor(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    child: Text(
                                      getTranslated(context, 'submit'),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> acceptRequest() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    print("Email" + widget.mail);

    //Reusable.showLoading(context);
    final bodyApi = {
      'email': widget.mail,
      'pin_code': pinController.value.text,
      'password': passwordController.value.text,
      'password_confirmation': confirmPasswordController.value.text,
    };

    http.Response response = await http.post(
        Uri.parse(
            'https://chromateck.com/laurus/api/v1/reset-password?lang=$languageCode'),
        body: bodyApi);
    return response;
  }

  dynamic acceptTask() async {
    Reusable.showLoading(context);

    final response = await acceptRequest();
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  validatae(String str) {
    print('str');
  }

  pinCode() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(38)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 48,
          child: Center(
            child: TextField(
              maxLines: 1,
              maxLength: 4,
              onChanged: (String txt) {},
              style: TextStyle(fontSize: 16, color: Constants.skyColor()),
              cursorColor: Constants.blueColor(),
              decoration: new InputDecoration(
                errorText: null,
                counterText: "",
                border: InputBorder.none,
                hintText: getTranslated(context, 'pin'),
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              controller: pinController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ConfirmPasswordWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(38)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 48,
          child: Center(
            child: TextField(
              maxLines: 1,
              onChanged: (String txt) {},
              style: TextStyle(fontSize: 16, color: Constants.skyColor()),
              cursorColor: Constants.blueColor(),
              decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: getTranslated(context, 'match'),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => {
                      showPassword(),
                    },
                  )),
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: passwordVisible,
              obscuringCharacter: "*",
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  PasswordWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(38)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 48,
          child: Center(
            child: TextField(
              maxLines: 1,
              onChanged: (String txt) {},
              style: TextStyle(fontSize: 16, color: Constants.skyColor()),
              cursorColor: Constants.blueColor(),
              decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: getTranslated(context, 'pass'),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => {
                      showPassword(),
                    },
                  )),
              controller: passwordController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: passwordVisible,
              obscuringCharacter: "*",
            ),
          ),
        ),
      ),
    );
  }

  void showPassword() {
    setState(() {
      {
        passwordVisible = !passwordVisible;
      }
    });
  }
}
