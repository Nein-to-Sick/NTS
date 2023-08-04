import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key, required this.title, required this.function})
      : super(key: key);

  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyThemeColors.myGreyscale.shade700.withOpacity(0.5),
        ), // 수정
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 5.0, 11, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: MyThemeColors.myGreyscale.shade300,
                  fontSize: 13,
                ),
              ), // 수정
              Icon(
                Icons.keyboard_arrow_down,
                color: MyThemeColors.myGreyscale.shade300,
              )
            ],
          ),
        ),
      ),
    );
  }
}
