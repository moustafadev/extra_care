import 'dart:convert';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/consts.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

class MyPoints extends StatefulWidget {
  @override
  _MyPointsState createState() => _MyPointsState();
}

class _MyPointsState extends State<MyPoints> {
  int points = 0;
  int pointsCost = 0;
  @override
  void initState() {
    super.initState();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: drawer(context),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appBarWithArrow(context, getTranslated(context, 'point')),
                      Container(
                        width: double.infinity,
                        decoration: new BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(20.0),
                                bottomRight: const Radius.circular(20.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            getTranslated(context, 'point'),
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .85,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(25))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          color: Constants.skyColor(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          getTranslated(context, 'mp'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Constants.skyColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      pointsCost.toString() +
                                          "  " +
                                          getTranslated(context, 'le'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Constants.greenColor(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          color: Constants.skyColor(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          getTranslated(context, 'point'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Constants.skyColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      points.toString() +
                                          "  " +
                                          getTranslated(context, 'points'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Constants.greenColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 12, right: 12),
                      //   child: Text(
                      //     getTranslated(context, 'gain'),
                      //     style: TextStyle(fontSize: 20, color: Colors.black),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 12, right: 12),
                      //   child: Text(
                      //     getTranslated(context, 'each'),
                      //     style:
                      //         TextStyle(fontSize: 18, color: Colors.grey[600]),
                      //   ),
                      // ),
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

  Future getCount() async {
    // print("object" + tabType);
    final loginresponse = await fetchCount();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        points = res['data']['points'];
        pointsCost = res['data']['points_cost'];
      });
    } else {
      setState(() {
        points = 0;
        pointsCost = 0;
      });
    }
  }
}
