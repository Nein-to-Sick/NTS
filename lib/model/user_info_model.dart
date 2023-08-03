import 'package:flutter/material.dart';

class UserInfoValueModel with ChangeNotifier {
  // user info data
  String userNickName = '';

  void userNickNameUpdate(value) async {
    userNickName = value;
    notifyListeners();
  }
}
