// import 'package:extra_care/screens/home/HomeBodyAfterRegistration.dart';
// import 'package:extra_care/screens/checkout/selectaddress.dart';
// import 'package:extra_care/widgets/drawer.dart';
// import 'package:flutter/material.dart';

// import '../../consts.dart';

// class RejectedScreen extends StatefulWidget {
//   @override
//   _RejectedScreenState createState() => _RejectedScreenState();
// }

// class _RejectedScreenState extends State<RejectedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         drawer: drawer(context),
//         appBar: AppBar(
//           //titleSpacing: 0.0,
//           leading: new Row(
//             children: [
//               Icon(Icons.arrow_back, color: Colors.white),
//               SizedBox(
//                 width: 8,
//               ),
//               InkWell(
//                   onTap: () {
//                     //drawer();
//                   },
//                   child: Icon(Icons.search, color: Colors.white)),
//             ],
//           ),
//           centerTitle: true,
//           title: Text(
//             "ExtraCare",
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [
//             Container(
//               child: Icon(Icons.favorite_border, color: Colors.white),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 10, left: 2),
//               child: Container(
//                 child: Icon(Icons.notifications_none, color: Colors.white),
//               ),
//             ),
//           ],
//           elevation: 0,
//           backgroundColor: Constants.greenColor(),
//         ),
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
//                       Container(
//                         width: double.infinity,
//                         height: 50,
//                         color: Colors.grey[200],
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: Text(
//                             "My Cart",
//                             style: TextStyle(fontSize: 37, color: Colors.black),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: MediaQuery.of(context).size.height,
//                         color: Colors.white,
//                         child: ListView.builder(
//                           itemCount: cartList.length,
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return CartListView(
//                               cartList: cartList[index],
//                               isShowDate: true,
//                               callback: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => SelectAddress()));
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 100,
//                         color: Colors.red[100],
//                         child: Text(
//                           'The following items has rejected',
//                           style: TextStyle(color: Colors.black, fontSize: 28),
//                         ),
//                         alignment: Alignment.center,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: MediaQuery.of(context).size.height,
//                         color: Colors.white,
//                         child: ListView.builder(
//                           itemCount: cartList.length,
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return CartListView(
//                               cartList: cartList[index],
//                               isShowDate: true,
//                               callback: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => SelectAddress()));
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         HomeBodyAfterRegistration()));
//                               },
//                               child: Container(
//                                 height: 40,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                     color: Constants.redColor(),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(25))),
//                                 child: Text(
//                                   'Back to Home',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 14),
//                                 ),
//                                 alignment: Alignment.center,
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => SelectAddress()));
//                               },
//                               child: Container(
//                                 height: 40,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                     color: Constants.redColor(),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(25))),
//                                 child: Text(
//                                   'Accept & CheckOut',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 14),
//                                 ),
//                                 alignment: Alignment.center,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
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

// class CartListView extends StatelessWidget {
//   final CartList cartList;
//   final bool isShowDate;
//   final VoidCallback callback;

//   const CartListView({Key key, this.cartList, this.isShowDate, this.callback})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//                 color: Constants.shadowColor(),
//                 blurRadius: 16,
//                 offset: Offset(4, 4)),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     cartList.name,
//                     style: TextStyle(
//                       fontSize: 23,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   child: Row(
//                     children: [
//                       Text(
//                         cartList.cost,
//                         style: TextStyle(fontSize: 16, color: Colors.black87),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Icon(
//                         Icons.close,
//                         color: Constants.redColor(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 cartList.desc,
//                 style: TextStyle(fontSize: 14, color: Constants.hintColor()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
