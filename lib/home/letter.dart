import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../component/button.dart';
import '../model/preset.dart';

class Letter extends StatefulWidget {
  const Letter({Key? key}) : super(key: key);

  @override
  State<Letter> createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  int index = 1;
  TextEditingController textEditingController = TextEditingController();
  late List<List<bool>> isSelected2 = [];
  late List<List<bool>> isSelected3 = [];
  bool isSelfSelected = false;
  bool isSomeoneSelected = false;

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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "누구한테 쓸까요?",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Text(
                      "받는 이를 정해주세요",
                      style: TextStyle(fontSize: 16),
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
                                ? const Color(0xff5E5E5E)
                                : Colors.white, // 수정
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xff5E5E5E), width: 1.3)),
                        // 수정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeroIcon(
                              HeroIcons.user,
                              style: HeroIconStyle.solid,
                              color: isSelfSelected
                                  ? Colors.white
                                  : const Color(0xff393939), // 수정
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
                                      : const Color(0xff393939)),
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
                                ? const Color(0xff5E5E5E)
                                : Colors.white, // 수정
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xff5E5E5E), width: 1.3)),
                        // 수정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeroIcon(
                              HeroIcons.userGroup,
                              style: HeroIconStyle.solid,
                              color: isSomeoneSelected
                                  ? Colors.white
                                  : const Color(0xff393939), // 수정
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
                                      : const Color(0xff393939)),
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
                      : setState(() {
                          index = 2;
                        });
                },
                title: '다음',
              )
            ],
          ),
        ),
      ),
    );
    Widget second = Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          const Text(
            "어떤 상황에 있는 사람한테 쓸까요?",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "알맞은 상황/감정을 골라주세요.",
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
                                            ? const Color(0xff5E5E5E) // 수정
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Color(0xff5E5E5E)), // 수정
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
                                                  : Color(0xff393939)),
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
                                    color: const Color(0xffC6C6C6), // 수정
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "이전",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff016670),
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
            "어떤 감정을 가진 사람한테 쓸까요?",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "알맞은 상황/감정을 골라주세요.",
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
                                            ? const Color(0xff5E5E5E) // 수정
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Color(0xff5E5E5E)), // 수정
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
                                                  : Color(0xff393939)),
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
                                    color: const Color(0xffC6C6C6), // 수정
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "이전",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff016670),
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
                              setState(() {
                                index = 4;
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
    Widget fourth = Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 50),
      child: Column(
        children: [
          const Text(
            "편지 쓰기",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "응원/지지/격려하는 글을 써주세요.",
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
                      setState(() {
                        Navigator.pop(context);
                      });
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
                      : index == 3
                          ? third
                          : fourth,
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressBar(
                    maxSteps: 4,
                    progressType: LinearProgressBar.progressTypeDots,
                    currentStep: index - 1,
                    progressColor: const Color(0xff016670),
                    // 수정
                    backgroundColor: const Color(0xffDDDDDD),
                    // 수정
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
