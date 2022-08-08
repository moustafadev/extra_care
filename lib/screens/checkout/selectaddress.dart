import 'dart:convert';
import 'dart:io';
import 'package:extra_care/screens/checkout/addressList.dart';
import 'package:path/path.dart' as path;
import 'package:extra_care/api/models/branches.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/api/models/insurance.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/checkout/selectPayment.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:extra_care/widgets/selectTypr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../consts.dart';

class SelectAddress extends StatefulWidget {
  final Map details;
  final int addId;
  final String addName;

  const SelectAddress({Key key, this.details, this.addId, this.addName})
      : super(key: key);
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

List adminAcceptStatusAdd;
PostpondModels _postpondModels = new PostpondModels();
BranchesData selectedBranch;
InsuranceModel _insuranceModel = new InsuranceModel();
CompanyData selectedCompany;
Map insuranceees;

class _SelectAddressState extends State<SelectAddress> {
  TextEditingController promoController = TextEditingController();
  TextEditingController address = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //static int length = 50;
  //List<bool> _isFalse = List<bool>.generate(length, (_) => false);
  bool isSelected = false;
  bool loading = false;
  double latitude;
  double longitude;
  int branchID = 0;
  int companyId = 0;
  String companyName = "";
  int selectRadio;
  int addressId = 0;
  int insc = 0;
  var branchDeliver;
  String branchName;

  @override
  void initState() {
    selectedCompany = null;
    addressId = widget.addId;
    super.initState();
    selectedBranch = null;
    getInsec();
    getCount();
    pospondReason().then((value) {
      setState(() {
        _postpondModels = value;
      });
    });

    insurance().then((value) {
      setState(() {
        _insuranceModel = value;
      });
    });
  }

