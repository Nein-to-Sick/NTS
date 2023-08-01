import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/model/preset.dart';

import '../component/button.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    Widget first = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 13, 15, 13),
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
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
                    height: 15,
                  ),
                  Button(
                    function: () {
                      setState(() {
                        index = 2;
                      });
                    }, title: '다음',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    Widget second = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: [
          const Text(
            "이런 상태가 맞나요?",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "알맞은 상황/감정을 골라주세요",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "상황",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: Preset().situation.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return SizedBox(
                          height: 20, // 이 부분을 추가하여 길이를 조절하세요
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: Preset().situation[index1].length,
                            itemBuilder: (BuildContext context, int index2) {
                              return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: index1 == 0 ? Color(0xffB0DD79) : index1 == 1 ? Color(0xffFEC125) : Color(0xffF29D8F))),
                                  child:
                                      Text(Preset().situation[index1][index2]));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Text(
                    "감정",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: Preset().situation.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return SizedBox(
                          height: 20, // 이 부분을 추가하여 길이를 조절하세요
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: Preset().situation[index1].length,
                            itemBuilder: (BuildContext context, int index2) {
                              return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                      Border.all(color: index1 == 0 ? Color(0xffB0DD79) : index1 == 1 ? Color(0xffFEC125) : Color(0xffF29D8F))),
                                  child:
                                  Text(Preset().situation[index1][index2]));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Button(function: (){Navigator.pop(context);}, title: '저장 후 나가기',)
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
              index == 1 ? first : second,
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
