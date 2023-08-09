import 'package:flutter/cupertino.dart';

class AlertController with ChangeNotifier {

  bool alert = false;
  void permission(bool alert) {
    alert = alert;
    notifyListeners();
  }
}
