import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:linear_progress_bar/ui/dots_indicator.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/profile/diary_filter.dart';
import 'package:nts/database/databaseService.dart';
import 'package:nts/model/diaryModel.dart';
import 'package:nts/model/search_model.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/profile_search_page.dart';
import 'package:nts/profile/settings.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/calendarController.dart';
import 'package:nts/provider/gpt_model.dart';
import 'package:nts/provider/messageController.dart';
import 'package:provider/provider.dart';
import 'package:nts/home/diary.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final searchModel = Provider.of<ProfileSearchModel>(context);
    final messageController = Provider.of<MessageController>(context);
    final calendarController = Provider.of<CalendarController>(context);

    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // temp
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('not');

                        searchModel.temptemp();
                      },
                      child: Text(searchModel.temp),
                    ),

                    //  temp logout button
                    IconButton(
                      onPressed: () {
                        userInfo.userNickNameClear();
                        FirebaseAuth.instance.signOut();
                        controller.movePage(0);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),

                    //  setting button
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
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),

                    //  title
                    Text(
                      "${userInfo.userNickName}님의 일기",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "Dodam"),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),

              //  search page or none page
              (userInfo.isDiaryExist)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: MyProfileSearchPage(
                        searchModel: searchModel,
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: MyThemeColors.myGreyscale[700]
                                ?.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '일기 보관함이 비어있습니다.',
                                style: TextStyle(
                                  color: MyThemeColors.myGreyscale[400],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.movePage(600);
                                  controller.changeColor(2);
                                  showAnimatedDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    animationType: DialogTransitionType
                                        .slideFromBottomFade,
                                    builder: (BuildContext context) {
                                      return MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider(
                                            create: (context) => GPTModel(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (context) =>
                                                BackgroundController(),
                                          ),
                                        ],
                                        child: Diary(
                                          controller: controller,
                                          messageController: messageController,
                                          userInfo: userInfo,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  '일기 쓰러가기',
                                  style: TextStyle(
                                    color: MyThemeColors.secondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

              /*
              //  diary list view
              Expanded(
                child: StreamBuilder(
                  //  searching condition
                  stream: calendarController.count == 2
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection("diary")
                          .orderBy("date", descending: true)
                          .where("date",
                              isGreaterThanOrEqualTo:
                                  calendarController.formatStartDate(),
                              isLessThanOrEqualTo:
                                  calendarController.formatEndDate())
                          .snapshots()
                      : calendarController.count == 1
                          ? FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection("diary")
                              .orderBy("date", descending: true)
                              .where("date",
                                  isGreaterThanOrEqualTo:
                                      calendarController.formatStartDate(),
                                  isLessThanOrEqualTo:
                                      calendarController.formatOneDayEndDate())
                              .snapshots()
                          :
                          //  without condition
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection("diary")
                              .orderBy("date", descending: true)
                              .snapshots(),
    
                  //  show list of diary
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final List<Diary> diaries = snapshot.data!.docs
                        .map((DocumentSnapshot doc) => Diary.fromSnapshot(doc))
                        .toList();
    
                    //  Filter the diaries based on the entered text in the search bar
                    final String searchText =
                        searchBarController.text.toLowerCase();
                    final List<Diary> filteredDiaries = diaries
                        .where((diary) =>
                            diary.title.toLowerCase().contains(searchText))
                        .toList();
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            filteredDiaries.length,
                            (index) {
                              final Diary diary = filteredDiaries[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          diary.date,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: MyThemeColors.myGreyscale[400],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          diary.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Dodam",
                                            color: MyThemeColors.myGreyscale[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              */

              //  consider bottom toggle button position
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
