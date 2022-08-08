import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/screens/orders/trackOrder.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

Future<String> successdialog(BuildContext context, Map track) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .6,
                child: Image.asset('assets/images/download.png',
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getTranslated(context, 'suc'),
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getTranslated(context, 'place'),
                style: TextStyle(color: Colors.black, fontSize: 11),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getTranslated(context, 'dev'),
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomTabScreen()),
                      (route) => false);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * .07,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Constants.redColor(),
                      style: BorderStyle.solid,
                    ),
                    color: Constants.redColor(),
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(context, 'con'),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackOrder(
                                details: track,
                              )),
                      (route) => false);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TrackOrder(
                  //       details: track,
                  //     ),
                  //   ),
                  // );
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => TrackOrder()));
                },
                child: Text(
                  getTranslated(context, 'track'),
                  style: TextStyle(color: Constants.hintColor(), fontSize: 16),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        );
      });
}
