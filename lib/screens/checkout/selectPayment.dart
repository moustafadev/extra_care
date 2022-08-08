import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../global/globals.dart' as globals;
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:extra_care/widgets/selectTypr.dart';
import 'package:extra_care/screens/orders/successdialog.dart';
import 'package:flutter/material.dart';
import 'package:extra_care/widgets/checkBox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:extra_care/utils/reusable.dart';
import '../../consts.dart';
import 'dart:convert';

import 'package:extra_care/api/apiService.dart';

class PaymentScreen extends StatefulWidget {
  final Map details;
  final int id;
  final String code;
  final int addressId;
  final List<File> attachmentPath;
  final int companyID;

  const PaymentScreen(
      {Key key,
      this.details,
      this.id,
      this.addressId,
      this.code,
      this.companyID,
      this.attachmentPath})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _value1 = false;
  bool _value2 = true;
  String type = 'cache';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: drawer(context),
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      selectType(context, Constants.greyColor(),
                          Constants.redColor(), Constants.greyColor()),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 15, right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              child: Text(
                                '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Constants.redColor(),
                                  style: BorderStyle.solid,
                                ),
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/images/logo.png",
                                          width: 60,
                                          height: 30,
                                        ),
                                      ),
                                      Text(
                                        getTranslated(context, 'cash'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8),
                                    child: MyCheckbox(
                                      checkedFillColor: Constants.skyColor(),
                                      value: _value2,
                                      onChanged: (bool value) => setState(() {
                                        _value2 = value;
                                        _value1 = false;
                                        type = 'cache';
                                        print(type);
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Constants.redColor(),
                                  style: BorderStyle.solid,
                                ),
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/images/visa.jpg",
                                          width: 60,
                                          height: 30,
                                        ),
                                      ),
                                      Text(
                                        getTranslated(context, 'card'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8),
                                    child: MyCheckbox(
                                      checkedFillColor: Constants.skyColor(),
                                      value: _value1,
                                      onChanged: (bool value) => setState(() {
                                        _value1 = value;
                                        _value2 = false;
                                        type = 'machine_card';
                                        print(type);
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              getTranslated(context, 'cach'),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'sub'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.details['total_price'] == null
                                        ? getTranslated(context, 'noPrice')
                                        : widget.details['total_price']
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       getTranslated(context, 'tax'),
                              //       style: TextStyle(
                              //         color: Colors.black,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //     Text(
                              //       widget.details['tax_fees'] == null
                              //           ? getTranslated(context, 'noPrice')
                              //           : widget.details['tax_fees'].toString(),
                              //       style: TextStyle(
                              //         color: Colors.black,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'del'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.details['delivery_cost'] == null
                                        ? getTranslated(context, 'noPrice')
                                        : widget.details['delivery_cost']
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  upload(widget.attachmentPath, context);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  width:
                                      MediaQuery.of(context).size.width * .85,
                                  decoration: BoxDecoration(
                                      color: Constants.skyColor(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated(context, 'next'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        widget.details['ask_to_pay'] == null
                                            ? getTranslated(context, 'noPrice')
                                            : widget.details['ask_to_pay']
                                                    .toString() +
                                                getTranslated(context, 'le'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
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

  dynamic removeAddres() async {
    // ignore: unused_local_variable
    var headers;
    Reusable.showLoading(context);
    final response = await checkout(
        widget.addressId.toString(), widget.id.toString(), type, widget.code);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);

      //successdialog(context,responseData['data']);
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future<dynamic> upload(List<File> imageFile, BuildContext context) async {
    print("attachment" + widget.attachmentPath.toString());
    print("attachment" + widget.companyID.toString());
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    var uri = Uri.parse(
        'https://chromateck.com/laurus/api/v1/order/check-out?lang=$languageCode');

    var request = new http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer ' + globals.userData['token']});
    if (widget.attachmentPath == null ||
        widget.attachmentPath == [] ||
        widget.companyID == 0 ||
        widget.companyID == null) {
      request.fields['address_id'] = widget.addressId.toString();
      request.fields['branch_id'] = widget.id.toString();
      request.fields['payment_method'] = type;
      request.fields['coupon_code'] = widget.code;

      Reusable.showLoading(context);

      var response = await request.send();
      var responses = await http.Response.fromStream(response);
      print("responseData : " + responses.body);
      Map<String, dynamic> responseData = json.decode(responses.body);
      if (responseData['status'] == 1) {
        Reusable.dismissLoading();
        // Reusable.showToast(responseData['massage'],
        //     gravity: ToastGravity.CENTER);
        successdialog(context, responseData['data']);
      } else if (responseData['status'] == 0) {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
      }
    } else if (widget.attachmentPath.isNotEmpty) {
      for (int i = 0; i < widget.attachmentPath.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          imageFile[i] == null ? null : 'Insurance_attachments[$i]',
          imageFile[i].path == null ? null : imageFile[i].path,
        ));
      }
      request.fields['address_id'] = widget.addressId.toString();
      request.fields['branch_id'] = widget.id.toString();
      request.fields['payment_method'] = type;
      request.fields['coupon_code'] = widget.code;
      request.fields['insurance_company_id'] = widget.companyID.toString();

      Reusable.showLoading(context);

      var response = await request.send();
      var responses = await http.Response.fromStream(response);
      print("responseData : " + responses.body);
      Map<String, dynamic> responseData = json.decode(responses.body);
      if (responseData['status'] == 1) {
        Reusable.dismissLoading();

        // Reusable.showToast(responseData['massage'],
        //     gravity: ToastGravity.CENTER);
        successdialog(context, responseData['data']);
      } else if (responseData['status'] == 0) {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
      }
    }
  }
}
