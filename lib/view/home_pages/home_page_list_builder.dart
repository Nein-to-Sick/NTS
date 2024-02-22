import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/controller/user_info_controller.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/component/agree_condition.dart';
import 'package:nts/view/component/button.dart';
import 'package:nts/view/component/nickname_sheet.dart';
import 'package:nts/view/home_pages/home.dart';
import 'package:provider/provider.dart';

import '../../controller/search_controller.dart';

class HomePageListViewBuilder extends StatefulWidget {
  final AudioPlayer player;
  final int firstPageIndex;
  const HomePageListViewBuilder({
    super.key,
    required this.player,
    required this.firstPageIndex,
  });

  @override
  State<HomePageListViewBuilder> createState() =>
      _HomePageListViewBuilderState();
}

class _HomePageListViewBuilderState extends State<HomePageListViewBuilder> {
  late PageController _pageController;
  int currentPageIndex = 0;
  bool _isNicknameSheetVisible = false;
  bool _isAgreementSheetVisible = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.firstPageIndex);
    currentPageIndex = widget.firstPageIndex;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemBuilder: (BuildContext context, int pageIndex) {
              switch (pageIndex) {
                case 0:
                  //  Agreement page
                  if (!_isAgreementSheetVisible) {
                    // 호출을 한번만 하도록 추가
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AgreementSheet().agreementTermSheet(
                        context,
                        _pageController,
                      );
                      setState(() {
                        _isAgreementSheetVisible = true;
                      });
                    });
                  }
                  return Container();
                case 1:
                  //  OnBoarding page 1
                  return _buildOnboardingPage(
                    context,
                    imagePath: "./assets/images/onboarding/1.png",
                    text: "먼저, 일기를 써보세요",
                    subTitle: "본인의 감정과 상황을 파악하는데 도움을 줄거에요",
                  );
                case 2:
                  //  OnBoarding page 2
                  return _buildOnboardingPage(
                    context,
                    imagePath: "./assets/images/onboarding/2.png",
                    text: "그럼, 편지를 받을수 있을거에요",
                    subTitle: "본인의 감정과 상황에 공감해주는 느낌을 받을수 있을거예요.",
                  );
                case 3:
                  //  OnBoarding page 2
                  return _buildOnboardingPage(
                    context,
                    imagePath: "./assets/images/onboarding/3.png",
                    text: "그리고, 감사의 마음을 전해보세요",
                    subTitle: "상대방도 본인이 보낸 편지에 보람을 느낄수 있을거예요.",
                  );
                case 4:
                  //  NickName input page
                  if (!_isNicknameSheetVisible) {
                    // 호출을 한번만 하도록 추가
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      NickName().myNicknameSheet(
                        context,
                        Provider.of<UserInfoValueModel>(
                          context,
                          listen: false,
                        ),
                        0,
                        _pageController,
                      );
                      setState(() {
                        _isNicknameSheetVisible = true;
                      });
                    });
                  }
                  return Container();
                case 5:
                  //  home page
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<BackgroundController>(context, listen: false)
                        .fireFlyOn();
                  });
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (BuildContext context) =>
                              ProfileSearchModel()),
                    ],
                    child: HomePage(player: widget.player)
                  );

                default:
                  return Container();
              }
            },
          ),
          (currentPageIndex < 3)
              ?
              //  next button
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 50.0, left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Button(
                      function: () {
                        _debounce?.cancel();

                        _debounce =
                            Timer(const Duration(milliseconds: 250), () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                          setState(() {
                            currentPageIndex = _pageController.page!.toInt();
                          });
                        });
                      },
                      title: (currentPageIndex != 2) ? '다음' : '시작하기',
                    ),
                  ),
                )
              : Container(),
          // (currentPageIndex < 3)
          //     ?
          //     //  skip to nickname page
          //     Positioned(
          //         right: 30,
          //         top: 50,
          //         child: GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               currentPageIndex = 4;
          //             });
          //             _pageController.animateToPage(4,
          //                 duration: const Duration(milliseconds: 300),
          //                 curve: Curves.ease);
          //           },
          //           child: Container(
          //             width: 40,
          //             height: 40,
          //             color: Colors.transparent,
          //             child: Center(
          //               child: Text(
          //                 "skip",
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w700,
          //                   color: (currentPageIndex == 0)
          //                       ? Colors.transparent
          //                       : MyThemeColors.myGreyscale[400],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container(),
        ],
      ),
    );
  }

  //  OnBoarding page design
  Widget _buildOnboardingPage(
    BuildContext context, {
    required String imagePath,
    required String text,
    required String subTitle,
  }) {
    return Center(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Image.asset(imagePath)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: AutoSizeText(
                text,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "Dodam",
                  color: MyThemeColors.whiteColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: AutoSizeText(
                subTitle,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Dodam",
                  color: MyThemeColors.myGreyscale.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
