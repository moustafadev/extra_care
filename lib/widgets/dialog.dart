import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/Chat/ChatScreen.dart';
import 'package:extra_care/screens/Prescription/Prescriprion.dart';
import 'package:extra_care/screens/home/resultScreen.dart';
import 'package:extra_care/screens/orders/reOrder.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../consts.dart';

Future<String> dialog(BuildContext context, no, order) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 150,
                child:
                    Image.asset('assets/images/logo.png', fit: BoxFit.contain),
              ),
              Text(
                getTranslated(context, 'nw'),
                style: TextStyle(color: Constants.skyColor(), fontSize: 14),
              ),
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * .6,
            //height: MediaQuery.of(context).size.height * .4,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Prescription()));
                  },
                  child: Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Constants.skyColor(),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      getTranslated(context, 'scanP'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    var isLog = preferences.getBool("islog");
                    isLog == false
                        ? Reusable.showToast(getTranslated(context, 'open'),
                            gravity: ToastGravity.CENTER)
                        : order == false
                            ? Reusable.showToast(
                                getTranslated(context, 'havent'),
                                gravity: ToastGravity.CENTER)
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReOrderScreen()));
                  },
                  child: Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: order == false
                            ? Colors.grey[600]
                            : Constants.skyColor(),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      getTranslated(context, 'repeat'),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResultScreen()));
                  },
                  child: Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Constants.skyColor(),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      getTranslated(context, 'serch'),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 10,
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
                            builder: (context) => ChatScreen()));
                  },
                  child: Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Constants.skyColor(),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      getTranslated(context, 'chat'),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    launch(('tel://$no'));
                  },
                  child: Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Constants.skyColor(),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      getTranslated(context, 'call'),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
