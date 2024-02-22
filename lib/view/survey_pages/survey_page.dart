import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/theme/custom_theme_data.dart';
import 'package:nts/view/Theme/theme_colors.dart';

import '../component/button.dart';
import '../component/suggestions_button.dart';

double emotionValue = 1.0; // 초기값 설정
List<double> emotionList = [];
int index = 0;

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int selectedIcon = 0;
  List<String> sliderList = ["전혀\n그렇지 않다.", "매우\n그렇다"];
  List<String> contentList = [
    '나는 내 삶의 개인적 측면에 대해서 만족한다.\n* 개인적 측면: 개인적 성취, 성격, 건강 등',
    '나는 내 삶의 관계적 측면에 대해서 만족한다.\n* 관계적 측면: 주위 사람들과의 관계 등',
    '나는 내가 속한 집단에 대해서 만족한다.\n* 직단적 측면: 직장, 지역사회 등',
    '앱 사용 후 즐거움을 느꼈다.',
    '앱 사용 후 편안함을 느꼈다.',
    '앱 사용 후 부정적 감정을 느꼈다.',
    '앱 사용 후 행복함을 느꼈다.',
    '앱 사용 후 짜증남을 느꼈다.',
    '앱 사용 후 무기력함을 느꼈다.',
    '앱 사용 후 무기력함을 느꼈다.'
  ];
  final opinionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '만족도 기록',
            style: BandiFont.headline3(context)?.copyWith(
              color: BandiColor.primaryColor(context),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '• 감정 변화 기록',
                    style: BandiFont.headline2(context)?.copyWith(
                      color: BandiColor.primaryColor(context),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '다음 질문에 답해주세요.',
                    style: BandiFont.small(context)?.copyWith(
                      color: BandiColor.primaryColor(context),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    contentList[index],
                    style: BandiFont.headline3(context)?.copyWith(
                      color: BandiColor.primaryColor(context),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Slider(
                  value: emotionValue,
                  min: 1,
                  max: 7,
                  divisions: 6,
                  // 슬라이더를 1부터 10까지 총 10등분으로 나눔
                  activeColor: MyThemeColors.primaryColor,
                  onChanged: (newValue) {
                    setState(() {
                      emotionValue = newValue;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sliderList[0],
                      style: BandiFont.headline3(context)?.copyWith(
                        color: BandiColor.primaryColor(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      sliderList[1],
                      style: BandiFont.headline3(context)?.copyWith(
                        color: BandiColor.primaryColor(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                RichText(
                  text: TextSpan(
                    text: '설정 값: ',
                    style: BandiFont.headline3(context)?.copyWith(
                      color: BandiColor.primaryColor(context),
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${emotionValue.toInt() == 1 ? "전혀 그렇지 않다" : emotionValue.toInt() == 7 ? "매우 그렇다" : emotionValue.toInt()}',
                        style: BandiFont.headline1(context)?.copyWith(
                          color: BandiColor.primaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 100,
                    child: Button(
                      title: index >= 8 ? "완료" :"다음",
                      condition: index == 9 ? "null" : "not null",
                      function: () {
                        emotionList.add(emotionValue);
                        setState(() {
                          index++;
                        });
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '• 종합 의견',
                    style: BandiFont.headline2(context)?.copyWith(
                      color: BandiColor.primaryColor(context),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //  emoji radio buttons
                const IconRadioButtonsGroup(),
                const SizedBox(
                  height: 20,
                ),

                // 의견 작성 필드
                opinionTextfiled(context, opinionController),

                const SizedBox(
                  height: 40,
                ),

                // 제출 버튼
                submitButton(context, opinionController),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}

Widget opinionTextfiled(
    BuildContext context, TextEditingController opinionController) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      border: Border.all(
        color: MyThemeColors.myGreyscale.shade100,
        width: 1,
      ),
    ),
    child: Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: TextField(
              autocorrect: false,
              controller: opinionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintMaxLines: 5,
                hintText: "궁금하거나 불편하거나 제안하고 싶은 점이 있다면 작성해주세요. 감사합니다!",
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  // color: AppColors.haruGreyscale.shade300,
                  color: Color(0xffB0B0B0),
                  fontFamily: "SUIT",
                ),
              ),

              //  enter(엔터) 키 이벤트 처리 with onSubmitted
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
              onTapOutside: (p) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget submitButton(
    BuildContext context, TextEditingController opinionController) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 60,
    child: ElevatedButton(
      onPressed: (opinionController.text.trim().isNotEmpty && index ==9)
          ? () async {
              await threeButtonDataupdate(
                      context, opinionController.text.trim())
                  .then((value) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('소중한 의견 감사드립니다!'),
                    dismissDirection: DismissDirection.vertical,
                  ),
                );
              });
            }
          : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: (opinionController.text.trim().isNotEmpty)
            ? MyThemeColors.whiteColor
            : MyThemeColors.myGreyscale.shade900,
        backgroundColor: (opinionController.text.trim().isNotEmpty)
            ? MyThemeColors.primaryColor
            : MyThemeColors.myGreyscale.shade100,
        surfaceTintColor: MyThemeColors.myGreyscale.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        '제출하기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class IconRadioButtonsGroup extends StatefulWidget {
  const IconRadioButtonsGroup({super.key});

  @override
  State<IconRadioButtonsGroup> createState() => _IconRadioButtonsGroupState();
}

class _IconRadioButtonsGroupState extends State<IconRadioButtonsGroup> {
  void _onIconSelected(int index) {
    setState(() {
      selectedIcon = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: [
              RadioIconButtonDesign(
                icon: HeroIcons.handThumbUp,
                isSelected: selectedIcon == 0,
                onPressed: () => _onIconSelected(0),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text('좋아요'),
            ],
          ),
          Column(
            children: [
              RadioIconButtonDesign(
                icon: HeroIcons.handThumbDown,
                isSelected: selectedIcon == 1,
                onPressed: () => _onIconSelected(1),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text('아쉬워요'),
            ],
          ),
          Column(
            children: [
              RadioIconButtonDesign(
                icon: HeroIcons.handRaised,
                isSelected: selectedIcon == 2,
                onPressed: () => _onIconSelected(2),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text('의견이 있어요'),
            ],
          ),
        ],
      ),
    );
  }
}

class RadioIconButtonDesign extends StatelessWidget {
  final HeroIcons icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const RadioIconButtonDesign({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? MyThemeColors.myGreyscale.shade900
              : MyThemeColors.myGreyscale[50],
        ),
        child: HeroIcon(
          icon,
          style: HeroIconStyle.solid,
          // color: AppColors.whiteColor,

          color: isSelected
              ? MyThemeColors.whiteColor
              : MyThemeColors.myGreyscale[400],
        ),
      ),
    );
  }
}

//  user opinion firebase update
Future<void> threeButtonDataupdate(BuildContext context, String opinion) async {
  String? userNickName;
  String threeButtonData = '';
  final userCollection = FirebaseFirestore.instance.collection("users");
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  final opinionCollection = FirebaseFirestore.instance
      .collection("userDataCollection")
      .doc(userId)
      .collection('opinions');

  if (userId != null) {
    DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('nickname')) {
        userNickName = userData['nickname'];
      } else {
        debugPrint('No field');
      }
    } else {
      debugPrint('No document');
    }
  } else {
    debugPrint('User ID is null');
  }

  if (selectedIcon == 0) {
    threeButtonData = 'like';
  } else if (selectedIcon == 1) {
    threeButtonData = 'dislike';
  } else {
    threeButtonData = 'propsal';
  }

  final QuerySnapshot snapshot = await opinionCollection.get();

  //  데이터 베이스에 저장
  await opinionCollection.doc('${snapshot.size} - ${userNickName!}').set(
    {
      "id": opinionCollection.doc().id,
      "nickname": userNickName,
      "userUid": userId,
      "date": DateTime.now(),
      "opinion": opinion,
      "type": threeButtonData,
      "emotionList": emotionList,
      "emotion_value": emotionList[0]+emotionList[1]+emotionList[2]+emotionList[3]+emotionList[4]+emotionList[5]-(emotionList[6]+emotionList[7]+emotionList[8]),
    },
  );
}
