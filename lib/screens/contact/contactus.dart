import 'dart:convert';

import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../consts.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController containController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: drawer(context),
          // resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      appBarWithArrow(context, getTranslated(context, 'us')),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .88,
                        alignment: Alignment.center,
                        //height: MediaQuery.of(context).size.height * .065,
                        decoration: BoxDecoration(
                            color: Constants.textFieldColor(),
                            border: Border.all(color: Colors.grey[400]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 17,
                            //maxLength: 11,
                            onChanged: (String txt) {},
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            cursorColor: Constants.blueColor(),
                            decoration: new InputDecoration(
                              errorText: null,
                              counterText: "",
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                color: Constants.skyColor(),
                                fontSize: 14,
                              ),
                              hintText: getTranslated(context, 'content'),
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            controller: containController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (containController.value.text == "" ||
                              containController.value.text == null) {
                            Reusable.showToast(
                                getTranslated(context, 'mustCon'),
                                gravity: ToastGravity.CENTER);
                          } else {
                            contactAut();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: MediaQuery.of(context).size.height * .07,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Constants.redColor(),
                              style: BorderStyle.solid,
                            ),
                            color: Constants.redColor(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(18.0)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            getTranslated(context, 'submit'),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic contactAut() async {
    // ignore: unused_local_variable
    var headers;
    Reusable.showLoading(context);
    final response = await contactAuth(containController.value.text);
    var res = json.decode(response.body);

    if (res['status'] == 1) {
      Reusable.dismissLoading();
      //Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomTabScreen()),
          (route) => false);
    } else {
      Reusable.dismissLoading();

      Reusable.showToast(res['massage'], gravity: ToastGravity.CENTER);
    }
  }
}
