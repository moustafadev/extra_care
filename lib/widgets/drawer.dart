import 'dart:convert';
import 'package:extra_care/main.dart';
import 'package:extra_care/screens/contact/contact.dart';
import 'package:extra_care/screens/notification/notification.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/screens/contact/aboutUs.dart';
import 'package:extra_care/screens/fav/favscreen.dart';
import 'package:extra_care/screens/home/branchesList.dart';
import 'package:extra_care/screens/orders/myOrder.dart';
import 'package:extra_care/screens/profile/myPoints.dart';
import 'package:extra_care/screens/profile/myProfile.dart';
import 'package:extra_care/screens/profile/setting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extra_care/screens/home/categories.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/login.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/material.dart';
import '../global/globals.dart' as globals;
import '../consts.dart';

Drawer drawer(BuildContext context, {isLog}) {
  return Drawer(
    child: Container(
      color: Constants.greenColor(),
      child: ListView(
        children: [
          globals.userData['token'] != null
              ? Container(
                  color: Constants.lightgreenColor(),
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      var isLog = preferences.getBool("islog");
                      isLog == false
                          ? Reusable.showToast(getTranslated(context, 'open'),
                              gravity: ToastGravity.CENTER)
                          : Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyProfile()));
                    },
                    child: new DrawerHeader(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 90,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                  ),
                                  child: globals.userData['user']
                                              ['attachment'] ==
                                          null
                                      ? Text(
                                          getTranslated(context, 'noPhoto'),
                                          style: TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Image.network(
                                            globals.userData['user']
                                                ['attachment'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                // Text(
                                //   "VIP",
                                //   style: TextStyle(
                                //       fontSize: 14, color: Colors.white70),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              globals.userData['user']['name'] == null
                                  ? ''
                                  : globals.userData['user']['name'],
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Text(
                            //   getTranslated(context, 'login'),
                            //   style:
                            //       TextStyle(fontSize: 14, color: Colors.white70),
                            // )
                          ],
                        ),
                      ),
                    )),
                  ),
                )
              : Container(
                  color: Constants.lightgreenColor(),
                  child: new DrawerHeader(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 70,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  //color: Constants.shadowColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/images/logo.png'),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // Text(
                              //   "VIP",
                              //   style: TextStyle(
                              //       fontSize: 14, color: Colors.white70),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              getTranslated(context, 'login'),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
          Container(
            color: Constants.greenColor(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BottomTabScreen()));
                  },
                  child: new ListTile(
                    leading: new IconButton(
                      icon: new Icon(Icons.home, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BottomTabScreen()));
                      },
                    ),
                    title: Text(
                      getTranslated(context, 'home'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesScreen()));
                  },
                  child: new ListTile(
                    leading: new IconButton(
                      icon: new Icon(Icons.category, color: Colors.white),
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CategoriesScreen()));
                      },
                    ),
                    title: Text(
                      getTranslated(context, 'cat'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    var isLog = preferences.getBool("islog");
                    isLog == false
                        ? Reusable.showToast(getTranslated(context, 'open'),
                            gravity: ToastGravity.CENTER)
                        : Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyOrder()));
                  },
                  child: new ListTile(
                    leading: new IconButton(
                      icon: new Icon(Icons.local_post_office,
                          color: Colors.white),
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        var isLog = preferences.getBool("islog");
                        isLog == false
                            ? Reusable.showToast(getTranslated(context, 'open'),
                                gravity: ToastGravity.CENTER)
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyOrder()));
                      },
                    ),
                    title: Text(
                      getTranslated(context, 'order'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    var isLog = preferences.getBool("islog");
                    isLog == false
                        ? Reusable.showToast(getTranslated(context, 'open'),
                            gravity: ToastGravity.CENTER)
                        : Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyPoints()));
                  },
                  child: new ListTile(
                    leading: new IconButton(
                      icon: new Icon(Icons.home, color: Colors.white),
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        var isLog = preferences.getBool("islog");
                        isLog == false
                            ? Reusable.showToast(getTranslated(context, 'open'),
                                gravity: ToastGravity.CENTER)
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyPoints()));
                      },
                    ),
                    title: Text(
                      getTranslated(context, 'point'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    getTranslated(context, 'promo'),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                globals.userData['token'] != null
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                        },
                        child: new ListTile(
                          leading: new IconButton(
                            icon: new Icon(Icons.notifications,
                                color: Colors.white),
                            onPressed: () {
                              //Navigator.pop(context);
                            },
                          ),
                          title: Text(
                            getTranslated(context, 'noti'),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    var isLog = preferences.getBool("islog");
                    isLog == false
                        ? Reusable.showToast(getTranslated(context, 'open'),
                            gravity: ToastGravity.CENTER)
                        : Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FavoriteScreen()));
                  },
                  child: new ListTile(
                    leading: new IconButton(
                      icon:
                          new Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        var isLog = preferences.getBool("islog");
                        isLog == false
                            ? Reusable.showToast(getTranslated(context, 'open'),
                                gravity: ToastGravity.CENTER)
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FavoriteScreen()));
                      },
                    ),
                    title: Text(
                      getTranslated(context, 'med'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BranchesList()));
                  },
                  child: new ListTile(
                    leading: new IconButton(
                      icon: new Icon(Icons.location_on, color: Colors.white),
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BranchesList()));
                      },
                    ),
                    title: Text(
                      getTranslated(context, 'branch'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                globals.userData['token'] != null
                    ? InkWell(
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          var isLog = preferences.getBool("islog");
                          isLog == false
                              ? Reusable.showToast(
                                  getTranslated(context, 'open'),
                                  gravity: ToastGravity.CENTER)
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SettingScreen()));
                        },
                        child: new ListTile(
                          leading: new IconButton(
                            icon: new Icon(Icons.settings_input_component,
                                color: Colors.white),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              var isLog = preferences.getBool("islog");
                              isLog == false
                                  ? Reusable.showToast(
                                      getTranslated(context, 'open'),
                                      gravity: ToastGravity.CENTER)
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingScreen()));
                            },
                          ),
                          title: Text(
                            getTranslated(context, 'set'),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    : Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrderTrackScreen()));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 13, top: 35, right: 13),
                        child: Text(
                          getTranslated(context, 'about'),
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () async {
                        // SharedPreferences preferences =
                        //     await SharedPreferences.getInstance();
                        // var isLog = preferences.getBool("islog");
                        // isLog == false
                        //     ? Navigator.of(context).push(MaterialPageRoute(
                        //         builder: (context) => Contact()))
                        //     : Navigator.of(context).push(MaterialPageRoute(
                        //         builder: (context) => ContactUs()));
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Contact()));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 13, top: 4, right: 13),
                        child: Text(
                          getTranslated(context, 'us'),
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    globals.userData['token'] != null
                        ? InkWell(
                            onTap: () {
                              // Navigator.of(context).pop();
                              log(context);
                              //globals.resetUserData();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 13, top: 4, right: 13),
                              child: Text(
                                getTranslated(context, 'out'),
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 15),
                              ),
                            ),
                          )
                        : Container(
                            color: Constants.greenColor(),
                          ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                // new AboutListTile(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(
                //         height: 20,
                //       ),
                //       InkWell(
                //         onTap: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => OrderTrackScreen()));
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.only(
                //               left: 13, top: 35, right: 13),
                //           child: Text(
                //             getTranslated(context, 'about'),
                //             style:
                //                 TextStyle(color: Colors.white70, fontSize: 15),
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 15,
                //       ),
                //       InkWell(
                //         onTap: () async {
                //           // SharedPreferences preferences =
                //           //     await SharedPreferences.getInstance();
                //           // var isLog = preferences.getBool("islog");
                //           // isLog == false
                //           //     ? Navigator.of(context).push(MaterialPageRoute(
                //           //         builder: (context) => Contact()))
                //           //     : Navigator.of(context).push(MaterialPageRoute(
                //           //         builder: (context) => ContactUs()));
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => Contact()));
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.only(
                //               left: 13, top: 4, right: 13),
                //           child: Text(
                //             getTranslated(context, 'us'),
                //             style:
                //                 TextStyle(color: Colors.white70, fontSize: 15),
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 15,
                //       ),
                //       globals.userData['token'] != null
                //           ? InkWell(
                //               onTap: () {
                //                 // Navigator.of(context).pop();
                //                 log(context);
                //                 //globals.resetUserData();
                //               },
                //               child: Padding(
                //                 padding: const EdgeInsets.only(
                //                     left: 13, top: 4, right: 13),
                //                 child: Text(
                //                   getTranslated(context, 'out'),
                //                   style: TextStyle(
                //                       color: Colors.white70, fontSize: 15),
                //                 ),
                //               ),
                //             )
                //           : Container(
                //               color: Constants.greenColor(),
                //             ),
                //       SizedBox(
                //         height: 20,
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// _resetLocalStorage(context) async {
//   final prefs = await SharedPreferences.getInstance();
//   log();
//   globals.resetUserData();

//   Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => SplashScreen()),
//       (route) => false);
//   prefs.clear();
// }

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
