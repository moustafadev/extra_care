import 'dart:convert';
import 'dart:io';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:extra_care/api/models/auth.dart';
import '../../global/globals.dart' as globals;
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/ForgotPassword.dart';
import 'package:extra_care/screens/auth/SignUpScreen.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extra_care/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import '../../utils/reusable.dart';

class LoginScreenForCart extends StatefulWidget {
  @override
  _LoginScreenStateForCart createState() => _LoginScreenStateForCart();
}

class _LoginScreenStateForCart extends State<LoginScreenForCart> {
  TextEditingController cellPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;

  @override
  void dispose() {
    super.dispose();
    cellPhoneController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Reusable.InitScreenDims(context);
    return SafeArea(
      child: Container(
        child: Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                              height: Reusable.getSize(context).height * .14,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: new Icon(Icons.arrow_back,
                                        color: Colors.black),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12),
                                    child: InkWell(
                                        onTap: () async {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();

                                          preferences.setBool("islog", false);
                                          // await productProvider
                                          //     .getAllCategoryList();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomTabScreen()));
                                        },
                                        child: Text(
                                          getTranslated(context, 'skip'),
                                          style: TextStyle(
                                              color:
                                                  Constants.lightBlackColor(),
                                              fontSize: 16),
                                        )),
                                  )
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
                          height: 2,
                        ),
                        Text(
                          getTranslated(context, 'loginTo'),
                          style: TextStyle(
                              color: Constants.hintColor(), fontSize: 17),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 15, right: 15, bottom: 3),
                          child: Container(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  emailWidget(),
                                  SizedBox(height: 10),
                                  passwordWidget(),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      if (cellPhoneController.value.text !=
                                              "" &&
                                          passwordController.value.text != "") {
                                        login(context);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: getTranslated(context, 'msg'),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.sp);
                                      }
                                    },
                                    child: button(
                                        context,
                                        getTranslated(context, 'login'),
                                        Constants.skyColor()),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    getTranslated(context, 'or'),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                      onTap: () {
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         AppbarWithBottomNavigationWidget()));
                                      },
                                      child: button(
                                          context,
                                          getTranslated(context, 'fb'),
                                          Constants.blueColor())),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: Text(
                                      getTranslated(context, 'forget'),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Constants.skyColor(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8, bottom: 8, left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                getTranslated(context, 'dont'),
                                style: TextStyle(
                                    color: Constants.greyColor(), fontSize: 17),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                  child: Text(
                                    getTranslated(context, 'signup'),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Constants.skyColor(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  _save(value) async {
    print(value.toString());
    final prefs = await SharedPreferences.getInstance();
    final key = 'User_Data';
    prefs.setString(key, value);
  }

  emailWidget() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * .07,
      decoration: BoxDecoration(
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: TextFormField(
          maxLines: 1,
          maxLength: 11,
          onChanged: (String txt) {},
          style: TextStyle(
            fontSize: 16,
          ),
          cursorColor: Constants.blueColor(),
          decoration: new InputDecoration(
            errorText: null,
            counterText: "",
            border: InputBorder.none,
            hintText: getTranslated(context, 'phone'),
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          controller: cellPhoneController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  passwordWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Constants.textFieldColor(),
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: MediaQuery.of(context).size.height * .07,
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

  void showPassword() {
    setState(() {
      {
        passwordVisible = !passwordVisible;
      }
    });
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
      'phone': cellPhoneController.value.text,
      'password': passwordController.value.text,
      'token': fcmToken,
      'serial_number': deviceId,
      'os': Platform.isAndroid ? 'android' : 'ios',
      'lang': languageCode
    };
    print("FCM Token" + fcmToken);
    http.Response response = await http.post(
        Uri.parse(
            'https://chromateck.com/laurus/api/v1/login?lang=$languageCode'),
        body: bodyApi);
    return response;
  }

  Future login(BuildContext context) async {
    Reusable.showLoading(context);

    final response = await acceptRequest();
    var res = json.decode(response.body);

    if (res['status'] == 0) {
      Reusable.dismissLoading();
      Fluttertoast.showToast(
          msg: res['massage'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.sp);
      print('error msg' + res['massage']);
    } else if (res['status'] == 1) {
      LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));
      globals.userData = res['data'];
      globals.userModel = loginModel;
      this._save(json.encode(res));
      print("user Id is = ${res['data']['user']['id']}");

      SharedPreferences.getInstance().then((value) {
        value.setBool("islog", true);
        value.setString('token', loginModel.data.token);
        print('thetoken' + value.getString('token'));
      });
      Reusable.dismissLoading();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyCartScreen()),
          (route) => false);
      // Fluttertoast.showToast(
      //     msg: json.decode(loginRequest.body)['massage'],
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.greenAccent,
      //     textColor: Colors.white,
      //     fontSize: 16.sp);

      print('error msg' + res['massage']);
    }
  }
}
