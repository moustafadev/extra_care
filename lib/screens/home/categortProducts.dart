import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/globals.dart' as globals;
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/home/itemscreen.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../consts.dart';

class CategoryProducts extends StatefulWidget {
  final int id;

  const CategoryProducts({Key key, this.id}) : super(key: key);
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

List adminAcceptStatusAdd;

class _CategoryProductsState extends State<CategoryProducts> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    globals.userData['token'] != null ? getListsToken() : getLists();
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
                      appBarWithArrow(
                          context, getTranslated(context, 'products')),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(2),
                        //height: 45,
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            getTranslated(context, 'products'),
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          adminAcceptStatusAdd.length ?? 0,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    color:
                                                        Constants.shadowColor(),
                                                    blurRadius: 16,
                                                    //offset: Offset(2, 2)
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child:
                                                        adminAcceptStatusAdd[
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
                                                                              adminAcceptStatusAdd[index]['is_favourite'] == 1 ? Icons.favorite : Icons.favorite_border,
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
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      child: Text(
                                                        adminAcceptStatusAdd[
                                                                        index][
                                                                    'p_gname'] ==
                                                                null
                                                            ? getTranslated(
                                                                context,
                                                                'noTitle')
                                                            : adminAcceptStatusAdd[
                                                                    index]
                                                                ['p_gname'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8,
                                                            bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          adminAcceptStatusAdd[
                                                                              index]
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
                                                              color: adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'is_discount'] ==
                                                                      "0"
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              decoration: adminAcceptStatusAdd[
                                                                              index]
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
                                                                FontWeight.bold,
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

  dynamic acceptTask(id, i) async {
    //Reusable.showLoading(context);

    final response = await toggleLike(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      getListsToken();
    } else {
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
    }
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchCategoeryProducts(widget.id);

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
    });
    // print("object" + tabType);
    final loginresponse = await fetchCategoeryProductsWithToken(widget.id);

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
