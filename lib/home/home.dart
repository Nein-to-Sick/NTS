import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nts/home/mailBox.dart';
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

  void _toggleTextVisibility() {
    if (mounted) {
      setState(() {
        _isTextVisible = false;
      });
      Future.delayed(const Duration(seconds: 3), () {
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
    final userName = userInfo.userNickName;
    final messageController = Provider.of<MessageController>(context);
    final gptMdoel = Provider.of<GPTModel>(context);
    final speaker = messageController.speaker;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                messageController.speakerToggle();
                                if(speaker) {
                                  widget.player.pause();
                                } else {
                                  widget.player.play();
                                }
                              },
                              child: Opacity(
                                  opacity: 0.4,
                                  child: HeroIcon(
                                    speaker
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
                                  barrierColor: Colors.transparent,
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
                                      barrierColor: Colors.transparent,
                                      animationType: DialogTransitionType
                                          .slideFromBottomFade,
                                      builder: (BuildContext context) {
                                        return ChangeNotifierProvider.value(
                                          value: gptMdoel,
                                          child: Consumer<GPTModel>(
                                            builder: (context, model, child) =>
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
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08),
                      child: AnimatedOpacity(
                        opacity: _isTextVisible ? 1.0 : 0.0,
                        // 변경할 불투명도를 설정하세요.
                        duration:
                            Duration(milliseconds: _isTextVisible ? 2000 : 300),
                        // 애니메이션 지속 시간 설정
                        child: Text(
                          "화면을 탭하여 글쓰기",
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
