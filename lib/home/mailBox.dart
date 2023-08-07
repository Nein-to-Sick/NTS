import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/letterModel.dart';

import '../component/button.dart';

class MailBox extends StatefulWidget {
  const MailBox({Key? key}) : super(key: key);

  @override
  State<MailBox> createState() => _MailBoxState();
}

class _MailBoxState extends State<MailBox> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  late String time = "";
  late String from = "";
  late String content = "";
  late int idx = 1;

  @override
  Widget build(BuildContext context) {
    Widget first = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("mailBox")
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
              return GestureDetector(
                onTap: () {
                  setState(() {
                    idx = 2;
                    time = letter.date;
                    from = letter.from;
                    content = letter.content;
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
                                letter.date,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: MyThemeColors.myGreyscale[700],
                                    fontFamily: "Dodam"),
                              ),
                              Text(
                                "from.${letter.from}",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Dodam",
                                    color: MyThemeColors.myGreyscale[100]),
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
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyThemeColors.myGreyscale[700],
                                  fontFamily: "Dodam"),
                            ),
                            Text(
                              "form.$from",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyThemeColors.myGreyscale[100],
                                  fontFamily: "Dodam"),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          content,
                          style: TextStyle(
                              fontSize: 16,
                              color: MyThemeColors.myGreyscale[800],
                              fontFamily: "Dodam"),
                        ),
                      ],
                    ),
                    Align(alignment: Alignment.bottomRight,child: HeroIcon(HeroIcons.heart, style: HeroIconStyle.outline, color: MyThemeColors.myGreyscale[700],))
                  ],
                ),
              ),
            ),
          ),
        ),
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
                        "편지함",
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
