import 'dart:convert';

import 'package:extra_care/api/models/branches.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/verify.dart';
import 'package:extra_care/widgets/button.dart';
import 'package:extra_care/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import '../../utils/reusable.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

PostpondModels _postpondModels = new PostpondModels();
BranchesData selectedBranch;

class SignUpScreenState extends State<SignUpScreen> {
  String selectedGender;
  String genderVal;
  bool passwordVisible = true;
  int branchID;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController matchPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    selectedBranch = null;
    super.initState();
    pospondReason().then((value) {
      setState(() {
        _postpondModels = value;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    matchPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/scroll.jpg',
                          fit: BoxFit.fill,
                          width: Reusable.getSize(context).width,
                          height: Reusable.getSize(context).height * .1,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: new Icon(Icons.arrow_back,
                                    color: Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      height: MediaQuery.of(context).size.height * .15,
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.contain),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23),
                      child: Column(
                        children: [
                          Text(getTranslated(context, 'create'),
                              style: TextStyle(
                                  //color: Main_Black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                          SizedBox(
                            height: 5,
                          ),
                          textField(context, getTranslated(context, 'name'),
                              controller: nameController),
                          SizedBox(
                            height: 10,
                          ),
                          genderDropDown(context),
                          SizedBox(
                            height: 10,
                          ),
                          textField(context, getTranslated(context, 'phone'),
                              controller: phoneController,
                              max: 11,
                              isPhoneKeyboard: true),
                          SizedBox(
                            height: 10,
                          ),
                          passwordWidget(),
                          SizedBox(
                            height: 10,
                          ),
                          matchPasswordWidget(),
                          SizedBox(
                            height: 10,
                          ),
                          textField(context, getTranslated(context, 'address'),
                              controller: addressController),
                          SizedBox(
                            height: 10,
                          ),
                          textField(context, getTranslated(context, 'email'),
                              controller: emailController),
                          SizedBox(
                            height: 10,
                          ),
                          _postpondModels != null &&
                                  _postpondModels.data != null &&
                                  _postpondModels.data.isNotEmpty
                              ? branchDropDown(context)
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (nameController.value.text == "") {
                                Reusable.showError(
                                    getTranslated(context, 'namee'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (selectedGender == null) {
                                Reusable.showError(
                                    getTranslated(context, 'gend'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (phoneController.value.text == "") {
                                Reusable.showError(
                                    getTranslated(context, 'mob'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (phoneController.value.text.length <
                                  11) {
                                Reusable.showError(
                                    getTranslated(context, 'length'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (passwordController.value.text == "") {
                                Reusable.showError(
                                    getTranslated(context, 'passw'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (matchPasswordController.value.text ==
                                  "") {
                                Reusable.showError(
                                    getTranslated(context, 'matchpass'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (addressController.value.text == "") {
                                Reusable.showError(
                                    getTranslated(context, 'addres'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (emailController.value.text == "") {
                                Reusable.showError(
                                    getTranslated(context, 'mail'),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (selectedBranch == null) {
                                Reusable.showError(
                                    getTranslated(context, 'bran'),
                                    gravity: ToastGravity.BOTTOM);
                              } else {
                                upload(context);
                              }
                            },
                            child: button(
                                context,
                                getTranslated(context, 'account'),
                                (selectedGender == null ||
                                        selectedGender == "" ||
                                        nameController.value.text == "" ||
                                        selectedBranch == null ||
                                        selectedBranch.trans.title == "" ||
                                        phoneController.value.text == "" ||
                                        emailController.value.text == "" ||
                                        addressController.value.text == "" ||
                                        passwordController.value.text == "" ||
                                        matchPasswordController.value.text ==
                                            "")
                                    ? Colors.grey
                                    : Constants.skyColor()),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  passwordWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
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
                  labelStyle: TextStyle(
                    color: Constants.skyColor(),
                    fontSize: 14,
                  ),
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

  matchPasswordWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
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
                  labelStyle: TextStyle(
                    color: Constants.skyColor(),
                    fontSize: 14,
                  ),
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
              controller: matchPasswordController,
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

  Widget genderDropDown(
    BuildContext context,
  ) {
    List<String> gender = <String>[
      getTranslated(context, 'male'),
      getTranslated(context, 'female'),
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGender,
          isExpanded: true,
          isDense: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: new Text(
              getTranslated(context, 'gender'),
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          items: gender.map((language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Text(
                  language,
                  style: TextStyle(
                    color: Constants.skyColor(),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value == getTranslated(context, 'male')) {
                setState(() {
                  genderVal = "male";
                  print(genderVal);
                });
              } else {
                setState(() {
                  genderVal = "female";
                  print(genderVal);
                });
              }
              selectedGender = value;
            });
          },
        ),
      ),
    );
  }

  Widget branchDropDown(
    BuildContext context,
  ) {
    //List<String> branches = <String>["Alex ", "Dokki", "Haram"];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BranchesData>(
          underline: Container(
            height: 0,
          ),
          isExpanded: true,
          isDense: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Text(getTranslated(context, 'near')),
          ),
          dropdownColor: Colors.white,
          value: selectedBranch,
          items: _postpondModels.data
              .map<DropdownMenuItem<BranchesData>>((BranchesData value) {
            return DropdownMenuItem<BranchesData>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: new Text(value.trans.title),
              ),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              selectedBranch = val;
              branchID = val.id;
              print(branchID);
            });
          },
        ),
      ),
    );
  }

  Future<PostpondModels> pospondReason() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(Language_Code);
    Reusable.showLoading(context);
    http.Response response = await http.get(
      Uri.parse(
          'https://chromateck.com/laurus/api/v1/home?type=branches&response_type=all&lang=$languageCode'),
    );
    Reusable.dismissLoading();
    return new PostpondModels.fromJson(json.decode(response.body));
  }

  Future<dynamic> upload(BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    var uri = Uri.parse(
        "https://chromateck.com/laurus/api/v1/register?lang=$languageCode");

    var request = new http.MultipartRequest("POST", uri);
    //request.headers.addAll(headers);

    request.fields['name'] = nameController.value.text;
    request.fields['phone'] = phoneController.value.text;
    request.fields['gender'] = genderVal;
    request.fields['email'] = emailController.value.text;
    request.fields['address'] = addressController.value.text;
    request.fields['branch_id'] = branchID.toString();
    request.fields['password'] = passwordController.value.text;
    request.fields['password_confirmation'] =
        matchPasswordController.value.text;

    Reusable.showLoading(context);
    //Reusable.dismissLoading();
    var response = await request.send();
    var responses = await http.Response.fromStream(response);
    print("responseData : " + responses.body);
    Map<String, dynamic> responseData = json.decode(responses.body);
    if (responseData['status'] == 1) {
      setState(() {
        Reusable.dismissLoading();
        // Reusable.showToast(responseData['massage'],
        //     gravity: ToastGravity.CENTER);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => VeryfiyScreen(
                      mail: emailController.value.text,
                    )),
            (route) => false);
      });
    } else if (responseData['status'] == 0) {
      String error = responseData['massage'];
      print('error massage' + error);
      Reusable.dismissLoading();
      maintanceDialog(context, error);
    } else if (responseData['status'] == -400) {
      String error = responseData['message'];
      print('error massage' + error);
      Reusable.dismissLoading();
      maintanceDialog(context, error);
    }
  }

  maintanceDialog(BuildContext context, error) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(error),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(getTranslated(context, 'ok')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
