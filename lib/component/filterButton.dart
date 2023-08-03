import 'package:flutter/material.dart';

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
            color: const Color(0xff5E5E5E).withOpacity(0.5)), // 수정
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 5.0, 11, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xffB0B0B0), fontSize: 13),
              ), // 수정
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xffB0B0B0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
