import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/controller/gpt_controller.dart';
import 'package:nts/controller/message_controller.dart';
import 'package:nts/controller/search_controller.dart';
import 'package:nts/controller/user_info_controller.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/home_pages/diary.dart';
import 'package:nts/view/profile_pages/profile_search_page.dart';
import 'package:nts/view/profile_pages/settings.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.alert});
  final bool alert;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final double minDragVelocity = 0.3;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final searchModel = Provider.of<ProfileSearchModel>(context);
    final messageController = Provider.of<MessageController>(context);
    final gptModel = Provider.of<GPTModel>(context);

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        // 왼쪽에서 오른쪽으로 드래그했는지 확인합니다.
        if (details.primaryVelocity != null &&
            details.primaryVelocity! > minDragVelocity) {
          controller.movePage(600);
          controller.changeColor(2);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //  setting button
                      Opacity(
                        opacity: 0.4,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                  value: userInfo,
                                  child: Consumer<UserInfoValueModel>(
                                    builder: (context, model, child) =>
                                        ProfileSettings(
                                      provider: controller,
                                      user: model,
                                      gptprovider: gptModel,
                                      alert: false,
                                    ),
                                  ),
                                );

                                /*
                                ProfileSettings(
                                  provider: controller,
                                  user: userInfo,
                                  gptprovider: gptModel,
                                  alert: false,
                                );
                                */
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),

                      //  title
                      Text(
                        "${userInfo.userNickName}님의 일기",
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "Dodam",
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),

                //  search page or none page
                (userInfo.isDiaryExist)
                    ?
                    //  search page
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: MyProfileSearchPage(
                            searchModel: searchModel,
                          ),
                        ),
                      )
                    :
                    //  no result page
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: MyThemeColors.myGreyscale[700]
                                  ?.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '일기 보관함이 비어있습니다.',
                                  style: TextStyle(
                                    color: MyThemeColors.myGreyscale[400],
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //  when try to write diary
                                GestureDetector(
                                  onTap: () {
                                    controller.movePage(600);
                                    controller.changeColor(2);
                                    showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      barrierColor: Colors.transparent,
                                      animationType: DialogTransitionType
                                          .slideFromBottomFade,
                                      builder: (BuildContext context) {
                                        return ChangeNotifierProvider.value(
                                          value: gptModel,
                                          child: Consumer<GPTModel>(
                                            builder: (context, model, child) =>
                                                Diary(
                                              controller: controller,
                                              messageController:
                                                  messageController,
                                              userInfo: userInfo,
                                              gptModel: gptModel,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    '일기 쓰러가기',
                                    style: TextStyle(
                                      color: MyThemeColors.secondaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                //  consider bottom toggle button position
                const SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
