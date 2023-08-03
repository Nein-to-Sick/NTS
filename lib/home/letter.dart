import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:nts/Theme/theme_colors.dart';

import '../component/button.dart';
import '../database/databaseService.dart';
import '../model/preset.dart';

class Letter extends StatefulWidget {
  const Letter({Key? key}) : super(key: key);

  @override
  State<Letter> createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  int index = 0;
  TextEditingController textEditingController = TextEditingController();
  late List<List<bool>> isSelected2 = [];
  late List<List<bool>> isSelected3 = [];
  bool isSelfSelected = false;
  bool isSomeoneSelected = false;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    isSelected2 = List.generate(Preset().situation.length,
        (i) => List.generate(Preset().situation[i].length, (j) => false));
    isSelected3 = List.generate(Preset().emotion.length,
        (i) => List.generate(Preset().emotion[i].length, (j) => false));
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: <Widget>[
              PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemBuilder: (BuildContext context, int pageIndex) {
                  switch (pageIndex) {
                    case 0:
                      return _buildPageFirst();
                    case 1:
                      return _buildPageSecond();
                    case 2:
                      return _buildPageThird();
                    case 3:
                      return _buildPageFourth();
                  }
                },
                onPageChanged: (ind) {
                  setState(() {
                    index = ind;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressBar(
                    maxSteps: 4,
                    progressType: LinearProgressBar.progressTypeDots,
                    currentStep: index,
                    progressColor: MyThemeColors.primaryColor,
                    backgroundColor: MyThemeColors.myGreyscale.shade100,
                    dotsSpacing: const EdgeInsets.only(right: 8),
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
                      )))
            ],
          ),
        ),
      ),
    );
  }

  _buildPageFirst() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "누구한테 쓸까요?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: MyThemeColors.myGreyscale[900]),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "받는 이를 정해주세요",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: MyThemeColors.myGreyscale[600]),
                    ),
                    const SizedBox(height: 85),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelfSelected = !isSelfSelected;
                          isSomeoneSelected = false;
                        });
                      },
                      child: Container(
                        width: 84,
                        height: 85,
                        decoration: BoxDecoration(
                          color: isSelfSelected
                              ? MyThemeColors.myGreyscale.shade700
                              : Colors.white, // 수정
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: MyThemeColors.myGreyscale.shade700,
                            width: 1.3,
                          ),
                        ),
                        // 수정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeroIcon(
                              HeroIcons.user,
                              style: HeroIconStyle.solid,
                              color: isSelfSelected
                                  ? Colors.white
                                  : MyThemeColors.myGreyscale.shade900,
                              size: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "나",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isSelfSelected
                                      ? Colors.white
                                      : MyThemeColors.myGreyscale.shade900,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelfSelected = false;
                          isSomeoneSelected = !isSomeoneSelected;
                        });
                      },
                      child: Container(
                        width: 84,
                        height: 85,
                        decoration: BoxDecoration(
                          color: isSomeoneSelected
                              ? MyThemeColors.myGreyscale.shade700
                              : Colors.white, // 수정
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: MyThemeColors.myGreyscale.shade700,
                            width: 1.3,
                          ),
                        ),
                        // 수정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeroIcon(
                              HeroIcons.userGroup,
                              style: HeroIconStyle.solid,
                              color: isSomeoneSelected
                                  ? Colors.white
                                  : MyThemeColors.myGreyscale.shade900,
                              size: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "누군가",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isSomeoneSelected
                                      ? Colors.white
                                      : MyThemeColors.myGreyscale.shade900,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Button(
                function: () {
                  isSomeoneSelected == false && isSelfSelected == false
                      ? null
                      : _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                },
                title: '다음',
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildPageSecond() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          Text(
            "어떤 상황에 있는 사람한테 쓸까요?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "알맞은 상황/감정을 골라주세요.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: MyThemeColors.myGreyscale[600]),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: Preset().situation.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            height: 30,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: Preset().situation[index1].length,
                              itemBuilder: (BuildContext context, int index2) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSelected2[index1][index2] =
                                          !isSelected2[index1][index2];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected2[index1][index2]
                                            ? MyThemeColors.myGreyscale.shade700
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: MyThemeColors
                                              .myGreyscale.shade700,
                                        ), // 수정
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 5, 12, 5),
                                        child: Text(
                                          Preset().situation[index1][index2],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: isSelected2[index1][index2]
                                                ? Colors.white
                                                : MyThemeColors
                                                    .myGreyscale.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: MyThemeColors.myGreyscale.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "이전",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: MyThemeColors.primaryColor,
                                        fontSize: 16), //수정
                                  ),
                                ),
                              ),
                              onTap: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          flex: 1,
                          child: Button(
                            function: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            title: '다음',
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildPageThird() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          Text(
            "어떤 감정을 가진 사람한테 쓸까요?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "알맞은 상황/감정을 골라주세요.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: MyThemeColors.myGreyscale[600]),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: Preset().emotion.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            height: 30,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: Preset().emotion[index1].length,
                              itemBuilder: (BuildContext context, int index2) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSelected3[index1][index2] =
                                          !isSelected3[index1][index2];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected3[index1][index2]
                                            ? MyThemeColors.myGreyscale.shade700
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: MyThemeColors
                                              .myGreyscale.shade700,
                                        ), // 수정
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 5, 12, 5),
                                        child: Text(
                                          Preset().emotion[index1][index2],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: isSelected3[index1][index2]
                                                ? Colors.white
                                                : MyThemeColors
                                                    .myGreyscale.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: MyThemeColors.myGreyscale.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "이전",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: MyThemeColors.primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700), //수정
                                  ),
                                ),
                              ),
                              onTap: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          flex: 1,
                          child: Button(
                            function: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            title: '다음',
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildPageFourth() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          Text(
            "편지 쓰기",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "응원/지지/격려하는 글을 써주세요.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: MyThemeColors.myGreyscale[600]),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                        child: TextField(
                          controller: textEditingController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: MyThemeColors.myGreyscale[300],
                                  fontFamily: "Dodam"),
                              hintMaxLines: 10,
                              hintText:
                                  "ex. 이 세상에는 네가 믿지 못할만큼 많은 사람들이 너를 응원하고, 네 성공을 진심으로 바라고 있어요. 우리 함께 하면서 한 걸음 한 걸음 더 나아가요. 모든 시련과 어려움을 함께 극복할 수 있어요.\n\n네가 성공할 때의 기쁨과 행복을 함께 나누고 싶어요. 네 곁에 있음에 감사하며, 네 꿈을 위해 늘 응원하겠습니다."),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Button(
                    function: () {
                      List<String> sit = [];
                      for (int i = 0; i < Preset().situation.length; i++) {
                        for (int j = 0; j < Preset().situation[i].length; j++) {
                          if (isSelected2[i][j] == true) {
                            sit.add(Preset().situation[i][j]);
                          }
                        }
                      }
                      List<String> emo = [];
                      for (int i = 0; i < Preset().emotion.length; i++) {
                        for (int j = 0; j < Preset().emotion[i].length; j++) {
                          if (isSelected3[i][j] == true) {
                            emo.add(Preset().emotion[i][j]);
                          }
                        }
                      }

                      if (isSelfSelected) {
                        DatabaseService().selfMessage(textEditingController.text, sit, emo);
                      } else {
                        DatabaseService().someoneMessage(textEditingController.text, sit, emo);

                      }

                      Navigator.pop(context);
                    },
                    title: '보낸 후 나가기',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
