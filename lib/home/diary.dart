import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:nts/database/databaseService.dart';
import '../Theme/theme_colors.dart';
import '../component/button.dart';
import '../model/preset.dart';

class Diary extends StatefulWidget {
  const Diary({super.key, required this.controller});
  final controller;

  @override
  DiaryState createState() => DiaryState();
}

class DiaryState extends State<Diary> {
  int index = 0;
  TextEditingController textEditingController = TextEditingController();
  late List<List<bool>> isSelected2 = [];
  late List<List<bool>> isSelected3 = [];
  int count2 = 0;
  int count3 = 0;
  late PageController _pageController;
  String contents = "";

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
                  }
                  return null;
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
                    maxSteps: 3,
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
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildPageFirst() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30.0, top: 50),
        child: Column(
          children: [
            //  title
            Text(
              "일기 쓰기",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MyThemeColors.myGreyscale[900]),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "나의 상황과 감정에 대해 자세히 말해주세요.",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyThemeColors.myGreyscale[600]),
            ),
            const SizedBox(
              height: 15,
            ),
            //  diary textfield
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom * 0.4),
                child: Column(
                  children: [
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
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 13, 15, 13),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: TextField(
                                      controller: textEditingController,
                                      style: const TextStyle(fontSize: 16),
                                      onSubmitted: (value) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      onTapOutside: (p) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          contents = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Dodam",
                                              color: MyThemeColors
                                                  .myGreyscale[300]),
                                          hintMaxLines: 7,
                                          hintText:
                                              "ex. 오늘은 뭔가 우울한 감정이 드는 날이었다. 이유를 딱히 알 수 없지만, 마음이 무겁고 슬프다. 머릿속에는 수많은 생각들이 맴돌고, 감정의 파도가 찾아와서 나를 휩쓸어가는 기분이다. 왜 이런 감정이 드는지 정말 이해가 안 된다."),
                                      maxLines: null,
                                      cursorColor: MyThemeColors.primaryColor,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 13,
            ),

            //  next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Button(
                function: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                title: '다음',
                condition: contents.length > 0 ? 'not null' : "null",
              ),
            )
          ],
        ));
  }

  _buildPageSecond() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          Text(
            "어떤 상황인가요?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "현재 상황과 관련된 키워드를 모두 골라주세요.",
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
                                      if (isSelected2[index1][index2]) {
                                        count2++;
                                      } else {
                                        count2--;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected2[index1][index2]
                                            ? MyThemeColors
                                                .myGreyscale.shade700 // 수정
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
                                              fontSize: 16,
                                              color: isSelected2[index1][index2]
                                                  ? Colors.white
                                                  : MyThemeColors
                                                      .myGreyscale.shade900,
                                              fontWeight: FontWeight.w500),
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
                                    color: MyThemeColors
                                        .myGreyscale.shade200, // 수정
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
                            condition: count2 > 0 ? 'not null' : 'null',
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
            "어떤 감정인가요?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "현재 감정과 관련된 키워드를 모두 골라주세요.",
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
                                      if (isSelected3[index1][index2]) {
                                        count3++;
                                      } else {
                                        count3--;
                                      }
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
                                              fontSize: 16,
                                              color: isSelected3[index1][index2]
                                                  ? Colors.white
                                                  : MyThemeColors
                                                      .myGreyscale.shade900,
                                              fontWeight: FontWeight.w500),
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
                              List<String> sit = [];
                              for (int i = 0;
                                  i < Preset().situation.length;
                                  i++) {
                                for (int j = 0;
                                    j < Preset().situation[i].length;
                                    j++) {
                                  if (isSelected2[i][j] == true) {
                                    sit.add(Preset().situation[i][j]);
                                  }
                                }
                              }
                              List<String> emo = [];
                              for (int i = 0;
                                  i < Preset().emotion.length;
                                  i++) {
                                for (int j = 0;
                                    j < Preset().emotion[i].length;
                                    j++) {
                                  if (isSelected3[i][j] == true) {
                                    emo.add(Preset().emotion[i][j]);
                                  }
                                }
                              }

                              DatabaseService().writeDiary(
                                  "GPT", textEditingController.text, sit, emo);

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.white,
                                content: const Text(
                                  '내 일기가 저장되었습니다!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                duration: Duration(seconds: 5), //올라와있는 시간
                                action: SnackBarAction(
                                  textColor: MyThemeColors
                                      .primaryColor, //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                                  label: '보러가기', //버튼이름
                                  onPressed: () {
                                    widget.controller.movePage(855.0);
                                    widget.controller.changeColor(3);
                                  },
                                ),
                              ));
                            },
                            title: '저장 후 나가기',
                            condition: count3 > 0 ? 'not null' : 'null',
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
}
