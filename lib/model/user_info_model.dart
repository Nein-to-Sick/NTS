import 'package:flutter/material.dart';

class UserInfoValueModel with ChangeNotifier {
  // user info data
  String userNickName = '';
  //  whether the nickname entered in the first place
  bool isValueEntered = false;
  //  whether the diary exist
  bool isDiaryExist = false;
  //  when thers is no diary and pressed the 'write diary button'

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

  void userDiaryExist() {
    isDiaryExist = true;
    notifyListeners();
  }
}
