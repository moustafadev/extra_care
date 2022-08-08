import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:http/http.dart' as http;
import '../../global/globals.dart' as globals;
import '../../consts.dart';

class Prescription extends StatefulWidget {
  @override
  PrescriptionState createState() => PrescriptionState();
}

class PrescriptionState extends State<Prescription> {
  TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;
  int read = 0;
  final picker = ImagePicker();

  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      Navigator.pop(this.context);
    });
  }

  Future getCameraImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      Navigator.pop(this.context);
    });
  }

  @override
  void initState() {
    getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: drawer(context),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              appBar(context, _scaffoldKey),
              Center(
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                getTranslated(context, 'noImage'),
                                style: TextStyle(fontSize: 20),
                              )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _image == null
                                ? InkWell(
                                    onTap: () {
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
                                                                      getCameraImage, //pickVideo,
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
                                                                      getImage,
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
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Constants.redColor(),
                                      size: 50,
                                    ),
                                  )
                                : Container()
                          ])
                    : Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            decoration: BoxDecoration(
                                color: Constants.textFieldColor(),
                                border: Border.all(color: Colors.grey[400]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Container(
                                height: 48,
                                child: Center(
                                  child: TextField(
                                    maxLines: 1,
                                    onChanged: (String txt) {},
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor: Constants.blueColor(),
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      labelStyle: TextStyle(
                                        color: Constants.skyColor(),
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      hintText: getTranslated(context, 'pre'),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                    ),
                                    controller: nameController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 10),
                            child: Image.file(
                              _image,
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * .8,
                              height: MediaQuery.of(context).size.height * .6,
                            ),
                          ),
                        ],
                      ),
              ),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getTranslated(context, 'cancle'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              var isLog = preferences.getBool("islog");
                              isLog == false
                                  ? uploadWithoutAuth(_image, context)
                                  : upload(_image, context);
                            },
                            child: Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: Constants.redColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getTranslated(context, 'addCart'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context, _scaffoldKey) {
    return Container(
      color: Constants.greenColor(),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .08,
      child: Center(
        child: Text(
          getTranslated(context, 'extra'),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
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

  Future<dynamic> upload(File imageFile, BuildContext context) async {
    if (_image == null) {
      Reusable.showToast(getTranslated(context, 'choose'),
          gravity: ToastGravity.CENTER);
    } else {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String languageCode = _pref.getString(Language_Code);

      var uri = Uri.parse(
          "https://chromateck.com/laurus/api/v1/cart/add?lang=$languageCode");

      var request = new http.MultipartRequest("POST", uri);
      request.headers
          .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

      request.files.add(await http.MultipartFile.fromPath(
        'prescription',
        imageFile.path,
        contentType: MediaType('application', 'x-tar'),
      ));
      request.fields['type'] = 'prescription';
      request.fields['note'] = nameController.value.text;

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
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => MyCartScreen()),
          //     (route) => false);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MyCartScreen(),
          //   ),
          // );
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyCartScreen()));
        });
      } else if (responseData['status'] == 0) {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
      }
    }
  }

  Future<dynamic> uploadWithoutAuth(
      File imageFile, BuildContext context) async {
    Reusable.showLoading(context);
    if (_image == null) {
      Reusable.showToast(getTranslated(context, 'choose'),
          gravity: ToastGravity.CENTER);
    } else {
      String deviceId;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String languageCode = _pref.getString(Language_Code);

      var uri = Uri.parse(
          "https://chromateck.com/laurus/api/v1/cart/add?lang=$languageCode");

      var request = new http.MultipartRequest("POST", uri);
      // request.headers
      //     .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

      request.files.add(await http.MultipartFile.fromPath(
        'prescription',
        imageFile.path,
        contentType: MediaType('application', 'x-tar'),
      ));
      request.fields['type'] = 'prescription';
      request.fields['note'] = nameController.value.text;
      request.fields['os'] = Platform.isAndroid ? 'android' : 'ios';
      request.fields['serial_number'] = deviceId;

      var response = await request.send();
      var responses = await http.Response.fromStream(response);
      print("responseData : " + responses.body);
      Map<String, dynamic> responseData = json.decode(responses.body);
      if (responseData['status'] == 1) {
        setState(() {
          Reusable.dismissLoading();
          // Reusable.showToast(responseData['massage'],
          //     gravity: ToastGravity.CENTER);
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => MyCartScreen()),
          //     (route) => false);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MyCartScreen(),
          //   ),
          // );
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyCartScreen()));
        });
      } else if (responseData['status'] == 0) {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
      }
    }
  }
}
