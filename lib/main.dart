import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/confirm_dialog.dart';
import 'package:nts/component/firefly.dart';
import 'package:nts/component/navigationToggle.dart';
import 'package:nts/component/notification.dart';
import 'package:nts/home/home_page_list_builder.dart';
import 'package:nts/loading/loading_page.dart';
import 'package:nts/login/login.dart';
import 'package:nts/model/search_model.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/new_profile.dart';
import 'package:nts/provider/alertController.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/gpt_model.dart';
import 'package:nts/provider/messageController.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "SUITE",
        textSelectionTheme: TextSelectionThemeData(
          //  커서 색상 수정
          cursorColor: MyThemeColors.primaryColor.withOpacity(0.6),
          selectionColor: MyThemeColors.primaryColor.withOpacity(0.2),
          selectionHandleColor: MyThemeColors.primaryColor.withOpacity(0.6),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => BackgroundController(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserInfoValueModel(),
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) => MessageController(),
            ),
            ChangeNotifierProvider(
              create: (context) => AlertController(),
            ),
            ChangeNotifierProvider(
              create: (context) => GPTModel(),
            ),
          ],
          child: const Background(),
        ),
      ),
    );
  }
}

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  BackgroundState createState() => BackgroundState();
}

class BackgroundState extends State<Background> {
  bool alert = false;
  final player = AudioPlayer();

  //간단히 함수로 처리
  Future playEffectAudio() async {
    final duration = await player.setAsset("assets/bgm/bgm1.mp3");
    await player.setLoopMode(LoopMode.one);
    await player.play();
  }

  @override
  void initState() {
    // 초기화
    FlutterLocalNotification.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      alert = (await FlutterLocalNotification.requestNotificationPermission())!;
    });
    playEffectAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context);
    final gptModel = Provider.of<GPTModel>(context);
    final ScrollController scrollController = controller.scrollController;
    onBackKeyCallOnMain() {
      showDialog(
        context: context,
        builder: (context) {
          return dialogWithYesOrNo(
            context,
            '정말로 종료하시는 건가요?',
            "",
            "종료",
            //  on Yes
            () {
              SystemNavigator.pop();
            },
            //  on No
            () {
              Navigator.pop(context);
            },
          );
        },
      );
    }

    onBackKeyCallOnMyPage() {
      controller.movePage(600);
      controller.changeColor(2);
    }

    return WillPopScope(
      //뒤로가기 막음
      onWillPop: () {
        if (scrollController.offset == 600 || scrollController.offset == 0) {
          onBackKeyCallOnMain();
        } else if (scrollController.offset == 855) {
          onBackKeyCallOnMyPage();
        }
        return Future(() => false);
      },
      child: Stack(
        children: [
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            children: [
              SizedBox(
                width: 1300,
                child: Image.asset(
                  'assets/background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: scrollController,
            builder: (context, child) {
              if (controller.fireFly) {
                if (scrollController.offset == 0 ||
                    scrollController.offset == 600 ||
                    scrollController.offset == 855) {
                  return const FireFly();
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          AnimatedBuilder(
            animation: scrollController,
            builder: (context, child) {
              if (scrollController.offset == 0) {
                return const LoginPage();
              } else if (scrollController.offset == 600) {
                return FutureBuilder(
                  future: _getUserDataFromFirebase(userInfo, gptModel),
                  builder: (context, snapshot) {
                    //  최초 로그인의 경우 (로그 아웃 및 계정 탈퇴 후도 포함)
                    if (userInfo.userNickName.isEmpty &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      print(controller.fireFly);
                      return const MyFireFlyProgressbar(
                        loadingText: '로그인하는 중...',
                        textColor: MyThemeColors.whiteColor,
                      );
                    }
                    //  로그인 성공 후
                    else if (snapshot.hasData) {
                      return HomePageListViewBuilder(
                        player: player,
                        firstPageIndex: snapshot.data!,
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else if (scrollController.offset == 855) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (BuildContext context) => ProfileSearchModel()),
                  ],
                  child: MyProfilePage(
                    alert: alert,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          controller.fireFly
              ? SafeArea(
                child: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      if (scrollController.offset == 600 ||
                          scrollController.offset == 855) {
                        return const NavigationToggle();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
              )
              : Container(),
        ],
      ),
    );
  }
}

//  0: OnBoarding, 4: HomePage
Future<int> _getUserDataFromFirebase(
    UserInfoValueModel userInfoModel, GPTModel gptModel) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (userInfoModel.userNickName.isEmpty) {
    //  local variable initialization
    userInfoModel.userNickNameUpdate(prefs.getString('nickname') ?? '');
    userInfoModel.userEmailUpdate(prefs.getString('email') ?? '');
    userInfoModel.userDiaryExist(prefs.getBool('diaryExist') ?? false);
    gptModel.updateAIUsingSetting(prefs.getBool('isAIUsing') ?? true);

    if (userInfoModel.userNickName.isEmpty) {
      final userCollection = FirebaseFirestore.instance.collection("users");
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          //  check whether the nickName exist
          if (userData.containsKey('nickname') &&
              userData.containsKey('email')) {
            userInfoModel.userNickNameUpdate(userData['nickname']);
            userInfoModel.userEmailUpdate(userData['email']);
          } else {
            debugPrint('No field');
            return 0;
          }

          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('diary')
              .get();

          //  check whether the diary exist
          if (querySnapshot.docs.isNotEmpty) {
            userInfoModel.userDiaryExist(true);
          }

          //  local variable update
          await prefs.setString('nickname', userData['nickname']);
          await prefs.setString('email', userData['email']);
          await prefs.setBool('diaryExist', true);
        } else {
          debugPrint('No document');
        }
      } else {
        debugPrint('User ID is null');
      }
    }
  }

  if (userInfoModel.userNickName.isEmpty) {
    return 0;
  } else {
    return 4;
  }
}
