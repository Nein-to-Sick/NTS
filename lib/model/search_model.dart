import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSearchModel with ChangeNotifier {
  List<DateTime?> dialogCalendarPickerValue = [
    DateTime.now(),
  ];
  List<String> timeResult = List<String>.empty(growable: true);
  List<String> situationResult = List<String>.empty(growable: true);
  List<String> emotionResult = List<String>.empty(growable: true);
  String diraySearchTitle = '';

  //  future query
  Future<QuerySnapshot> futureSearchResults = (FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("diary")
      .orderBy("date", descending: true)
      .get());

  //  필터 적용 여부 확인
  bool isFiltered() {
    if (timeResult.isNotEmpty ||
        situationResult.isNotEmpty ||
        emotionResult.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //  일기 수정 후 리빌드 필요
  void refreshBuilder() {
    futureSearchResults = (FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("diary")
        .orderBy("date", descending: true)
        .get());

    notifyListeners();
  }

/*
  //  필터에 따른 서로 다른 query 리턴
  void newFilterQuery() {
    Query newQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("diary")
        .orderBy("date", descending: true);

    try {
      if (timeResult.isNotEmpty) {
        //  서로 다른 기간
        if (timeResult[1].compareTo('null') != 0) {
          newQuery = newQuery.where("date",
              isGreaterThanOrEqualTo: parseFormedTime(timeResult[0], "0:0:0"),
              isLessThanOrEqualTo: parseFormedTime(timeResult[1], "23:59:59"));
        }
        //  하루만 일때
        else {
          newQuery = newQuery.where("date",
              isGreaterThanOrEqualTo: parseFormedTime(timeResult[0], "0:0:0"),
              isLessThanOrEqualTo: parseFormedTime(timeResult[0], "23:59:59"));
        }
      }

      if (situationResult.isNotEmpty) {
        for (String situation in situationResult) {
          newQuery = newQuery.where('situation', isEqualTo: situation);
        }
      }

      if (emotionResult.isNotEmpty) {
        for (String emotion in emotionResult) {
          newQuery = newQuery.where('emotion', isEqualTo: emotion);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    futureSearchResults = newQuery.get();
    notifyListeners();
  }

  //  필터 리셋 함수
  void resetFilter() {
    futureSearchResults = (FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("diary")
        .orderBy("date", descending: true)
        .get());

    notifyListeners();
  }
  */

  //  검색창의 검색어 저장 함수
  void updateTitleValue(value) {
    diraySearchTitle = value;
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
    //resetFilter();
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

  //  date format translate
  String parseFormedTime(String timeString, String endValue) {
    String formattedTime =
        "${timeString.substring(0, 4)}/${timeString.substring(5, 7)}/${timeString.substring(8, 10)} $endValue";

    return formattedTime;
  }
}
