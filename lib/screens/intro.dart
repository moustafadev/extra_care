import 'package:extra_care/classes/language.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/auth/login.dart';
import 'package:extra_care/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var lang = Language.languageList();
  Language language;

  Future<void> changeLanguage(lang) async {
    Locale _temp = await setLocale(lang);

    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .2,
                          //alignment: Alignment.center,
                          child: Image.asset('assets/images/scroll.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      height: MediaQuery.of(context).size.height * .28,
                      //alignment: Alignment.center,
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.contain),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          getTranslated(context, 'start'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              child: button(context, 'اللغة العربية',
                                  Constants.buttonColor()),
                              onTap: () async {
                                changeLanguage(lang[1].languageCode);
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setBool('language', true);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              child: button(
                                  context, 'English', Constants.buttonColor()),
                              onTap: () async {
                                changeLanguage(lang[0].languageCode);
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setBool('language', true);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
