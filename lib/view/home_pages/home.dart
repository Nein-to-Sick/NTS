import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:nts/controller/ai_chat_controller.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/controller/gpt_controller.dart';
import 'package:nts/controller/message_controller.dart';
import 'package:nts/controller/search_controller.dart';
import 'package:nts/controller/user_info_controller.dart';
import 'package:nts/view/ai_chat_pages/ai_chat.dart';
import 'package:nts/view/home_pages/mailBox.dart';
import 'package:nts/view/survey_pages/survey_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../component/help.dart';
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

  void _toggleTextVisibility() {
    if (mounted) {
      setState(() {
        _isTextVisible = false;
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _isTextVisible = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final messageController = Provider.of<MessageController>(context);
    final gptMdoel = Provider.of<GPTModel>(context);

    // print(userInfo.currentYellowValue);
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _isTextVisible ? 0.0 : 0.45, // 변경할 불투명도를 설정하세요.
            duration: Duration(
                milliseconds: !_isTextVisible ? 300 : 1000), // 애니메이션 지속 시간 설정
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
        SafeArea(
          child: GestureDetector(
            onTap: () {
              _toggleTextVisibility(); // Add this line
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity!.isNegative) {
                // 오른쪽에서 왼쪽으로 드래그
                controller.movePage(855);
                controller.changeColor(3);
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    messageController
                                        .setSpeaker(!messageController.speaker);
                                    if (messageController.speaker) {
                                      widget.player.play();
                                    } else {
                                      widget.player.pause();
                                    }
                                    await prefs.setBool('speakerSetting',
                                        messageController.speaker);
                                  },
                                  child: Opacity(
                                      opacity: 0.4,
                                      child: HeroIcon(
                                        messageController.speaker
                                            ? HeroIcons.speakerWave
                                            : HeroIcons.speakerXMark,
                                        style: HeroIconStyle.solid,
                                      ))),
                              const SizedBox(
                                width: 13,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      barrierColor: Colors.transparent,
                                      builder: (BuildContext context) =>
                                          const Help(),
                                      animationType: DialogTransitionType
                                          .slideFromBottomFade);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                            BorderRadius
                                                                .circular(20),
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
                                      barrierColor: Colors.transparent,
                                      builder: (BuildContext context) =>
                                          MailBox(
                                            controller: controller,
                                            userName: userInfo.userNickName,
                                          ),
                                      animationType: DialogTransitionType
                                          .slideFromTopFade);
                                  messageController.confirm();
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        HeroIcon(
                          HeroIcons.chevronDoubleLeft,
                          color: Colors.white.withOpacity(0.3),
                          style: HeroIconStyle.mini,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      AnimatedOpacity(
                        opacity: _isTextVisible ? 0.0 : 1.0,
                        // 변경할 불투명도를 설정하세요.
                        duration:
                            Duration(milliseconds: _isTextVisible ? 1000 : 300),
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
                                        barrierColor: Colors.transparent,
                                        animationType: DialogTransitionType
                                            .slideFromBottomFade,
                                        builder: (BuildContext context) {
                                          return ChangeNotifierProvider.value(
                                            value: gptMdoel,
                                            child: Consumer<GPTModel>(
                                              builder:
                                                  (context, model, child) =>
                                                      Diary(
                                                controller: controller,
                                                messageController:
                                                    messageController,
                                                userInfo: userInfo,
                                                gptModel: gptMdoel,
                                              ),
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
                                    "📖 일기 쓰기",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: _isTextVisible
                                  ? null
                                  : () {
                                      showAnimatedDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierColor: Colors.transparent,
                                        builder: (BuildContext context) =>
                                            Letter(
                                          controller: controller,
                                          userName: userInfo.userNickName,
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
                                    "💌 편지 쓰기",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: _isTextVisible
                                  ? null
                                  : () {
                                      // 과거의 나와 대화하기 창
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MultiProvider(providers: [
                                              ChangeNotifierProvider(
                                                create: (context) =>
                                                    AIChatController(),
                                              ),
                                              ChangeNotifierProvider(
                                                create:
                                                    (BuildContext context) =>
                                                        ProfileSearchModel(),
                                              ),
                                            ], child: const AIChatPage()),
                                          ));
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 9),
                                  child: Text(
                                    "🛠️ 과거의 나와 대화하기",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: _isTextVisible
                                  ? null
                                  : () {
                                      // 과거의 나와 대화하기 창
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SurveyPage(),
                                        ),
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
                                    "📝 만족도 기록",
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
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.102),
                        child: AnimatedOpacity(
                          opacity: _isTextVisible ? 1.0 : 0.0,
                          // 변경할 불투명도를 설정하세요.
                          duration: Duration(
                              milliseconds: _isTextVisible ? 1000 : 300),
                          // 애니메이션 지속 시간 설정
                          child: Text(
                            "화면을 탭하여 글쓰기",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
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
      ],
    );
  }
}
