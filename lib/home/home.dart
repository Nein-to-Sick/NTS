import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/home/mailBox.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/messageController.dart';
import 'package:nts/provider/gpt_model.dart';
import 'package:provider/provider.dart';
import '../component/notification.dart';
import '../model/user_info_model.dart';
import 'diary.dart';
import 'letter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final userName = userInfo.userNickName;
    final messageController = Provider.of<MessageController>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
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
                                    padding:
                                        const EdgeInsets.only(top: 2, left: 20),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: const Color(0xffFCE181)),
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
                          animationType: DialogTransitionType.slideFromTopFade);
                      messageController.confirm();
                    },
                  )),
            ),
            const SizedBox(
              height: 130,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Column(
                children: [
                  Text(
                    "안녕하세요 $userName님,",
                    style: const TextStyle(
                        fontSize: 25, color: Colors.white, fontFamily: "Dodam"),
                  ),
                  const Text("오늘 하루 어떠셨나요?",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "Dodam")),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "일기 쓰기",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    onTap: () {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: false,
                        animationType: DialogTransitionType.slideFromBottomFade,
                        builder: (BuildContext context) {
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (context) => GPTModel(),
                              ),
                              ChangeNotifierProvider(
                                create: (context) => BackgroundController(),
                              ),
                            ],
                            child: Diary(
                              controller: controller,
                              messageController: messageController,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "편지 쓰기",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    onTap: () {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => Letter(
                          controller: controller,
                          userName: userName,
                        ),
                        animationType: DialogTransitionType.slideFromBottomFade,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
