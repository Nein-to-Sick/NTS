import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
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

class _MyProfileSearchPageState extends State<MyProfileSearchPage> {
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return //  search bar and filter
        Column(
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
      ],
    );
  }
}
