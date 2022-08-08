import 'dart:convert';
import '../../global/globals.dart' as globals;
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/home/itemscreen.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

List adminAcceptStatusAdd;
List adminAcceptStatus;
List adminAcceptSearchAdd;

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchValue = TextEditingController();
  bool loading = false;
  bool searchActive = false;
  var isFav = 0;
  int fav;
  var lang;
  bool faved = false;
  String searchString = "";

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
    globals.userData['token'] != null ? getListsToken() : getLists();
  }

  @override
  void dispose() {
    searchValue.dispose();
    super.dispose();
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
                        children: [
                          //appBarWithArrow(context),
                          // SizedBox(
                          //   height: 2,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.arrow_back,
                                        color: Colors.black)),
                                Container(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: TextFormField(
                                    onChanged: (value) async {
                                      setState(() {
                                        searchActive = true;
                                        if (value.trim() == '') {
                                          searchActive = false;
                                        }
                                        searchString = value.trim();
                                        loading = false;
                                        // searchActive = true;
                                      });
                                      // if (value == "" || value == null) {
                                      //   globals.userData['token'] != null
                                      //       ? getListsToken()
                                      //       : getLists();
                                      // } else {
                                      //   globals.userData['token'] != null
                                      //       ? await getSearchToken(value)
                                      //       : await getSearch(value);
                                      // }
                                      // old code below
                                      // if (value == "" || value == null) {
                                      //   // globals.userData['token'] != null
                                      //   //     ? getListsToken()
                                      //   //     : getLists();
                                      // } else {
                                      //   globals.userData['token'] != null
                                      //       ? getSearchToken(value)
                                      //       : getSearch(value);
                                      // }
                                    },
                                    controller: searchValue,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        hintText:
                                            getTranslated(context, 'search'),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            // if (searchValue.value.text == "" ||
                                            //     searchValue.value.text == null) {
                                            //   globals.userData['token'] != null
                                            //       ? getListsToken()
                                            //       : getLists();
                                            // } else {
                                            //   globals.userData['token'] != null
                                            //       ? getSearchToken(
                                            //           searchValue.value.text)
                                            //       : getSearch(
                                            //           searchValue.value.text);
                                            //   searchValue.clear();
                                            // }
                                            searchValue.clear();
                                            globals.userData['token'] != null
                                                ? getListsToken()
                                                : getLists();
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  ),
                                ),
                              ],
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
                              : searchActive == true
                                  //? searchActive == true
                                  //  adminAcceptSearchAdd.isNotEmpty ||
                                  //         adminAcceptSearchAdd.length != 0
                                  ? FutureBuilder(
                                      future: globals.userData['token'] != null
                                          ? getSearchToken(
                                              searchValue.value.text)
                                          : getSearch(searchValue.value.text),
                                      builder: (context, snapShot) {
                                        if (!snapShot.hasData) {
                                          return Center(
                                              child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.amber),
                                          ));
                                        } else if (snapShot.hasError) {
                                          return Center(
                                            child: Text(
                                                "ERROR: ${snapShot.error}"),
                                          );
                                        } else {
                                          if (snapShot.hasData &&
                                              snapShot.data.isNotEmpty) {
                                            // var searArray = snapShot.data
                                            //     .where((f) =>
                                            //         f['name']
                                            //             .toString()
                                            //             .contains(
                                            //                 searchString
                                            //                     .trim()) &&
                                            //         (searchString.trim() !=
                                            //             ''))
                                            //     .toList();
                                            // print(searArray.toString());
                                          }
                                        }
                                        return snapShot.data.length != 0
                                            ? ListView(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: [
                                                  GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2),
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        snapShot.data.length ??
                                                            0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ItemScreen(
                                                                              details: snapShot.data[index],
                                                                            )));
                                                          },
                                                          child: Container(
                                                            //height: 300,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16.0)),
                                                              boxShadow: <
                                                                  BoxShadow>[
                                                                BoxShadow(
                                                                  color: Constants
                                                                      .shadowColor(),
                                                                  blurRadius:
                                                                      16,
                                                                  //offset: Offset(2, 2)
                                                                ),
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
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  child: snapShot.data[index]
                                                                              [
                                                                              'photo'] ==
                                                                          null
                                                                      ? Text(getTranslated(
                                                                          context,
                                                                          'noPhoto'))
                                                                      : Stack(
                                                                          children: [
                                                                            Image.network(
                                                                              snapShot.data[index]['photo'],
                                                                              height: 100,
                                                                              width: double.infinity,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Directionality(
                                                                                textDirection: TextDirection.ltr,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    SmoothStarRating(
                                                                                      allowHalfRating: false,
                                                                                      onRated: (value) {
                                                                                        print("rating value -> $value");
                                                                                      },
                                                                                      starCount: 5,
                                                                                      rating: snapShot.data[index]['rate'] == null ? 0.0 : double.parse(snapShot.data[index]['rate']),
                                                                                      size: 20.0,
                                                                                      isReadOnly: true,
                                                                                      color: Colors.yellow,
                                                                                      borderColor: Colors.yellow,
                                                                                      filledIconData: Icons.star,
                                                                                      halfFilledIconData: Icons.star_half,
                                                                                      defaultIconData: Icons.star_border,
                                                                                      spacing: .5,
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        SharedPreferences preferences = await SharedPreferences.getInstance();
                                                                                        var isLog = preferences.getBool("islog");
                                                                                        isLog == false ? Reusable.showToast(getTranslated(context, 'open'), gravity: ToastGravity.CENTER) : acceptTask(snapShot.data[index]['p_id'].toString(), index);
                                                                                        //getLists();
                                                                                      },
                                                                                      child: Icon(
                                                                                        faved == false
                                                                                            ? snapShot.data[index]['is_favourite'] == 1
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right: 8),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .4,
                                                                    child: Text(
                                                                      snapShot.data[index]['p_gname'] ==
                                                                              null
                                                                          ? getTranslated(
                                                                              context,
                                                                              'noTitle')
                                                                          : snapShot.data[index]
                                                                              [
                                                                              'p_gname'],
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right: 8,
                                                                      bottom:
                                                                          5),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        snapShot.data[index]['p_price'].toString() ==
                                                                                null
                                                                            ? getTranslated(context,
                                                                                'noPrice')
                                                                            : snapShot.data[index]['p_price'].toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color: snapShot.data[index]['is_discount'] == "0"
                                                                                ? Colors.black
                                                                                : Colors.grey,
                                                                            decoration: snapShot.data[index]['is_discount'] == "0" ? null : TextDecoration.lineThrough),
                                                                      ),
                                                                      Text(
                                                                        snapShot.data[index]['is_discount'] ==
                                                                                "0"
                                                                            ? ""
                                                                            : snapShot.data[index]['offer_price'].toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Constants.greenColor(),
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
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 200,
                                                    child: Reusable.noData(
                                                        msg: getTranslated(
                                                            context,
                                                            'noRes'))));
                                      })
                                  : ListView(
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
      ),
    );
  }

  dynamic acceptTask(id, i) async {
    //Reusable.showLoading(context);

    final response = await toggleLike(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      fav = res['data']['is_favourite'];
      listsToken();
      faved = true;
    } else {
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
    }
  }

  Future getSearch(key) async {
    // adminAcceptSearchAdd = [];
    setState(() {
      //loading = true;
      searchActive = true;
    });

    final loginresponse = await fetchSearch(key);
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      // adminAcceptSearchAdd = [];
      // for (var item in res['data']) {
      //   if (mounted)
      //     setState(() {
      //       adminAcceptSearchAdd.add(item);
      //     });
      // }
      return res['data'];
    } else {
      setState(() {
        loading = false;
      });
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future getSearchToken(key) async {
    // adminAcceptSearchAdd = [];
    // print(adminAcceptSearchAdd.length);
    setState(() {
      // loading = true;
      searchActive = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchSearchWithToken(key);
    var res = json.decode(loginresponse.body);

    if (res['status'] == 1) {
      // for (var item in res['data']) {
      //   if (mounted)
      //     setState(() {
      //       adminAcceptSearchAdd.add(item);
      //     });
      // }
      return res['data'];
    } else {
      setState(() {
        loading = false;
      });
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
      searchActive = false;
    });
    // print("object" + tabType);
    final loginresponse = await fetchProducts();
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

  Future getListsToken() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
      searchActive = false;
    });
    // print("object" + tabType);
    final loginresponse = await fetchProductsWithToken();

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

    final loginresponse = await fetchProductsWithToken();

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
