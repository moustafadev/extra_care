import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../appConstatnt.dart';

class PrescriptionBody extends StatefulWidget {
  @override
  PrescriptionBodyState createState() => PrescriptionBodyState();
}

class PrescriptionBodyState extends State<PrescriptionBody> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
      child: Column(
        children: [
          MyCardTiteWidget(),
          Divider(height: 1),
          ItemsUploadedList(),
          Divider(height: 1),
          SizedBox(
            height: 5,
          ),
          UploadAnotherPrescriptionButton(),
          SizedBox(
            height: 20,
          ),
          InfoTextWidget(),
          SizedBox(
            height: 100,
          ),
          HomeAndCheckOutButtons(), //!!!
        ],
      ),
    ));
  }

  // ignore: non_constant_identifier_names
  Widget MyCardTiteWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'My Cart',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ItemsUploadedList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      child: ListView.separated(
        separatorBuilder: (_, __) => Divider(height: 1),
        // controller: Uploadedlist,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              child: ListTile(
                onTap: null,
                title: Text('Uploaded Prescription'),
                subtitle: Text('Uploded Date 24 Augst 2020'),
                trailing: Icon(Icons.close),
              ),
            ),
          );
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget UploadAnotherPrescriptionButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.04,
          // ignore: deprecated_member_use
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: PINK)),
            onPressed: () {},
            color: PINK,
            textColor: Colors.white,
            child: Text('Upload Another Prescription',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal)),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InfoTextWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.16,
      child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Center(
              child: Text(
                'Prescription Rules',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    color: LIGHT_BLUE),
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text:
                        'Please note that sending prescription is not a complete order , the order process will start after accepting form the pharmacy and send an email for start order.',
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        color: LIGHT_BLUE),
                  ),
                  TextSpan(
                      text: 'Read more',
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //  print('Read more');
                        }),
                ]),
              ),
            ),
          )),
    );
  }

  // ignore: non_constant_identifier_names
  Widget HomeAndCheckOutButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.05, //0.08
        child: Row(
          children: [
            BackToHomeButton(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.44,
            ),
            CheckOutButton(),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BackToHomeButton() {
    return Container(
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: PINK)),
        onPressed: () {},
        color: PINK,
        textColor: Colors.white,
        child: Text('Bcak to Home',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal)),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CheckOutButton() {
    return Container(
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: PINK)),
        onPressed: () {},
        color: PINK,
        textColor: Colors.white,
        child: Text('checkout',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal)),
      ),
    );
  }
}
