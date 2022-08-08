import 'package:flutter/material.dart';

Widget button(BuildContext context, String title, Color color) {
  return Container(
    decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.all(Radius.circular(25))),
    width: MediaQuery.of(context).size.width * .8,
    height: MediaQuery.of(context).size.height * .07,
    alignment: Alignment.center,
    child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
  );
}
