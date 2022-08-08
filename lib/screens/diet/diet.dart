import 'dart:convert';
import '../../global/globals.dart' as globals;
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/home/itemscreen.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appbar.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../consts.dart';

class DietScreen extends StatefulWidget {
  @override
  _DietScreenState createState() => _DietScreenState();
}

List adminAcceptStatusAdd;
List adminAcceptStatus;
Map most;

class _DietScreenState extends State<DietScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  List<double> rating = [];
  int read = 0;
  bool faved = false;
  var isFav = 0;
  int fav;
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
    getCount();
    sale();
    getLang();
    globals.userData['token'] != null ? getListsToken() : getLists();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appBar(context, _scaffoldKey, read),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                getTranslated(context, 'diet'),
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                            ),
                          ),
                          loading
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                              : most != null
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemScreen(details: most)));
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Image.network(
                                                  most['photo'],
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .3,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .9,
                                                child: Text(
                                                  most['p_gname'] == null
                                                      ? getTranslated(
                                                          context, 'noTitle')
                                                      : most['p_gname'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8,
                                                  left: 12,
                                                  right: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      most['p_price'] == null
                                                          ? getTranslated(
                                                              context,
                                                              'noPrice')
                                                          : most['p_price']
                                                                  .toString() +
                                                              " " +
                                                              getTranslated(
                                                                  context,
                                                                  'le'),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Constants
                                                              .hintColor(),
                                                          decoration: most[
                                                                      'is_discount'] ==
                                                                  "0"
                                                              ? null
                                                              : TextDecoration
                                                                  .lineThrough)),
                                                  Text(
                                                      adminAcceptStatusAdd[0][
                                                                  'is_discount'] ==
                                                              "0"
                                                          ? ""
                                                          : most['offer_price']
                                                                  .toString() +
                                                              getTranslated(
                                                                  context,
                                                                  'le'),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Constants
                                                            .greenColor(),
                                                      )),
                                                  Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: SmoothStarRating(
                                                        allowHalfRating: false,
                                                        onRated: (value) {
                                                          print(
                                                              "rating value -> $value");
                                                        },
                                                        starCount: 5,
                                                        rating: most['rate'] ==
                                                                null
                                                            ? 0.0
                                                            : double.parse(
                                                                most['rate']),
                                                        size: 15.0,
                                                        isReadOnly: true,
                                                        color: Colors.yellow,
                                                        borderColor:
                                                            Colors.yellow,
                                                        filledIconData:
                                                            Icons.star,
                                                        halfFilledIconData:
                                                            Icons.star_half,
                                                        defaultIconData:
                                                            Icons.star_border,
                                                        spacing: .5,
                                                      )),
                                                  // SmoothStarRating(
                                                  //   allowHalfRating: true,
                                                  //   starCount: 1,
                                                  //   rating: 4.8,
                                                  //   size: 20,
                                                  //   color: Constants.starColor(),
                                                  //   borderColor: Constants.starColor(),
                                                  // ),
                                                  // Text('(233 ratings)',
                                                  //     style: TextStyle(
                                                  //       fontSize: 13,
                                                  //       color: Constants.hintColor(),
                                                  //     )),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ItemScreen(
                                                                      details:
                                                                          most)));
                                                    },
                                                    child: Container(
                                                      //height: 20,
                                                      //width: 80,
                                                      decoration: BoxDecoration(
                                                          color: Constants
                                                              .skyColor(),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          25))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          getTranslated(
                                                              context, 'most'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              getTranslated(context, 'products'),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22),
                            ),
                          ),
                          loading
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                  ? ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              adminAcceptStatusAdd.length ?? 0,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ItemScreen(
                                                                details:
                                                                    adminAcceptStatusAdd[
                                                                        index],
                                                              )));
                                                },
                                                child: Container(
                                                  //height: 300,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16.0)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                        color: Constants
                                                            .shadowColor(),
                                                        blurRadius: 16,
                                                        //offset: Offset(2, 2)
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: adminAcceptStatusAdd[
                                                                        index]
                                                                    ['photo'] ==
                                                                null
                                                            ? Text(
                                                                getTranslated(
                                                                    context,
                                                                    'noPhoto'))
                                                            : Stack(
                                                                children: [
                                                                  Image.network(
                                                                    adminAcceptStatusAdd[
                                                                            index]
                                                                        [
                                                                        'photo'],
                                                                    height: 100,
                                                                    width: double
                                                                        .infinity,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Directionality(
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SmoothStarRating(
                                                                            allowHalfRating:
                                                                                false,
                                                                            onRated:
                                                                                (value) {
                                                                              print("rating value -> $value");
                                                                            },
                                                                            starCount:
                                                                                5,
                                                                            rating: adminAcceptStatusAdd[index]['rate'] == null
                                                                                ? 0.0
                                                                                : double.parse(adminAcceptStatusAdd[index]['rate']),
                                                                            size:
                                                                                20.0,
                                                                            isReadOnly:
                                                                                true,
                                                                            color:
                                                                                Colors.yellow,
                                                                            borderColor:
                                                                                Colors.yellow,
                                                                            filledIconData:
                                                                                Icons.star,
                                                                            halfFilledIconData:
                                                                                Icons.star_half,
                                                                            defaultIconData:
                                                                                Icons.star_border,
                                                                            spacing:
                                                                                .5,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              SharedPreferences preferences = await SharedPreferences.getInstance();
                                                                              var isLog = preferences.getBool("islog");
                                                                              isLog == false ? Reusable.showToast(getTranslated(context, 'open'), gravity: ToastGravity.CENTER) : acceptTask(adminAcceptStatusAdd[index]['p_id'].toString(), index);
                                                                              //getLists();
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              faved == false
                                                                                  ? adminAcceptStatusAdd[index]['is_favourite'] == 1
                                                                                      ? Icons.favorite
                                                                                      : Icons.favorite_border
                                                                                  : adminAcceptStatus[index]['is_favourite'] == 1
                                                                                      ? Icons.favorite
                                                                                      : Icons.favorite_border,
                                                                              color: Constants.greenColor(),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                          child: Text(
                                                            adminAcceptStatusAdd[
                                                                            index]
                                                                        [
                                                                        'p_gname'] ==
                                                                    null
                                                                ? getTranslated(
                                                                    context,
                                                                    'noTitle')
                                                                : adminAcceptStatusAdd[
                                                                        index]
                                                                    ['p_gname'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8,
                                                                bottom: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              adminAcceptStatusAdd[index]
                                                                              [
                                                                              'p_price']
                                                                          .toString() ==
                                                                      null
                                                                  ? getTranslated(
                                                                      context,
                                                                      'noPrice')
                                                                  : adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'p_price']
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: adminAcceptStatusAdd[index]
                                                                              [
                                                                              'is_discount'] ==
                                                                          "0"
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .grey,
                                                                  decoration: adminAcceptStatusAdd[index]
                                                                              [
                                                                              'is_discount'] ==
                                                                          "0"
                                                                      ? null
                                                                      : TextDecoration
                                                                          .lineThrough),
                                                            ),
                                                            Text(
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'is_discount'] ==
                                                                      "0"
                                                                  ? ""
                                                                  : adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'offer_price']
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Constants
                                                                    .greenColor(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 4),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          child: Reusable.noData(
                                              msg: getTranslated(
                                                  context, 'noData')))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getRate(i) {
    setState(() {
      rating = adminAcceptStatusAdd[i]['rate'];
    });
  }

  dynamic acceptTask(id, i) async {
    //Reusable.showLoading(context);

    final response = await toggleLike(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      //fav = res['data']['is_favourite'];
      listsToken();
      faved = true;
      // getListsToken();
    } else {
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
    }
  }

  Future getCount() async {
    // print("object" + tabType);
    final loginresponse = await fetchCount();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        read = res['data']['un_read_notification_count'];
      });
    } else {
      setState(() {
        read = 0;
      });
    }
  }

  Future sale() async {
    // print("object" + tabType);
    final loginresponse = await mostSale();
    var res = json.decode(loginresponse.body);

    // setState(() {
    //   most = res;
    // });

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        most = res['data'];
        print(most);
      });
    } else {
      setState(() {
        most = null;
      });
    }
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    rating = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchDietCategoery();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptStatusAdd.add(item);
          });
      }
      // for (var item in res['data']['rate']) {
      //   if (mounted)
      //     setState(() {
      //       rating.add(item);
      //       print(rating);
      //     });
      // }
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

  Future getListsToken() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchDietProductsWithToken();

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

  Future listsToken() async {
    adminAcceptStatus = [];

    final loginresponse = await fetchDietProductsWithToken();

    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptStatus.add(item);
          });
      }
    } else {
      return;
    }
  }
}
