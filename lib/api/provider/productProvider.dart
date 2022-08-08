import 'dart:convert';

import 'package:extra_care/api/environment.dart';
import 'package:extra_care/api/models/allCategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  List<AllCategoryModel> _allCategoriesModel;
  List<AllCategoryModel> get allCategoriesModel => _allCategoriesModel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<dynamic> getAllCategoryList() async {
    print('Starting Commments request');
    http.Response response = await http.get(
        Uri.parse('https://readyworx.com/pharmacy/public/api/categories'),
        headers: Environment.requestHeader);

    Map<dynamic, dynamic> responseData = json.decode(response.body);
    var results;
    if (responseData['success'] == true) {
      _allCategoriesModel = [];
      responseData['data'].forEach((element) {
        _allCategoriesModel.add(AllCategoryModel.fromJson(element));
      });
      results = true;
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }
}
