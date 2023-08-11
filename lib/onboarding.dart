import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

import 'component/button.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key, required this.controller});

  final controller;

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              children: <Widget>[
                _buildOnboardingPage(
                  context,
                  imagePath: "./assets/onboard/1.png",
                  text: "일기를 쓰고",
                  buttonText: '다음',
                  onPageButtonTap: () {
                    _controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                ),
                _buildOnboardingPage(
                  context,
                  imagePath: "./assets/onboard/1.png",
                  text: "일기를 쓰고",
                  buttonText: '다음',
                  onPageButtonTap: () {
                    _controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                ),
                _buildOnboardingPage(
                  context,
                  imagePath: "./assets/onboard/3.png",
                  text: "감사의 마음을 전해보세요",
                  buttonText: '시작하기',
                  onPageButtonTap: () {
                    Navigator.pop(context);
                    widget.controller.movePage(600.0);
                  },
                ),
              ],
            ),
            Positioned(
              right: 30,
              top: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.controller.movePage(600.0);
                },
                child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.transparent,
                    child: Center(
                        child: Text("skip",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MyThemeColors.myGreyscale[400])))),
              ),
            ),
          ],
        ));
  }

  Widget _buildOnboardingPage(
    BuildContext context, {
    required String imagePath,
    required String text,
    required String buttonText,
    required void Function() onPageButtonTap,
  }) {
    return Center(
      child: Stack(
        children: [
          Center(child: Image.asset(imagePath)),
          Padding(
            padding: EdgeInsets.only(top: 180.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 25, fontFamily: "Dodam", color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, left: 20, right: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Button(
                function: onPageButtonTap,
                title: buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
