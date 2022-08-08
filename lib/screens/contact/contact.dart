import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBarWithArrow(context, getTranslated(context, 'us')),
                        Image.asset(
                          "assets/images/copy.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            getTranslated(context, 'us'),
                            style: TextStyle(
                                fontSize: 25, color: Constants.skyColor()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: Text(
                            getTranslated(context, 'detUs'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              letterSpacing: 1,
                              wordSpacing: 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Image.asset(
                            "assets/images/map.png",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'delAdd1'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      wordSpacing: 3,
                                    ),
                                  ),
                                  Text(
                                    getTranslated(context, 'delAdd2'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      wordSpacing: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}
