import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.function, required this.title}) : super(key: key);

  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: const Color(0xff016670), // 수정
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        onTap: () {
          function();
        });
  }
}
