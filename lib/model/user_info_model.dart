import 'package:flutter/material.dart';

class UserInfoValueModel with ChangeNotifier {
  // user info data
  String userNickName = '';
  //  whether the nickname entered in the first place
  String userEmail = '';
  bool isValueEntered = false;
  //  whether the diary exist
  bool isDiaryExist = false;

  void userNickNameUpdate(value) {
    userNickName = value;
    notifyListeners();
  }

  void userInfoClear() {
    userNickName = '';
    isValueEntered = false;
    notifyListeners();
  }

  void userEmailUpdate(value) {
    userNickName = value;
    notifyListeners();
  }

  void userEmailClear() {
    userEmail = '';
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

  void userDiaryExist() {
    isDiaryExist = true;
    notifyListeners();
  }
}
