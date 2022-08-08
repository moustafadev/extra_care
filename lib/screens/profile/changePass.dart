import 'dart:convert';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:extra_care/widgets/drawer.dart';
import '../../consts.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool passwordVisible = true;
  String errorMessage = '';

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: drawer(context),
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
                      appBarWithArrow(
                          context, getTranslated(context, 'changePass')),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        getTranslated(context, 'resetPass'),
                        style: TextStyle(color: Colors.black, fontSize: 29),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                oldPasswordWidget(),
                                SizedBox(height: 20),
                                PasswordWidget(),
                                SizedBox(height: 20),
                                ConfirmPasswordWidget(),
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    if (confirmPasswordController.text == "" ||
                                        passwordController.text == "" ||
                                        oldPasswordController.text == "") {
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
                                      changePass();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: (confirmPasswordController
                                                  .text.isEmpty ||
                                              passwordController.text.isEmpty ||
                                              oldPasswordController
                                                  .text.isEmpty)
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

  dynamic changePass() async {
    if (passwordController.value.text == oldPasswordController.value.text) {
      Reusable.showToast(getTranslated(context, 'same'),
          gravity: ToastGravity.CENTER);
    } else {
      Reusable.showLoading(context);

      final response = await change(oldPasswordController.value.text,
          passwordController.value.text, confirmPasswordController.value.text);
      var res = json.decode(response.body);
      if (res['status'] == 1) {
        Reusable.dismissLoading();

        Reusable.showToast("done", gravity: ToastGravity.CENTER);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomTabScreen()),
            (route) => false);
      } else {
        Reusable.dismissLoading();
        // Reusable.showToast("false", gravity: ToastGravity.CENTER);
        Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      }
    }
  }

  // ignore: non_constant_identifier_names
  ConfirmPasswordWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 48,
          child: Center(
            child: TextField(
              maxLines: 1,
              onChanged: (String txt) {},
              style: TextStyle(
                fontSize: 16,
              ),
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
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 48,
          child: Center(
            child: TextField(
              maxLines: 1,
              onChanged: (String txt) {},
              style: TextStyle(
                fontSize: 16,
              ),
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

  oldPasswordWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: 48,
          child: Center(
            child: TextField(
              maxLines: 1,
              onChanged: (String txt) {},
              style: TextStyle(
                fontSize: 16,
              ),
              cursorColor: Constants.blueColor(),
              decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: getTranslated(context, 'old'),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => {
                      showPassword(),
                    },
                  )),
              controller: oldPasswordController,
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
