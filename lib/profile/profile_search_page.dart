import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/database/databaseService.dart';
import 'package:nts/loading/loading_page.dart';
import 'package:nts/model/diaryModel.dart';
import 'package:nts/model/search_model.dart';
import 'package:nts/profile/diary_filter.dart';

class MyProfileSearchPage extends StatefulWidget {
  final ProfileSearchModel searchModel;
  const MyProfileSearchPage({
    super.key,
    required this.searchModel,
  });

  @override
  State<MyProfileSearchPage> createState() => _MyProfileSearchPageState();
}

//  diary firestore path
final diaryPath = FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection("diary");

class _MyProfileSearchPageState extends State<MyProfileSearchPage> {
  final searchBarController = TextEditingController();
  //  whether the query state changed
  bool isBasicQuery = true;

  //  basic query state
  Future<QuerySnapshot> futureSearchResults =
      (diaryPath.orderBy("date", descending: true).get());

  //  new filter
  changeSearchFilter() {
    Future<QuerySnapshot> newSearchResults =
        (diaryPath.orderBy("date", descending: true).get());
    setState(() {
      futureSearchResults = newSearchResults;
      isBasicQuery = false;
      print('new search!');
    });
  }

  //  reset filter
  resetSearchFilter() {
    Future<QuerySnapshot> newSearchResults =
        (diaryPath.orderBy("date", descending: true).get());
    if (!isBasicQuery) {
      setState(() {
        futureSearchResults = newSearchResults;
        print('reset search!');
      });
    }
  }

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
        future: futureSearchResults,
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
                child: MyFireFlyProgressbar(loadingText: '검색 중...'));
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
            final String searchText = searchBarController.text.toLowerCase();
            final List<DiaryModel> filteredDiaries = diaries
                .where(
                    (diary) => diary.title.toLowerCase().contains(searchText))
                .toList();
            return (filteredDiaries.isEmpty)
                ? displayNoSearchResult()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        filteredDiaries.length,
                        (index) {
                          final DiaryModel diary = filteredDiaries[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    MyThemeColors.whiteColor.withOpacity(0.9),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
              child: TextField(
                controller: searchBarController,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                textInputAction: TextInputAction.go,
                onChanged: (value) {
                  widget.searchModel.updateTitleValue(value.trim());
                },
                onSubmitted: (value) {
                  //  검색 실행 함수
                  changeSearchFilter();
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
                  fillColor: MyThemeColors.myGreyscale[700]?.withOpacity(0.5),
                  filled: true,
                  hintText: '제목으로 검색',
                  hintStyle: TextStyle(
                    color: MyThemeColors.myGreyscale[300],
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        // 검색 실행 함수
                        changeSearchFilter();
                      },
                      icon: HeroIcon(
                        HeroIcons.magnifyingGlass,
                        style: HeroIconStyle.mini,
                        color: (widget.searchModel.dirayTitle.isNotEmpty)
                            ? MyThemeColors.whiteColor
                            : MyThemeColors.myGreyscale[300],
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
                          animationType:
                              DialogTransitionType.slideFromBottomFade,
                          builder: (BuildContext context) {
                            return SearchFilterDialog(
                              searchModel: widget.searchModel,
                              newSearchFunction: changeSearchFilter,
                              resetSearchFunction: resetSearchFilter,
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
                        ? Positioned(
                            top: 7,
                            left: 27,
                            child: Container(
                              width: 10,
                              height: 10,
                              padding: const EdgeInsets.all(5),
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
          height: 20,
        ),

        //  diary list view
        Expanded(child: displaySearchResult()),
      ],
    );
  }
}
