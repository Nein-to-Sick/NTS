import 'package:flutter/cupertino.dart';

class BackgroundController with ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  void movePage(double page) {
    scrollController.animateTo(
      page,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
    notifyListeners();
  }

  int page = 2;
  void changeColor(int index) {
    page = index;
    notifyListeners();
  }

  bool fireFly = false;
  void fireFlyOn() {
    fireFly = true;
    notifyListeners();
  }
  void fireFlyOff() {
    fireFly = false;
    notifyListeners();
  }
}
