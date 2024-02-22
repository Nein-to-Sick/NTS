import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nts/controller/ai_chat_controller.dart';
import 'package:nts/controller/alert_controller.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/controller/gpt_controller.dart';
import 'package:nts/controller/message_controller.dart';
import 'package:nts/controller/search_controller.dart';
import 'package:nts/controller/user_info_controller.dart';
import 'package:nts/theme/custom_theme_data.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/auth_page/login.dart';
import 'package:nts/view/component/confirm_dialog.dart';
import 'package:nts/view/component/firefly.dart';
import 'package:nts/view/component/navigationToggle.dart';
import 'package:nts/view/component/notification.dart';
import 'package:nts/view/home_pages/home_page_list_builder.dart';
import 'package:nts/view/loading_pages/loading_page.dart';
import 'package:nts/view/profile_pages/new_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: child!,
      ),
      theme: CustomThemeData.light,
      /*
      ThemeData(
        fontFamily: "SUITE",
        textSelectionTheme: TextSelectionThemeData(
          //  커서 색상 수정
          cursorColor: MyThemeColors.primaryColor.withOpacity(0.6),
          selectionColor: MyThemeColors.primaryColor.withOpacity(0.2),
          selectionHandleColor: MyThemeColors.primaryColor.withOpacity(0.6),
        ),
      ),
      */
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

class BackgroundState extends State<Background> with WidgetsBindingObserver {
  bool alert = false;
  final player = AudioPlayer();

  //간단히 함수로 처리
  Future playEffectAudio() async {
    await player.setAsset("assets/bgm/bgm.mp3");
    await player.setLoopMode(LoopMode.one);
  }

  @override
  void initState() {
    // 초기화
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlutterLocalNotification.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool? tempAlert =
          await FlutterLocalNotification.requestNotificationPermission();
      if (tempAlert != null) {
        alert = tempAlert;
      }
    });
    playEffectAudio();

    //  when android
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xff272D35),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        playEffectAudio();
        player.play();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        player.pause();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final userInfo = Provider.of<UserInfoValueModel>(context, listen: false);
    final gptModel = Provider.of<GPTModel>(context, listen: false);
    final messageModel = Provider.of<MessageController>(context, listen: false);
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

    return AbsorbPointer(
      absorbing: userInfo.disAllowToTouch,
      child: WillPopScope(
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
                    'assets/images/background/back_dark.png',
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
                    return FireFly(
                        userInfoController: Provider.of<UserInfoValueModel>(
                            context,
                            listen: true));
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
                  return FutureBuilder<int>(
                    future: _getUserDataFromFirebase(
                        userInfo, gptModel, messageModel, player),
                    builder: (context, snapshot) {
                      //  최초 로그인의 경우 (로그 아웃 및 계정 탈퇴 후도 포함)
                      if (userInfo.userNickName.isEmpty &&
                          snapshot.connectionState == ConnectionState.waiting) {
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
                        create: (BuildContext context) => ProfileSearchModel(),
                      ),
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
      ),
    );
  }
}

//  0: Agreement 4: HomePage
Future<int> _getUserDataFromFirebase(
    UserInfoValueModel userInfoModel,
    GPTModel gptModel,
    MessageController messageModel,
    AudioPlayer player) async {
  if (userInfoModel.userNickName.isNotEmpty) {
    return 5;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime currentDateTime = DateTime.now();

  if (prefs.getString('LoginedDate') == null) {
    await prefs.setString('LoginedDate', DateTime.now().toString());
  } else {
    currentDateTime = DateTime.parse(prefs.getString('LoginedDate').toString());
    DateTime now = DateTime.now();
    //  When last login time was not today

    if (currentDateTime.isBefore(DateTime(now.year, now.month, now.day))) {
      //  local variable update

      await prefs.setString('LoginedDate', DateTime.now().toString());
      final userCollection = FirebaseFirestore.instance.collection("users");
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();

      userInfoModel.updateYellowValue(userSnapshot["yellow"]);

      //  max yellow value < 31
      if (userInfoModel.currentYellowValue + 1 < 31) {
        userInfoModel.updateYellowValue(userInfoModel.currentYellowValue + 1);
      }

      //  when is the first day of month
      if (now.day == 1) {
        userInfoModel.updateYellowValue(1);
      }

      //  local variable update
      await prefs.setInt('yellowCount', userInfoModel.currentYellowValue);

      await userCollection.doc(userId).update({
        "yellow": userInfoModel.currentYellowValue,
      });
    }
  }

  if (userInfoModel.userNickName.isEmpty) {
    //  local variable initialization
    userInfoModel.userNickNameUpdate(prefs.getString('nickname') ?? '');
    userInfoModel.userEmailUpdate(prefs.getString('email') ?? '');
    userInfoModel.userDiaryExist(prefs.getBool('diaryExist') ?? false);
    userInfoModel.updateYellowValue(prefs.getInt('yellowCount') ?? 1);
    gptModel.updateAIUsingSetting(prefs.getBool('isAIUsing') ?? true);
    messageModel.setSpeaker(prefs.getBool('speakerSetting') ?? true);

    if (messageModel.speaker) {
      player.play();
    } else {
      player.pause();
    }

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
            userInfoModel.updateYellowValue(userData['yellow']);
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
            await prefs.setBool('diaryExist', true);
          }

          //  local variable update
          await prefs.setString('nickname', userData['nickname']);
          await prefs.setString('email', userData['email']);
          await prefs.setInt('yellowCount', userData['yellow']);
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
    return 5;
  }
}
