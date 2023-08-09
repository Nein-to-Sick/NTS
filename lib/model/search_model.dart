import 'package:flutter/material.dart';

class ProfileSearchModel with ChangeNotifier {
  List<String> timeResult = List<String>.empty(growable: true);
  List<String> situationResult = List<String>.empty(growable: true);
  List<String> emotionResult = List<String>.empty(growable: true);
  String dirayTitle = '';

  String temp = 'none';

  void temptemp() {
    temp = (temp.compareTo('none') == 0) ? 'wow' : 'none';
    notifyListeners();
  }

  void updateTitleValue(value) {
    dirayTitle = value;
    notifyListeners();
  }

  void updateCalendarValue(String value) {
    timeResult = value
        .substring(0, value.length)
        .split('@ ')
        .map((value) => value.trim())
        .toList();
    notifyListeners();
  }

  void addSituation(value) {
    situationResult.add(value);
    notifyListeners();
  }

  void removeSituation(value) {
    situationResult.remove(value);
    notifyListeners();
  }

  void addEmotion(value) {
    emotionResult.add(value);
    notifyListeners();
  }

  void removeEmotion(value) {
    emotionResult.remove(value);
    notifyListeners();
  }

  void clearAllValue() {
    clearCalendarValue();
    clearSituationValue();
    clearEmotionValue();
    notifyListeners();
  }

  void clearCalendarValue() {
    timeResult.clear();
    notifyListeners();
  }

  void clearSituationValue() {
    situationResult.clear();
    notifyListeners();
  }

  void clearEmotionValue() {
    emotionResult.clear();
    notifyListeners();
  }
}
