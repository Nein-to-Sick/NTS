import 'package:flutter/cupertino.dart';

class MessageController with ChangeNotifier {
  bool newMessage = false;

  void getMessage() {
    newMessage = true;
    notifyListeners();
  }

  void confirm() {
    newMessage = false;
    notifyListeners();
  }

  bool speaker = true;
  void speakerToggle() {
    speaker = !speaker;
    notifyListeners();
  }
}
