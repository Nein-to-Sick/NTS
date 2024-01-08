import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/controller/diary_controller.dart';
import 'package:nts/controller/search_controller.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/loading_pages/loading_page.dart';
import 'package:nts/view/profile_pages/diary_filter.dart';
import 'package:nts/view/profile_pages/read_edit_diary.dart';

class MyProfileSearchPage extends StatefulWidget {
  final ProfileSearchModel searchModel;
  const MyProfileSearchPage({
    super.key,
    required this.searchModel,
  });

  @override
  State<MyProfileSearchPage> createState() => _MyProfileSearchPageState();
}

class _MyProfileSearchPageState extends State<MyProfileSearchPage> {
  final searchBarController = TextEditingController();

  //  without provider future
  /*
  Future<QuerySnapshot> futureSearchResults = (FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("diary")
      .orderBy("date", descending: true)
      .get());
  */

  @override
  Widget build(BuildContext context) {
    //  search result without data
    displayNoSearchResult() {
      return const Center(
        child: Text(
          '검색 결과가 존재하지 않습니다.',
          style: TextStyle(
            color: MyThemeColors.whiteColor,
            fontSize: 16,
          ),
        ),
      );
    }

    //  search result with data
    displaySearchResult() {
      return FutureBuilder(
        future: widget.searchModel.futureSearchResults,
        //futureSearchResults,
        builder: (context, snapshot) {
          //  error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                '검색 중 오류 발생',
                style: TextStyle(
                  color: MyThemeColors.whiteColor,
                  fontSize: 16,
                ),
              ),
            );
          }
          //  on searching
          else if (snapshot.hasData == false ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: MyFireFlyProgressbar(
              loadingText: '검색 중...',
              textColor: MyThemeColors.whiteColor,
            ));
          }
          //  got result but empty
          else if (snapshot.data!.docs.isEmpty) {
            return displayNoSearchResult();
          }
          //  got result with data
          else {
            //  search with title
            final List<DiaryModel> diaries = snapshot.data!.docs
                .map((DocumentSnapshot doc) => DiaryModel.fromSnapshot(doc))
                .toList();
            //  Filter the diaries based on the entered text in the search bar
            final String searchText =
                searchBarController.text.trim().toLowerCase();

            bool getDateCompare(String diaryDateTime) {
              DateTime startDate, endDate;
              startDate = endDate = DateTime.now();
              if (widget.searchModel.timeResult[1].compareTo('null') != 0) {
                startDate = widget.searchModel.parseFormedTime(
                    widget.searchModel.timeResult[0], "00:00:00");
                endDate = widget.searchModel.parseFormedTime(
                    widget.searchModel.timeResult[1], "23:59:59");
              } else {
                startDate = widget.searchModel.parseFormedTime(
                    widget.searchModel.timeResult[0], "00:00:00");
                endDate = widget.searchModel.parseFormedTime(
                    widget.searchModel.timeResult[0], "23:59:59");
              }

              DateTime diaryDateTimeValue = widget.searchModel.parseFormedTime(
                  diaryDateTime, '${diaryDateTime.substring(11, 16)}:00');

              return (diaryDateTimeValue.isAfter(startDate) &&
                  diaryDateTimeValue.isBefore(endDate));
            }

            //  time, emotion, situation filter
            final List<DiaryModel> filteredDiaries = diaries
                .where((diary) =>
                    (diary.title.toLowerCase().contains(searchText) ||
                        diary.content.toLowerCase().contains(searchText)) &&
                    (widget.searchModel.emotionResult.isEmpty ||
                        widget.searchModel.emotionResult.every(
                            (emotion) => diary.emotion.contains(emotion))) &&
                    (widget.searchModel.situationResult.isEmpty ||
                        widget.searchModel.situationResult.every((situation) =>
                            diary.situation.contains(situation))) &&
                    (widget.searchModel.timeResult.isEmpty ||
                        getDateCompare(
                          diary.date,
                        )))
                .toList();

            return (filteredDiaries.isEmpty)
                ? displayNoSearchResult()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          filteredDiaries.length,
                          (index) {
                            final DiaryModel diary = filteredDiaries[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  //  read a diary
                                  showAnimatedDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.transparent,
                                    animationType: DialogTransitionType
                                        .slideFromBottomFade,
                                    builder: (BuildContext context) {
                                      return ReadDiaryDialog(
                                        diaryContent: diary,
                                        searchModel: widget.searchModel,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyThemeColors.whiteColor
                                        .withOpacity(0.9),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          convertDateFormat(diary.date),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color:
                                                MyThemeColors.myGreyscale[400],
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
                                            color:
                                                MyThemeColors.myGreyscale[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
          }
        },
      );
    }

    //  search bar and filter and list view
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //  search bar
            Flexible(
              flex: 85,
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: searchBarController,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  textInputAction: TextInputAction.go,
                  onChanged: (value) {
                    widget.searchModel.updateTitleValue(value.trim());
                  },
                  onSubmitted: (value) {
                    // 검색 실행
                    FocusScope.of(context).unfocus();
                  },
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  style: TextStyle(
                    color: MyThemeColors.myGreyscale[300],
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15, right: 15),
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
                    fillColor: MyThemeColors.myGreyscale[700]?.withOpacity(0.5),
                    filled: true,
                    hintText: '제목 / 내용으로 검색',
                    hintStyle: TextStyle(
                      color: MyThemeColors.myGreyscale[300],
                      fontSize: 14,
                    ),
                    suffixIcon: (widget.searchModel.diraySearchTitle.isNotEmpty)
                        ? IconButton(
                            onPressed: () {
                              if (widget
                                  .searchModel.diraySearchTitle.isNotEmpty) {
                                setState(() {
                                  searchBarController.clear();
                                });
                                widget.searchModel.updateTitleValue('');
                              }
                            },
                            icon: HeroIcon(
                              HeroIcons.xCircle,
                              style: HeroIconStyle.mini,
                              color: MyThemeColors.myGreyscale[600],
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 5,
            ),

            //  filter button
            Flexible(
              flex: 15,
              child: Container(
                height: 37,
                width: 37,
                decoration: BoxDecoration(
                  color: MyThemeColors.myGreyscale[700]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.transparent,
                          animationType:
                              DialogTransitionType.slideFromBottomFade,
                          builder: (BuildContext context) {
                            return SearchFilterDialog(
                              searchModel: widget.searchModel,
                            );
                          },
                        );
                      },
                      icon: HeroIcon(
                        HeroIcons.funnel,
                        style: HeroIconStyle.solid,
                        color: (widget.searchModel.isFiltered())
                            ? MyThemeColors.whiteColor
                            : MyThemeColors.myGreyscale[300],
                      ),
                    ),
                    //  필터 적용 여부 표시
                    (widget.searchModel.isFiltered())
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 9,
                              height: 9,
                              margin: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyThemeColors.secondaryColor,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),

        //  diary list view
        Expanded(child: displaySearchResult()),
      ],
    );
  }
}

String convertDateFormat(String originalFormat) {
  // 주어진 문자열을 '/', ' ', ':'를 기준으로 분리
  List<String> parts = originalFormat.split(RegExp(r'[\/\s:]'));

  // 분리된 부분을 필요한 형식에 맞게 조합
  String formattedDate =
      '${parts[0]}년 ${parts[1].padLeft(2, '0')}월 ${parts[2].padLeft(2, '0')}일 ${parts[3]}시';

  return formattedDate;
}
