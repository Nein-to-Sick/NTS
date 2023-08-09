import 'package:flutter/material.dart';

class ProfileSearchModel with ChangeNotifier {
  List<DateTime?> dialogCalendarPickerValue = [
    DateTime.now(),
  ];
  List<String> timeResult = List<String>.empty(growable: true);
  List<String> situationResult = List<String>.empty(growable: true);
  List<String> emotionResult = List<String>.empty(growable: true);
  String dirayTitle = '';

  String temp = 'none';

  //  테스트용 함수
  void temptemp() {
    temp = (temp.compareTo('none') == 0) ? 'wow' : 'none';
    notifyListeners();
  }

  bool isFiltered() {
    if (timeResult.isNotEmpty ||
        situationResult.isNotEmpty ||
        emotionResult.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //  검색창의 검색어 저장 함수
  void updateTitleValue(value) {
    dirayTitle = value;
    notifyListeners();
  }

  //  달력 안의 기간 변수 설정
  void updateCalendarSubValue(value) {
    dialogCalendarPickerValue = value;
    notifyListeners();
  }

  //  달력 밖의 기간 변수 설정, 파베 쿼리시 사용하는 변수
  void updateCalendarValue(String value) {
    timeResult = value
        .substring(0, value.length)
        .split('@ ')
        .map((value) => value.trim())
        .toList();
    notifyListeners();
  }

  //  상황 키워드 더하기
  void addSituation(value) {
    situationResult.add(value);
    notifyListeners();
  }

  //  상황 키워드 빼기
  void removeSituation(value) {
    situationResult.remove(value);
    notifyListeners();
  }

  //  감정 키워드 더하기
  void addEmotion(value) {
    emotionResult.add(value);
    notifyListeners();
  }

  //  감정 키워드 빼기
  void removeEmotion(value) {
    emotionResult.remove(value);
    notifyListeners();
  }

  //  초기화 버튼 함수, 아래 함수들은 필요시 개별적으로 호출이 가능함
  void clearAllValue() {
    clearCalendarValue();
    clearSituationValue();
    clearEmotionValue();
    clearCalendarSubValue();
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

  void clearCalendarSubValue() {
    dialogCalendarPickerValue.clear();
    dialogCalendarPickerValue = [DateTime.now()];
    notifyListeners();
  }
}
