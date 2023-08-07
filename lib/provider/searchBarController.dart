import 'package:flutter/cupertino.dart';

class SearchBarController with ChangeNotifier {
  int folded = 0;

  void fold(int index) {
    folded = index;
    notifyListeners();
  }
}
