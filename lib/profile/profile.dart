import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/animatedSearchBar.dart';
import 'package:nts/component/filterButton.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/settings.dart';
import 'package:nts/provider/calendarController.dart';
import 'package:provider/provider.dart';
import '../model/preset.dart';
import 'calendar.dart';
import '../model/diaryModel.dart';
import '../provider/backgroundController.dart';
import '../provider/searchBarController.dart';
import 'keyword.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController textEditingController = TextEditingController();

  bool calendar = false;
  bool situation = false;
  bool emotion = false;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final searchController = Provider.of<SearchBarController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final userName = userInfo.userNickName;

    int folded = searchController.folded;

    final calendarController = Provider.of<CalendarController>(context);

    void signUserOut() {
      FirebaseAuth.instance.signOut();
      controller.movePage(0);
    }

    int flag = 0;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
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
                    Text(
                      "$userName님의 일기",
                      style: const TextStyle(
                          fontSize: 25, color: Colors.white, fontFamily: "Dodam"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Stack(
                      children: [
                        folded == 0
                            ? Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          calendarController.count == 2 ||
                                                  calendarController.count == 1
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      color: MyThemeColors
                                                          .primaryColor),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Wrap(
                                                          spacing:
                                                              3, // gap between adjacent chips
                                                          children: (calendarController
                                                                  .selected.keys
                                                                  .where((key) =>
                                                                      calendarController
                                                                              .selected[
                                                                          key]!)
                                                                  .toList()
                                                                ..sort((a, b) =>
                                                                    a.compareTo(
                                                                        b))) // 정렬 추가
                                                              .map<Widget>((date) {
                                                            setState(() {
                                                              flag++;
                                                            });
                                                            int year = int.parse(
                                                                date.substring(
                                                                    0, 4));
                                                            int month = int.parse(
                                                                date.substring(4,
                                                                    6)); // 숫자로 변환해 0 제거
                                                            int day = int.parse(
                                                                date.substring(6,
                                                                    8)); // 숫자로 변환해 0 제거

                                                            return Text(
                                                              calendarController.count == 1 ? '$year.$month.$day' :
                                                              flag == 1
                                                                  ? '$year.$month.$day ~'
                                                                  : '$year.$month.$day',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize: 13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                calendarController
                                                                    .setSelected(
                                                                        {});
                                                                calendarController
                                                                    .setCount(0);
                                                              });
                                                            },
                                                            child: HeroIcon(
                                                              HeroIcons.xCircle,
                                                              style: HeroIconStyle
                                                                  .mini,
                                                              color: MyThemeColors
                                                                  .myGreyscale[0]
                                                                  ?.withOpacity(
                                                                      0.5),
                                                              size: 18,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : FilterButton(
                                                  title: "날짜",
                                                  function: () {
                                                    setState(() {
                                                      calendar = !calendar;
                                                      situation = false;
                                                      emotion = false;
                                                    });
                                                  }, isExpanded: calendar,),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          FilterButton(
                                              title: "상황", function: () {
                                                setState(() {
                                                  situation = !situation;
                                                  calendar = false;
                                                  emotion = false;
                                                });
                                          }, isExpanded: situation,),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          FilterButton(
                                              title: "감정", function: () {
                                            setState(() {
                                              emotion = !emotion;
                                              calendar = false;
                                              situation = false;
                                            });
                                          }, isExpanded: emotion,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        AnimSearchBar(
                          style: TextStyle(color: Colors.white),
                          autoFocus: true,
                          textFieldIconColor: MyThemeColors.myGreyscale[300],
                          textFieldColor:
                              MyThemeColors.myGreyscale[700]?.withOpacity(0.5),
                          color: MyThemeColors.myGreyscale[700]?.withOpacity(0.5),
                          searchIconColor: MyThemeColors.myGreyscale[300],
                          rtl: true,
                          width: 400,
                          textController: textEditingController,
                          onSuffixTap: () {
                            setState(() {
                              textEditingController.clear();
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              textEditingController.text = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // AnimatedContainer(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: calendar ? MediaQuery.of(context).size.height * 0.4 : 0.0,
                    //   duration: Duration(milliseconds: 300),
                    //   curve: Curves.easeInOut,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: calendar ? Colors.white : Colors.transparent,
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Text(calendar ? "d" : ""),
                    //   ),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.505,
                      child: StreamBuilder(
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
                                        isLessThanOrEqualTo: calendarController
                                            .formatOneDayEndDate())
                                    .snapshots()
                                : FirebaseFirestore.instance
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

                          // Filter the diaries based on the entered text in the search bar
                          final String searchText = textEditingController.text.toLowerCase();
                          final List<Diary> filteredDiaries = diaries
                              .where(
                                  (diary) => diary.title.toLowerCase().contains(searchText))
                              .toList();
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                calendar
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Calendar(),
                                      )
                                    : Container(),
                                situation ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Keyword(title: Preset().situation,),
                                ) : Container(),
                                emotion ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Keyword(title: Preset().emotion,),
                                ) : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                    filteredDiaries.length,
                                    (index) {
                                    final Diary diary = filteredDiaries[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10.0),
                                          child: Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                        color: MyThemeColors
                                                            .myGreyscale[400]),
                                                  ),
                                                  const SizedBox(
                                                    height: 13,
                                                  ),
                                                  Text(
                                                    diary.title,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Dodam",
                                                        color: MyThemeColors
                                                            .myGreyscale[800]),
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
