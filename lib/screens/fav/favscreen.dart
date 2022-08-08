import 'dart:convert';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/home/itemscreen.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../consts.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

List adminAcceptStatusAdd;

class _FavoriteScreenState extends State<FavoriteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false;
  //static int length = 17;
  //List<bool> _isFavorited = List<bool>.generate(length, (_) => false);

  @override
  void initState() {
    super.initState();
    getLists();
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
                      children: [
                        appBarWithArrow(context, getTranslated(context, 'fav')),
                        Container(
                          width: double.infinity,
                          //height: 50,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              getTranslated(context, 'fav'),
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          ),
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
                                    adminAcceptStatusAdd.length == 0
                                ? ListView.builder(
                                    itemCount: adminAcceptStatusAdd.length ?? 0,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => ItemScreen(
                                                      details:
                                                          adminAcceptStatusAdd[
                                                              index])));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0,
                                              left: 8,
                                              right: 8,
                                              bottom: 4),
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: adminAcceptStatusAdd[
                                                                    index]
                                                                ['photo'] ==
                                                            null
                                                        ? Text(getTranslated(
                                                            context, 'noPhoto'))
                                                        : Image.network(
                                                            adminAcceptStatusAdd[
                                                                index]['photo'],
                                                            width: 100,
                                                            height: 80,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
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
                                                                      [
                                                                      'p_gname'],
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              acceptTask(
                                                                  adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'p_id']
                                                                      .toString(),
                                                                  index);
                                                              //getLists();
                                                            },
                                                            child: Icon(
                                                              adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'is_favourite'] ==
                                                                      1
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              color: Constants
                                                                  .greenColor(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        child: Text(
                                                          adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'p_desc'] ==
                                                                  null
                                                              ? getTranslated(
                                                                  context, 'noDis')
                                                              : adminAcceptStatusAdd[index]
                                                                              [
                                                                              'p_desc']
                                                                          .toString()
                                                                          .length >
                                                                      68
                                                                  ? adminAcceptStatusAdd[index]
                                                                              [
                                                                              'p_desc']
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              63) +
                                                                      "..."
                                                                  : adminAcceptStatusAdd[
                                                                              index]
                                                                          [
                                                                          'p_desc']
                                                                      .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Constants
                                                                  .hintColor()),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        adminAcceptStatusAdd[
                                                                        index][
                                                                    'p_price'] ==
                                                                null
                                                            ? getTranslated(
                                                                context,
                                                                'noPrice')
                                                            : adminAcceptStatusAdd[
                                                                        index]
                                                                    ['p_price']
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ),
                                                  ],
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                        child: Reusable.noData(
                                            msg: getTranslated(
                                                context, 'noFav')))),
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

  dynamic acceptTask(id, i) async {
    //Reusable.showLoading(context);

    final response = await toggleLike(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      //Reusable.showToast("done", gravity: ToastGravity.CENTER);
      adminAcceptStatusAdd.removeAt(i);
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
    final loginresponse = await fetchFav();
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
