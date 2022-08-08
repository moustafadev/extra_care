import 'package:extra_care/api/models/auth.dart';
import 'package:flutter/cupertino.dart';

class LoginUserProvider extends ChangeNotifier {
  var httpHeader;
  String _sessionToken = '';
  LoginModel _userData;
  String _serverURL;

  // ignore: unnecessary_getters_setters
  LoginModel get userData => _userData;
  int get uID {
    return _userData.data.user.id;
  }

  // ignore: unnecessary_getters_setters
  set userData(LoginModel value) {
    _userData = value;
  }

  String get sessionToken => _sessionToken;

  set sessionToken(String value) {
    _sessionToken = value;
    httpHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json', /////
      //'SessionToken': 'Bearer ' + sessionToken,
      'Authorization': 'Bearer $sessionToken',
      //sessionToken
    };
    print('session token' + sessionToken);
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  String get serverURL => _serverURL;

  // ignore: unnecessary_getters_setters
  set serverURL(String value) {
    _serverURL = value;
  }
}
