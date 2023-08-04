import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.function,
    required this.title,
    this.condition = "not null",
  }) : super(key: key);

  final String title;
  final Function function;
  final String condition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: condition.contains("not null")
            ? () {
                function();
              }
            : null,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: condition.contains("not null")
                  ? MyThemeColors.primaryColor
                  : MyThemeColors.myGreyscale[100],
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ));
  }
}
