import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/screens/orders/orderDetails.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class OrederList extends StatefulWidget {
  @override
  _OrederListState createState() => _OrederListState();
}

List adminAcceptStatusAdd;

class _OrederListState extends State<OrederList> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
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
                        //height: 45,
                        color: Colors.grey[200],
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
                                  itemCount: adminAcceptStatusAdd.length ?? 0,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (adminAcceptStatusAdd[index]
                                                ['status'] ==
                                            "canceled") {
                                          Reusable.showToast(
                                              getTranslated(context, 'sorry'),
                                              gravity: ToastGravity.CENTER);
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetails(
                                                        details:
                                                            adminAcceptStatusAdd[
                                                                index],
                                                      )));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color:
                                                      Constants.shadowColor(),
                                                  blurRadius: 16,
                                                  offset: Offset(4, 4)),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          context, 'orderId'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      adminAcceptStatusAdd[
                                                                      index]
                                                                  ['id'] ==
                                                              null
                                                          ? getTranslated(
                                                              context,
                                                              'noTitle')
                                                          : adminAcceptStatusAdd[
                                                                  index]['id']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Constants
                                                              .skyColor()),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          context, 'total'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      adminAcceptStatusAdd[
                                                                      index][
                                                                  'ask_to_pay'] ==
                                                              null
                                                          ? getTranslated(
                                                              context,
                                                              'noPrice')
                                                          : adminAcceptStatusAdd[
                                                                      index]
                                                                  ['ask_to_pay']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Constants
                                                              .skyColor()),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              adminAcceptStatusAdd[index]
                                                          ['status'] ==
                                                      "in_review"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              rejectOffer(
                                                                  adminAcceptStatusAdd[
                                                                              index]
                                                                          ['id']
                                                                      .toString(),
                                                                  index);
                                                            },
                                                            child: Text(
                                                              getTranslated(
                                                                  context,
                                                                  'rejectOffer'),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Constants
                                                                      .redColor()),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              acceptOffer(
                                                                  adminAcceptStatusAdd[
                                                                              index]
                                                                          ['id']
                                                                      .toString(),
                                                                  index);
                                                            },
                                                            child: Text(
                                                              getTranslated(
                                                                  context,
                                                                  'acceptOffer'),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Constants
                                                                      .skyColor()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
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

  dynamic acceptOffer(id, i) async {
    //Reusable.showLoading(context);

    final response = await acceptReview(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      Reusable.showToast("done", gravity: ToastGravity.CENTER);
      //adminAcceptStatusAdd.removeAt(i);
      getLists();
    } else {
      Reusable.dismissLoading();
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  dynamic rejectOffer(id, i) async {
    //Reusable.showLoading(context);

    final response = await rejectReview(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      Reusable.showToast("done", gravity: ToastGravity.CENTER);
      //adminAcceptStatusAdd.removeAt(i);
      getLists();
    } else {
      Reusable.dismissLoading();
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
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
