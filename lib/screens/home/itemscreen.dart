import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../global/globals.dart' as globals;
import '../../consts.dart';

class ItemScreen extends StatefulWidget {
  final Map details;

  const ItemScreen({Key key, this.details}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

List adminAcceptStatusAdd;

class _ItemScreenState extends State<ItemScreen> {
  TextEditingController agree = TextEditingController();
  TextEditingController touristName = TextEditingController();
  var rating = 1.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelected = false;
  bool isSelected2 = false;
  int _itemCount = 1;
  bool medOk = false;
  bool natOk = false;
  LinkedScrollControllerGroup _controllers;
  ScrollController _area;
  ScrollController _places;
  bool showMore = false;
  var name;
  bool loading = false;
  FToast fToast;

  @override
  void initState() {
    super.initState();
    getLists();
    fToast = FToast();
    fToast.init(context);
    _controllers = LinkedScrollControllerGroup();
    _area = _controllers.addAndGet();
    _places = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _area.dispose();
    _places.dispose();
    super.dispose();
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _area,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBarWithArrow(
                            context, getTranslated(context, 'proD')),
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  child: widget.details['photo'] == null
                                      ? Text(getTranslated(context, 'noPhoto'))
                                      : Image.network(
                                          widget.details['photo'],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Text(
                                        widget.details['p_gname'] == null
                                            ? getTranslated(context, 'noTitle')
                                            : widget.details['p_gname'],
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                        widget.details['p_price'].toString() ==
                                                null
                                            ? getTranslated(context, 'noPrice')
                                            : widget.details['p_price']
                                                    .toString() +
                                                getTranslated(context, 'le'),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            decoration:
                                                widget.details['is_discount'] ==
                                                        "0"
                                                    ? null
                                                    : TextDecoration
                                                        .lineThrough)),
                                    Text(
                                        widget.details['is_discount'] == "0"
                                            ? ""
                                            : widget.details['offer_price']
                                                    .toString() +
                                                getTranslated(context, 'le'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.redColor(),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // (widget.details['additions'] as List)
                                        //             .length ==
                                        widget.details['has_medical_report'] ==
                                                0
                                            ? showToast(
                                                getTranslated(context, 'havnt'))
                                            // Reusable.showToast(
                                            //     getTranslated(context, 'havnt'))
                                            : medicalDialog(context);
                                      },
                                      child: Container(
                                        child: Text(
                                          getTranslated(context, 'medical'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Constants.greenColor()),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // (widget.details['additions'] as List)
                                        //             .length ==
                                        widget.details[
                                                    'has_nutrition_report'] ==
                                                0
                                            ? showToast(
                                                getTranslated(context, 'havnt'))
                                            // Reusable.showToast(
                                            //     getTranslated(context, 'havnt'))
                                            : nutritionDialog(context);
                                      },
                                      child: Container(
                                        child: Text(
                                          getTranslated(context, 'nutrition'),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Constants.greenColor()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 35,
                                        //width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey[500],
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated(context, 'type'),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                widget.details['type'] == null
                                                    ? getTranslated(
                                                        context, 'noType')
                                                    : widget.details['type'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    widget.details['p_quantity'] == null ||
                                            widget.details['p_quantity'] ==
                                                "0" ||
                                            widget.details['p_quantity'] == 0
                                        ? Text(
                                            getTranslated(context, 'outStock'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          )
                                        : Container(
                                            height: 35,
                                            width: 110,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                new IconButton(
                                                  icon: new Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_itemCount > 1)
                                                        _itemCount--;
                                                    });
                                                  },
                                                ),
                                                new Text(
                                                  _itemCount.toString(),
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                new IconButton(
                                                    icon: new Icon(Icons.add),
                                                    onPressed: () {
                                                      if (_itemCount <
                                                          widget.details[
                                                              'p_quantity']) {
                                                        setState(
                                                            () => _itemCount++);
                                                      } else {
                                                        showToast(getTranslated(
                                                            context,
                                                            'maxStock'));
                                                      }
                                                    })
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                    widget.details['p_quantity'] == null ||
                                            widget.details['p_quantity'] ==
                                                "0" ||
                                            widget.details['p_quantity'] == 0
                                        ? Container()
                                        : InkWell(
                                            onTap: () async {
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              var isLog =
                                                  preferences.getBool("islog");
                                              isLog == false
                                                  ? uploadWithoutAuth(context)
                                                  : upload(context);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Constants.redColor(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25))),
                                              child: Text(
                                                getTranslated(
                                                    context, 'addCart'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     'Related Video',
                        //     textAlign: TextAlign.start,
                        //     style: TextStyle(color: Colors.black, fontSize: 20),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     child: Image.asset(
                        //       "assets/images/rec.png",
                        //       height: MediaQuery.of(context).size.height * .3,
                        //       width: MediaQuery.of(context).size.width,
                        //       fit: BoxFit.contain,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated(context, 'descrip'),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.details['p_desc'] == null
                                  ? getTranslated(context, 'noDis')
                                  : widget.details['p_desc'],
                              style: TextStyle(
                                  color: Constants.hintColor(), fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated(context, 'side'),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.details['p_seffect'] == null
                                  ? getTranslated(context, 'noSide')
                                  : widget.details['p_seffect'],
                              style: TextStyle(
                                  color: Constants.hintColor(), fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        adminAcceptStatusAdd.length != 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'rates'),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    // showMore == false
                                    //     ? adminAcceptStatusAdd.length > 1
                                    //         ? InkWell(
                                    //             onTap: () {
                                    //               setState(() {
                                    //                 showMore = true;
                                    //               });
                                    //             },
                                    //             child: Text(
                                    //               getTranslated(
                                    //                   context, 'more'),
                                    //               style: TextStyle(
                                    //                   color:
                                    //                       Constants.skyColor(),
                                    //                   fontSize: 16),
                                    //             ),
                                    //           )
                                    //         : Container()
                                    //     : InkWell(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             showMore = false;
                                    //           });
                                    //         },
                                    //         child: Text(
                                    //           getTranslated(context, 'less'),
                                    //           style: TextStyle(
                                    //               color: Constants.skyColor(),
                                    //               fontSize: 16),
                                    //         ),
                                    //       ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
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
                            : showMore == false
                                ? adminAcceptStatusAdd.isNotEmpty ||
                                        adminAcceptStatusAdd.length != 0
                                    ? ListView.builder(
                                        controller: _places,
                                        itemCount: 1 ?? 0,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(
                                                color: Constants.skyColor(),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Constants
                                                                    .skyColor()),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child:
                                                              new CircleAvatar(
                                                            child: Text(
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer'] ==
                                                                      null
                                                                  ? ""
                                                                  : adminAcceptStatusAdd[
                                                                              index]['customer']
                                                                          [
                                                                          'name']
                                                                      .toString()
                                                                      .substring(
                                                                          0, 1),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Constants
                                                                      .skyColor()),
                                                            ),
                                                            // backgroundImage: NetworkImage(user.photo),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .6,
                                                            child: Text(
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer'] ==
                                                                      null
                                                                  ? getTranslated(
                                                                      context,
                                                                      'noTitle')
                                                                  : adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer']
                                                                      ['name'],
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            child:
                                                                SmoothStarRating(
                                                              allowHalfRating:
                                                                  false,
                                                              onRated: (value) {
                                                                print(
                                                                    "rating value -> $value");
                                                              },
                                                              starCount: 5,
                                                              rating: adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'rate'] ==
                                                                      null
                                                                  ? 0.0
                                                                  : double.parse(
                                                                      adminAcceptStatusAdd[index]['rate'].toString()),
                                                              size: 20.0,
                                                              isReadOnly: true,
                                                              color:
                                                                  Colors.yellow,
                                                              borderColor:
                                                                  Colors.yellow,
                                                              filledIconData:
                                                                  Icons.star,
                                                              halfFilledIconData:
                                                                  Icons
                                                                      .star_half,
                                                              defaultIconData:
                                                                  Icons
                                                                      .star_border,
                                                              spacing: .5,
                                                            )),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'updated_at'] ==
                                                                  null
                                                              ? getTranslated(
                                                                  context,
                                                                  'noTitle')
                                                              : adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'updated_at']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .9,
                                                      child: Text(
                                                        adminAcceptStatusAdd[
                                                                        index][
                                                                    'comment'] ==
                                                                null
                                                            ? getTranslated(
                                                                context,
                                                                'noDis')
                                                            : adminAcceptStatusAdd[
                                                                    index]
                                                                ['comment'],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container()
                                : adminAcceptStatusAdd.isNotEmpty ||
                                        adminAcceptStatusAdd.length != 0
                                    ? ListView.builder(
                                        controller: _places,
                                        itemCount:
                                            adminAcceptStatusAdd.length ?? 0,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(
                                                color: Constants.skyColor(),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Constants
                                                                    .skyColor()),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child:
                                                              new CircleAvatar(
                                                            child: Text(
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer'] ==
                                                                      null
                                                                  ? ""
                                                                  : adminAcceptStatusAdd[
                                                                              index]['customer']
                                                                          [
                                                                          'name']
                                                                      .toString()
                                                                      .substring(
                                                                          0, 1),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Constants
                                                                      .skyColor()),
                                                            ),
                                                            // backgroundImage: NetworkImage(user.photo),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .6,
                                                            child: Text(
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer'] ==
                                                                      null
                                                                  ? getTranslated(
                                                                      context,
                                                                      'noTitle')
                                                                  : adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'customer']
                                                                      ['name'],
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            child:
                                                                SmoothStarRating(
                                                              allowHalfRating:
                                                                  false,
                                                              onRated: (value) {
                                                                print(
                                                                    "rating value -> $value");
                                                              },
                                                              starCount: 5,
                                                              rating: adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'rate'] ==
                                                                      null
                                                                  ? 0.0
                                                                  : double.parse(
                                                                      adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'rate']),
                                                              size: 20.0,
                                                              isReadOnly: true,
                                                              color:
                                                                  Colors.yellow,
                                                              borderColor:
                                                                  Colors.yellow,
                                                              filledIconData:
                                                                  Icons.star,
                                                              halfFilledIconData:
                                                                  Icons
                                                                      .star_half,
                                                              defaultIconData:
                                                                  Icons
                                                                      .star_border,
                                                              spacing: .5,
                                                            )),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'updated_at'] ==
                                                                  null
                                                              ? getTranslated(
                                                                  context,
                                                                  'noTitle')
                                                              : adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'updated_at']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .9,
                                                      child: Text(
                                                        adminAcceptStatusAdd[
                                                                        index][
                                                                    'comment'] ==
                                                                null
                                                            ? getTranslated(
                                                                context,
                                                                'noDis')
                                                            : adminAcceptStatusAdd[
                                                                    index]
                                                                ['comment'],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(),
                        SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  var isLog = preferences.getBool("islog");
                                  isLog == false
                                      ? Reusable.showToast(
                                          getTranslated(context, 'open'),
                                          gravity: ToastGravity.CENTER)
                                      : ratingDialog(context);
                                },
                                child: Text(
                                  getTranslated(context, 'addRev'),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Constants.redColor()),
                                ),
                              ),
                              showMore == false
                                  ? adminAcceptStatusAdd.length > 1
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              showMore = true;
                                            });
                                          },
                                          child: Text(
                                            getTranslated(context, 'more'),
                                            style: TextStyle(
                                                color: Constants.skyColor(),
                                                fontSize: 16),
                                          ),
                                        )
                                      : Container()
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          showMore = false;
                                        });
                                      },
                                      child: Text(
                                        getTranslated(context, 'less'),
                                        style: TextStyle(
                                            color: Constants.skyColor(),
                                            fontSize: 16),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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

  ratingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              getTranslated(context, 'review'),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (value) {
                          setState(() {
                            rating = value;
                          });
                          print("rating value -> $value");
                        },
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        isReadOnly: false,
                        color: Colors.yellow,
                        borderColor: Colors.yellow,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        spacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TextField(
                    controller: touristName,
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    autofocus: true,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  getTranslated(context, 'ok'),
                  style: TextStyle(color: Constants.skyColor()),
                ),
                onPressed: () async {
                  rate();
                },
              ),
            ],
          );
        });
  }

  dynamic rate() async {
    // ignore: unused_local_variable
    var headers;
    Reusable.showLoading(context);
    final response = await addRate(widget.details['p_id'].toString(),
        touristName.value.text, rating.toString());
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      touristName.clear();
      Navigator.of(context).pop();
      getLists();
    } else {
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
    final loginresponse = await fetchReviews(widget.details['p_id'].toString());
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    print(res['data']);
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

  Future<String> nutritionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                getTranslated(context, 'sure'),
                style: TextStyle(fontSize: 22, color: Constants.redColor()),
              ),
              content: Text(
                (widget.details['additions'] as List).length == 1
                    ? getTranslated(context, 'accept') +
                        widget.details['additions'][0]['price'].toString() +
                        getTranslated(context, 'le')
                    : getTranslated(context, 'accept') +
                        widget.details['additions'][1]['price'].toString() +
                        getTranslated(context, 'le'),
                style: TextStyle(fontSize: 14, color: Constants.blueColor()),
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text(getTranslated(context, 'ok')),
                  onPressed: () async {
                    setState(() {
                      natOk = true;
                      print("medok" + medOk.toString());
                      print("natok" + natOk.toString());
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  Future<String> medicalDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                getTranslated(context, 'sureM'),
                style: TextStyle(fontSize: 22, color: Constants.redColor()),
              ),
              content: Text(
                getTranslated(context, 'accept') +
                    widget.details['additions'][0]['price'].toString() +
                    getTranslated(context, 'le'),
                style: TextStyle(fontSize: 14, color: Constants.blueColor()),
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text(getTranslated(context, 'ok')),
                  onPressed: () async {
                    setState(() {
                      medOk = true;
                      print("medok" + medOk.toString());
                      print("natok" + natOk.toString());
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  Future<dynamic> upload(BuildContext context) async {
    print("medok1" + medOk.toString());
    print("natok1" + natOk.toString());
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    //var headers = {'Authorization': 'Bearer ' + globals.userData['token']}
    var uri = Uri.parse(
        "https://chromateck.com/laurus/api/v1/cart/add?lang=$languageCode");

    var request = new http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

    if (medOk == false && natOk == false) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      print("medok2" + medOk.toString());
      print("natok2" + natOk.toString());
    } else if (natOk == false && medOk == true) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[0]'] = 1.toString();
      print("medok3" + medOk.toString());
      print("natok3" + natOk.toString());
    } else if (medOk == false && natOk == true) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[1]'] = 2.toString();
      print("medok4" + medOk.toString());
      print("natok4" + natOk.toString());
    } else if (medOk == true && natOk == true) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[0]'] = 1.toString();
      request.fields['additions[1]'] = 2.toString();
      print("medok5" + medOk.toString());
      print("natok5" + natOk.toString());
    }

    print("medok" + medOk.toString());
    print("natok" + natOk.toString());

    Reusable.showLoading(context);
    var response = await request.send();
    var responses = await http.Response.fromStream(response);
    print("responseData : " + responses.body);
    Map<String, dynamic> responseData = json.decode(responses.body);
    if (responseData['status'] == 1) {
      setState(() {
        Reusable.dismissLoading();
        // Reusable.showToast(responseData['massage'],
        //     gravity: ToastGravity.CENTER);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyCartScreen()),
            (route) => false);
      });
    } else if (responseData['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(responseData['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future<dynamic> uploadWithoutAuth(BuildContext context) async {
    String deviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    var uri = Uri.parse(
        "https://chromateck.com/laurus/api/v1/cart/add?lang=$languageCode");

    var request = new http.MultipartRequest("POST", uri);
    // request.headers
    //     .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

    if (medOk == false && natOk == false) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['os'] = Platform.isAndroid ? 'android' : 'ios';
      request.fields['serial_number'] = deviceId;
    } else if (natOk == false && medOk == true) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[0]'] = 1.toString();
      request.fields['os'] = Platform.isAndroid ? 'android' : 'ios';
      request.fields['serial_number'] = deviceId;
    } else if (medOk == false && natOk == true) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[1]'] = 2.toString();
      request.fields['os'] = Platform.isAndroid ? 'android' : 'ios';
      request.fields['serial_number'] = deviceId;
    } else if (medOk == true && natOk == true) {
      request.fields['type'] = 'product';
      request.fields['product_id'] = widget.details['p_id'].toString();
      request.fields['quantity'] = _itemCount.toString();
      request.fields['additions[0]'] = 1.toString();
      request.fields['additions[1]'] = 2.toString();
      request.fields['os'] = Platform.isAndroid ? 'android' : 'ios';
      request.fields['serial_number'] = deviceId;
    }

    print("device serial" + deviceId);

    Reusable.showLoading(context);
    var response = await request.send();
    var responses = await http.Response.fromStream(response);
    print("responseData : " + responses.body);
    Map<String, dynamic> responseData = json.decode(responses.body);
    if (responseData['status'] == 1) {
      setState(() {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyCartScreen()),
            (route) => false);
      });
    } else if (responseData['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(responseData['massage'], gravity: ToastGravity.CENTER);
    }
  }

  showToast(txt) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red[600],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error),
          SizedBox(
            width: 12.0,
          ),
          Text(txt),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 1),
    );
  }
}
