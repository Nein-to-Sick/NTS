import 'package:flutter/material.dart';

class ProfileSearchModel with ChangeNotifier {
  List<String> timeResult = List<String>.empty(growable: true);

  void updateCalendarValue(value) {
    timeResult = value
        .substring(0, value.length)
        .split('@ ')
        .map((value) => value.trim())
        .toList();
    notifyListeners();
  }
}
