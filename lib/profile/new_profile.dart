import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/search_model.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/profile_search_page.dart';
import 'package:nts/profile/settings.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/gpt_model.dart';
import 'package:nts/provider/messageController.dart';
import 'package:provider/provider.dart';
import 'package:nts/home/diary.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.alert});
  final bool alert;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final searchModel = Provider.of<ProfileSearchModel>(context);
    final messageController = Provider.of<MessageController>(context);

    super.build(context);
    return Scaffold(
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
                    //  temp logout button
                    // IconButton(
                    //   onPressed: () {
                    //     userInfo.userInfoClear();
                    //     FirebaseAuth.instance.signOut();
                    //     controller.movePage(0);
                    //   },
                    //   icon: const Icon(
                    //     Icons.logout,
                    //     color: Colors.white,
                    //   ),
                    // ),

                    //  setting button
                    Opacity(
                      opacity: 0.4,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return ProfileSettings(
                                provider: controller,
                                user: userInfo,
                                alert: false,
                              );
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
                          fontFamily: "Dodam"),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),

              //  search page or none page
              (userInfo.isDiaryExist)
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: MyProfileSearchPage(
                          searchModel: searchModel,
                        ),
                      ),
                    )
                  : Expanded(
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
                                      return MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider(
                                            create: (context) => GPTModel(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (context) =>
                                                BackgroundController(),
                                          ),
                                        ],
                                        child: Diary(
                                          controller: controller,
                                          messageController: messageController,
                                          userInfo: userInfo,
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
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
