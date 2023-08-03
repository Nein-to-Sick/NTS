import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/component/nickName_Sheet.dart';
import 'package:nts/home/mailBox.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/while_loading_page.dart';
import 'package:provider/provider.dart';

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
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                child: const HeroIcon(
                  HeroIcons.envelope,
                  color: Colors.white,
                  style: HeroIconStyle.solid,
                  size: 30,
                ),
                onTap: () {
                  showAnimatedDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => const MailBox(),
                      animationType: DialogTransitionType.slideFromTopFade);
                },
              )),
          const SizedBox(
            height: 130,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Column(
              children: [
                const Text(
                  "안녕하세요 OO님,",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                const Text("오늘 하루 어떠셨나요?",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
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
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                  onTap: () {
                    showAnimatedDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => const Diary(),
                        animationType:
                            DialogTransitionType.slideFromBottomFade);
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
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                  onTap: () {
                    showAnimatedDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => const Letter(),
                        animationType:
                            DialogTransitionType.slideFromBottomFade);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
