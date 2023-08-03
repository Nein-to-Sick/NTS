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
                    time = letter.time;
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
                                letter.time,
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                "form.${letter.from}",
                                style: const TextStyle(fontSize: 13),
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
                            style: const TextStyle(fontSize: 16),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          "form.$from",
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: MyThemeColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.all(13.0),
                child: Text(
                  "감사하기",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            onTap: () {}),
        const SizedBox(
          height: 15,
        ),
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
                      const Text("편지함"),
                      idx == 1 ? first : Expanded(child: second),
                      Button(
                        function: () {
                          Navigator.pop(context);
                        },
                        title: '닫기',
                      )
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
