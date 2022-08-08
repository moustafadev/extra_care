import 'package:extra_care/localization/demoLocalization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslated(BuildContext context, String key) {
  return DemoLocalizations.of(context).getTranslatedValue(key);
}

const String English = 'en';
const String Arabic = 'ar';

const String Language_Code = 'langueageCode';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  await _pref.setString(Language_Code, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case English:
      _temp = Locale(languageCode, 'US');
      break;
    case Arabic:
      _temp = Locale(languageCode, 'EG');
      break;
    default:
      _temp = Locale(English, 'US');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code) ?? English;
  return _locale(languageCode);
}
