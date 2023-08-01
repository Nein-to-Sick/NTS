import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/model/letterModel.dart';

import '../component/button.dart';

class MailBox extends StatefulWidget {
  const MailBox({Key? key}) : super(key: key);

  @override
  State<MailBox> createState() => _MailBoxState();
}

class _MailBoxState extends State<MailBox> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text("편지함"),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection("mailBox")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final List<LetterModel> letters = snapshot.data!.docs
                              .map((DocumentSnapshot doc) =>
                                  LetterModel.fromSnapshot(doc))
                              .toList();
                          return Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 30),
                              itemCount: letters.length,
                              itemBuilder: (BuildContext context, int index) {
                                final LetterModel letter = letters[index];
                                return Card(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Button(function: (){Navigator.pop(context);}, title: '닫기',)
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
