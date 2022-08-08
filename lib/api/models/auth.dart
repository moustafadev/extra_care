// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel with ChangeNotifier {
  LoginModel({
    this.data,
    this.status,
    this.massage,
  });

  Data data;
  int status;
  String massage;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        massage: json["massage"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "massage": massage,
      };
}

class Data {
  Data({
    this.token,
    this.user,
  });

  var token;
  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
      };
}

class User {
  User(
      {this.id,
      this.number,
      this.name,
      this.address,
      this.phone,
      this.email,
      this.info,
      this.activation,
      this.gender,
      this.attachment});

  int id;
  String number;
  String name;
  String address;
  String phone;
  String email;
  dynamic info;
  String activation;
  String gender;
  String attachment;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        attachment: json["attachment"],
        info: json["info"],
        activation: json["activation"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "email": email,
        "info": info,
        "activation": activation,
        "gender": gender,
      };
}

class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);
  String toString() {
    if (_message == null) return "Exception";
    return "Exception:$_message";
  }
}
