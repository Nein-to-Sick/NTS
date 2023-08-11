import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/preset.dart';
import 'package:nts/model/search_model.dart';
import 'package:nts/profile/new_calendar.dart';
import 'package:provider/provider.dart';

class SearchFilterDialog extends StatefulWidget {
  final ProfileSearchModel searchModel;

  const SearchFilterDialog({
    super.key,
    required this.searchModel,
  });

  @override
  State<SearchFilterDialog> createState() => _SearchFilterDialogState();
}

class _SearchFilterDialogState extends State<SearchFilterDialog> {
  late List<List<bool>> isSelected2 = [];
  late List<List<bool>> isSelected3 = [];
  int countSituation = 0;
  int countEmotion = 0;
  int countDate = 0;

  @override
  void initState() {
    super.initState();
    isSelected2 = List.generate(Preset().situation.length,
        (i) => List.generate(Preset().situation[i].length, (j) => false));
    isSelected3 = List.generate(Preset().emotion.length,
        (i) => List.generate(Preset().emotion[i].length, (j) => false));
    updateIsSelectedSituation();
    updateIsSelectedEmotion();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: MyThemeColors.myGreyscale[25],
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
              child: Column(
                children: [
                  //  close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Opacity(
                          opacity: 0.2,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: HeroIcon(
                                HeroIcons.xMark,
                                size: 23,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //  date, situation, emotion selection
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  date
                        Text(
                          '날짜',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SUIT',
                            color: MyThemeColors.myGreyscale.shade900,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        //  calendar date picker
                        ChangeNotifierProvider.value(
                          value: widget.searchModel,
                          child: Consumer<ProfileSearchModel>(
                            builder: (context, model, child) => MyNewCalendar(
                              searchModel: model,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        ),

                        //  situation
                        Text(
                          '상황',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SUIT',
                            color: MyThemeColors.myGreyscale.shade900,
                          ),
                        ),

                        //  situation keyword selection
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: Preset().situation.length,
                                  itemBuilder:
                                      (BuildContext context, int index1) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: SizedBox(
                                        height: 30,
                                        child: Center(
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Preset()
                                                .situation[index1]
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isSelected2[index1]
                                                            [index2] =
                                                        !isSelected2[index1]
                                                            [index2];
                                                    if (isSelected2[index1]
                                                        [index2]) {
                                                      countSituation++;
                                                      widget.searchModel
                                                          .addSituation(Preset()
                                                                  .situation[
                                                              index1][index2]);
                                                    } else {
                                                      countSituation--;
                                                      widget.searchModel
                                                          .removeSituation(
                                                              Preset().situation[
                                                                      index1]
                                                                  [index2]);
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 9.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: isSelected2[index1]
                                                              [index2]
                                                          ? MyThemeColors
                                                              .myGreyscale
                                                              .shade700
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: MyThemeColors
                                                            .myGreyscale
                                                            .shade700,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      child: Text(
                                                        Preset().situation[
                                                            index1][index2],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: isSelected2[
                                                                      index1]
                                                                  [index2]
                                                              ? Colors.white
                                                              : MyThemeColors
                                                                  .myGreyscale
                                                                  .shade900,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
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
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        //  emotion
                        Text(
                          '감정',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SUIT',
                            color: MyThemeColors.myGreyscale.shade900,
                          ),
                        ),

                        //  emotion keyword selection
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: Preset().emotion.length,
                            itemBuilder: (BuildContext context, int index1) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: SizedBox(
                                  height: 30,
                                  child: Center(
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          Preset().emotion[index1].length,
                                      itemBuilder:
                                          (BuildContext context, int index2) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSelected3[index1][index2] =
                                                  !isSelected3[index1][index2];
                                              if (isSelected3[index1][index2]) {
                                                countEmotion++;
                                                widget.searchModel.addEmotion(
                                                    Preset().emotion[index1]
                                                        [index2]);
                                              } else {
                                                countEmotion--;
                                                widget.searchModel
                                                    .removeEmotion(
                                                        Preset().emotion[index1]
                                                            [index2]);
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 9.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isSelected3[index1]
                                                        [index2]
                                                    ? MyThemeColors
                                                        .myGreyscale.shade700
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: MyThemeColors
                                                      .myGreyscale.shade700,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                child: Text(
                                                  Preset().emotion[index1]
                                                      [index2],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: isSelected3[index1]
                                                            [index2]
                                                        ? Colors.white
                                                        : MyThemeColors
                                                            .myGreyscale
                                                            .shade900,
                                                    fontWeight: FontWeight.w500,
                                                  ),
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
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        //  clear and search button
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: MyThemeColors.myGreyscale.shade200,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: Text(
                                      "초기화",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: MyThemeColors.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (widget.searchModel.isFiltered()) {
                                    widget.searchModel.clearAllValue();
                                    setState(
                                      () {
                                        isSelected2 = List.generate(
                                            Preset().situation.length,
                                            (i) => List.generate(
                                                Preset().situation[i].length,
                                                (j) => false));
                                        isSelected3 = List.generate(
                                            Preset().emotion.length,
                                            (i) => List.generate(
                                                Preset().emotion[i].length,
                                                (j) => false));
                                        countSituation = 0;
                                        countEmotion = 0;
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: MyThemeColors.primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: Text(
                                      "검색하기",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: MyThemeColors.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateIsSelectedSituation() {
    for (var value in widget.searchModel.situationResult) {
      for (int i = 0; i < Preset().situation.length; i++) {
        if (Preset().situation[i].contains(value)) {
          int indexInInnerList = Preset().situation[i].indexOf(value);
          isSelected2[i][indexInInnerList] = true;
          countSituation++;
        }
      }
    }
  }

  void updateIsSelectedEmotion() {
    for (var value in widget.searchModel.emotionResult) {
      for (int i = 0; i < Preset().emotion.length; i++) {
        if (Preset().emotion[i].contains(value)) {
          int indexInInnerList = Preset().emotion[i].indexOf(value);
          isSelected3[i][indexInInnerList] = true;
          countEmotion++;
        }
      }
    }
  }
}
