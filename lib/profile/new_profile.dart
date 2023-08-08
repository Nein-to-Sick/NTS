import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/diary_filter.dart';
import 'package:nts/database/databaseService.dart';
import 'package:nts/model/diaryModel.dart';
import 'package:nts/model/search_model.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/settings.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/calendarController.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final calendarController = Provider.of<CalendarController>(context);
    final searchModel = Provider.of<ProfileSearchModel>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            //  setting button
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        fontSize: 25, color: Colors.white, fontFamily: "Dodam"),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //  search bar and filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //  search bar
                      Flexible(
                        flex: 85,
                        child: TextField(
                          controller: searchBarController,
                          keyboardType: TextInputType.multiline,
                          autocorrect: false,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          onTapOutside: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          style: TextStyle(
                            color: MyThemeColors.myGreyscale[300],
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: MyThemeColors.primaryColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: MyThemeColors.myGreyscale[700]
                                ?.withOpacity(0.5),
                            filled: true,
                            hintText: 'ex. 알바, 여행, 공부',
                            hintStyle: TextStyle(
                              color: MyThemeColors.myGreyscale[300],
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  // 검색 실행
                                },
                                icon: HeroIcon(
                                  HeroIcons.magnifyingGlass,
                                  style: HeroIconStyle.mini,
                                  color: MyThemeColors.myGreyscale[300],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      //  filter button
                      Flexible(
                        flex: 15,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: MyThemeColors.myGreyscale[700]
                                ?.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: false,
                                animationType:
                                    DialogTransitionType.slideFromBottomFade,
                                builder: (BuildContext context) {
                                  return SearchFilterDialog();
                                },
                              );
                            },
                            icon: HeroIcon(
                              HeroIcons.funnel,
                              style: HeroIconStyle.solid,
                              color: MyThemeColors.myGreyscale[300],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

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

            //  consider bottom toggle button position
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
