import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/component/animatedSearchBar.dart';
import 'package:nts/component/filterButton.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/settings.dart';
import 'package:provider/provider.dart';
import '../model/diaryModel.dart';
import '../provider/backgroundController.dart';
import '../provider/searchBarController.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {

    final controller = Provider.of<BackgroundController>(context);
    final searchController = Provider.of<SearchBarController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final userName = userInfo.userNickName;
    print(userName);

    bool folded = searchController.folded;

    void signUserOut() {
      FirebaseAuth.instance.signOut();
      controller.movePage(0);
    }

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: signUserOut,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return ProfileSettings(provider: controller);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(userName),
                    const Text(
                      "OO님의 일기",
                      style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: "Dodam"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !folded
                        ? Row(
                            children: [
                              FilterButton(title: "날짜", function: () {}),
                              const SizedBox(
                                width: 10,
                              ),
                              FilterButton(title: "감정", function: () {}),
                              const SizedBox(
                                width: 10,
                              ),
                              FilterButton(title: "상황", function: () {}),
                            ],
                          )
                        : Container(),
                    const AnimatedSearchBar()
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.505,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection("diary")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final List<Diary> diaries = snapshot.data!.docs
                          .map(
                              (DocumentSnapshot doc) => Diary.fromSnapshot(doc))
                          .toList();
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 13),
                        itemCount: diaries.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Diary diary = diaries[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(diary.date),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    Text(
                                      diary.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
