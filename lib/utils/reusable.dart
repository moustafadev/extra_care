import 'dart:convert';
import 'package:extra_care/global/globals.dart' as globals;
import 'package:extra_care/api/models/auth.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/login.dart';
import 'package:extra_care/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';

class Reusable {
  FToast fToast;

  static void clearUserData(BuildContext context) {
    SharedPreferences.getInstance().then((value) => value.clear());
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
  }

  static Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ignore: non_constant_identifier_names
  static InitScreenDims(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        Orientation.portrait,
        designSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        allowFontScaling: true);
  }

  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Widget sperator(
      {double width, double height, Color color, bool horizontal = true}) {
    return horizontal
        ? Container(
            width: width != null ? width : double.infinity,
            height: 0.5,
            color: color != null ? color : Colors.grey.withOpacity(0.8),
          )
        : Container(
            width: 0.5,
            height: height,
            color: color != null ? color : Colors.grey.withOpacity(0.8),
          );
  }

  static Widget showLoader(bool _load,
      {double width = double.infinity, double height = double.infinity}) {
    Widget loadingIndicator = _load
        ? new Container(
            color: Colors.white,
            width: width,
            height: height,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(
                    child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(MyColors.primary),
                ))),
          )
        : new Container();

    return loadingIndicator;
  }

  static Widget noData({double height = 100, String msg = "لا توجد بيانات"}) {
    return Container(
        child: Text(
          msg,
          style: TextStyle(color: Colors.black),
        ),
        alignment: Alignment.center,
        height: height);
  }

  static Widget showMsg(String msg, {double height = double.infinity}) {
    return new Container(
      color: Colors.white,
      width: double.infinity,
      height: height,
      child: new Padding(
          padding: const EdgeInsets.all(5.0),
          child: new Center(
              child: Text(
            msg,
            style: TextStyle(
              color: MyColors.appBlack,
              fontFamily: "Segoe",
            ),
          ))),
    );
  }

  static void showError(String msg,
      {ToastGravity gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showToast(String msg,
      {ToastGravity gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // static void skip(BuildContext context){
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
  //     return MainScreen();
  //   }));
  // }

  static Widget mustLogin(BuildContext context,
      {width = double.infinity, height = double.infinity}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You have to SignIn First !",
            style: TextStyle(color: Colors.grey),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
              child: Text(
                "SignIn",
                style: TextStyle(
                  color: MyColors.primary,
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: MyColors.primary)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false);
              })
        ],
      ),
    );
  }

  // static Future<UserData> getUser(BuildContext context) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   print("UserName ${prefs.getString("name")}");
  //   return UserData(
  //       prefs.getInt("id"),
  //       prefs.getString("name"),
  //       prefs.getString("email"),
  //       prefs.getString("imagePath"),
  //       prefs.getString("gender"),
  //       prefs.getString("nationality"),
  //       prefs.getString("cityName"),
  //       prefs.getString("countryName"),
  //       prefs.getString("phone"),
  //       prefs.getString("token"),
  //       prefs.getInt("userType")
  //   );
  // }

  static Future clearPrefs(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
  }

  static Widget errorDialog(
      BuildContext context, double width, double height, List<String> error) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        Orientation.portrait,
        designSize: Size(width, height),
        allowFontScaling: true);

    List<Widget> errors = [];

    for (String i in error) {
      errors.add(
        Text(
          i,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(12.0),
              color: Colors.red,
//            fontFamily: lan == "en" ? "Poppins" : "Arabic",
              fontFamily: "Segoe",
              decoration: TextDecoration.none),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: width * 0.8,
        width: width * 0.8,
        child: Padding(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Error",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(15.0),
                        color: Colors.red,
                        fontFamily: "Segoe",
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                  Column(
                    children: errors,
                  ),
                ],
              ),
              Align(
                child: GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                alignment: Alignment.topRight,
              ),
            ],
            alignment: Alignment.center,
          ),
          padding: EdgeInsets.all(width * 0.03),
        ),
      ),
    );
  }

  static void showLoading(BuildContext context) {
    EasyLoading.show(
        status: getTranslated(context, 'loading'),
        maskType: EasyLoadingMaskType.black);
  }

  static void dismissLoading() {
    EasyLoading.dismiss();
  }

  static Future<LoginModel> getUserModel() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('User_Data') != null) {
      globals.userData = json.decode(prefs.getString('User_Data'))['data'];
      LoginModel userModel =
          LoginModel.fromJson(json.decode(prefs.getString('User_Data')));
      globals.userModel = userModel;
      return userModel;
    } else {
      return null;
    }
  }
}
