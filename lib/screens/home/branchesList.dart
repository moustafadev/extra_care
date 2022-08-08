import 'dart:convert';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class BranchesList extends StatefulWidget {
  @override
  _BranchesListState createState() => _BranchesListState();
}

List adminAcceptStatusAdd;

class _BranchesListState extends State<BranchesList> {
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
                      appBarWithArrow(
                          context, getTranslated(context, 'branch')),
                      Container(
                        width: double.infinity,
                        //height: 45,
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            getTranslated(context, 'branch'),
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
                                      onTap: () {},
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
                                                          context, 'branName'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      adminAcceptStatusAdd[
                                                                      index]
                                                                  ['trans'] ==
                                                              null
                                                          ? getTranslated(
                                                              context,
                                                              'noTitle')
                                                          : adminAcceptStatusAdd[
                                                                      index]
                                                                  ['trans']
                                                              ['title'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
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
                                                          context, 'maxTime'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      adminAcceptStatusAdd[
                                                                      index][
                                                                  'maximum_delivery_time'] ==
                                                              null
                                                          ? getTranslated(
                                                              context, 'noMax')
                                                          : adminAcceptStatusAdd[
                                                                          index]
                                                                      [
                                                                      'maximum_delivery_time']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 2) +
                                                              getTranslated(
                                                                  context,
                                                                  'min'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
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

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchBranches();
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
