import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/letterModel.dart';

import '../component/button.dart';
import '../database/databaseService.dart';
import 'letter.dart';

class MailBox extends StatefulWidget {
  const MailBox({Key? key, required this.controller, required this.userName})
      : super(key: key);

  final controller;
  final userName;

  @override
  State<MailBox> createState() => _MailBoxState();
}

class _MailBoxState extends State<MailBox> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  late String time = "";
  late String from = "";
  late String content = "";
  late int idx = 1;
  late bool notMatch = false;
  late bool heart = false;
  late String id = "";
  late String fromUid = "";

  @override
  Widget build(BuildContext context) {
    Widget first = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("mailBox")
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<LetterModel> letters = snapshot.data!.docs
            .map((DocumentSnapshot doc) => LetterModel.fromSnapshot(doc))
            .toList();
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 30),
            itemCount: letters.length,
            itemBuilder: (BuildContext context, int index) {
              final LetterModel letter = letters[index];

              String year = letter.date.substring(0, 4);
              String month = letter.date.substring(5, 7); // 숫자로 변환해 0 제거
              String day = letter.date.substring(8, 10);
              String hour = letter.date.substring(11, 13);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    idx = 2;
                    time = "$year년 $month월 $day일 $hour시";
                    from = letter.from;
                    content = letter.content;
                    notMatch = letter.notMatch;
                    heart = letter.heart;
                    id = letter.id;
                    fromUid = letter.fromUid;
                  });
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$year년 $month월 $day일 $hour시",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: MyThemeColors.myGreyscale[200],
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "from.${letter.from}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Dodam",
                                    color: MyThemeColors.myGreyscale[200]),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            letter.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: MyThemeColors.myGreyscale[800],
                                fontFamily: "Dodam"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    Widget second = Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: [
                    Expanded(
                      child: Text(
                        content,
                        style: TextStyle(
                            fontSize: 16,
                            color: MyThemeColors.myGreyscale[800],
                            fontFamily: "Dodam"),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            !notMatch
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        heart = !heart;
                                      });
                                      DatabaseService().clickHeart(id, heart, fromUid);
                                    },
                                    child: heart
                                        ? const HeroIcon(
                                            HeroIcons.heart,
                                            style: HeroIconStyle.solid,
                                            color: MyThemeColors.secondaryColor,
                                          )
                                        : HeroIcon(
                                            HeroIcons.heart,
                                            style: HeroIconStyle.outline,
                                            color:
                                                MyThemeColors.myGreyscale[700],
                                          ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "from.$from",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Dodam",
                                  color: MyThemeColors.myGreyscale[200]),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: MyThemeColors.myGreyscale[200]),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
        notMatch
            ? Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => Letter(
                            controller: widget.controller,
                            userName: widget.userName,
                          ),
                          animationType:
                              DialogTransitionType.slideFromBottomFade,
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: MyThemeColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(13.0),
                          child: Text(
                            "편지 쓰러가기",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )),
                ],
              )
            : Container(),
        const SizedBox(
          height: 15,
        ),
        Button(
          function: () {
            setState(() {
              idx = 1;
            });
          },
          title: '이전',
        )
      ],
    );

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 25.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        idx == 1 ? "편지함" : "편지",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: MyThemeColors.myGreyscale[900]),
                      ),
                      idx == 1 ? first : Expanded(child: second),
                      idx != 2
                          ? Button(
                              function: () {
                                Navigator.pop(context);
                              },
                              title: '닫기',
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Opacity(
                  opacity: 0.2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: HeroIcon(
                          HeroIcons.xMark,
                          size: 23,
                        )),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
