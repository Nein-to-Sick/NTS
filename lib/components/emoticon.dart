import 'package:flutter/material.dart';

class Emotion extends StatelessWidget {
  const Emotion({Key? key, required this.size, required this.emotion})
      : super(key: key);

  final String size;
  final String emotion;

  @override
  Widget build(BuildContext context) {
    double s = 10;
    if (size == "big") {
      s = 64;
    } else if (size == "medium") {
      s = 32;
    } else if (size == "small") {
      s = 16;
    }
    return SizedBox(
        width: s,
        height: s,
        child: Image.asset("./assets/emo_icons/$emotion.png"));
  }
}
