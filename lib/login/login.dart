import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/login/auth_service.dart';
import 'package:provider/provider.dart';

import '../provider/backgroundController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showAnimatedText = true;
  User? user = FirebaseAuth.instance.currentUser;

  //error message popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MyThemeColors.whiteColor,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    addListener();
    _controller.forward();

    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final BackgroundController controller =
            Provider.of<BackgroundController>(context, listen: false);
        controller.movePage(600);
        controller.changeColor(2);
      });
    }
  }

  addListener() {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showAnimatedText = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 여기에 추가하세요.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.19),
              child: Column(
                children: [
                  SizedBox(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 7.0,
                            color: Colors.white,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: flickerText(_showAnimatedText, "반"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: flickerText(_showAnimatedText, "딧"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: flickerText(_showAnimatedText, "불"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: flickerText(_showAnimatedText, "이"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      child: Text(
                        "마음을 밝히는 작은 불빛",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 55.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      height: 60,
                      width: 335,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                const Color.fromARGB(14, 255, 255, 255)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff1A5DCC)),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () {
                          AuthService().signInWithGoogle().then((value) async {
                            setState(() {
                              user = value;
                            });

                            if (user != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (controller.scrollController.hasClients) {
                                  controller.movePage(600);
                                  controller.changeColor(2);
                                }
                              });
                            }
                          });
                          // signUserIn();
                        },
                        // controller.movePage(600);,
                        child: Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(5, 0, 12, 0),
                                child: const Image(
                                  image: AssetImage("assets/googlelogo.png"),
                                )),
                            const Expanded(
                              child: Text(
                                "Google로 로그인",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //  apple login button
                  // GestureDetector(
                  //   child: SizedBox(
                  //     height: 60,
                  //     width: 335,
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(
                  //           overlayColor: MaterialStateProperty.all(
                  //               const Color.fromARGB(14, 255, 255, 255)),
                  //           backgroundColor:
                  //               MaterialStateProperty.all(Colors.black),
                  //           shadowColor:
                  //               MaterialStateProperty.all(Colors.transparent),
                  //           shape: MaterialStateProperty.all<
                  //               RoundedRectangleBorder>(RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(18.0),
                  //           ))),
                  //       onPressed: () {
                  //         showErrorMessage("V.1.0.0에 구현될 예정입니다.");
                  //       },
                  //       child: Row(
                  //         children: [
                  //           Container(
                  //               margin: const EdgeInsets.fromLTRB(5, 0, 12, 0),
                  //               child: const Image(
                  //                 image: AssetImage("assets/applelogo.png"),
                  //               )),
                  //           const Expanded(
                  //             child: Text(
                  //               "Apple로 로그인",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

Widget flickerText(showAnimatedText, text) {
  return Visibility(
    visible: showAnimatedText,
    replacement: Text(
      text,
      style: const TextStyle(fontSize: 50, fontFamily: "Dodam"),
    ),
    child: AnimatedTextKit(
      totalRepeatCount: 1,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      animatedTexts: [
        FlickerAnimatedText(text,
            textStyle: const TextStyle(fontSize: 50, fontFamily: "Dodam")),
      ],
      isRepeatingAnimation: false,
      //...
    ),
  );
}
