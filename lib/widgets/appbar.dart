import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/notification/notification.dart';
import 'package:extra_care/screens/home/resultScreen.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';

Widget appBar(BuildContext context, _scaffoldKey, read) {
  return Container(
    color: Constants.greenColor(),
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * .2
        : MediaQuery.of(context).size.height * .43,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 12, right: 12),
        //   child: InkWell(
        //       onTap: () async {
        //         Navigator.of(context).push(
        //             MaterialPageRoute(builder: (context) => ResultScreen()));
        //       },
        //       child: Icon(Icons.search, color: Colors.white)),
        // ),
        Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            color: Colors.white,
            height: 80,
          ),
        ),
        //SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'What are you looking for?',
                ),
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 12, right: 12),
        //   child: InkWell(
        //     onTap: () async {
        //       SharedPreferences preferences =
        //           await SharedPreferences.getInstance();
        //       var isLog = preferences.getBool("islog");
        //       isLog == false
        //           ? Reusable.showToast(getTranslated(context, 'open'),
        //               gravity: ToastGravity.CENTER)
        //           : Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) => NotificationScreen()));
        //     },
        //     child: Container(
        //       child: read == 0
        //           ? Icon(Icons.notifications_none, color: Colors.white)
        //           : Stack(
        //               children: [
        //                 Icon(Icons.notifications_none, color: Colors.white),
        //                 Positioned(
        //                   top: 0,
        //                   right: 0,
        //                   left: 0,
        //                   // alignment: Alignment.topCenter,
        //                   child: Container(
        //                     width: 11,
        //                     height: 11,
        //                     decoration: BoxDecoration(
        //                         shape: BoxShape.circle, color: Colors.red),
        //                     alignment: Alignment.center,
        //                     child: Text(
        //                       read.toString(),
        //                       style:
        //                           TextStyle(fontSize: 11, color: Colors.white),
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //     ),
        //   ),
        // )
      ],
    ),
  );
}
