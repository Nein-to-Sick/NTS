import 'package:flutter/cupertino.dart';

class SearchBarController with ChangeNotifier {
  bool folded = false;

  void fold() {
    folded = !folded;
    notifyListeners();
  }
}
