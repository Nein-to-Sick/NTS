import 'package:flutter/material.dart';

class UserInfoValueModel with ChangeNotifier {
  // user info data
  String userNickName = '';
  String userEmail = '';
  bool isValueEntered = false;

  void userNickNameUpdate(value) {
    userNickName = value;
    notifyListeners();
  }

  void userNickNameClear() {
    userNickName = '';
    notifyListeners();
  }

  void userEmailUpdate(value) {
    userNickName = value;
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
