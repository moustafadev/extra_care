import 'package:extra_care/screens/checkout/selectPayment.dart';
import 'package:flutter/material.dart';

import '../consts.dart';

Future<String> inscDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Insurance section",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * .6,
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentScreen()));
                  },
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Constants.textFieldColor(),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Insurance section",
                            style: TextStyle(
                                color: Constants.hintColor(), fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PaymentScreen()));
                            },
                            child: Icon(Icons.keyboard_arrow_down,
                                color: Constants.redColor()),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scan your ID",
                      style:
                          TextStyle(color: Constants.hintColor(), fontSize: 18),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaymentScreen()));
                      },
                      child: Icon(Icons.camera_alt, color: Colors.black),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Your sheet is uploaded successfully We will review it and reply to you",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Constants.redColor(), fontSize: 16),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "No thank you, I don’t have insurance",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
          ),
        );
      });
}
