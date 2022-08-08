import 'package:flutter/material.dart';

import '../../consts.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white70,

        drawer: Drawer(
          child: Container(
            child: ListView(
              children: [
                Container(
                  color: Constants.lightgreenColor(),
                  child: new DrawerHeader(
                      child: Padding(
                    padding: const EdgeInsets.only(left:20 , top: 20),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Constants.shadowColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "VIP",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Sherif ElShamaa",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login",
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
                Container(
                  color: Constants.greenColor(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.filter_none, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Diet & Fitness",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.category, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Category",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon:
                        new Icon(Icons.local_post_office, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "My Order",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "My Points",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "PromoCode",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "My Medicine List",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.location_on, color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Branches Location",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.settings_input_component,
                        color: Colors.white),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "settings",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                new AboutListTile(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13, top: 35),
                        child: Text(
                          "About Us",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13, top: 4),
                        child: Text(
                          "Contact Us",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(
                          "LogOut",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
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
      ),
    );
  }
}
