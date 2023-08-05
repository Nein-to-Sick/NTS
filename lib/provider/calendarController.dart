import 'package:flutter/cupertino.dart';

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
}
