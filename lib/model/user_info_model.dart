import 'package:flutter/material.dart';

class UserInfoValueModel with ChangeNotifier {
  // user info data
  String userNickName = '';
  bool isValueEntered = false;

  void userNickNameUpdate(value) {
    userNickName = value;
    notifyListeners();
  }

  void userNickNameClear() {
    userNickName = '';
    notifyListeners();
  }

  void valueUpdate() {
    isValueEntered = true;
    notifyListeners();
  }

  void valueDeUpdate() {
    isValueEntered = false;
    notifyListeners();
  }
}
