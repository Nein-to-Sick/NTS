import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/home/mailBox.dart';
import 'package:nts/loading/loading_page.dart';
import 'package:nts/profile/notification.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    // 초기화
    FlutterLocalNotification.init();

    // 3초 후 권한 요청
    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final userName = userInfo.userNickName;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const HeroIcon(
                      HeroIcons.envelope,
                      color: Colors.white,
                      style: HeroIconStyle.solid,
                    ),
                    onTap: () {
                      showAnimatedDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => const MailBox(),
                          animationType: DialogTransitionType.slideFromTopFade);
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
                        )),
                    onTap: () {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: false,
                        animationType: DialogTransitionType.slideFromBottomFade,
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider.value(
                            value: BackgroundController(),
                            child: Diary(
                              controller: controller,
                            ),
                          );
                          ;
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
                        )),
                    onTap: () {
                      showAnimatedDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) =>
                              Letter(controller: controller),
                          animationType:
                              DialogTransitionType.slideFromBottomFade);
                    },
                  ),

                  //  test
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
                            "로딩 페이지 보기",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyFireFlyProgressbar(progress: 0.45),
                        ),
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
