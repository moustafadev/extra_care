import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/api/models/insurance.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/home/itemscreen.dart';
import 'package:extra_care/screens/home/subCategory.dart';
import 'package:extra_care/screens/qr/afterScanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../consts.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import '../../global/globals.dart' as globals;
import 'package:extra_care/screens/home/categories.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appbar.dart';
import 'package:extra_care/widgets/dialog.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBodyAfterRegistration extends StatefulWidget {
  @override
  HomeBodyAfterRegistrationState createState() =>
      HomeBodyAfterRegistrationState();
}

List adminAcceptStatusAdd;
List adminAcceptAds;
Map insuranceees;

InsuranceModel _insuranceModel = new InsuranceModel();
CompanyData selectedCompany;

class HomeBodyAfterRegistrationState extends State<HomeBodyAfterRegistration> {
  var name;
  bool loading = false;
  String resultOfQR = "";
  int points = 0;
  int pointsCost = 0;
  int read = 0;
  int insc = 0;
  bool haveOrder = false;
  var call = "";
  int companyId = 0;
  String companyName = "";
  Map details;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isLog = preferences.getBool("islog");
    setState(() {
      name = isLog;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    // getInsec();
    // getCount();
    // getLists();
    // getCall();
    // getAds();
    selectedCompany = null;
    // insurance().then((value) {
    //   setState(() {
    //     _insuranceModel = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Reusable.InitScreenDims(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: drawer(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    appBar(context, _scaffoldKey, read),
                    // check with flag if user is loged in or not to show its data or hide it.
                    (name == true) ? userData() : Container(),
                    // !isAllCategLoaded
                    //     ? Reusable.showLoader(!isAllCategLoaded, height: 60.h)
                    //     :
                    // ProductsLisWidget(),
                    ImageWidget(),
                    listOfButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> upload(List<File> imageFile, BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    var uri = Uri.parse(
      'https://chromateck.com/laurus/api/v1/insurance/add?lang=$languageCode',
    );

    var request = new http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer ' + globals.userData['token']});
    if (imageFile.isNotEmpty) {
      for (int i = 0; i < imageFile.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          imageFile[i] == null ? null : 'Insurance_attachments[$i]',
          imageFile[i].path == null ? null : imageFile[i].path,
        ));
      }
      request.fields['insurance_company_id'] = companyId.toString();

      Reusable.showLoading(context);

      var response = await request.send();
      var responses = await http.Response.fromStream(response);
      print("responseData : " + responses.body);
      Map<String, dynamic> responseData = json.decode(responses.body);
      if (responseData['status'] == 1) {
        Reusable.dismissLoading();

        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
        selectedCompany = null;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomTabScreen()),
            (route) => false);
        //Navigator.of(context).pop();
      } else if (responseData['status'] == 0) {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
      }
    }
  }

  userData() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                globals.userData['user']['name'] == null
                    ? ''
                    : globals.userData['user']['name'],
                //user.name == null ? '' : user.name,
                // "MAriam Younes",
                style: TextStyle(color: Colors.black),
              ),
              flex: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  points.toString() + "  " + getTranslated(context, 'points'),
                  style: TextStyle(color: Colors.black, fontSize: 12.sp),
                ),
                Text(
                  pointsCost.toString() + "  " + getTranslated(context, 'le'),
                  style: TextStyle(color: Colors.black, fontSize: 12.sp),
                ),
              ],
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(points.toString(),
            //         style: TextStyle(color: Colors.black, fontSize: 12.sp)),
            //     Text(pointsCost.toString(),
            //         style: TextStyle(color: Colors.black, fontSize: 12.sp)),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ProductsLisWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(getTranslated(context, 'category'),
                      style: TextStyle(color: Colors.black)),
                  flex: 1,
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(getTranslated(context, 'all'),
                          style: TextStyle(color: Colors.black, fontSize: 12)),
                      Icon(Icons.arrow_right, color: Colors.black),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesScreen()));
                  },
                )
              ],
            ),
          ),
          loading
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                      height: 115.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          border: Border.all(
                              width: 1,
                              color: Colors.grey[600],
                              style: BorderStyle.solid)),
                      child: Reusable.showLoader(loading)),
                )
              : adminAcceptStatusAdd.isNotEmpty ||
                      adminAcceptStatusAdd.length != 0
                  ? Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120.h,
                        child: ListView.builder(
                            //  physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SubCategory(
                                                id: adminAcceptStatusAdd[index]
                                                    ['id'],
                                              )));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.w),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: adminAcceptStatusAdd[index]
                                                        ['attachment'] ==
                                                    null
                                                ? Text(getTranslated(
                                                    context, 'noPhoto'))
                                                : Image.network(
                                                    adminAcceptStatusAdd[index]
                                                        ['attachment'],
                                                    height: 80.h,
                                                    width: 100.w,
                                                    fit: BoxFit.contain,
                                                  ),
                                          )),
                                    ),
                                    Container(
                                        width: 100.w,
                                        child: Text(
                                          adminAcceptStatusAdd[index]['trans']
                                                      ['name'] ==
                                                  null
                                              ? getTranslated(
                                                  context, 'noTitle')
                                              : adminAcceptStatusAdd[index]
                                                  ['trans']['name'],
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12.sp),
                                        ))
                                  ],
                                ),
                              );
                            }),
                      ))
                  : Container(
                      //width: MediaQuery.of(context).size.width,
                      // height: 115.h,
                      // child: Reusable.noData(
                      //     msg: getTranslated(context, 'noData')
                      //     )
                      )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ImageWidget() {
    return loading
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Container(
                height: 115.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    border: Border.all(
                        width: 1,
                        color: Colors.grey[600],
                        style: BorderStyle.solid)),
                child: Reusable.showLoader(loading)),
          )
        : (adminAcceptAds?.isNotEmpty ?? false) ||
                (adminAcceptAds?.length ?? -1) == 0
            ? Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    //alignment: AlignmentDirectional.topStart,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(getTranslated(context, 'all'),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                              Icon(Icons.arrow_right, color: Colors.black),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CategoriesScreen()));
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            // autoPlayAnimationDuration:
                            //     Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: adminAcceptAds
                              .map((item) => Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemScreen(details: item)));
                                      },
                                      child: Center(
                                          child: Image.network(item['photo'])),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Reusable.noData(
                    msg: getTranslated(context, 'noData'),
                  ),
                ),
              );
  }

  Widget listOfButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.h, 10.w, 30.w, 15.h),
      child: Column(
        children: [
          ButtonWidgetWithAction(getTranslated(context, 'orderNow'),
              () => dialog(context, call, haveOrder)),
          SizedBox(height: 10),
          ButtonWidgetWithAction(getTranslated(context, 'qr'), () {
            scanQR();
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => QRViewExample()));
          }),
          SizedBox(height: 10),
          ButtonWidgetWithAction(getTranslated(context, 'insu'), () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            var isLog = preferences.getBool("islog");
            isLog == false
                ? Reusable.showToast(getTranslated(context, 'open'),
                    gravity: ToastGravity.CENTER)
                : inscDialog(context);
          }),
          SizedBox(height: 10),
        ],
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
                    getTranslated(context, 'ins'),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                content: Container(
                  height: 500,
                  width: 400,
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
                                    : Text(
                                        insuranceees['insurance_company']
                                            ['trans']['name'],
                                        style: TextStyle(
                                            color: Constants.skyColor(),
                                            fontSize: 18),
                                      )
                                : Container(
                                    width: 250,
                                    height: MediaQuery.of(context).size.height *
                                        .06,
                                    decoration: BoxDecoration(
                                      color: Constants.textFieldColor(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                          items: _insuranceModel.data.map<
                                                  DropdownMenuItem<
                                                      CompanyData>>(
                                              (CompanyData value) {
                                            return DropdownMenuItem<
                                                CompanyData>(
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16),
                                                child: new Text(
                                                    value.trans.title,
                                                    style: TextStyle(
                                                        color: Constants
                                                            .skyColor(),
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
                                ? ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          itemCount: (insuranceees[
                                                      'attachment_relation']
                                                  as List)
                                              .length,
                                          itemBuilder: (ctx, index) {
                                            return Card(
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                      onTap: () async {
                                                        Reusable.showLoading(
                                                            context);
                                                        final response =
                                                            await deleteInsurance(
                                                                insuranceees['attachment_relation']
                                                                            [
                                                                            index]
                                                                        ['id']
                                                                    .toString());
                                                        var res = json.decode(
                                                            response.body);

                                                        if (res['status'] ==
                                                            1) {
                                                          setState(() {
                                                            (insuranceees[
                                                                        'attachment_relation']
                                                                    as List)
                                                                .removeAt(
                                                                    index);
                                                          });
                                                          getInsec();
                                                          getCount();
                                                          Reusable
                                                              .dismissLoading();
                                                          if ((insuranceees[
                                                                          'attachment_relation']
                                                                      as List)
                                                                  .length ==
                                                              0) {
                                                            Navigator.pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            BottomTabScreen()),
                                                                (route) =>
                                                                    false);
                                                          }
                                                        } else {}
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Constants
                                                            .skyColor(),
                                                      )),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Image.network(
                                                        insuranceees[
                                                                'attachment_relation']
                                                            [index]['url'],
                                                        //height: 100,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    flex: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  )
                                : Container(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  padding: EdgeInsets.all(16),
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
                                                                  icon: Icon(Icons
                                                                      .camera_alt_outlined),
                                                                  onPressed:
                                                                      () async {
                                                                    // ignore: deprecated_member_use
                                                                    var image =
                                                                        await picker.getImage(
                                                                            source:
                                                                                ImageSource.camera);
                                                                    setState(
                                                                        () {
                                                                      _image = File(
                                                                          image
                                                                              .path);
                                                                      attachmentPath
                                                                          .add(
                                                                              _image);
                                                                      Navigator
                                                                          .pop(this
                                                                              .context);
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
                                                                  icon: Icon(Icons
                                                                      .image),
                                                                  onPressed:
                                                                      () async {
                                                                    // ignore: deprecated_member_use
                                                                    var image =
                                                                        await picker.getImage(
                                                                            source:
                                                                                ImageSource.gallery);
                                                                    setState(
                                                                        () {
                                                                      _image = File(
                                                                          image
                                                                              .path);
                                                                      attachmentPath
                                                                          .add(
                                                                              _image);
                                                                      print("length" +
                                                                          attachmentPath
                                                                              .length
                                                                              .toString());
                                                                      Navigator
                                                                          .pop(this
                                                                              .context);
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
                            ListView.builder(
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
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Text(
                                                  path.basename(
                                                    attachmentPath[index].path,
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
                                    getTranslated(context, 'up'),
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
                            insc == 0 || attachmentPath.length == 0
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      upload(attachmentPath, context);
                                    },
                                    child: Text(
                                      getTranslated(context, 'next'),
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Constants.skyColor(),
                                          fontSize: 15),
                                    ),
                                  ),
                            _image == null || companyId == 0
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      upload(attachmentPath, context);
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
                                          Navigator.of(context).pop();
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
                                    : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  // ignore: non_constant_identifier_names
  Widget ButtonWidgetWithAction(String title, Function onButtonCick) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.08,
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blue)),
        onPressed: onButtonCick,
        //() {},
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(title, style: TextStyle(fontSize: 15)),
      ),
    );
  }

  Future scanQR() async {
    try {
      var qrResult = await BarcodeScanner.scan();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var isLog = preferences.getBool("islog");
      isLog == false
          ? noToken(qrResult.rawContent)
          : qrCode(qrResult.rawContent);
      //qrCode(qrResult);
      // setState(() {
      //   resultOfQR = qrResult.toString();
      //   print("qrResult" + qrResult.toString());
      //   print("resultOfQR" + resultOfQR.toString());
      //   print("object" + resultOfQR);
      // });

    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          resultOfQR = "Camera permission was denied";
        });
      } else {
        setState(() {
          resultOfQR = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        resultOfQR = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        resultOfQR = "Unknown Error $ex";
      });
    }
  }

  dynamic qrCode(code) async {
    final response = await fetchQR(code);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
      details = res['data'];
      //Reusable.showToast("done", gravity: ToastGravity.CENTER);
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => AfterScan(
      //               details: details,
      //             )),
      //     (route) => false);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AfterScan(
                    details: details,
                  )));
    } else if (res['status'] == 0) {
      // Reusable.showToast("false", gravity: ToastGravity.CENTER);
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  dynamic noToken(code) async {
    final response = await fetchQRNoToken(code);
    var res = json.decode(response.body);
    if (res['status'] == 1) {
    } else if (res['status'] == 0) {
      // Reusable.showToast("false", gravity: ToastGravity.CENTER);
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future getAds() async {
    adminAcceptAds = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchAds();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      for (var item in res['data']) {
        if (mounted)
          setState(() {
            adminAcceptAds.add(item);
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

  Future getLists() async {
    adminAcceptStatusAdd = [];
    setState(() {
      loading = true;
    });
    // print("object" + tabType);
    final loginresponse = await fetchCategoery();
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

  Future getCount() async {
    // print("object" + tabType);
    final loginresponse = await fetchCount();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        points = res['data']['points'];
        pointsCost = res['data']['points_cost'];
        read = res['data']['un_read_notification_count'];
        haveOrder = res['data']['have_order'];
        insc = res['data']['has_insurance'];
      });
    } else {
      setState(() {
        points = 0;
        pointsCost = 0;
        read = 0;
        haveOrder = false;
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
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future getCall() async {
    // print("object" + tabType);
    final loginresponse = await callFetch();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        call = res['data']['ph_telephone'];
      });
    } else {
      setState(() {
        call = "";
      });
    }
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

  // Future<InsuranceModel> insurance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String languageCode = prefs.getString(Language_Code);
  //   Reusable.showLoading(context);
  //   http.Response response = await http.get(
  //     Uri.parse(
  //         'https://chromateck.com/laurus/api/v1/home?type=insurance_companies&response_type=all&lang=$languageCode'),
  //   );
  //   Reusable.dismissLoading();
  //   return new InsuranceModel.fromJson(json.decode(response.body));
  // }
}
