import 'package:extra_care/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class NotificationItemScreen extends StatefulWidget {
  @override
  _NotificationItemScreenState createState() => _NotificationItemScreenState();
}

class _NotificationItemScreenState extends State<NotificationItemScreen> {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //appBar(context, _scaffoldKey),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: double.infinity,
                          height: 55,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 4),
                            child: Text(
                              "22 Simple Ways to Get Healthier With Minimal Effort",
                              style: TextStyle(
                                  fontSize: 22, color: Constants.skyColor()),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/copy.png",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 270,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Modern society makes getting healthy harder than ever. People are busy trying to balance work, family and other responsibilities. As a result, their health goals are often put on hold. That said, being healthy does not have to be difficult. Here are 22 simple ways to get healthier with minimal effort. Vegetables can be loosely classified as starchy and non-starchy vegetables. Starchy vegetables generally have more carbs and calories than their non-starchy counterparts. Examples of starchy vegetables include potatoes, corn and navy beans. Non-starchy vegetables include spinach and other dark green leafy vegetables, carrots, broccoli and cauliflower. Filling half of your plate with non-starchy vegetables is a simple way to make your diet healthier. They are low in calories but packed with nutrients, fiber and water (1Trusted Source). By replacing some of the starch and protein of your meal with non-starchy vegetables, you can still eat a similar amount of food — but with fewer calories (2Trusted Source). This simple strategy also saves you the hassle of worrying about serving sizes and calories. Summary: Filling half of your plate with non-starchy vegetables is a simple way to eat healthier. Vegetables are low in calories and high in fiber and nutrients. Believe it or not, the size of your plate can affect how much you eat. In one study, scientists found that people who ate from large serving bowls ate 56% (142 calories) more food than people who ate from smaller bowls (3Trusted Source). In an analysis of 72 studies, scientists found that people consistently ate more food when offered larger portions and plates (4). The simple illusion of eating from a smaller plate could help you feel satisfied with less food. Summary: Eating from a smaller plate is a simple way to trick your brain into eating less. This can be useful if you feel the portions you eat are too big. Refined carbs are commonly known as simple carbs or “empty” carbs. They are rigorously processed and stripped of nearly all their nutrients and fiber. This means they add extra calories to your diet with no nutritional benefit. Examples of refined carbs include white flour, white bread and white rice.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                letterSpacing: 1,
                                wordSpacing: 2),
                          ),
                        ),
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
}
