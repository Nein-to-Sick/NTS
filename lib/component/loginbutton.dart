import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  final Color backgroundColor;
  final String write;

  const LoginButton(
      {super.key,
      required this.onTap,
      required this.imagePath,
      required this.backgroundColor,
      required this.write});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: 60,
        width: 335,
        child: ElevatedButton(
          style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Color.fromARGB(14, 255, 255, 255)),
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          onPressed: () {},
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 12, 0),
                  child: Image(
                    image: AssetImage(imagePath),
                  )),
              Expanded(
                child: Text(
                  write,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
