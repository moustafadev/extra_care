import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:extra_care/screens/orders/orderDetails.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class ReOrderScreen extends StatefulWidget {
  @override
  _ReOrderScreenState createState() => _ReOrderScreenState();
}

List adminAcceptStatusAdd;

class _ReOrderScreenState extends State<ReOrderScreen> {
  int _activeMeterIndex;
  bool loading = false;
  var lang;

  getLang() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    setState(() {
      lang = languageCode;
    });
  }

  @override
  void initState() {
    super.initState();
    getLang();
    getLists();
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
                    children: [
                      appBarWithArrow(context, getTranslated(context, 'order')),
                      Container(
                        width: double.infinity,
                        decoration: new BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(20.0),
                                bottomRight: const Radius.circular(20.0))),
                        //height: 45,

                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            getTranslated(context, 'order'),
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        ),
                      ),
                      loading
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .62,
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
                                  // controller: _places,
                                  itemCount: adminAcceptStatusAdd.length ?? 0,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return adminAcceptStatusAdd[index]
                                                ['status'] ==
                                            "delivered"
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              child: ExpansionPanelList(
                                                expansionCallback:
                                                    (int i, bool) {
                                                  setState(() {
                                                    _activeMeterIndex =
                                                        _activeMeterIndex ==
                                                                index
                                                            ? null
                                                            : index;
                                                  });
                                                },
                                                children: [
                                                  new ExpansionPanel(
                                                    isExpanded:
                                                        _activeMeterIndex ==
                                                            index,
                                                    headerBuilder: (BuildContext
                                                                context,
                                                            bool isExpanded) =>
                                                        InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _activeMeterIndex =
                                                              index;
                                                        });
                                                      },
                                                      child: new Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0,
                                                                  right: 15),
                                                          alignment: lang ==
                                                                  'ar'
                                                              ? Alignment
                                                                  .centerRight
                                                              : Alignment
                                                                  .centerLeft,
                                                          child: new Text(
                                                            getTranslated(
                                                                    context,
                                                                    'orderId') +
                                                                " : " +
                                                                adminAcceptStatusAdd[
                                                                            index]
                                                                        ['id']
                                                                    .toString() +
                                                                "  " +
                                                                adminAcceptStatusAdd[
                                                                            index]
                                                                        [
                                                                        'pending_at']
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                            style: TextStyle(
                                                                color: Constants
                                                                    .skyColor()),
                                                          )),
                                                    ),
                                                    body: new InkWell(
                                                      onTap: () {
                                                        if (adminAcceptStatusAdd[
                                                                        index][
                                                                    'status'] ==
                                                                "canceled" ||
                                                            adminAcceptStatusAdd[
                                                                        index][
                                                                    'status'] ==
                                                                "rejected") {
                                                          Reusable.showToast(
                                                              getTranslated(
                                                                  context,
                                                                  'sorry'),
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          OrderDetails(
                                                                            details:
                                                                                adminAcceptStatusAdd[index],
                                                                          )));
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            boxShadow: <
                                                                BoxShadow>[
                                                              BoxShadow(
                                                                  color: Constants
                                                                      .shadowColor(),
                                                                  blurRadius:
                                                                      16,
                                                                  offset:
                                                                      Offset(4,
                                                                          4)),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8,
                                                                        bottom:
                                                                            8),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(
                                                                          context,
                                                                          'status'),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Text(
                                                                        adminAcceptStatusAdd[index]['status'] ==
                                                                                null
                                                                            ? getTranslated(context,
                                                                                'noStat')
                                                                            : adminAcceptStatusAdd[index]['status'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                            color: Constants.redColor()),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8,
                                                                        bottom:
                                                                            8),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(
                                                                          context,
                                                                          'total'),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Text(
                                                                        adminAcceptStatusAdd[index]['ask_to_pay'] ==
                                                                                null
                                                                            ? getTranslated(context,
                                                                                'noPrice')
                                                                            : adminAcceptStatusAdd[index]['ask_to_pay'].toString() +
                                                                                " " +
                                                                                getTranslated(context, 'le'),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                            color: Constants.redColor()),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'status'] ==
                                                                      "delivered"
                                                                  ? Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "",
                                                                            style:
                                                                                TextStyle(fontSize: 16, color: Colors.black),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              ordering(adminAcceptStatusAdd[index]['id'].toString());
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              getTranslated(context, 're'),
                                                                              style: TextStyle(fontSize: 16, decoration: TextDecoration.underline, color: Constants.redColor()),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 4),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: Reusable.noData(
                                          msg: getTranslated(
                                              context, 'noData'))))
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

  viewItem(BuildContext context, image) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        //isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            // ElevatedButton(
            //           child: const Text('Close BottomSheet'),
            //           onPressed: () => Navigator.pop(context),
            child: new Container(
              color: Colors.transparent,
              child: new Center(
                child: ExtendedImage.network(
                  image,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .8,
                  //enableLoadState: false,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                      minScale: 0.9,
                      animationMinScale: 0.7,
                      maxScale: 4.0,
                      animationMaxScale: 4.5,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: true,
                      initialAlignment: InitialAlignment.center,
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  dynamic ordering(id) async {
    //Reusable.showLoading(context);
    final response = await reOrder(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyCartScreen()));
      getLists();
    } else if (res['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchOrders();
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
}
