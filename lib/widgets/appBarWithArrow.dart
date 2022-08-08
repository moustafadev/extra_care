import 'package:flutter/material.dart';
import '../consts.dart';

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
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8, right: 8),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       InkWell(
        //         onTap: () async {
        //           SharedPreferences preferences =
        //               await SharedPreferences.getInstance();
        //           var isLog = preferences.getBool("islog");
        //           isLog == false
        //               ? Reusable.showToast(getTranslated(context, 'open'),
        //                   gravity: ToastGravity.CENTER)
        //               : Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => FavoriteScreen()));
        //         },
        //         child: Container(
        //           child: Icon(Icons.favorite_border, color: Colors.white),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(right: 10, left: 2),
        //         child: InkWell(
        //           onTap: () async {
        //             SharedPreferences preferences =
        //                 await SharedPreferences.getInstance();
        //             var isLog = preferences.getBool("islog");
        //             isLog == false
        //                 ? Reusable.showToast(getTranslated(context, 'open'),
        //                     gravity: ToastGravity.CENTER)
        //                 : Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => NotificationScreen()));
        //           },
        //           child: Container(
        //             child: Icon(Icons.notifications_none, color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
      ],
    ),
  );
}
