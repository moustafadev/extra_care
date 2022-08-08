import 'dart:convert';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:extra_care/screens/contact/contact.dart';
import 'package:extra_care/screens/notification/notification.dart';
import 'package:extra_care/screens/orders/myOrder.dart';
import 'package:extra_care/screens/profile/changeLang.dart';
import 'package:extra_care/screens/profile/myPoints.dart';
import 'package:extra_care/screens/profile/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/globals.dart' as globals;
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/consts.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appBarWithArrow(context, getTranslated(context, 'myP')),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .15,
                            //alignment: Alignment.center,
                            child: Image.asset('assets/images/scroll.jpg',
                                fit: BoxFit.fill),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          getTranslated(context, 'myAcc'),
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProfileScreen()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'ep'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyCartScreen()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'myCart'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyOrder()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.wallet_travel,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'order'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyPoints()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.person_pin,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'point'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          getTranslated(context, 'set'),
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationScreen()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.notifications,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'noti'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChangeLanguage()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.language,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'lang'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Contact()));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.info,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'us'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  log(context);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: Constants.greenColor(),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      getTranslated(context, 'out'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
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

  dynamic log(BuildContext context) async {
    final response = await logout();
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      final prefs = await SharedPreferences.getInstance();
      globals.resetUserData();
      //FirebaseMessaging().deleteInstanceID();
      await prefs.clear();
      //MyApp.restartApp(context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
    } else {
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  // dynamic log(BuildContext context) async {
  //   final response = await logout();
  //   var res = json.decode(response.body);

  //   if (res['status'] == 1) {
  //     // Reusable.dismissLoading();
  //     //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
  //     final prefs = await SharedPreferences.getInstance();
  //     globals.resetUserData();

  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => SplashScreen()),
  //         (route) => false);
  //     prefs.clear();
  //   } else {
  //     Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
  //   }
  // }
}
