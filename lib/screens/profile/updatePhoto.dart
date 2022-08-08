import 'dart:convert';
import 'dart:io';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/api/models/auth.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/profile/profile.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../global/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File _image;
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            appBarWithArrow(context, getTranslated(context, 'pp')),
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
                              getTranslated(context, 'noPic'),
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
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        _image,
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * .88,
                        height: MediaQuery.of(context).size.height * .6,
                      ),
                    ),
            ),
            _image != null
                ? InkWell(
                    onTap: () async {
                      await upload(_image, context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: Constants.skyColor(),
                            size: 35,
                          ),
                          Text(
                            getTranslated(context, 'upload'),
                            style: TextStyle(color: Constants.skyColor()),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Constants.skyColor(),
        //   onPressed: getImage,
        //   tooltip: getTranslated(context, 'pick'),
        //   child: Icon(Icons.add_a_photo),
        // ),
      ),
    );
  }

  _save(value) async {
    print(value.toString());
    final prefs = await SharedPreferences.getInstance();
    final key = 'User_Data';
    prefs.setString(key, value);
  }

  Future show(BuildContext context) async {
    final response = await showProfile();
    var res = json.decode(response.body);

    LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));
    if (res['status'] == 0) {
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    } else if (res['status'] == 1) {
      globals.userData = res['data'];
      globals.userModel = loginModel;
      this._save(json.encode(res));
      print("user Id is = ${res['data']['user']['id']}");

      SharedPreferences.getInstance().then((value) {
        value.setString('token', loginModel.data.token);
        print('thetoken' + value.getString('token'));
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
          (route) => false);
    }
  }

  Future<dynamic> upload(File imageFile, BuildContext context) async {
    if (_image == null) {
      Reusable.showToast(getTranslated(context, 'choosePic'),
          gravity: ToastGravity.CENTER);
    } else {
      {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        String languageCode = _pref.getString(Language_Code);

        var uri = Uri.parse(
            "https://chromateck.com/laurus/api/v1/update-profile?lang=$languageCode");

        var request = new http.MultipartRequest("POST", uri);
        request.headers
            .addAll({'Authorization': 'Bearer ' + globals.userData['token']});

        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
          contentType: MediaType('application', 'x-tar'),
        ));

        Reusable.showLoading(context);

        var response = await request.send();
        var responses = await http.Response.fromStream(response);
        print("responseData : " + responses.body);
        Map<String, dynamic> responseData = json.decode(responses.body);
        if (responseData['status'] == 1) {
          setState(() {
            show(context);
            Reusable.dismissLoading();
            // Reusable.showToast(responseData['massage'],
            //     gravity: ToastGravity.CENTER);
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => BottomTabScreen()),
            //     (route) => false);
          });
        } else if (responseData['status'] == 0) {
          Reusable.dismissLoading();
          Reusable.showToast(responseData['massage'],
              gravity: ToastGravity.CENTER);
        }
      }
    }
  }
}
