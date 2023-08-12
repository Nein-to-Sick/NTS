import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nts/home/mailBox.dart';
import 'package:nts/onboarding.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/messageController.dart';
import 'package:nts/provider/gpt_model.dart';
import 'package:provider/provider.dart';
import '../component/help.dart';
import '../model/user_info_model.dart';
import 'diary.dart';
import 'letter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.player}) : super(key: key);

  final AudioPlayer player;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isTextVisible = true;
  bool speakerOn = true;

  void _toggleTextVisibility() {
    setState(() {
      _isTextVisible = false;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isTextVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final userName = userInfo.userNickName;
    final messageController = Provider.of<MessageController>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GestureDetector(
          onTap: () {
            _toggleTextVisibility(); // Add this line
          },
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  speakerOn = !speakerOn;
                                  if (speakerOn) {
                                    widget.player.play();
                                  } else {
                                    widget.player.pause();
                                  }
                                });
                              },
                              child: Opacity(
                                  opacity: 0.4,
                                  child: HeroIcon(
                                    speakerOn
                                        ? HeroIcons.speakerWave
                                        : HeroIcons.speakerXMark,
                                    style: HeroIconStyle.solid,
                                  ))),
                          SizedBox(
                            width: 13,
                          ),
                          GestureDetector(
                            onTap: () {
                              showAnimatedDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      const Help(),
                                  animationType:
                                      DialogTransitionType.slideFromBottomFade);
                            },
                            child: const Opacity(
                                opacity: 0.4,
                                child: HeroIcon(
                                  HeroIcons.questionMarkCircle,
                                  style: HeroIconStyle.solid,
                                  size: 25,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: messageController.newMessage
                          ? const EdgeInsets.only(top: 17, left: 7)
                          : const EdgeInsets.only(top: 20),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: messageController.newMessage
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "새로운 편지가 도착했어요",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(3),
                                            child: const Align(
                                              alignment: Alignment.topRight,
                                              child: HeroIcon(
                                                HeroIcons.envelope,
                                                color: Colors.white,
                                                style: HeroIconStyle.solid,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2, left: 20),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: const Color(
                                                        0xffFCE181)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : const Opacity(
                                    opacity: 0.4,
                                    child: HeroIcon(
                                      HeroIcons.envelope,
                                      color: Colors.white,
                                      style: HeroIconStyle.solid,
                                    ),
                                  ),
                            onTap: () {
                              showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => MailBox(
                                        controller: controller,
                                        userName: userName,
                                      ),
                                  animationType:
                                      DialogTransitionType.slideFromTopFade);
                              messageController.confirm();
                            },
                          )),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Onboarding(controller: controller)));
                    },
                    child: Text("온보딩")),
                Column(
                  children: [
                    AnimatedOpacity(
                      opacity: _isTextVisible ? 0.0 : 1.0,
                      // 변경할 불투명도를 설정하세요.
                      duration:
                          Duration(milliseconds: _isTextVisible ? 2000 : 300),
                      // 애니메이션 지속 시간 설정
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _isTextVisible
                                ? null
                                : () {
                                    showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      animationType: DialogTransitionType
                                          .slideFromBottomFade,
                                      builder: (BuildContext context) {
                                        return MultiProvider(
                                          providers: [
                                            ChangeNotifierProvider(
                                              create: (context) => GPTModel(),
                                            ),
                                            ChangeNotifierProvider(
                                              create: (context) =>
                                                  BackgroundController(),
                                            ),
                                          ],
                                          child: Diary(
                                            controller: controller,
                                            messageController:
                                                messageController,
                                            userInfo: userInfo,
                                          ),
                                        );
                                      },
                                    );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                child: Text(
                                  "일기 쓰기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 11,
                          ),
                          GestureDetector(
                            onTap: _isTextVisible
                                ? null
                                : () {
                                    showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      barrierColor: Colors.transparent,
                                      builder: (BuildContext context) => Letter(
                                        controller: controller,
                                        userName: userName,
                                      ),
                                      animationType: DialogTransitionType
                                          .slideFromBottomFade,
                                    );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                child: Text(
                                  "편지 쓰기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: AnimatedOpacity(
                        opacity: _isTextVisible ? 1.0 : 0.0,
                        // 변경할 불투명도를 설정하세요.
                        duration:
                            Duration(milliseconds: _isTextVisible ? 2000 : 300),
                        // 애니메이션 지속 시간 설정
                        child: Text(
                          "화면 탭하여 글쓰기",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
