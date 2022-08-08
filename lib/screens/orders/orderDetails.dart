import 'package:extended_image/extended_image.dart';
import 'package:extra_care/screens/fav/favscreen.dart';
import 'package:flutter/material.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/api/models/branches.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'dart:convert';
import 'package:extra_care/screens/orders/orderList.dart';
import 'package:extra_care/screens/orders/trackOrder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extra_care/widgets/checkBox.dart';
import '../../global/globals.dart' as globals;
import 'package:http/http.dart' as http;
import '../../consts.dart';

class OrderDetails extends StatefulWidget {
  final Map details;

  const OrderDetails({Key key, this.details}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

List adminAcceptStatusAdd;
PostpondModels _postpondModels = new PostpondModels();
BranchesData selectedBranch;

class _OrderDetailsState extends State<OrderDetails> {
  bool edit = false;
  bool isSelected = false;
  bool loading = false;
  int branchID = 0;
  int selectRadio;
  int addressId = 0;
  String branchName;
  bool _value1 = false;
  bool _value2 = false;
  String type = '';

  @override
  void initState() {
    super.initState();
    selectRadio = 0;
    getLists();
    selectedBranch = null;
    pospondReason().then((value) {
      setState(() {
        _postpondModels = value;
      });
    });
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
                          context, getTranslated(context, 'ordDet')),
                      Container(
                        width: double.infinity,
                        //height: 45,
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Text(
                                getTranslated(context, 'ordDet'),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => TrackOrder(
                                            details: widget.details,
                                          )));
                                },
                                child: Text(
                                  getTranslated(context, 'trackOrder'),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Constants.redColor()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'orderId'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      widget.details['id'] == null
                                          ? getTranslated(context, 'noTitle')
                                          : widget.details['id'].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.skyColor()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'total'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      widget.details['ask_to_pay'] == null
                                          ? getTranslated(context, 'noPrice')
                                          : widget.details['ask_to_pay']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.skyColor()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'status'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      widget.details['status'] == null
                                          ? getTranslated(context, 'noStat')
                                          : widget.details['status'].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.skyColor()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'branName'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      widget.details['branch'] == null
                                          ? getTranslated(context, 'noBran')
                                          : widget.details['branch']['trans']
                                              ['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.skyColor()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'address'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Flexible(
                                      //alignment: Alignment.topRight,
                                      child: Text(
                                        widget.details['address'] == null
                                            ? getTranslated(context, 'noStat')
                                            : widget.details['address']['title']
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Constants.skyColor()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'pay'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      widget.details['payment_method'] == null
                                          ? getTranslated(context, 'noPay')
                                          : widget.details['payment_method'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.skyColor()),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'insDis'),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      widget.details['insurance_discount'] ==
                                              null
                                          ? getTranslated(context, 'noDiscount')
                                          : widget.details['insurance_discount']
                                                  .toString() +
                                              " % ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.skyColor()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              widget.details['status'] == 'pending'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              rejectOffer();
                                            },
                                            child: Text(
                                              getTranslated(
                                                  context, 'cancelOrder'),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Constants.redColor()),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                edit = true;
                                              });
                                            },
                                            child: Text(
                                              getTranslated(
                                                  context, 'editOrder'),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Constants.skyColor()),
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
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                // controller: _items,
                                itemCount:
                                    (widget.details['products_data'] as List)
                                        .length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return Card(
                                      elevation: 2,
                                      child: Column(
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
                                                Flexible(
                                                  child: widget.details[
                                                                  'products_data']
                                                              [i]['type'] ==
                                                          'prescription'
                                                      ? InkWell(
                                                          onTap: () {
                                                            viewItem(
                                                                context,
                                                                widget.details[
                                                                        'products_data'][i]
                                                                    [
                                                                    'attachment']);
                                                          },
                                                          child: Image.network(
                                                            widget.details[
                                                                    'products_data']
                                                                [
                                                                i]['attachment'],
                                                            width: 70,
                                                            height: 50,
                                                            fit: BoxFit.fill,
                                                          ))
                                                      : Text(
                                                          widget.details['products_data']
                                                                          [i][
                                                                      'product'] ==
                                                                  null
                                                              ? getTranslated(
                                                                  context,
                                                                  'noTitle')
                                                              : widget.details[
                                                                          'products_data'][i]
                                                                      [
                                                                      'product']
                                                                  ['p_gname'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.details['products_data']
                                                                    [i]
                                                                ['product'] ==
                                                            null
                                                        ? widget.details['products_data']
                                                                        [i]
                                                                    ['note'] ==
                                                                null
                                                            ? getTranslated(
                                                                context, 'noNote')
                                                            : widget.details[
                                                                    'products_data']
                                                                [i]['note']
                                                        : widget
                                                            .details['products_data']
                                                                [i]['product']
                                                                ['p_price']
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Constants
                                                            .redColor()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            itemCount:
                                                (widget.details['products_data']
                                                        [i]['children'] as List)
                                                    .length,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, b) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            widget.details['products_data']
                                                                            [i][
                                                                        'children'] ==
                                                                    null
                                                                ? getTranslated(
                                                                    context,
                                                                    'noTitle')
                                                                : widget.details['products_data']
                                                                                [i]
                                                                            [
                                                                            'children'][b]
                                                                        [
                                                                        'product']
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
                                                        Text(
                                                          widget.details['products_data'][i]
                                                                          ['children'][b][
                                                                      'product'] ==
                                                                  null
                                                              ? getTranslated(
                                                                  context,
                                                                  'noPrice')
                                                              : widget.details[
                                                                      'products_data']
                                                                      [i]
                                                                      ['children']
                                                                      [b]
                                                                      ['product']
                                                                      ['p_price']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color: Constants
                                                                  .redColor()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          getTranslated(
                                                              context, 'note'),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            widget.details['products_data'][i]
                                                                            ['children'][b]
                                                                        [
                                                                        'note'] ==
                                                                    null
                                                                ? getTranslated(
                                                                    context,
                                                                    'noNote')
                                                                : widget.details[
                                                                            'products_data'][i]
                                                                        [
                                                                        'children']
                                                                    [b]['note'],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Constants
                                                                    .redColor()),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  (widget.details['products_data']
                                                                          [i][
                                                                      'children']
                                                                  as List)
                                                              .length ==
                                                          0
                                                      ? Container()
                                                      : widget.details['products_data']
                                                                              [i]
                                                                          ['children'][b]
                                                                      [
                                                                      'product']
                                                                  [
                                                                  'is_favourite'] ==
                                                              1
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right: 8,
                                                                      bottom:
                                                                          8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      acceptTask(widget
                                                                          .details[
                                                                              'products_data']
                                                                              [
                                                                              i]
                                                                              [
                                                                              'children']
                                                                              [
                                                                              b]
                                                                              [
                                                                              'product']
                                                                              [
                                                                              'p_id']
                                                                          .toString());
                                                                    },
                                                                    child: Text(
                                                                      getTranslated(
                                                                          context,
                                                                          'my'),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          decoration: TextDecoration
                                                                              .underline,
                                                                          color:
                                                                              Constants.redColor()),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // خدي دي كوبي و اقلبي الحالة بحيث لو null يبقا كدا يعرض التانيين

                                          widget.details['products_data'][i]
                                                      ['product'] ==
                                                  null
                                              ? Container()
                                              : widget.details['products_data']
                                                              [i]['product']
                                                          ['is_favourite'] ==
                                                      1
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8,
                                                              bottom: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              acceptTask(widget
                                                                  .details[
                                                                      'products_data']
                                                                      [i][
                                                                      'product']
                                                                      ['p_id']
                                                                  .toString());
                                                            },
                                                            child: Text(
                                                              getTranslated(
                                                                  context,
                                                                  'my'),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  color: Constants
                                                                      .redColor()),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      edit == false
                          ? Container()
                          : loading
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .2,
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
                                  ? Container(
                                      //height: 350.0,
                                      child: Column(
                                        children: adminAcceptStatusAdd
                                            .map((data) => RadioListTile(
                                                  title: Text(data['title']),
                                                  groupValue: addressId,
                                                  value: data['id'],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      addressId = data['id'];
                                                      print("addressId" +
                                                          addressId.toString());
                                                    });
                                                  },
                                                  selected: true,
                                                ))
                                            .toList(),
                                      ),
                                    )
                                  : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      edit == false
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getTranslated(context, 'near'),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      _postpondModels != null &&
                                              _postpondModels.data != null &&
                                              _postpondModels.data.isNotEmpty
                                          ? branchDropDown(context)
                                          : Container(),
                                    ],
                                  ),
                                  Text(
                                    selectedBranch == null
                                        ? widget.details['branch']['trans']
                                            ['title']
                                        : branchName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    getTranslated(context, 'max') +
                                        widget.details['branch']
                                                ['maximum_delivery_time']
                                            .toString()
                                            .substring(0, 2) +
                                        getTranslated(context, 'min'),
                                    style: TextStyle(
                                      color: Constants.hintColor(),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      edit == false
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 15, right: 15),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                "assets/images/logo.png",
                                                width: 60,
                                                height: 30,
                                              ),
                                            ),
                                            Text(
                                              getTranslated(context, 'cash'),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, left: 8),
                                          child: MyCheckbox(
                                            checkedFillColor:
                                                Constants.skyColor(),
                                            value: _value2,
                                            onChanged: (bool value) =>
                                                setState(() {
                                              _value2 = true;
                                              _value1 = false;
                                              type = 'cache';
                                              print("type" + type);
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                "assets/images/visa.jpg",
                                                width: 60,
                                                height: 30,
                                              ),
                                            ),
                                            Text(
                                              getTranslated(context, 'card'),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, left: 8),
                                          child: MyCheckbox(
                                            checkedFillColor:
                                                Constants.skyColor(),
                                            value: _value1,
                                            onChanged: (bool value) =>
                                                setState(() {
                                              _value1 = true;
                                              _value2 = false;
                                              type = 'machine_card';
                                              print("type" + type);
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                      edit == false
                          ? Container()
                          : InkWell(
                              onTap: () {
                                if (branchID == 0 &&
                                    addressId == 0 &&
                                    type == "") {
                                } else {
                                  upload(context);
                                }
                                //removeAddres();
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .08,
                                width: MediaQuery.of(context).size.width * .4,
                                decoration: BoxDecoration(
                                    color: (branchID == 0 &&
                                            addressId == 0 &&
                                            type == "")
                                        ? Colors.grey
                                        : Constants.greenColor(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                alignment: Alignment.center,
                                child: Text(
                                  getTranslated(context, 'submit'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
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

  dynamic rejectOffer() async {
    Reusable.showLoading(context);

    final response = await cancelOrder(widget.details['id'].toString());
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      Reusable.dismissLoading();
      Reusable.showToast("done", gravity: ToastGravity.CENTER);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrederList(),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => OrederList()),
      //     (route) => false);
      //adminAcceptStatusAdd.removeAt(i);
      //getLists();
    } else {
      Reusable.dismissLoading();
      Reusable.showToast("false", gravity: ToastGravity.CENTER);
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Widget branchDropDown(
    BuildContext context,
  ) {
    //List<String> branches = <String>["Alex ", "Dokki", "Haram"];
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * 0.05,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BranchesData>(
          iconSize: 0.0,
          isExpanded: true,
          isDense: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Text(
              getTranslated(context, 'change'),
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
          dropdownColor: Colors.white,
          value: null,
          items: _postpondModels.data
              .map<DropdownMenuItem<BranchesData>>((BranchesData value) {
            return DropdownMenuItem<BranchesData>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: new Text(value.trans.title,
                    style:
                        TextStyle(color: Constants.skyColor(), fontSize: 14)),
              ),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              selectedBranch = val;
              branchID = val.id;
              branchName = val.trans.title;
              print("branchId" + branchID.toString());
            });
          },
        ),
      ),
    );
  }

  dynamic acceptTask(id) async {
    //Reusable.showLoading(context);

    final response = await toggleLike(id);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      // Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => FavoriteScreen()),
      //     (route) => false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FavoriteScreen(),
        ),
      );
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => FavoriteScreen()));
    } else {
      //Reusable.dismissLoading();
      //Reusable.showToast("false", gravity: ToastGravity.CENTER);
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
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
      setState(() {
        loading = false;
      });
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future<PostpondModels> pospondReason() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(Language_Code);
    Reusable.showLoading(context);
    http.Response response = await http.get(
      Uri.parse(
          'https://chromateck.com/laurus/api/v1/home?type=branches&response_type=all&lang=$languageCode'),
    );
    Reusable.dismissLoading();
    return new PostpondModels.fromJson(json.decode(response.body));
  }

  Future<dynamic> upload(BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    //var headers = {'Authorization': 'Bearer ' + globals.userData['token']}
    var uri = Uri.parse(
        "https://chromateck.com/laurus/api/v1/order/update?lang=$languageCode");

    var request = new http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

    if (branchID == null || branchID == 0) {
      setState(() {
        branchID = widget.details['branch']['id'];
      });
    }
    if (addressId == 0 || addressId == null) {
      setState(() {
        addressId = widget.details['address']['id'];
      });
    }

    if (type == "" || type == null) {
      setState(() {
        type = widget.details['payment_method'];
      });
    }
    request.fields['order_id'] = widget.details['id'].toString();
    request.fields['address_id'] = addressId.toString();
    request.fields['branch_id'] = branchID.toString();
    request.fields['payment_method'] = type;

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
            MaterialPageRoute(builder: (context) => OrederList()),
            (route) => false);
      });
    } else if (responseData['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(responseData['massage'], gravity: ToastGravity.CENTER);
    }
  }
}
