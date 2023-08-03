import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/preset.dart';

import '../component/button.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  int index = 1;
  TextEditingController textEditingController = TextEditingController();
  late List<List<bool>> isSelected2 = [];
  late List<List<bool>> isSelected3 = [];

  @override
  void initState() {
    super.initState();
    isSelected2 = List.generate(Preset().situation.length,
        (i) => List.generate(Preset().situation[i].length, (j) => false));
    isSelected3 = List.generate(Preset().emotion.length,
        (i) => List.generate(Preset().emotion[i].length, (j) => false));
  }

  @override
  Widget build(BuildContext context) {
    Widget first = Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          const Text(
            "일기 쓰기",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "나의 상황과 감정에 대해 자세히 말해주세요.",
            style: TextStyle(fontSize: 16),
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
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 16),
                              hintMaxLines: 7,
                              hintText:
                                  "ex. 오늘은 뭔가 우울한 감정이 드는 날이었다. 이유를 딱히 알 수 없지만, 마음이 무겁고 슬프다. 머릿속에는 수많은 생각들이 맴돌고, 감정의 파도가 찾아와서 나를 휩쓸어가는 기분이다. 왜 이런 감정이 드는지 정말 이해가 안 된다."),
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
                      setState(() {
                        index = 2;
                      });
                    },
                    title: '다음',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    Widget second = Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          const Text(
            "어떤 상황인가요?",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "현재 상황과 관련된 키워드를 모두 골라주세요.",
            style: TextStyle(fontSize: 16),
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
                                        fontSize: 16), //수정
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  index = 1;
                                });
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          flex: 1,
                          child: Button(
                            function: () {
                              setState(() {
                                index = 3;
                              });
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
    Widget third = Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          const Text(
            "어떤 감정인가요?",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "현재 감정과 관련된 키워드를 모두 골라주세요.",
            style: TextStyle(fontSize: 16),
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
                                              fontSize: 16,
                                              color: isSelected3[index1][index2]
                                                  ? Colors.white
                                                  : MyThemeColors
                                                      .myGreyscale.shade900),
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
                                        fontSize: 16), //수정
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  index = 2;
                                });
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          flex: 1,
                          child: Button(
                            function: () {
                              Navigator.pop(context);
                            },
                            title: '저장 후 나가기',
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

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: [
              index == 1
                  ? first
                  : index == 2
                      ? second
                      : third,
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressBar(
                    maxSteps: 3,
                    progressType: LinearProgressBar.progressTypeDots,
                    currentStep: index - 1,
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
                  ),
                ),
              )
            ],
          )),
    );
  }
}
