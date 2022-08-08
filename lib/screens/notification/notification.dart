import 'dart:convert';
import 'dart:ui';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/consts.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/orders/orderDetails.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

List adminAcceptStatusAdd;

class _NotificationState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int status = 0;
  int sound = 0;
  bool loading = false;
  var soundVal = "";
  var pushVal = "";

  @override
  void initState() {
    super.initState();
    getLists();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          key: _scaffoldKey,
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
                        appBarWithArrow(
                            context, getTranslated(context, 'noti')),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.notifications_none,
                                    color: Constants.redColor(),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(getTranslated(context, 'push'),
                                      style: TextStyle(
                                          color: Constants.redColor(),
                                          fontSize: 18)),
                                ],
                              ),
                              Switch(
                                value: status == 1 ? true : false,
                                onChanged: (value) {
                                  setState(() {
                                    // pushVal == "0"
                                    //     ? status = false
                                    //     : status = true;
                                    toggle("push");
                                    //getCount();
                                    print(status);
                                  });
                                },
                                activeTrackColor: Colors.grey,
                                activeColor: Constants.redColor(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.volume_up,
                                    color: Constants.redColor(),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(getTranslated(context, 'sound'),
                                      style: TextStyle(
                                          color: Constants.redColor(),
                                          fontSize: 18)),
                                ],
                              ),
                              Switch(
                                value: sound == 1 ? true : false,
                                onChanged: (value) {
                                  setState(() {
                                    // soundVal == "0" ? sound = false:sound = true;
                                    // sound = value;
                                    toggle("sound ");
                                    print(sound);
                                  });
                                },
                                activeTrackColor: Colors.grey,
                                activeColor: Constants.redColor(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        loading
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .62,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey[600],
                                            style: BorderStyle.solid)),
                                    child: Reusable.showLoader(loading)),
                              )
                            : adminAcceptStatusAdd.isNotEmpty ||
                                    adminAcceptStatusAdd.length != 0
                                ? ListView.builder(
                                    itemCount: adminAcceptStatusAdd.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (adminAcceptStatusAdd[index]
                                                  ['type'] ==
                                              "order") {
                                            read(adminAcceptStatusAdd[index]
                                                    ['id']
                                                .toString());
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetails(
                                                          details:
                                                              adminAcceptStatusAdd[
                                                                      index]
                                                                  ['data'],
                                                        )));
                                          } else if (adminAcceptStatusAdd[index]
                                                  ['type'] ==
                                              "general") {
                                            read(adminAcceptStatusAdd[index]
                                                    ['id']
                                                .toString());
                                          }
                                        },
                                        child: Card(
                                          elevation: 5,
                                          child: Container(
                                            color: adminAcceptStatusAdd[index]
                                                        ['pivot']['is_read'] ==
                                                    "0"
                                                ? Colors.grey[200]
                                                : Colors.white,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                //mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .7,
                                                          child: Text(
                                                            adminAcceptStatusAdd[
                                                                            index]
                                                                        [
                                                                        "title"] ==
                                                                    null
                                                                ? getTranslated(
                                                                    context,
                                                                    'noTitle')
                                                                : adminAcceptStatusAdd[
                                                                        index]
                                                                    ["title"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Constants
                                                                    .skyColor(),
                                                                fontSize: 16),
                                                          )),
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .7,
                                                          child: Text(
                                                            adminAcceptStatusAdd[
                                                                            index]
                                                                        [
                                                                        "body"] ==
                                                                    null
                                                                ? ""
                                                                : adminAcceptStatusAdd[
                                                                        index]
                                                                    ["body"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          )),
                                                    ],
                                                  ),
                                                  Text(
                                                    adminAcceptStatusAdd[index]
                                                            ['created_at']
                                                        .toString()
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
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

  dynamic delete(id) async {
    final response = await deleteNotification(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      getLists();
    } else if (res['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  dynamic read(id) async {
    final response = await readNotification(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      getLists();
    } else if (res['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  dynamic toggle(type) async {
    final response = await toggleNotification(type);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      getCount();
    } else if (res['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchNotification();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptStatusAdd.add(item);
          });
      }
    } else {
      setState(() {
        loading = false;
      });
      //return;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future getCount() async {
    // print("object" + tabType);
    final loginresponse = await fetchCount();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        sound = res['data']['notification_sound'];
        status = res['data']['push_notification'];
      });
    } else {
      setState(() {
        pushVal = "";
        soundVal = "";
      });
    }
  }
}
