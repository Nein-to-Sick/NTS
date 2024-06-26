import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/model/database_model.dart';
import 'package:nts/model/preset_model.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/component/confirm_dialog.dart';
import '../component/button.dart';

class Letter extends StatefulWidget {
  const Letter(
      {Key? key,
      required this.controller,
      required this.userName,
      this.situation = const [], // 수정
      this.emotion = const []}) // 수정
      : super(key: key);
  final BackgroundController controller;
  final String userName;
  final List<dynamic> situation; // 수정
  final List<dynamic> emotion; // 수정

  @override
  State<Letter> createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  int index = 0;
  TextEditingController textEditingController = TextEditingController();
  late List<List<bool>> isSelected2 = [];
  late List<List<bool>> isSelected3 = [];
  int count2 = 0;
  int count3 = 0;
  bool isSelfSelected = false;
  bool isSomeoneSelected = false;
  String contents = "";
  final FocusNode _focusNode = FocusNode();

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    isSelected2 = List.generate(
        Preset().situation.length,
        (i) => List.generate(Preset().situation[i].length, (j) {
              if (widget.situation.contains(Preset().situation[i][j])) {
                count2++;
                return true;
              } else {
                return false;
              }
            }));
    isSelected3 = List.generate(
        Preset().emotion.length,
        (i) => List.generate(Preset().emotion[i].length, (j) {
              if (widget.emotion.contains(Preset().emotion[i][j])) {
                count3++;
                return true;
              } else {
                return false;
              }
            }));
    _pageController = PageController(initialPage: 0);
    if (widget.situation.isNotEmpty) {}
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    onBackKeyCall() {
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        builder: (context) {
          return dialogWithYesOrNo(
            context,
            '정말로 나가시는 건가요?',
            '나갈시 기존에 쓰고 있었던 글은\n모두 삭제되고 복구가 불가능합니다.',
            '나가기',
            //  on Yes
            () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            //  on No
            () {
              Navigator.pop(context);
            },
          );
        },
      );
    }

    return WillPopScope(
      //뒤로가기 막음
      onWillPop: () {
        onBackKeyCall();
        return Future(() => false);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: MyThemeColors.myGreyscale[25],
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.75,
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
                    return null;
                  },
                  onPageChanged: (ind) {
                    setState(() {
                      index = ind;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressBar(
                      dotsInactiveSize: 4,
                      dotsActiveSize: 4,
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
                      onBackKeyCall();
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
      ),
    );
  }

  _buildPageFirst() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 50),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                      "받는 이를 정해주세요.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MyThemeColors.myGreyscale[400]),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                    ? Colors.black
                                    : Colors.white, // 수정
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelfSelected
                                      ? Colors.transparent
                                      : MyThemeColors.myGreyscale.shade100,
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
                                        : MyThemeColors.myGreyscale.shade600,
                                    size: 20,
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
                                            : MyThemeColors
                                                .myGreyscale.shade600,
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
                                    ? Colors.black
                                    : Colors.white, // 수정
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSomeoneSelected
                                      ? Colors.transparent
                                      : MyThemeColors.myGreyscale.shade100,
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
                                        : MyThemeColors.myGreyscale.shade600,
                                    size: 20,
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
                                          : MyThemeColors.myGreyscale.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isSelfSelected
                  ? Text(
                      "주의사항: 나에게 보내면 최소 한 달 뒤에 확인할 수 있습니다.",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: MyThemeColors.myGreyscale[400]),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
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
                condition: isSomeoneSelected == false && isSelfSelected == false
                    ? 'null'
                    : 'not null',
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildPageSecond() {
    double maxWidth = MediaQuery.of(context).size.width * 0.85;
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 24.0, top: 50, left: 24, right: 24),
      child: Column(
        children: [
          Text(
            isSelfSelected ? "어떤 상황의 나에게 쓸까요?" : "누구를 위한 편지인가요?",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "상황 키워드를 모두 골라주세요.",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MyThemeColors.myGreyscale[400]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: Preset().situation.length,
                itemBuilder: (BuildContext context, int index1) {
                  double itemExtentValue =
                      (maxWidth - 48) / Preset().situation[index1].length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: ListView.builder(
                          //shrinkWrap: true,
                          itemExtent: itemExtentValue,
                          scrollDirection: Axis.horizontal,
                          itemCount: Preset().situation[index1].length,
                          itemBuilder: (BuildContext context, int index2) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (Preset()
                                      .situation[index1][index2]
                                      .contains("상황 없음")) {
                                    for (int i = 0;
                                        i < Preset().situation.length;
                                        i++) {
                                      for (int j = 0;
                                          j < Preset().situation[i].length;
                                          j++) {
                                        if (i != index1 || j != index2) {
                                          isSelected2[i][j] = false;
                                        }
                                      }
                                    }
                                  } else {
                                    // 다른 키워드가 선택되면 '상황 없음'을 해제합니다.
                                    for (int i = 0;
                                        i < Preset().situation.length;
                                        i++) {
                                      for (int j = 0;
                                          j < Preset().situation[i].length;
                                          j++) {
                                        if (Preset()
                                            .situation[i][j]
                                            .contains("상황 없음")) {
                                          isSelected2[i][j] = false;
                                        }
                                      }
                                    }
                                  }
                                  isSelected2[index1][index2] =
                                      !isSelected2[index1][index2];
                                  count2 = 0;
                                  for (int i = 0;
                                      i < Preset().situation.length;
                                      i++) {
                                    for (int j = 0;
                                        j < Preset().situation[i].length;
                                        j++) {
                                      if (isSelected2[i][j] == true) {
                                        count2++;
                                      }
                                    }
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 7.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected2[index1][index2]
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected2[index1][index2]
                                          ? Colors.transparent
                                          : MyThemeColors.myGreyscale.shade100,
                                    ), // 수정
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          Preset().situation[index1][index2],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontSize: 16,
                                            color: isSelected2[index1][index2]
                                                ? Colors.white
                                                : MyThemeColors
                                                    .myGreyscale.shade600,
                                          ),
                                        ),
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
                    condition: count2 > 0 ? 'not null' : 'null',
                  )),
            ],
          )
        ],
      ),
    );
  }

  _buildPageThird() {
    double maxWidth = MediaQuery.of(context).size.width * 0.85;
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 24.0, top: 50, left: 24, right: 24),
      child: Column(
        children: [
          Text(
            isSelfSelected ? "어떤 감정의 나에게 쓸까요?" : "누구를 위한 편지인가요?",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "감정 키워드를 모두 골라주세요.",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MyThemeColors.myGreyscale[400]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: Preset().emotion.length,
                itemBuilder: (BuildContext context, int index1) {
                  double itemExtentValue =
                      (maxWidth - 48) / Preset().emotion[index1].length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: ListView.builder(
                          //shrinkWrap: true,
                          itemExtent: itemExtentValue,
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
                                padding: const EdgeInsets.only(right: 7.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected3[index1][index2]
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected3[index1][index2]
                                          ? Colors.transparent
                                          : MyThemeColors.myGreyscale.shade100,
                                    ), // 수정
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          Preset().emotion[index1][index2],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontSize: 16,
                                            color: isSelected3[index1][index2]
                                                ? Colors.white
                                                : MyThemeColors
                                                    .myGreyscale.shade600,
                                          ),
                                        ),
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
                    condition: count3 > 0 ? 'not null' : 'null',
                  )),
            ],
          )
        ],
      ),
    );
  }

  _buildPageFourth() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 50),
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
            "마음을 담을수록 전달될 가능성이 커져요",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MyThemeColors.myGreyscale[400]),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom * 0.4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyThemeColors.myGreyscale.shade50,
                        ),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(_focusNode);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 13, 15, 80),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: TextField(
                                    focusNode: _focusNode,
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
                                    controller: textEditingController,
                                    style: const TextStyle(
                                        fontSize: 16, height: 1.6),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color:
                                                MyThemeColors.myGreyscale[300],
                                            fontFamily: "Dodam",
                                            height: 1.6),
                                        hintMaxLines: 10,
                                        hintText:
                                            "ex. 이 세상에는 네가 믿지 못할만큼 많은 사람들이 너를 응원하고, 네 성공을 진심으로 바라고 있어요. 우리 함께 하면서 한 걸음 한 걸음 더 나아가요. 모든 시련과 어려움을 함께 극복할 수 있어요.\n\n네 곁에 있음에 감사하며, 네 꿈을 위해 늘 응원하겠습니다."),
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(7)),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        isSelfSelected
                                            ? Text(
                                                "(보내는 이) 나",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: MyThemeColors
                                                        .myGreyscale[200]),
                                              )
                                            : Text(
                                                "(보내는 이) 누군가",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: MyThemeColors
                                                        .myGreyscale[200]),
                                              ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "(상황) ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: MyThemeColors
                                                      .myGreyscale[200]),
                                            ),
                                            Text(
                                              Preset()
                                                  .situation
                                                  .asMap()
                                                  .entries
                                                  .expand((entry) => entry.value
                                                      .asMap()
                                                      .entries
                                                      .where((subEntry) =>
                                                          isSelected2[entry.key]
                                                              [subEntry.key]))
                                                  .map((subEntry) =>
                                                      subEntry.value)
                                                  .toList()
                                                  .join(', '),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: MyThemeColors
                                                          .myGreyscale[
                                                      200]), // 콤마로 키워드를 구분합니다.
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "(감정) ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: MyThemeColors
                                                      .myGreyscale[200]),
                                            ),
                                            Text(
                                              Preset()
                                                  .emotion
                                                  .asMap()
                                                  .entries
                                                  .expand((entry) => entry.value
                                                      .asMap()
                                                      .entries
                                                      .where((subEntry) =>
                                                          isSelected3[entry.key]
                                                              [subEntry.key]))
                                                  .map((subEntry) =>
                                                      subEntry.value)
                                                  .toList()
                                                  .join(', '),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: MyThemeColors
                                                          .myGreyscale[
                                                      200]), // 콤마로 키워드를 구분합니다.
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 13,
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
                            function: () async {
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

                              DateTime now = DateTime.now();
                              String time =
                                  DateFormat('yyyy/MM/dd HH:mm').format(now);

                              String? addedDocId;
                              if (isSelfSelected) {
                                addedDocId = await DatabaseService()
                                    .selfMessage(textEditingController.text,
                                        sit, emo, time, widget.userName);
                              } else {
                                addedDocId =
                                    await DatabaseService().someoneMessage(
                                  textEditingController.text,
                                  sit,
                                  emo,
                                  widget.userName,
                                  time,
                                );
                              }

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.white,
                                content: const Text(
                                  '내 편지를 보냈습니다!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                duration: const Duration(seconds: 5),
                                //올라와있는 시간
                                action: SnackBarAction(
                                    textColor: MyThemeColors.primaryColor,
                                    //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                                    label: '취소하기',
                                    //버튼이름
                                    onPressed: () {
                                      if (addedDocId != null) {
                                        if (isSelfSelected) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .collection('selfMailBox')
                                              .doc(addedDocId)
                                              .delete();
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('everyMail')
                                              .doc(addedDocId)
                                              .delete();
                                        }
                                      }
                                    }),
                              ));
                            },
                            title: '보내기',
                            condition:
                                contents.isNotEmpty ? 'not null' : 'null',
                          )),
                    ],
                  )
                  //  submmit button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
