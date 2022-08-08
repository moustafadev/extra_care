import 'dart:convert';
import 'package:extra_care/api/apiService.dart';
import 'package:extra_care/screens/Prescription/Prescriprion.dart';
import 'package:extra_care/screens/home/HomeBodyAfterRegistration.dart';
import 'package:extra_care/screens/diet/diet.dart';
import 'package:extra_care/screens/cart/mycart.dart';
import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class BottomTabScreen extends StatefulWidget {
  @override
  _BottomTabScreenState createState() => _BottomTabScreenState();
}

class _BottomTabScreenState extends State<BottomTabScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentTab = 0;
  int cart = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeBodyAfterRegistration(),
    // DietScreen(),
    // Prescription(),
    MyCartScreen()
  ];

  @override
  void initState() {
    super.initState();
    getCount();
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == 2) {
        _scaffoldKey.currentState.openDrawer(); // CHANGE THIS LINE
      } else {
        _currentTab = index;
      }
    });
  }

  Widget callPage(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return HomeBodyAfterRegistration();
      // case 1:
      //   return DietScreen();
      // case 2:
      //   return Prescription();
      case 1:
        return MyCartScreen();
      case 2:
        return drawer(context);

        break;
      default:
        return HomeBodyAfterRegistration();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: drawer(context),
        //backgroundColor: Colors.white,
        body: _widgetOptions.elementAt(_currentTab),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              border: Border.all(
                width: 1,
                color: Constants.skyColor(),
                style: BorderStyle.solid,
              )),
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentTab,
              onTap: onTabTapped,
              // onTap: (int index) {
              //   setState(() {
              //     _currentTab = index;
              //   });
              // },
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey[500],
              items: [
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.home,
                    size: 40,
                  ),
                  // ignore: deprecated_member_use
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.fitness_center),
                //   // ignore: deprecated_member_use
                //   title: Text(""),
                // ),
                // BottomNavigationBarItem(
                //   icon: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(Icons.camera_alt),
                //       // Padding(
                //       //   padding: const EdgeInsets.only(left: 4, right: 4),
                //       //   child: Text("R"),
                //       // )
                //     ],
                //   ),
                //   // ignore: deprecated_member_use
                //   title: Text(""),
                // ),
                // BottomNavigationBarItem(
                //   icon: ImageIcon(
                //     AssetImage('assets/images/instagram.png'),
                //     size: 35,
                //     color: Colors.redAccent,
                //   ),
                //   // ignore: deprecated_member_use
                //   title: Text(""),
                // ),
                BottomNavigationBarItem(
                  label: '',
                  icon: cart == 0
                      ? Icon(
                          Icons.add_shopping_cart,
                          size: 40,
                        )
                      : Stack(
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              size: 40,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              // alignment: Alignment.topCenter,
                              child: Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                alignment: Alignment.center,
                                child: Text(
                                  cart.toString(),
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                  // ignore: deprecated_member_use
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.settings,
                    size: 40,
                  ),
                  // ignore: deprecated_member_use
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getCount() async {
    // print("object" + tabType);
    final loginresponse = await fetchCount();
    var res = json.decode(loginresponse.body);

    // List adminDone = [];
    if (res['status'] == 1) {
      setState(() {
        cart = res['data']['product_in_cart_count'];
      });
    } else {
      setState(() {
        cart = 0;
      });
    }
  }
}
