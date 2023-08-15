import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/button.dart';
import 'package:nts/component/nickname_sheet.dart';
import 'package:nts/home/home.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.firstPageIndex);
    currentPageIndex = widget.firstPageIndex;
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
                  //  OnBoarding page 1
                  return _buildOnboardingPage(
                    context,
                    imagePath: "./assets/onboard/1.png",
                    text: "일기를 쓰고",
                  );
                case 1:
                  //  OnBoarding page 2
                  return _buildOnboardingPage(
                    context,
                    imagePath: "./assets/onboard/2.png",
                    text: "위로의 편지를 받고",
                  );
                case 2:
                  //  OnBoarding page 2
                  return _buildOnboardingPage(
                    context,
                    imagePath: "./assets/onboard/3.png",
                    text: "감사의 마음을 전해보세요",
                  );
                case 3:
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
                case 4:
                  //  home page
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<BackgroundController>(context, listen: false)
                        .fireFlyOn();
                  });
                  return HomePage(player: widget.player);
                default:
                  return Container();
              }
            },
          ),
          (currentPageIndex < 2)
              ?
              //  next button
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 50.0, left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Button(
                      function: () {
                        setState(() {
                          currentPageIndex = _pageController.page!.toInt();
                        });
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      title: (currentPageIndex != 1) ? '다음' : '시작하기',
                    ),
                  ),
                )
              : Container(),
          (currentPageIndex < 2)
              ?
              //  skip to nickname page
              Positioned(
                  right: 30,
                  top: 50,
                  child: GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(3,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "skip",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: MyThemeColors.myGreyscale[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  //  OnBoarding page design
  Widget _buildOnboardingPage(
    BuildContext context, {
    required String imagePath,
    required String text,
  }) {
    return Center(
      child: Stack(
        children: [
          Center(child: Image.asset(imagePath)),
          Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 25, fontFamily: "Dodam", color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
