import 'dart:convert';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/checkout/selectaddress.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../../consts.dart';

class AddressList extends StatefulWidget {
  final Map details;

  const AddressList({Key key, this.details}) : super(key: key);
  @override
  _AddressListState createState() => _AddressListState();
}

List adminAcceptStatusAdd;

class _AddressListState extends State<AddressList> {
  TextEditingController address = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelected = false;
  bool loading = false;
  double latitude;
  double longitude;
  int selectRadio;
  int addressId = 0;
  String addressName;

  @override
  void initState() {
    super.initState();
    selectRadio = 0;
    getCurrentLocation();
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      appBarWithArrow(
                          context, getTranslated(context, 'checkout')),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                              elevation: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Constants.shadowColor(),
                                        blurRadius: 16,
                                        offset: Offset(4, 4)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    loading
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7.0)),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey[600],
                                                        style:
                                                            BorderStyle.solid)),
                                                child: Reusable.showLoader(
                                                    loading)),
                                          )
                                        : adminAcceptStatusAdd.isNotEmpty ||
                                                adminAcceptStatusAdd.length == 0
                                            ? Container(
                                                //height: 350.0,
                                                child: Column(
                                                  children: adminAcceptStatusAdd
                                                      .map((data) =>
                                                          RadioListTile(
                                                            secondary: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 2.0,
                                                                      right: 2),
                                                              child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    removeAddres(
                                                                        data['id']
                                                                            .toString());
                                                                    //getLists();
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Constants
                                                                        .skyColor(),
                                                                  )),
                                                            ),
                                                            title: Text(
                                                                data['title']),
                                                            groupValue:
                                                                addressId,
                                                            value: data['id'],
                                                            onChanged: (val) {
                                                              setState(() {
                                                                addressName =
                                                                    data[
                                                                        'title'];
                                                                // selectRadio =
                                                                //     data[
                                                                //         'title'];
                                                                addressId =
                                                                    data['id'];
                                                                print(
                                                                    addressId);
                                                                print(
                                                                    addressName);
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => SelectAddress(
                                                                              addId: addressId,
                                                                              details: widget.details,
                                                                              addName: addressName,
                                                                            )));
                                                              });
                                                            },
                                                            selected: true,
                                                          ))
                                                      .toList(),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8, top: 4),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    child: Reusable.noData(
                                                        msg: getTranslated(
                                                            context,
                                                            'noData')))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        touristNameDialog(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Text(
                                          getTranslated(context, 'new'),
                                          style: TextStyle(
                                              color: Constants.redColor(),
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> touristNameDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'address')),
            content: TextFormField(
              style: TextStyle(fontSize: 16, color: Colors.black),
              minLines: 1,
              maxLines: 1,
              controller: address,
              decoration: InputDecoration(
                counterText: "",
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(getTranslated(context, 'ok'),
                    style: TextStyle(
                      color: Constants.skyColor(),
                    )),
                onPressed: () async {
                  if (address.text.isEmpty) {
                  } else {
                    getCurrentLocation();
                    addAddres(address.value.text, latitude.toString(),
                        longitude.toString());
                    address.clear();
                    Navigator.of(context).pop();
                    //getLists();
                  }
                },
              ),
            ],
          );
        });
  }

  dynamic addAddres(title, lat, long) async {
    // ignore: unused_local_variable
    var headers;
    //Reusable.showLoading(context);
    getCurrentLocation();
    final response = await addAddress(title, lat, long);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      // Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      getLists();
    } else {
      //Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  dynamic removeAddres(id) async {
    // ignore: unused_local_variable
    var headers;
    //Reusable.showLoading(context);
    getCurrentLocation();
    final response = await removeAddress(id);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //adminAcceptStatusAdd.removeAt(i);
      getLists();
    } else {
      //Reusable.dismissLoading();

      // Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  getCurrentLocation() async {
    var answer = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = answer.latitude;
      longitude = answer.longitude;
      print("distance" +
          latitude.toString() +
          "distances" +
          longitude.toString());
    });
    return answer;
  }

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchAddressList();
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
      return;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }
}
