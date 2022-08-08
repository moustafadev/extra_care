import 'package:extra_care/classes/language.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/buttombar/buttomBar.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:flutter/material.dart';
import 'package:extra_care/widgets/drawer.dart';
import '../../consts.dart';
import '../../main.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  var lang = Language.languageList();
  Language language;

  Future<void> changeLanguage(lang) async {
    Locale _temp = await setLocale(lang);

    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: drawer(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appBarWithArrow(context, getTranslated(context, 'changeLang')),
            SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  changeLanguage(lang[1].languageCode);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomTabScreen()),
                      (route) => false);
                  //MyApp.restartApp(context);
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .88,
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("اللغة العربية",
                            style: TextStyle(
                                fontSize: 17, color: Constants.skyColor())),
                        Text(lang[1].flag),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            InkWell(
              onTap: () async {
                changeLanguage(lang[0].languageCode);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomTabScreen()),
                    (route) => false);
                //MyApp.restartApp(context);
              },
              child: Card(
                elevation: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width * .88,
                  height: MediaQuery.of(context).size.height * .1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(lang[0].name,
                          style: TextStyle(
                              fontSize: 17, color: Constants.skyColor())),
                      Text(lang[0].flag),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
