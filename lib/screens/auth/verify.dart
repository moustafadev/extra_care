import 'dart:convert';
import 'dart:io';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';

import '../../global/globals.dart' as globals;
import 'package:device_info/device_info.dart';
import 'package:extra_care/api/models/auth.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/login.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';

class VeryfiyScreen extends StatefulWidget {
  final String mail;

  const VeryfiyScreen({Key key, this.mail}) : super(key: key);
  @override
  _VeryfiyScreenState createState() => _VeryfiyScreenState();
}

class _VeryfiyScreenState extends State<VeryfiyScreen> {
  bool verify = false;
  String code;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          // title: Text(
          //   getTranslated(context, 'verify'),
          //   style: TextStyle(color: Constants.skyColor(), fontSize: 18),
          // ),
          elevation: 0,
          leading: null,
          // new IconButton(
          //   icon: new Icon(Icons.arrow_back, color: Colors.black),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        backgroundColor: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        getTranslated(context, 'validate'),
                        style: TextStyle(
                            color: Constants.skyColor(), fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(18.0),
                    //   child: Text(
                    //     getTranslated(context, 'recev'),
                    //     style: TextStyle(color: Colors.black, fontSize: 12),
                    //   ),
                    // ),
                    Container(
                      alignment: Alignment.center,
                      child: _inputFields(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: (code == '' || code == null)
                                  ? Colors.grey
                                  : Constants.skyColor(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              getTranslated(context, 'very'),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          onTap: () async {
                            if (code == "" || code == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  getTranslated(context, 'false'),
                                  textAlign: TextAlign.center,
                                  style:
                                      Constants.fontLight(color: Colors.white),
                                ),
                              ));
                            } else {
                              acceptTask();
                            }
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        acceptReset();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'resend'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          // Text(
                          //   getTranslated(context, 'sec'),
                          //   style: TextStyle(
                          //     color: Constants.whiteColor(),
                          //     fontSize: 15,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> resetRequest() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    //Reusable.showLoading(context);
    final bodyApi = {
      'email': widget.mail,
    };
    http.Response response = await http.post(
        Uri.parse(
            'https://chromateck.com/laurus/api/v1/send-pin-code?lang=$languageCode'),
        body: bodyApi);
    return response;
  }

  dynamic acceptReset() async {
    Reusable.showLoading(context);

    final response = await resetRequest();
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //resetDialog(context);
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future<dynamic> acceptRequest() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    String fcmToken = _pref.getString('fcmToken');
    String deviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    //Reusable.showLoading(context);
    final bodyApi = {
      'email': widget.mail,
      'pin_code': code.toString(),
      'token': fcmToken,
      'serial_number': deviceId,
      'os': Platform.isAndroid ? 'android' : 'ios'
    };
    http.Response response = await http.post(
        Uri.parse(
            'https://chromateck.com/laurus/api/v1/active-account?lang=$languageCode'),
        body: bodyApi);
    return response;
  }

  dynamic acceptTask() async {
    // ignore: unused_local_variable
    var headers;
    Reusable.showLoading(context);

    final response = await acceptRequest();
    var res = json.decode(response.body);
    LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));
    if (res['status'] == 1) {
      Reusable.dismissLoading();
      globals.userData = res['data'];
      globals.userModel = loginModel;
      this._save(json.encode(res));
      print("user Id is = ${res['data']['user']['id']}");

      SharedPreferences.getInstance().then((value) {
        value.setBool("islog", true);
        value.setString('token', loginModel.data.token);
        print('thetoken' + value.getString('token'));
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomTabScreen()),
          (route) => false);
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  _save(value) async {
    print(value.toString());
    final prefs = await SharedPreferences.getInstance();
    final key = 'User_Data';
    prefs.setString(key, value);
  }

  Future<String> verificationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'verify')),
            content: Text(getTranslated(context, 'verifyContent')),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(getTranslated(context, 'ok')),
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
              ),
            ],
          );
        });
  }

  Widget _inputFields() {
    // return VerificationCode(
    //   textStyle: TextStyle(
    //     fontSize: 26.0,
    //     color: Colors.white,
    //   ),
    //   keyboardType: TextInputType.number,
    //   // in case underline color is null it will use primaryColor: Colors.red from Theme
    //   underlineColor: Colors.amber,
    //   length: 4,
    //   // clearAll is NOT required, you can delete it
    //   // takes any widget, so you can implement your design
    //   clearAll: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Text(
    //       'clear all',
    //       style: TextStyle(
    //           fontSize: 14.0,
    //           decoration: TextDecoration.underline,
    //           color: Colors.blue[700]),
    //     ),
    //   ),
    //   onCompleted: (String value) {
    //     setState(() {
    //       verify = true;
    //       code = value;
    //     });
    //   },
    //   onEditing: (bool value) {
    //     // setState(() {
    //     //   _onEditing = value;
    //     // });
    //     // if (!_onEditing) FocusScope.of(context).unfocus();
    //   },
    // );
    return VerificationCodeInput(
      keyboardType: TextInputType.number,
      itemDecoration: BoxDecoration(
          color: Constants.skyColor(),
          shape: BoxShape.rectangle,
          border: Border.all(color: Constants.skyColor()),
          borderRadius: BorderRadius.circular(20)),
      textStyle: TextStyle(
        fontSize: 26.0,
        color: Colors.white,
      ),
      length: 4,
      itemSize: 50,
      onCompleted: (String value) {
        setState(() {
          verify = true;
          code = value;
        });
      },
    );
  }
}
