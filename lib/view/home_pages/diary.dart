import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/controller/gpt_controller.dart';
import 'package:nts/controller/message_controller.dart';
import 'package:nts/controller/user_info_controller.dart';
import 'package:nts/model/database_model.dart';
import 'package:nts/model/preset_model.dart';
import 'package:nts/theme/custom_theme_data.dart';
import 'package:nts/view/component/confirm_dialog.dart';
import 'package:nts/view/loading_pages/loading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Theme/theme_colors.dart';
import '../component/button.dart';

bool react = true;
// 감정 키워드 갯수 세기
int count3 = 0;
List<String> emotionCart = [];
late List<List<bool>> isSelected3 = [];

class Diary extends StatefulWidget {
  final GPTModel gptModel;
  final BackgroundController controller;
  final MessageController messageController;
  final UserInfoValueModel userInfo;

  const Diary({
    super.key,
    required this.controller,
    required this.messageController,
    required this.userInfo,
    required this.gptModel,
  });

  @override
  DiaryState createState() => DiaryState();
}

class DiaryState extends State<Diary> {
  int index = 0;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController todayDiaryController = TextEditingController();
  bool isPageLoading = false;

  late List<List<bool>> isSelected2 = [];

  int count2 = 0;

  late PageController _pageController;
  String contents = "";
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isSelected2 = List.generate(Preset().situation.length,
        (i) => List.generate(Preset().situation[i].length, (j) => false));
    isSelected3 = List.generate(Preset().emotion.length,
        (i) => List.generate(Preset().emotion[i].length, (j) => false));
    _pageController = PageController(initialPage: 0);
    getTodayDiary();
  }

  void getTodayDiary() {
    DatabaseService().getTodayDiary().then((value) {
      setState(() {
        todayDiaryController.text = value;
      });
    });
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
              widget.gptModel.endAnalyzeDiary();
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
                        //  일기 쓰기 화면
                        return _buildPageFirst();
                      case 1:
                        return
                            //  AI analyzation result
                            FutureBuilder<bool>(
                          future: widget.gptModel.watiFetchDiaryData(),
                          builder: (context, snapshot) {
                            //  최초 분석의 경우
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                widget.gptModel.isAnalyzed == false) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                widget.gptModel.whileLoadingStart();
                              });

                              isPageLoading = true;

                              return const MyFireFlyProgressbar(
                                loadingText: '정리 중...',
                                textColor: MyThemeColors.blackColor,
                              );
                            }
                            //  Future 데이터 가져오기
                            else if (snapshot.data == false) {
                              isPageLoading = true;

                              return const MyFireFlyProgressbar(
                                loadingText: '정리 중...',
                                textColor: MyThemeColors.blackColor,
                              );
                            }
                            //  오류 발생 시
                            else if (snapshot.hasError) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                widget.gptModel.whileLoadingDone();
                              });
                              return BuildPageThird_1();
                            }
                            //  분석 완료
                            else {
                              if (widget.gptModel.isOnLoading) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  widget.gptModel.whileLoadingDone();

                                  isPageLoading = false;

                                  if (widget.gptModel.isAIUsing) {
                                    if (!widget.gptModel.situationSummerization
                                        .contains('error')) {
                                      //  ai analyze snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            '일기를 키워드로 정리했어요!',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 2000),
                                        ),
                                      );

                                      updateIsSelectedSituation();
                                      updateIsSelectedEmotion();
                                    } else {
                                      isPageLoading = false;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            '정리 중 오류가 발생했어요',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 2000),
                                        ),
                                      );
                                    }
                                  }
                                });
                              }

                              //  상황 분석
                              return BuildPageThird_1();
                            }
                          },
                        );

                      case 2:
                        //  감정 분석
                        return _buildPageTodayDiary();
                    }
                    return null;
                  },
                  onPageChanged: (ind) {
                    setState(() {
                      index = ind;
                    });
                  },
                ),
                (isPageLoading)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: LinearProgressBar(
                            dotsInactiveSize: 4,
                            dotsActiveSize: 4,
                            maxSteps: 3,
                            progressType: LinearProgressBar.progressTypeDots,
                            currentStep: index,
                            progressColor: MyThemeColors.primaryColor,
                            backgroundColor: MyThemeColors.myGreyscale.shade100,
                            dotsSpacing: const EdgeInsets.only(right: 8),
                          ),
                        ),
                      ),

                // 로딩 중에는 버튼 비활성화 - 에러
                (isPageLoading)
                    ? Container()
                    : GestureDetector(
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
                              ),
                            ),
                          ),
                        ),
                      ),
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
                  color: MyThemeColors.myGreyscale[400]),
            ),
            const SizedBox(
              height: 15,
            ),
            //  diary textfield
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
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 60),
                                  child: Padding(
                                    //  아래 padding으로 대체시 텍스트 필드만 밀림
                                    padding: const EdgeInsets.all(0),
                                    /*
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).viewInsets.bottom *
                                                0.4),
                                                */
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
                                          widget.gptModel
                                              .updateDiaryMainText(value);
                                          setState(() {
                                            contents = value;
                                          });
                                        },
                                        controller: textEditingController,
                                        style: const TextStyle(
                                            fontSize: 16, height: 1.6),
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Dodam",
                                                color: MyThemeColors
                                                    .myGreyscale[300],
                                                height: 1.6),
                                            hintMaxLines: 7,
                                            hintText:
                                                "ex. 오늘은 뭔가 우울한 감정이 드는 날이었다. 이유를 딱히 알 수 없지만, 마음이 무겁고 슬프다. 머릿속에는 수많은 생각들이 맴돌고, 감정의 파도가 찾아와서 나를 휩쓸어가는 기분이다. 왜 이런 감정이 드는지 정말 이해가 안 된다.\n\n\n\n\n\n\n\n\n"),
                                        maxLines: null,
                                        maxLength: widget.gptModel.isAIUsing
                                            ? 300
                                            : 2147483647,
                                        keyboardType: TextInputType.multiline,
                                      ),
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
                                              0.014),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "(날짜) ${DateFormat("yyyy년 MM월 dd일 HH시").format(DateTime.now())}",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: MyThemeColors
                                                          .myGreyscale[200])),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    widget.gptModel.isAIUsing
                                                        ? "${contents.length}/300"
                                                        : "무제한",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: MyThemeColors
                                                          .myGreyscale[200],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
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
                  widget.gptModel
                      .tryAnalyzeDiary(widget.gptModel.diaryMainText.trim());
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                title: '다음',
                condition: contents.isNotEmpty ? 'not null' : "null",
              ),
            )
          ],
        ));
  }

  _buildPageSecond() {
    double maxWidth = MediaQuery.of(context).size.width * 0.85;
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 24.0, top: 50, left: 24, right: 24),
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
            "상황 키워드를 모두 골라주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: MyThemeColors.myGreyscale[400],
            ),
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
                                    ),
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
                                            //fontSize: 12,
                                            color: isSelected2[index1][index2]
                                                ? Colors.white
                                                : MyThemeColors
                                                    .myGreyscale.shade600,
                                            fontWeight: FontWeight.w500,
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
                            color: MyThemeColors.myGreyscale.shade200, // 수정
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
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  BuildPageThird_1() {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 24.0, top: 50, left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "다음과 같은 감정이 파악돼요",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical, // 수직 스크롤
              itemCount: (emotionCart.length / 3).ceil(), // 리스트를 n개씩 묶어서 계산
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 30, // 각 줄의 높이
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal, // 수평 스크롤
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index2) {
                        int realIndex = index * 3 + index2;
                        if (realIndex >= emotionCart.length) {
                          return const SizedBox
                              .shrink(); // 만약 인덱스가 리스트 길이를 넘어가면 빈 SizedBox 반환
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 7.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: MyThemeColors.primaryColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Center(
                                child: Text(
                                  emotionCart[realIndex],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: MyThemeColors.primaryColor,
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
                );
              },
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: MyThemeColors.whiteColor,
                    builder: (BuildContext context) {
                      return const BuildPageThird();
                    },
                  );
                },
                child: Text(
                  "제가 느낀 감정이 아니에요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: MyThemeColors.myGreyscale[400]),
                ),
              ),
              const SizedBox(
                height: 20,
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
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: Button(
                      function: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        List<String> sit = [];
                        for (int i = 0; i < Preset().situation.length; i++) {
                          for (int j = 0;
                              j < Preset().situation[i].length;
                              j++) {
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

                        DateTime now = DateTime.now();
                        String time =
                            DateFormat('yyyy/MM/dd HH:mm').format(now);

                        //  diray firebase upload
                        DatabaseService().writeDiary(
                          widget.gptModel.diaryTitle,
                          textEditingController.text.trim(),
                          sit,
                          emo,
                          widget.messageController,
                          time,
                        );

                        widget.userInfo.userDiaryExist(true);
                        await prefs.setBool('diaryExist', true);

                        if (!mounted) return;
                        //Navigator.pop(context);
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );

                        widget.gptModel.endAnalyzeDiary();
                      },
                      title: '저장',
                      condition: count3 > 0 ? 'not null' : 'null',
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildPageTodayDiary() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24.0, top: 50),
        child: Column(
          children: [
            //  title
            Text(
              "오늘의 일기",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MyThemeColors.myGreyscale[900]),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "당신과 비슷한 하루에게 공감을 전달해주세요.",
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
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom *
                                          0.4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyThemeColors.myGreyscale.shade50,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 60),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: TextField(
                                          focusNode: _focusNode,
                                          controller: todayDiaryController,
                                          readOnly: true,
                                          style: const TextStyle(
                                              fontSize: 16, height: 1.6),
                                          decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Dodam",
                                                color: MyThemeColors
                                                    .myGreyscale[300],
                                                height: 1.6),
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          !react
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 11.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 26,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                react = true;
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.white,
                                                  content: const Text(
                                                    '내 일기가 저장되었습니다!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  //올라와있는 시간
                                                  action: SnackBarAction(
                                                    textColor: MyThemeColors
                                                        .primaryColor,
                                                    //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                                                    label: '보러가기',
                                                    //버튼이름
                                                    onPressed: () {
                                                      widget.controller
                                                          .movePage(855.0);
                                                      widget.controller
                                                          .changeColor(3);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const HeroIcon(
                                                  HeroIcons.gift,
                                                  style: HeroIconStyle.solid,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "응원해요",
                                                  style:
                                                      BandiFont.small2(context)
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                react = true;
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.white,
                                                  content: const Text(
                                                    '내 일기가 저장되었습니다!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  //올라와있는 시간
                                                  action: SnackBarAction(
                                                    textColor: MyThemeColors
                                                        .primaryColor,
                                                    //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                                                    label: '보러가기',
                                                    //버튼이름
                                                    onPressed: () {
                                                      widget.controller
                                                          .movePage(855.0);
                                                      widget.controller
                                                          .changeColor(3);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const HeroIcon(
                                                  HeroIcons.heart,
                                                  style: HeroIconStyle.solid,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "공감해요",
                                                  style:
                                                      BandiFont.small2(context)
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                react = true;
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.white,
                                                  content: const Text(
                                                    '내 일기가 저장되었습니다!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  //올라와있는 시간
                                                  action: SnackBarAction(
                                                    textColor: MyThemeColors
                                                        .primaryColor,
                                                    //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                                                    label: '보러가기',
                                                    //버튼이름
                                                    onPressed: () {
                                                      widget.controller
                                                          .movePage(855.0);
                                                      widget.controller
                                                          .changeColor(3);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  "./assets/emo_icons/together.png",
                                                  scale: 2,
                                                ),
                                                const SizedBox(
                                                  height: 1.5,
                                                ),
                                                Text(
                                                  "함께해요",
                                                  style:
                                                      BandiFont.small2(context)
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 26,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          react = !react;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 66,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black,
                        ),
                        child: react
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const HeroIcon(
                                    HeroIcons.heart,
                                    style: HeroIconStyle.solid,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text("반응하기",
                                      style: BandiFont.small2(context)
                                          ?.copyWith(color: Colors.white))
                                ],
                              )
                            : const HeroIcon(
                                HeroIcons.xMark,
                                style: HeroIconStyle.solid,
                                color: Colors.white,
                                size: 20,
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
                  setState(() {
                    react = true;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.white,
                      content: const Text(
                        '내 일기가 저장되었습니다!',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: const Duration(seconds: 5),
                      //올라와있는 시간
                      action: SnackBarAction(
                        textColor: MyThemeColors.primaryColor,
                        //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                        label: '보러가기',
                        //버튼이름
                        onPressed: () {
                          widget.controller.movePage(855.0);
                          widget.controller.changeColor(3);
                        },
                      ),
                    ),
                  );
                },
                title: '건너뛰기',
                condition: contents.isNotEmpty ? 'not null' : "null",
              ),
            )
          ],
        ));
  }

  void updateIsSelectedSituation() {
    for (var value in widget.gptModel.situationSummerization) {
      for (int i = 0; i < Preset().situation.length; i++) {
        if (Preset().situation[i].contains(value)) {
          int indexInInnerList = Preset().situation[i].indexOf(value);
          isSelected2[i][indexInInnerList] = true;
          count2++;
        }
      }
    }
  }

  void updateIsSelectedEmotion() {
    emotionCart.clear();
    for (var value in widget.gptModel.emotionSummerization) {
      for (int i = 0; i < Preset().emotion.length; i++) {
        if (Preset().emotion[i].contains(value)) {
          emotionCart.add(value);
          int indexInInnerList = Preset().emotion[i].indexOf(value);
          isSelected3[i][indexInInnerList] = true;
          count3++;
        }
      }
    }
  }
}

class BuildPageThird extends StatefulWidget {
  const BuildPageThird({super.key});

  @override
  State<BuildPageThird> createState() => _BuildPageThirdState();
}

class _BuildPageThirdState extends State<BuildPageThird> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 24.0, top: 40, left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "감정 수정하기",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyThemeColors.myGreyscale[900]),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  Preset().emotion.length,
                  (index1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Preset().largeCategories[index1],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: MyThemeColors.myGreyscale[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 30 *
                              ((Preset().emotion[index1].length / 2).ceil())
                                  .toDouble(),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                (Preset().emotion[index1].length / 3).ceil(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder:
                                        (BuildContext context, int index2) {
                                      int realIndex = index * 3 + index2;
                                      if (realIndex >=
                                          Preset().emotion[index1].length) {
                                        return const SizedBox.shrink();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (emotionCart.contains(Preset()
                                              .emotion[index1][realIndex])) {
                                            emotionCart.remove(Preset()
                                                .emotion[index1][realIndex]);
                                          } else {
                                            emotionCart.add(Preset()
                                                .emotion[index1][realIndex]);
                                          }
                                          setState(() {
                                            isSelected3[index1][realIndex] =
                                                !isSelected3[index1][realIndex];
                                            if (isSelected3[index1]
                                                [realIndex]) {
                                              count3++;
                                            } else {
                                              count3--;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 7.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: isSelected3[index1]
                                                        [realIndex]
                                                    ? MyThemeColors.primaryColor
                                                    : MyThemeColors
                                                        .myGreyscale.shade100,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    Preset().emotion[index1]
                                                        [realIndex],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: isSelected3[index1]
                                                              [realIndex]
                                                          ? MyThemeColors
                                                              .primaryColor
                                                          : MyThemeColors
                                                              .myGreyscale
                                                              .shade600,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Button(
                function: () async {
                  Navigator.pop(context);
                },
                title: '저장',
                condition: count3 > 0 ? 'not null' : 'null',
              ),
            ],
          )
        ],
      ),
    );
  }
}
