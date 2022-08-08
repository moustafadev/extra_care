import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/screens/profile/changeLang.dart';
import 'package:extra_care/screens/profile/changePass.dart';
import 'package:extra_care/widgets/appBarWithArrow.dart';
import 'package:flutter/material.dart';
import 'package:extra_care/widgets/drawer.dart';
import '../../consts.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: drawer(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appBarWithArrow(context, getTranslated(context, 'set')),
            SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .88,
                    height: MediaQuery.of(context).size.height * .2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Constants.skyColor(),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.settings_backup_restore),
                            ),
                          ),
                          Text(
                            getTranslated(context, 'changePass'),
                            style: TextStyle(
                                fontSize: 17, color: Constants.skyColor()),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Constants.skyColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangeLanguage()));
              },
              child: Card(
                elevation: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width * .88,
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Constants.skyColor(),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.language),
                          ),
                        ),
                        Text(
                          getTranslated(context, 'changeLang'),
                          style: TextStyle(
                              fontSize: 17, color: Constants.skyColor()),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Constants.skyColor(),
                          ),
                        ),
                      ],
                    ),
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
