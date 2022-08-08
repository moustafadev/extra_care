import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:extra_care/localization/localizationConstants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/globals.dart' as globals;

final String baseUrl = 'https://chromateck.com/laurus/api/v1/';

Future fetchCategoery() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=categories&response_type=all&lang=$languageCode'));
  return response;
}

Future fetchSubCategoery(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(baseUrl +
      'home?type=sub_categories&response_type=all&category_id=$id&lang=$languageCode'));
  return response;
}

Future fetchFav() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=products&response_type=all&is_favourate=1&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> toggleLike(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'product_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'favourite/toggle?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchProducts() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=products&response_type=all&lang=$languageCode'));
  return response;
}

Future fetchSearch(key) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(baseUrl +
      'home?type=products&response_type=all&search=$key&lang=$languageCode'));
  return response;
}

Future fetchAds() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=ads&response_type=all&lang=$languageCode'));
  return response;
}

Future callFetch() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=settings&response_type=all&lang=$languageCode'));
  return response;
}

Future fetchAddressList() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          baseUrl + 'home?type=addresses&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> addAddress(title, lat, long) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'title': title,
    'longitude': long,
    'latitude': lat,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'address/add?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> removeAddress(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'address_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'address/remove?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> testCoupon(code) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'coupon_code': code,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'order/test-coupon?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchCart() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          baseUrl + 'home?type=cart&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchCartSerial() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  String deviceId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }
  http.Response response = await http.get(
    Uri.parse(baseUrl +
        'home?type=cart&response_type=all&os=${Platform.isAndroid ? 'android' : 'ios'}&serial_number=$deviceId&lang=$languageCode'),
  );
  return response;
}

Future<dynamic> removeCartItem(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'product_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'cart/remove?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> removeCartItemSerial(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  String deviceId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }
  //Reusable.showLoading(context);
  final bodyApi = {
    'product_id': id,
    'serial_number': deviceId,
    'os': Platform.isAndroid ? 'android' : 'ios',
  };
  http.Response response = await http.post(
    Uri.parse(baseUrl + 'cart/remove?lang=$languageCode'),
    body: bodyApi,
  );
  return response;
}

Future<dynamic> checkout(addressid, branchId, pay, code) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'address_id': addressid,
    'branch_id': branchId,
    'payment_method': pay,
    'coupon_code': code,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'order/check-out?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchOrders() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          baseUrl + 'home?type=orders&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchBranches() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=branches&response_type=all&lang=$languageCode'));
  return response;
}

Future<dynamic> contactAuth(content) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'contact': content,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'contact-us?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> contactOutAuth(name, phone, mail, content) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'name': name,
    'phone': phone,
    'email': mail,
    'contact': content,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'contact-us?lang=$languageCode'),
      body: bodyApi);
  return response;
}

Future<dynamic> addRate(id, comment, rate) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'product_id': id,
    'comment': comment,
    'rate': rate,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'review/add?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> logout() async {
  String deviceId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'serial_number': deviceId,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'logout?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchCategoeryProducts(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(baseUrl +
      'home?type=products&response_type=all&category_id=$id&lang=$languageCode'));
  return response;
}

Future showProfile() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          'https://chromateck.com/laurus/api/v1/show-profile?lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> name(name) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'name': name,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'update-profile?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> address(address) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'address': address,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'update-profile?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> change(old, newPass, match) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'old_password': old,
    'password': newPass,
    'password_confirmation': match,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'reset-password?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchCategoeryProductsWithToken(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=products&response_type=all&category_id=$id&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchProductsWithToken() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          baseUrl + 'home?type=products&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchSearchWithToken(key) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=products&response_type=all&search=$key&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchReviews(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(baseUrl +
      'home?type=reviews&response_type=all&product_id=$id&lang=$languageCode'));
  return response;
}

Future fetchCount() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=user_counts&response_type=all&lang$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchDietCategoery() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=diet_fitness&response_type=all&lang=$languageCode'));
  return response;
}

Future fetchDietProductsWithToken() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=diet_fitness&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> cancelOrder(orderId) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'order_id': orderId,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'order/cancel?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> rejectReview(orderId) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'order_id': orderId,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'order/reject-review?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> acceptReview(orderId) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'order_id': orderId,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'order/accept-review?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> editCartCount(id, count) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'product_id': id,
    'quantity': count,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'cart/edit-quantity?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> editCartCountSerial(id, count) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  String deviceId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }
  //Reusable.showLoading(context);
  final bodyApi = {
    'product_id': id,
    'quantity': count,
    'serial_number': deviceId,
    'os': Platform.isAndroid ? 'android' : 'ios',
  };
  http.Response response = await http.post(
    Uri.parse(baseUrl + 'cart/edit-quantity?lang=$languageCode'),
    body: bodyApi,
  );
  return response;
}

Future<dynamic> sendMsg(msg) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'message': msg,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'chat/send-message?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchChatList() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          baseUrl + 'home?type=chat&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> reOrder(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'order_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'order/reordering?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchQR(qr) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=scan_qr_code&response_type=all&qr_code=$qr&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future fetchQRNoToken(qr) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
    Uri.parse(baseUrl +
        'home?type=scan_qr_code&response_type=all&qr_code=$qr&lang=$languageCode'),
  );
  return response;
}

Future fetchNotification() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(baseUrl +
          'home?type=notifications&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> deleteNotification(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'notification_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'notifications/delete?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> readNotification(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'notification_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'notifications/read?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> toggleNotification(type) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'type': type,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'notifications/toggle-settings?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future mostSale() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(Uri.parse(
      baseUrl + 'home?type=Most_sale&response_type=all&lang=$languageCode'));
  return response;
}

Future getInsurance() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  http.Response response = await http.get(
      Uri.parse(
          baseUrl + 'home?type=insurance&response_type=all&lang=$languageCode'),
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}

Future<dynamic> deleteInsurance(id) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(Language_Code);
  //Reusable.showLoading(context);
  final bodyApi = {
    'Insurance_attachment_id': id,
  };
  http.Response response = await http.post(
      Uri.parse(baseUrl + 'insurance/delete?lang=$languageCode'),
      body: bodyApi,
      headers: {
        'Authorization': 'Bearer ' + globals.userData['token'],
      });
  return response;
}
