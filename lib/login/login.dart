import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/component/loginbutton.dart';
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

  //error message popup
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // After 1 second, hide AnimatedTextKit and show the regular text
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showAnimatedText = false;
        });
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);

    void signUserIn() {
      User? user = FirebaseAuth.instance.currentUser;

      // print(user);

      if (user != null) {
        // User is logged in, return 600
        print("moving");
        controller.movePage(600);
      }
      print("counint: ");
      print(user);
    }

    signUserIn();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Visibility(
                      visible: _showAnimatedText,
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        animatedTexts: [
                          FlickerAnimatedText('반 딧 불 이'),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                      replacement: Text('반 딧 불 이'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    child: Text("일기 쓰고 편지 받는 앱"),
                    // AnimatedTextKit(
                    //   animatedTexts: [
                    //     TypewriterAnimatedText('일기 쓰고 편지 받는 앱'),
                    //   ],
                    //   onTap: () {
                    //     print("Tap Event");
                    //   },
                    // ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                // Spacer(),
                GestureDetector(
                  child: SizedBox(
                    height: 60,
                    width: 335,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Color.fromARGB(14, 255, 255, 255)),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff1A5DCC)),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {
                        AuthService().signInWithGoogle().then((value) {
                          signUserIn();
                        });
                        // signUserIn();
                      },
                      // controller.movePage(600);,
                      child: Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 12, 0),
                              child: Image(
                                image: AssetImage("assets/googlelogo.png"),
                              )),
                          Expanded(
                            child: Text(
                              "Google로 시작하기",
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
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: SizedBox(
                    height: 60,
                    width: 335,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Color.fromARGB(14, 255, 255, 255)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {
                        showErrorMessage("V.1.0.0에 구현될 예정입니다.");
                      },
                      child: Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 12, 0),
                              child: Image(
                                image: AssetImage("assets/applelogo.png"),
                              )),
                          Expanded(
                            child: Text(
                              "Apple로 시작하기",
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
                ),
              ],
            ),
          ),
        ),
      )),
    );

    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Text(
    //       "Login",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(bottom: 40.0),
    //       child: Align(
    //         alignment: Alignment.bottomCenter,
    //         child: ElevatedButton(
    //           onPressed: () {
    //             controller.movePage(600);
    //           },
    //           child: const Icon(Icons.arrow_forward),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
