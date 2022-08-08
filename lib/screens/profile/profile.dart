import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:extra_care/screens/profile/updatePhoto.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/api/models/auth.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extra_care/api/models/insurance.dart';
import '../../global/globals.dart' as globals;
import '../../consts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

Map insuranceees;
InsuranceModel _insuranceModel = new InsuranceModel();
CompanyData selectedCompany;

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController touristName = TextEditingController();
  TextEditingController touristPhone = TextEditingController();
  TextEditingController touristaddress = TextEditingController();
  int insc = 0;
  int companyId = 0;
  String companyName = "";

  @override
  void initState() {
    getInsec();
    getCount();
    super.initState();
    selectedCompany = null;
    insurance().then((value) {
      setState(() {
        _insuranceModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        drawer: drawer(context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              appBarWithArrow(context, getTranslated(context, 'profile')),
              getProfileUI(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  onTap: () {
                    touristNameDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        getTranslated(context, 'userName'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Text(
                          globals.userData['user']['name'] == null
                              ? ''
                              : globals.userData['user']['name'],
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  onTap: () {
                    touristAddressDialog(context);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          getTranslated(context, 'updateAddress'),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            globals.userData['user']['address'] == null
                                ? ''
                                : globals.userData['user']['address'],
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[500]),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  onTap: () {
                    inscDialog(context);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          getTranslated(context, 'insurance'),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            insc == 1
                                ? insuranceees['insurance_company'] == null
                                    ? ""
                                    : insuranceees['insurance_company']['trans']
                                        ['name']
                                : getTranslated(context, 'not'),
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[500]),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 20,
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
                            padding: EdgeInsets.only(left: 16, right: 16),
                            itemCount:
                                (insuranceees['attachment_relation'] as List)
                                    .length,
                            itemBuilder: (ctx, index) {
                              return Card(
                                child: Column(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          Reusable.showLoading(context);
                                          final response = await deleteInsurance(
                                              insuranceees[
                                                          'attachment_relation']
                                                      [index]['id']
                                                  .toString());
                                          var res = json.decode(response.body);

                                          if (res['status'] == 1) {
                                            setState(() {
                                              (insuranceees[
                                                          'attachment_relation']
                                                      as List)
                                                  .removeAt(index);
                                            });
                                            getInsec();
                                            getCount();
                                            Reusable.dismissLoading();
                                            if ((insuranceees[
                                                            'attachment_relation']
                                                        as List)
                                                    .length ==
                                                0) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileScreen()),
                                                  (route) => false);
                                            }
                                          } else {}
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Constants.skyColor(),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Image.network(
                                          insuranceees['attachment_relation']
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
            ],
          ),
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
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future<dynamic> upload(List<File> imageFile, BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);

    var uri = Uri.parse(
        'https://chromateck.com/laurus/api/v1/insurance/add?lang=$languageCode');

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
            MaterialPageRoute(builder: (context) => ProfileScreen()),
            (route) => false);
        //Navigator.of(context).pop();
      } else if (responseData['status'] == 0) {
        Reusable.dismissLoading();
        Reusable.showToast(responseData['massage'],
            gravity: ToastGravity.CENTER);
      }
    }
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
                content: SingleChildScrollView(
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
                                      insuranceees['insurance_company']['trans']
                                          ['name'],
                                      style: TextStyle(
                                          color: Constants.skyColor(),
                                          fontSize: 18),
                                    )
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
                                        itemCount:
                                            (insuranceees['attachment_relation']
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

                                                      if (res['status'] == 1) {
                                                        setState(() {
                                                          (insuranceees[
                                                                      'attachment_relation']
                                                                  as List)
                                                              .removeAt(index);
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
                                                                          ProfileScreen()),
                                                              (route) => false);
                                                        }
                                                      } else {}
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color:
                                                          Constants.skyColor(),
                                                    )),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
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
                                    color: Constants.hintColor(), fontSize: 16),
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
                                                                  var image = await picker
                                                                      .getImage(
                                                                          source:
                                                                              ImageSource.camera);
                                                                  setState(() {
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
                                                                  var image = await picker
                                                                      .getImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                                  setState(() {
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
                ));
          });
        });
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

  _save(value) async {
    print(value.toString());
    final prefs = await SharedPreferences.getInstance();
    final key = 'User_Data';
    prefs.setString(key, value);
  }

  Future updateName(BuildContext context) async {
    Reusable.showLoading(context);
    final response = await name(touristName.value.text);
    var res = json.decode(response.body);

    if (res['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    } else if (res['status'] == 1) {
      show(context);

      Reusable.dismissLoading();
      //Navigator.of(context).pop();
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => ProfileScreen()),
      //     (route) => false);
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }

  Future updateAddress(BuildContext context) async {
    Reusable.showLoading(context);
    final response = await address(touristaddress.value.text);
    var res = json.decode(response.body);

    if (res['status'] == 0) {
      Reusable.dismissLoading();
      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    } else if (res['status'] == 1) {
      show(context);
      Reusable.dismissLoading();
      //Navigator.of(context).pop();

      // Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
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

  Future<String> touristNameDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'editName')),
            content: TextFormField(
              style: TextStyle(fontSize: 16, color: Colors.black),
              minLines: 1,
              maxLines: 1,
              controller: touristName,
              maxLength: 25,
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
                  if (touristName.text.isEmpty) {
                  } else {
                    updateName(context);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<String> touristAddressDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'editAddress')),
            content: TextField(
              controller: touristaddress,
              keyboardType: TextInputType.text,
              maxLength: 30,
              decoration: InputDecoration(
                counterText: "",
              ),
              autocorrect: true,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(getTranslated(context, 'ok'),
                    style: TextStyle(
                      color: Constants.skyColor(),
                    )),
                onPressed: () async {
                  if (touristaddress.text.isEmpty) {
                  } else {
                    updateAddress(context);
                  }
                },
              ),
            ],
          );
        });
  }

  getProfileUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.skyColor()),
                    shape: BoxShape.circle,
                  ),
                  child: new CircleAvatar(
                    // backgroundImage:
                    //     NetworkImage(globals.userData['user']['attachment']),
                    backgroundColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network(
                        globals.userData['user']['attachment'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Constants.skyColor(),
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadImage()));
                      },
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UploadImage()));
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
