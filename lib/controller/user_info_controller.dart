import 'package:flutter/material.dart';

class UserInfoValueModel with ChangeNotifier {
  String userNickName = '';
  String userEmail = '';
  bool isValueEntered = false;
  bool isDiaryExist = false;
  bool disAllowToTouch = false;
  int currentYellowValue = 1;

  void userNickNameUpdate(value) {
    userNickName = value;
    notifyListeners();
  }

  void userInfoClear() {
    userNickName = '';
    userEmail = '';
    isValueEntered = false;
    isDiaryExist = false;
    notifyListeners();
  }

  void userEmailUpdate(value) {
    userEmail = value;
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

  void userDiaryExist(value) {
    isDiaryExist = value;
    notifyListeners();
  }

  void updateYellowValue(value) {
    currentYellowValue = value;
    notifyListeners();
  }

  void updateAbsorbToTouch(value) {
    disAllowToTouch = value;
    notifyListeners();
  }
}