  @override
  void dispose() {
    promoController.dispose();
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
                      selectType(context, Constants.redColor(),
                          Constants.greyColor(), Constants.greyColor()),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(getTranslated(context, 'devTo')),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          //height: 350.0,
                                          child: Text(
                                        widget.addName == "" ||
                                                widget.addName == null
                                            ? widget.details['address'] == null
                                                ? getTranslated(context, 'noAd')
                                                : widget.details['address']
                                                    ["title"]
                                            : widget.addName,
                                        style: TextStyle(
                                            color: Constants.skyColor(),
                                            fontSize: 14),
                                      )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressList(
                                                        details: widget.details,
                                                      )));
                                        },
                                        child: Text(
                                          getTranslated(context, 'change'),
                                          style: TextStyle(
                                              color: Constants.redColor(),
                                              fontSize: 14),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))),
                      SizedBox(
                        height: 20,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 12, right: 12),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         getTranslated(context, 'promo'),
                      //         style: TextStyle(
                      //             color: Constants.redColor(), fontSize: 18),
                      //       ),
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * .5,
                      //         height: 40,
                      //         alignment: Alignment.center,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Colors.black,
                      //             style: BorderStyle.solid,
                      //           ),
                      //           color: Colors.white,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(12.0)),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             promoWidget(),
                      //             promoController.value.text == ""
                      //                 ? Container()
                      //                 : Padding(
                      //                     padding: const EdgeInsets.only(
                      //                         right: 8.0, left: 8),
                      //                     child: Icon(Icons.verified_user,
                      //                         color: isSelected == false
                      //                             ? Colors.red
                      //                             : Constants.skyColor()),
                      //                   ),
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ? widget.details['branch']['trans']['title']
                                  : branchName,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              selectedBranch == null
                                  ? getTranslated(context, 'max') +
                                      widget.details['branch']
                                              ['maximum_delivery_time']
                                          .toString()
                                          .substring(0, 2) +
                                      getTranslated(context, 'min')
                                  : getTranslated(context, 'max') +
                                      branchDeliver.toString().substring(0, 2) +
                                      getTranslated(context, 'min'),
                              style: TextStyle(
                                color: Constants.hintColor(),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 10),
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
                                  if (widget.details['address'] == null &&
                                      (widget.addName == "" ||
                                          widget.addName == null)) {
                                    Reusable.showToast(
                                        getTranslated(context, 'select'),
                                        gravity: ToastGravity.CENTER);
                                  } else if (branchID == null ||
                                      branchID == 0) {
                                    setState(() {
                                      branchID = widget.details['branch']['id'];
                                      print(branchID);
                                      print(
                                          "promo" + promoController.value.text);
                                    });
                                    if (insc == 0) {
                                      inscDialog(context);
                                    } else if (insc == 1) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                    details: widget.details,
                                                    id: branchID,
                                                    code: promoController
                                                        .value.text,
                                                    addressId: addressId == 0 ||
                                                            addressId == null
                                                        ? widget.details[
                                                            'address']['id']
                                                        : addressId,
                                                  )));
                                    }
                                  } else {
                                    if (insc == 0) {
                                      inscDialog(context);
                                    } else if (insc == 1) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                    details: widget.details,
                                                    id: branchID,
                                                    attachmentPath: [],
                                                    companyID: 0,
                                                    code: promoController
                                                        .value.text,
                                                    addressId: addressId == 0 ||
                                                            addressId == null
                                                        ? widget.details[
                                                            'address']['id']
                                                        : addressId,
                                                  )));
                                    }
                                  }
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
            padding: const EdgeInsets.only(left: 16.0, right: 16 ,bottom: 27),
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
              branchDeliver = val.max;
              print(branchID);
            });
          },
        ),
      ),
    );
  }

  Widget companyDropDown(
    BuildContext context,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * 0.05,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CompanyData>(
          //iconSize: 0.0,
          isExpanded: true,
          isDense: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Text(
              getTranslated(context, 'ins'),
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
          dropdownColor: Colors.white,
          value: selectedCompany,
          items: _insuranceModel.data
              .map<DropdownMenuItem<CompanyData>>((CompanyData value) {
            return DropdownMenuItem<CompanyData>(
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
              selectedCompany = val;
              companyId = val.id;
              companyName = val.trans.title;
              print(companyId);
            });
          },
        ),
      ),
    );
  }

  dynamic testPromo(code) async {
    final response = await testCoupon(code);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      // Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
      setState(() {
        isSelected = true;
      });
    } else {
      //Reusable.dismissLoading();
      setState(() {
        isSelected = false;
      });
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  promoWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * .3,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: Center(
          child: TextFormField(
            minLines: 1,
            maxLength: 5,
            onChanged: (String txt) {
              testPromo(promoController.value.text);
            },
            style: TextStyle(
              fontSize: 16,
            ),
            cursorColor: Constants.blueColor(),
            decoration: new InputDecoration(
              errorText: null,
              counterText: "",
              border: InputBorder.none,
              hintText: getTranslated(context, 'promo'),
              hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            controller: promoController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }

  inscDialog(BuildContext context) {
    List<File> attachmentPath = [];
    final picker = ImagePicker();
    File _image;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Center(
                  child: Text(
                    '',
                     //getTranslated(context, 'ins'),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                content: Container(
                  height: 500,
                  width: 500,
                  child: SingleChildScrollView(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            insc == 1
                                ? insuranceees['insurance_company'] == null
                                    ? Text("")
                                    : Text(insuranceees['insurance_company']
                                        ['trans']['name'])
                                : Container(
                                    width: 250,
                                    height:
                                        MediaQuery.of(context).size.height * .06,
                                    decoration: BoxDecoration(
                                      color: Constants.textFieldColor(),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25.0)),
                                    ),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width * .5,
                                      height: MediaQuery.of(context).size.height *
                                          0.05,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<CompanyData>(
                                          //iconSize: 0.0,
                                          isExpanded: true,
                                          isDense: true,
                                          hint: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16),
                                            child: Text(
                                              getTranslated(context, 'ins'),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          dropdownColor: Colors.white,
                                          value: selectedCompany,
                                          items: _insuranceModel.data
                                              .map<DropdownMenuItem<CompanyData>>(
                                                  (CompanyData value) {
                                            return DropdownMenuItem<CompanyData>(
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16),
                                                child: new Text(value.trans.title,
                                                    style: TextStyle(
                                                        color:
                                                            Constants.skyColor(),
                                                        fontSize: 14)),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              selectedCompany = val;
                                              companyId = val.id;
                                              companyName = val.trans.title;
                                              print(companyId);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                            insc == 1
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(left: 16, right: 16),
                                    itemCount:
                                        (insuranceees['attachment_relation']
                                                as List)
                                            .length,
                                    itemBuilder: (ctx, index) {
                                      return Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: Text(
                                                      path.basename(
                                                        insuranceees[
                                                                'attachment_relation']
                                                            [index]['url'],
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      setState(() {
                                                        attachmentPath
                                                            .removeAt(index);
                                                      });
                                                    })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getTranslated(context, 'scan'),
                                        style: TextStyle(
                                            color: Constants.hintColor(),
                                            fontSize: 16),
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .camera_alt_outlined),
                                                                        onPressed:
                                                                            () async {
                                                                          // ignore: deprecated_member_use
                                                                          var image =
                                                                              await picker.getImage(source: ImageSource.camera);
                                                                          setState(
                                                                              () {
                                                                            _image =
                                                                                File(image.path);
                                                                            attachmentPath
                                                                                .add(_image);
                                                                            Navigator.pop(
                                                                                this.context);
                                                                          });
                                                                        }, //pickVideo,
                                                                      ),
                                                                      Text(
                                                                        getTranslated(
                                                                            context,
                                                                            'cam'),
                                                                        style:
                                                                            TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  flex: 1,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .image),
                                                                        onPressed:
                                                                            () async {
                                                                          var image =
                                                                              await picker.getImage(source: ImageSource.gallery);
                                                                          setState(
                                                                              () {
                                                                            _image =
                                                                                File(image.path);
                                                                            attachmentPath
                                                                                .add(_image);
                                                                            print("length" +
                                                                                attachmentPath.length.toString());
                                                                            Navigator.pop(
                                                                                this.context);
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        getTranslated(
                                                                            context,
                                                                            'gal'),
                                                                        style:
                                                                            TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  flex: 1,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          },
                                          child: Icon(Icons.camera_alt_outlined,
                                              color: Colors.black))
                                    ],
                                  ),
                            insc == 1
                                ? Container()
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(left: 16, right: 16),
                                    itemCount: attachmentPath.length,
                                    itemBuilder: (ctx, index) {
                                      return Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: Text(
                                                      path.basename(
                                                        attachmentPath[index]
                                                            .path,
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      setState(() {
                                                        attachmentPath
                                                            .removeAt(index);
                                                      });
                                                    })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                            _image == null
                                ? Container()
                                : SizedBox(
                                    height: 15,
                                  ),
                            _image == null || attachmentPath.length == 0
                                ? Container()
                                : Text(
                                    getTranslated(context, 'up') +
                                        attachmentPath.length.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Constants.redColor(),
                                        fontSize: 16),
                                  ),
                            _image == null && companyId == 0
                                ? Container()
                                : SizedBox(
                                    height: 15,
                                  ),
                            _image == null || companyId == 0
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      if (companyId != 0 && _image != null) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentScreen(
                                                      details: widget.details,
                                                      id: branchID,
                                                      code: promoController
                                                          .value.text,
                                                      addressId: addressId == 0 ||
                                                              addressId == null
                                                          ? widget.details[
                                                              'address']['id']
                                                          : addressId,
                                                      companyID: companyId,
                                                      attachmentPath:
                                                          attachmentPath,
                                                    )));
                                      } else {
                                        Reusable.showToast("two is must",
                                            gravity: ToastGravity.CENTER);
                                      }
                                    },
                                    child: Text(
                                      getTranslated(context, 'next'),
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Constants.skyColor(),
                                          fontSize: 15),
                                    ),
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                            companyId != 0 || attachmentPath.length != 0
                                ? Container()
                                : insc == 0
                                    ? InkWell(
                                        onTap: () {
                                          // if (addressId == 0) {
                                          //   Reusable.showToast(getTranslated(context, 'select'),
                                          //       gravity: ToastGravity.CENTER);
                                          // } else if (branchID == null || branchID == 0) {
                                          //   setState(() {
                                          //     branchID = widget.details['branch']['id'];
                                          //     print(branchID);
                                          //   });

                                          // }
                                          if (companyId == 0 && _image == null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentScreen(
                                                          details: widget.details,
                                                          id: branchID,
                                                          code: promoController
                                                              .value.text,
                                                          addressId: addressId ==
                                                                      0 ||
                                                                  addressId ==
                                                                      null
                                                              ? widget.details[
                                                                  'address']['id']
                                                              : addressId,
                                                          companyID: companyId,
                                                          attachmentPath:
                                                              attachmentPath,
                                                        )));
                                          } else {
                                            Reusable.showToast("two is must",
                                                gravity: ToastGravity.CENTER);
                                          }
                                        },
                                        child: Text(
                                          getTranslated(context, 'no'),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Constants.skyColor(),
                                              fontSize: 15),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          // if (addressId == 0) {
                                          //   Reusable.showToast(getTranslated(context, 'select'),
                                          //       gravity: ToastGravity.CENTER);
                                          // } else if (branchID == null || branchID == 0) {
                                          //   setState(() {
                                          //     branchID = widget.details['branch']['id'];
                                          //     print(branchID);
                                          //   });

                                          // }
                                          if (companyId == 0 && _image == null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentScreen(
                                                          details: widget.details,
                                                          id: branchID,
                                                          code: promoController
                                                              .value.text,
                                                          addressId: addressId ==
                                                                      0 ||
                                                                  addressId ==
                                                                      null
                                                              ? widget.details[
                                                                  'address']['id']
                                                              : addressId,
                                                          companyID: companyId,
                                                          attachmentPath:
                                                              attachmentPath,
                                                        )));
                                          } else {
                                            Reusable.showToast("two is must",
                                                gravity: ToastGravity.CENTER);
                                          }
                                        },
                                        child: Text(
                                          getTranslated(context, 'noTh'),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Constants.skyColor(),
                                              fontSize: 15),
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Future getCount() async {
    // print("object" + tabType);
    final loginresponse = await fetchCount();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        insc = res['data']['has_insurance'];
      });
    } else {
      setState(() {
        insc = 0;
      });
    }
  }

  Future getInsec() async {
    // print("object" + tabType);
    final loginresponse = await getInsurance();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        insuranceees = res['data'];
      });
    } else {
      //  Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
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

  Future<InsuranceModel> insurance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(Language_Code);
    Reusable.showLoading(context);
    http.Response response = await http.get(
      Uri.parse(
          'https://chromateck.com/laurus/api/v1/home?type=insurance_companies&response_type=all&lang=$languageCode'),
    );
    Reusable.dismissLoading();
    return new InsuranceModel.fromJson(json.decode(response.body));
  }
}
