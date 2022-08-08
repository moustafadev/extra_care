import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:extra_care/api/environment.dart';
import 'package:extra_care/api/models/auth.dart';
import 'package:extra_care/api/provider/loginProvider.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:extra_care/utils/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  var headers;

  LoginModel _authModel = LoginModel();

  LoginModel get authModel => _authModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<LoginModel> loginFunction(
      BuildContext context, String phone, String pass) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String languageCode = _pref.getString(Language_Code);
    // ignore: unused_local_variable
    String deviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    final Map<String, dynamic> body = {
      'phone': phone,
      'password': pass,
      'token': '123',
      'serial_number': "123",
      'os': Platform.isAndroid ? 'android' : 'ios',
      'lang': languageCode
    };
    _isLoading = true;
    notifyListeners();
    print('Starting request');
    http.Response response = await http.post(
        Uri.parse(
            'https://chromateck.com/laurus/api/v1/login?lang=$languageCode'),
        body: json.encode(body),
        headers: Environment.requestHeader);
    print('Completed request');

    Map<String, dynamic> res = json.decode(response.body);
    if (res['status'] == 1) {
      // login successful
      //_authModel = LoginModel.fromJson(res['data']);
      _authModel = parseLogin(response.body);
      Provider.of<LoginUserProvider>(context, listen: false).userData =
          authModel;
      Provider.of<LoginUserProvider>(context, listen: false).sessionToken =
          authModel.data.token;
      headers =
          Provider.of<LoginUserProvider>(context, listen: false).httpHeader;
      // print('token');
      print('this is session token' +
          Provider.of<LoginUserProvider>(context, listen: false).sessionToken);
    } else if (res['status'] == 0) {
      Reusable.clearUserData(context);
    }
    _isLoading = false;
    notifyListeners();
    return authModel;
  }

  LoginModel parseLogin(String body) {
    final parsed = json.decode(body);
    return LoginModel.fromJson(parsed);
  }
}
