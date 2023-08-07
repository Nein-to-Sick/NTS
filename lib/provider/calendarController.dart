import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CalendarController with ChangeNotifier {
  Map<String, bool> selected = {}; // Change the key type to String
  int count = 0;

  void setSelected(Map<String, bool> s) {
    selected = s;
    // notifyListeners();
  }

  void setCount(int c) {
    count = c;
    // notifyListeners();
  }

  DateTime dateKeyToDateTime(String dateKey) {
    return DateTime.parse(
        '${dateKey.substring(0, 4)}-${dateKey.substring(4, 6)}-${dateKey.substring(6, 8)}');
  }

  String formatStartDate() {
    DateTime startDate = selected.keys
        .where((key) => selected[key]!)
        .map((e) => dateKeyToDateTime(e))
        .reduce((a, b) => a.compareTo(b) < 0 ? a : b);
    return DateFormat('yyyy/MM/dd 0:0:0').format(startDate);
  }

  String formatEndDate() {
    DateTime endDate = selected.keys
        .where((key) => selected[key]!)
        .map((e) => dateKeyToDateTime(e))
        .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
        // .add(Duration(days: 1));

    return DateFormat('yyyy/MM/dd 23:59:59').format(endDate);
  }

  String formatOneDayEndDate() {
    DateTime endDate = selected.keys
        .where((key) => selected[key]!)
        .map((e) => dateKeyToDateTime(e))
        .reduce((a, b) => a.compareTo(b) < 0 ? a : b);

    return DateFormat('yyyy/MM/dd 23:59:59').format(endDate);
  }
}
