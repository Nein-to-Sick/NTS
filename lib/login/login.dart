import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            title: Text(message),
          );
        });
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
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final BackgroundController controller = Provider.of<BackgroundController>(context, listen: false);
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
                      replacement: const Text('반 딧 불 이'),
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        animatedTexts: [
                          FlickerAnimatedText('반 딧 불 이'),
                        ],
                        // onTap: () {
                        //   if (kDebugMode) {
                        //     print("Tap Event");
                        //   }
                        // },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    child: Text("일기 쓰고 편지 받는 앱"),
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
                              const Color.fromARGB(14, 255, 255, 255)),
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xff1A5DCC)),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {
                        AuthService().signInWithGoogle().then((value) {
                          setState(() {
                            user = value;
                          });
                          if (user != null) {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
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
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: SizedBox(
                    height: 60,
                    width: 335,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              const Color.fromARGB(14, 255, 255, 255)),
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
                              child: const Image(
                                image: AssetImage("assets/applelogo.png"),
                              )),
                          const Expanded(
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
  }
}
