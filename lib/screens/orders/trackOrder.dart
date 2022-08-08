import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:extra_care/widgets/selectTypr.dart';
import 'package:flutter/material.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import '../../consts.dart';

class TrackOrder extends StatefulWidget {
  final Map details;

  const TrackOrder({Key key, this.details}) : super(key: key);
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        appBarWithArrow(
                            context, getTranslated(context, 'tracking')),
                        SizedBox(
                          height: 3,
                        ),
                        selectType(context, Constants.greyColor(),
                            Constants.greyColor(), Constants.redColor()),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          widget.details['id'].toString() ==
                                                  null
                                              ? ""
                                              : getTranslated(
                                                      context, 'orderId') +
                                                  "  " +
                                                  widget.details['id']
                                                      .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Constants.redColor()),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Text(
                                                  widget.details['branch'] ==
                                                          null
                                                      ? ""
                                                      : widget.details['branch']
                                                          ['trans']['title'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          Constants.hintColor(),
                                                      fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4, bottom: 3),
                                        child: Text(
                                          getTranslated(context, 'address'),
                                          style: TextStyle(
                                              color: Constants.redColor(),
                                              fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 3),
                                        child: Text(
                                          widget.details['address'] == null
                                              ? ""
                                              : widget.details['address']
                                                  ['title'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       left: 4, right: 4),
                                      //   child: Text(
                                      //     " Building Al Hayel 2 Bushar St",
                                      //     style: TextStyle(
                                      //         color: Constants.hintColor(),
                                      //         fontSize: 14),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, 'total') +
                                                  "  :  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.details['ask_to_pay'] ==
                                                      null
                                                  ? getTranslated(
                                                      context, 'noPrice')
                                                  : widget.details['ask_to_pay']
                                                          .toString() +
                                                      "  " +
                                                      getTranslated(
                                                          context, 'le'),
                                              style: TextStyle(
                                                  color: Constants.redColor(),
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  track(
                                      widget.details['signed_at'] == null
                                          ? ""
                                          : widget.details['signed_at']
                                              .toString()
                                              .substring(0, 10),
                                      widget.details['signed_at'] == null
                                          ? ""
                                          : widget.details['signed_at']
                                              .toString()
                                              .substring(11, 16),
                                      widget.details['signed_at'] == null
                                          ? Colors.white
                                          : Constants.greenColor(),
                                      Colors.grey,
                                      getTranslated(context, 'sign'),
                                      widget.details['branch'] == null
                                          ? ""
                                          : widget.details['branch']['trans']
                                              ['title'],
                                      true),
                                  track(
                                      widget.details['processed_at'] == null
                                          ? ""
                                          : widget.details['processed_at']
                                              .toString()
                                              .substring(0, 10),
                                      widget.details['processed_at'] == null
                                          ? ""
                                          : widget.details['processed_at']
                                              .toString()
                                              .substring(11, 16),
                                      widget.details['processed_at'] == null
                                          ? Colors.white
                                          : Constants.greenColor(),
                                      Colors.grey,
                                      getTranslated(context, 'pro'),
                                      widget.details['branch'] == null
                                          ? ""
                                          : widget.details['branch']['trans']
                                              ['title'],
                                      true),
                                  track(
                                      widget.details['shipped_at'] == null
                                          ? ""
                                          : widget.details['shipped_at']
                                              .toString()
                                              .substring(0, 10),
                                      widget.details['shipped_at'] == null
                                          ? ""
                                          : widget.details['shipped_at']
                                              .toString()
                                              .substring(11, 16),
                                      widget.details['shipped_at'] == null
                                          ? Colors.white
                                          : Constants.greenColor(),
                                      Colors.grey,
                                      getTranslated(context, 'ship'),
                                      widget.details['branch'] == null
                                          ? ""
                                          : widget.details['branch']['trans']
                                              ['title'],
                                      true),
                                  track(
                                      widget.details['Out_for_delivery_at'] ==
                                              null
                                          ? ""
                                          : widget
                                              .details['Out_for_delivery_at']
                                              .toString()
                                              .substring(0, 10),
                                      widget.details['Out_for_delivery_at'] ==
                                              null
                                          ? ""
                                          : widget
                                              .details['Out_for_delivery_at']
                                              .toString()
                                              .substring(11, 16),
                                      widget.details['Out_for_delivery_at'] ==
                                              null
                                          ? Colors.white
                                          : Constants.greenColor(),
                                      Colors.grey,
                                      getTranslated(context, 'outFor'),
                                      widget.details['branch'] == null
                                          ? ""
                                          : widget.details['branch']['trans']
                                              ['title'],
                                      true),
                                  track(
                                      widget.details['end_at'] == null
                                          ? ""
                                          : widget.details['end_at']
                                              .toString()
                                              .substring(0, 10),
                                      widget.details['end_at'] == null
                                          ? ""
                                          : widget.details['end_at']
                                              .toString()
                                              .substring(11, 16),
                                      widget.details['end_at'] == null
                                          ? Colors.white
                                          : Constants.greenColor(),
                                      Colors.grey,
                                      getTranslated(context, 'devl'),
                                      widget.details['branch'] == null
                                          ? ""
                                          : widget.details['branch']['trans']
                                              ['title'],
                                      false),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  track(date, time, Color color, Color border, status, branch, bool div) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: border, width: .7),
                  ),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                ),
                div == false
                    ? Container()
                    : Container(
                        width: 1,
                        height: MediaQuery.of(context).size.height * .15,
                        color: Colors.grey,
                      ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(color: Constants.skyColor(), fontSize: 13),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  branch,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 11),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget appBarWithArrow(BuildContext context, title) {
    return Container(
      color: Constants.greenColor(),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .08,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BottomTabScreen()));
                },
                child: Icon(Icons.arrow_back, color: Colors.white)),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
