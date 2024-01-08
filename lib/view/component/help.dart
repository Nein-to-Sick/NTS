import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/component/button.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Opacity(
                  opacity: 0.1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: HeroIcon(
                      HeroIcons.xMark,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Text(
                "이용 정보",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: MyThemeColors.myGreyscale[900]),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "반딧불이를 얻는 법",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "1.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: WrappedKoreanText(
                                    "앱에 들어올 때마다 하루에 최대 1마리씩 반딧불이가 추가돼요.\n",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "2.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                    child: WrappedKoreanText(
                                  "반딧불이는 한 달에 최대 30마리로 매달 1일에 초기화돼요.",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "반딧불이를 깜박이게 하는 법",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WrappedKoreanText(
                              "1. 누군가를 위해 마음을 담아 정성껏 편지를 작성해봐요.",
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: WrappedKoreanText(
                                "(편지를 많이 적을수록 반딧불이가 깜빡일 가능성이 올라가요.)\n",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "2.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: WrappedKoreanText(
                                    "당신의 마음이 담긴 편지를 누군가가 읽고 감사의 하트 버튼을 누를 때:편지 작성자가 앱에 들어왔을 때 반딧불이들이 밝게 깜박이는 모습을 3~5초간 볼 수 있어요.",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                function: () {
                  Navigator.pop(context);
                },
                title: "닫기",
              )
            ],
          ),
        ),
      ),
    );
  }
}
