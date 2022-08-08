import 'package:flutter/material.dart';

class LoadingModel with ChangeNotifier {
  // ignore: non_constant_identifier_names
  bool Loading = false;

  void toggleLoading() {
    Loading = !Loading;
    print(Loading.toString());
    notifyListeners();
  }
}
