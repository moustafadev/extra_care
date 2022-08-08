import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../consts.dart';

Widget selectType(BuildContext context, Color one, Color two, Color three) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Constants.shadowColor(),
            blurRadius: 16,
            offset: Offset(4, 4)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 37, color: one),
          SizedBox(
            width: 35,
          ),
          Icon(Icons.payment, size: 37, color: two),
          SizedBox(
            width: 35,
          ),
          Icon(Icons.local_car_wash, size: 37, color: three),
        ],
      ),
    ),
  );
}
