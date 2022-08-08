// import 'package:extra_care/screens/models/categoriesList.dart';
// import 'package:extra_care/widgets/appbar.dart';
// import 'package:extra_care/widgets/drawer.dart';
// import 'package:flutter/material.dart';

// import '../../consts.dart';

// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   var categoryList = CategoryList.categoryList;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         drawer: drawer(context),
//         key: _scaffoldKey,
//         backgroundColor: Colors.white,
//         body: InkWell(
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           focusColor: Colors.transparent,
//           onTap: () {
//             FocusScope.of(context).requestFocus(FocusNode());
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       appBar(context, _scaffoldKey),
//                       Container(
//                         width: double.infinity,
//                         height: 45,
//                         color: Colors.grey[200],
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: Text(
//                             "My Cart",
//                             style: TextStyle(fontSize: 34, color: Colors.black),
//                           ),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Container(
//                             width: 170,
//                             height: 170,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Constants.greenColor(),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(100.0)),
//                             ),
//                             child: Icon(
//                               Icons.shopping_basket,
//                               color: Colors.white,
//                               size: 90,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           Text(
//                             "Cart Empty",
//                             style: TextStyle(
//                                 fontSize: 23, color: Constants.skyColor()),
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Good food is always cooking! Go ahead,\norder some yummy items from the menu.",
//                               style: TextStyle(
//                                   fontSize: 18, color: Constants.skyColor()),
//                             ),
//                           ),
//                           //SizedBox(height: 10,),
//                           Text(
//                             "Browse More",
//                             style: TextStyle(fontSize: 17, color: Colors.black),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
