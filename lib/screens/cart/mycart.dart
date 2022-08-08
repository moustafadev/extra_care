import 'dart:convert';
import 'package:extra_care/screens/cart/loginForCart.dart';

import '../../global/globals.dart' as globals;
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/consts.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/screens/checkout/selectaddress.dart';
import 'package:extra_care/screens/home/resultScreen.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appbar.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

List adminAcceptStatusAdd;
List checkout;
Map totalCheck;

class _MyCartScreenState extends State<MyCartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  bool noData = false;
  int read = 0;
  List<int> edit;
  bool isEdit = false;
  //static int length = 100;
  //List<int> _itemCount = List<int>.generate(length, (_) => 1);

  @override
  void initState() {
    super.initState();
    globals.userData['token'] != null ? getLists() : getSerialLists();
    getCount();
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
                        appBar(context, _scaffoldKey, read),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              getTranslated(context, 'myCart'),
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // (name == false)
                        //     ? Padding(
                        //         padding:
                        //             EdgeInsets.only(left: 8, right: 8, top: 4),
                        //         child: Container(
                        //             width: MediaQuery.of(context).size.width,
                        //             height: 115,
                        //             child: Reusable.noData(
                        //                 msg: getTranslated(context, 'must'))))
                        //     :
                        loading
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Container(
                                    height: 115,
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
                                    adminAcceptStatusAdd.length != 0 ||
                                    adminAcceptStatusAdd == null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 5, right: 5),
                                    child: ListView.builder(
                                      itemCount: adminAcceptStatusAdd.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            viewItem(context, index);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Card(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Constants
                                                            .shadowColor(),
                                                        blurRadius: 16,
                                                        offset: Offset(4, 4)),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    adminAcceptStatusAdd[index]
                                                                ['type'] ==
                                                            'prescription'
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                  child: adminAcceptStatusAdd[index]
                                                                              [
                                                                              'attachment'] ==
                                                                          null
                                                                      ? Text(getTranslated(
                                                                          context,
                                                                          'noPhoto'))
                                                                      : Image
                                                                          .network(
                                                                          adminAcceptStatusAdd[index]
                                                                              [
                                                                              'attachment'],
                                                                          width:
                                                                              85,
                                                                          height:
                                                                              80,
                                                                        ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .5,
                                                                  child: Text(
                                                                    adminAcceptStatusAdd[index]['note'] ==
                                                                            null
                                                                        ? getTranslated(
                                                                            context,
                                                                            'noNote')
                                                                        : adminAcceptStatusAdd[index]
                                                                            [
                                                                            'note'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                    onTap: () {
                                                                      globals.userData['token'] !=
                                                                              null
                                                                          ? removeAddres(
                                                                              adminAcceptStatusAdd[index]['id']
                                                                                  .toString(),
                                                                              index)
                                                                          : removeAddresSerial(
                                                                              adminAcceptStatusAdd[index]['id'].toString(),
                                                                              index);
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red,
                                                                    )),
                                                              ],
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    bottom: 8,
                                                                    right: 1,
                                                                    left: 1),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: adminAcceptStatusAdd[index]
                                                                              [
                                                                              'product'] ==
                                                                          null
                                                                      ? Text(getTranslated(
                                                                          context,
                                                                          'noPhoto'))
                                                                      : Image
                                                                          .network(
                                                                          adminAcceptStatusAdd[index]['product']
                                                                              [
                                                                              'photo'],
                                                                          width:
                                                                              65,
                                                                          height:
                                                                              50,
                                                                        ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            .7,
                                                                        child:
                                                                            Text(
                                                                          adminAcceptStatusAdd[index]['product'] == null
                                                                              ? getTranslated(context, 'noTitle')
                                                                              : adminAcceptStatusAdd[index]['product']['p_gname'],
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            .7,
                                                                        child:
                                                                            Text(
                                                                          adminAcceptStatusAdd[index]['product'] == null
                                                                              ? getTranslated(context, 'noTitle')
                                                                              : adminAcceptStatusAdd[index]['product']['type'],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    adminAcceptStatusAdd[index]
                                                                ['type'] ==
                                                            'prescription'
                                                        ? Container()
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 75,
                                                                    ),
                                                                    Text(
                                                                      adminAcceptStatusAdd[index]['product']['p_price'] ==
                                                                              null
                                                                          ? getTranslated(
                                                                              context,
                                                                              'noPrice')
                                                                          : adminAcceptStatusAdd[index]['product']['p_price'].toString() +
                                                                              getTranslated(context, 'le'),
                                                                      style: TextStyle(
                                                                          decoration: adminAcceptStatusAdd[index]['product']['is_discount'] == "0"
                                                                              ? null
                                                                              : TextDecoration
                                                                                  .lineThrough,
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                        adminAcceptStatusAdd[index]['product']['is_discount'] ==
                                                                                "0"
                                                                            ? ""
                                                                            : adminAcceptStatusAdd[index]['product']['offer_price'].toString() +
                                                                                getTranslated(context, 'le'),
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Constants.redColor(),
                                                                        )),
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                  onTap: () {},
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 90,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.grey[
                                                                            400],
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(25))),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          child: adminAcceptStatusAdd[index]['quantity'] == 1
                                                                              ? Icon(
                                                                                  Icons.delete,
                                                                                  size: 15,
                                                                                )
                                                                              : Text(
                                                                                  "-",
                                                                                  style: TextStyle(fontSize: 20),
                                                                                ),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (adminAcceptStatusAdd[index]['quantity'] > 1) {
                                                                                adminAcceptStatusAdd[index]['quantity']--;
                                                                                globals.userData['token'] != null ? editCount(adminAcceptStatusAdd[index]['id'].toString(), adminAcceptStatusAdd[index]['quantity'].toString(), index) : editCountSerial(adminAcceptStatusAdd[index]['id'].toString(), adminAcceptStatusAdd[index]['quantity'].toString(), index);
                                                                              } else if (adminAcceptStatusAdd[index]['quantity'] == 1) {
                                                                                globals.userData['token'] != null ? removeAddres(adminAcceptStatusAdd[index]['id'].toString(), index) : removeAddresSerial(adminAcceptStatusAdd[index]['id'].toString(), index);
                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                        new Text(
                                                                          adminAcceptStatusAdd[index]['quantity']
                                                                              .toString(),
                                                                          //  isEdit == false ? adminAcceptStatusAdd[index]['quantity'].toString() : edit[index].toString(),
                                                                          // _itemCount[index].toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 15),
                                                                        ),
                                                                        InkWell(
                                                                          child:
                                                                              Text(
                                                                            "+",
                                                                            style:
                                                                                TextStyle(fontSize: 20),
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              adminAcceptStatusAdd[index]['quantity']++;
                                                                              globals.userData['token'] != null ? editCount(adminAcceptStatusAdd[index]['id'].toString(), adminAcceptStatusAdd[index]['quantity'].toString(), index) : editCountSerial(adminAcceptStatusAdd[index]['id'].toString(), adminAcceptStatusAdd[index]['quantity'].toString(), index);
                                                                            });
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    adminAcceptStatusAdd[index]
                                                                ['type'] ==
                                                            'prescription'
                                                        ? Container()
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 75,
                                                                    ),
                                                                    Text(
                                                                      getTranslated(
                                                                          context,
                                                                          'addtotal'),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                        adminAcceptStatusAdd[index]['additions_total_price'] ==
                                                                                null
                                                                            ? ""
                                                                            : adminAcceptStatusAdd[index]['additions_total_price'].toString() +
                                                                                getTranslated(context, 'le'),
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Constants.redColor(),
                                                                        )),
                                                                  ],
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
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .15,
                                            //alignment: Alignment.center,
                                            child: Image.asset(
                                                'assets/images/scroll.jpg',
                                                fit: BoxFit.fill),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 170,
                                            height: 170,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Constants.greenColor(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                            ),
                                            child: Icon(
                                              Icons.shopping_basket,
                                              color: Colors.white,
                                              size: 90,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Text(
                                            getTranslated(context, 'empty'),
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Constants.skyColor()),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // Center(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(
                                          //         15.0),
                                          //     child: Text(
                                          //       getTranslated(
                                          //           context, 'good'),
                                          //       style: TextStyle(
                                          //           fontSize: 18,
                                          //           color: Constants
                                          //               .skyColor()),
                                          //     ),
                                          //   ),
                                          // ),
                                          //SizedBox(height: 10,),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResultScreen()));
                                            },
                                            child: Text(
                                              getTranslated(context, 'bro'),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                        SizedBox(
                          height: 10,
                        ),
                        adminAcceptStatusAdd.isNotEmpty ||
                                adminAcceptStatusAdd.length != 0 ||
                                noData == true
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomTabScreen()));
                                      },
                                      child: Container(
                                        height: 40,
                                        // width: 120,
                                        decoration: BoxDecoration(
                                            color: Constants.skyColor(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            getTranslated(context, 'back'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Reusable.showLoading(context);
                                        await check();
                                        Reusable.dismissLoading();
                                        globals.userData['token'] != null
                                            ? Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectAddress(
                                                          details: totalCheck,
                                                        )))
                                            : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreenForCart()));
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Constants.redColor(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            getTranslated(context, 'checkout'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
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

  viewItem(BuildContext context, i) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        //isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: new Container(
              // height: MediaQuery.of(context).size.height * .75,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                  // decoration: new BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: new BorderRadius.only(
                  //         topLeft: const Radius.circular(30.0),
                  //         topRight: const Radius.circular(30.0))),
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 12, left: 12, bottom: 8),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'inform'),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30.0))),
                      child: adminAcceptStatusAdd[i]['product'] == null
                          ? Text(getTranslated(context, 'noPhoto'))
                          : Image.network(
                              adminAcceptStatusAdd[i]['product']['photo'],
                              width: 70,
                              height: 70,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        adminAcceptStatusAdd[i]['product'] == null
                            ? getTranslated(context, 'noTitle')
                            : adminAcceptStatusAdd[i]['product']['p_gname'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        adminAcceptStatusAdd[i]['product'] == null
                            ? getTranslated(context, 'noTitle')
                            : adminAcceptStatusAdd[i]['product']['type'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        adminAcceptStatusAdd[i]['product'] == null
                            ? getTranslated(context, 'noTitle')
                            : adminAcceptStatusAdd[i]['product']['p_price']
                                .toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      getTranslated(context, 'prodDis'),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Text(
                        adminAcceptStatusAdd[i]['product'] == null
                            ? getTranslated(context, 'noDis')
                            : adminAcceptStatusAdd[i]['product']['p_desc']
                                .toString(),
                        style: TextStyle(
                            fontSize: 14, color: Constants.hintColor()),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              )),
            ),
          );
        });
  }

  dynamic removeAddres(id, i) async {
    final response = await removeCartItem(id);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      adminAcceptStatusAdd.removeAt(i);
      getLists();
    } else {
      //Reusable.dismissLoading();

      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  dynamic editCount(id, count, i) async {
    final response = await editCartCount(id, count);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //adminAcceptStatusAdd.removeAt(i);
      // setState(() {
      //   edit = adminAcceptStatusAdd[i]['quantity'];
      //   isEdit = true;
      // });
      //getLists();
    } else {
      //Reusable.dismissLoading();

      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      // setState(() {
      //   isEdit = false;
      // });
    }
  }

  dynamic removeAddresSerial(id, i) async {
    final response = await removeCartItemSerial(id);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      adminAcceptStatusAdd.removeAt(i);
      getSerialLists();
    } else {}
  }

  dynamic editCountSerial(id, count, i) async {
    final response = await editCartCountSerial(id, count);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
    } else {}
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

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchCart();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      if (mounted)
        setState(() {
          totalCheck = res['total_order_data'];
        });
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptStatusAdd.add(item);
            noData = true;
          });
      }
    } else {
      setState(() {
        loading = false;
        noData = false;
      });
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //return;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future getSerialLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchCartSerial();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      if (mounted)
        setState(() {
          totalCheck = res['total_order_data'];
        });
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptStatusAdd.add(item);
            noData = true;
          });
      }
    } else {
      setState(() {
        loading = false;
        noData = false;
      });
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //return;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future check() async {
    checkout = [];
    // print("object" + tabType);
    final loginresponse = globals.userData['token'] != null
        ? await fetchCart()
        : await fetchCartSerial();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      if (mounted)
        setState(() {
          totalCheck = res['total_order_data'];
        });
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            checkout.add(item);
            noData = true;
          });
      }
    } else {
      setState(() {
        noData = false;
      });
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      //return;
    }
  }
}
