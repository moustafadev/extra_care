library my_prj.globals;

import 'package:extra_care/api/models/auth.dart';

final int photo = 0;
final int video = 1;

Map<String, dynamic> userData = {
  'token': null,
  "user": {"id": 0, "name": '', "address": '', "phone": "", "attachment": ''},
};
LoginModel userModel = new LoginModel();

resetUserData() {
  userData = {
    'token': null,
    "user": {"id": 0, "name": ''},
  };
}
