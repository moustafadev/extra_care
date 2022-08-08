import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class OrderTrackScreen extends StatefulWidget {
  @override
  _OrderTrackScreenState createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends State<OrderTrackScreen> {
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
                        appBarWithArrow(
                            context, getTranslated(context, 'about')),
                        Image.asset(
                          "assets/images/copy.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 270,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            getTranslated(context, 'ab'),
                            style: TextStyle(
                                fontSize: 25, color: Constants.skyColor()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: Text(
                            getTranslated(context, 'det'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              letterSpacing: 1,
                              wordSpacing: 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/copy.png",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * .45,
                                height: 100,
                              ),
                              Image.asset(
                                "assets/images/copy.png",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * .45,
                                height: 100,
                              ),
                            ],
                          ),
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
