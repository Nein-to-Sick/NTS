import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/confirm_dialog.dart';
import 'package:nts/component/firefly.dart';
import 'package:nts/component/navigationToggle.dart';
import 'package:nts/component/nickname_sheet.dart';
import 'package:nts/loading/loading_page.dart';
import 'package:nts/login/login.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/new_profile.dart';
import 'package:nts/provider/alertController.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:nts/provider/calendarController.dart';
import 'package:nts/provider/messageController.dart';
import 'package:nts/provider/searchBarController.dart';
import 'package:provider/provider.dart';
import 'component/notification.dart';
import 'firebase_options.dart';
import 'home/home.dart';

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
            ChangeNotifierProvider(create: (context) => AlertController())
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

  @override
  void initState() {
    // 초기화
    FlutterLocalNotification.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      alert = (await FlutterLocalNotification.requestNotificationPermission())!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final ScrollController scrollController = controller.scrollController;
    onBackKeyCallOnMain() {
      showDialog(
        context: context,
        builder: (context) {
          return dialogWithYesOrNo(
            context,
            '앱 종료',
            '앱을 종료하시겠나요?',
            //  on Yes
            () {
              SystemNavigator.pop();
            },
            //  on No
            () {},
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
        if (scrollController.offset == 600) {
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
                  'assets/back.png',
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
                  future: _getNickNameFromFirebase(
                      Provider.of<UserInfoValueModel>(context, listen: false)),
                  builder: (context, snapshot) {
                    //  최초 로그인의 경우 (로그 아웃 및 계정 탈퇴 후도 포함)
                    if (Provider.of<UserInfoValueModel>(context, listen: false)
                            .userNickName
                            .isEmpty &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      print(controller.fireFly);
                      return const MyFireFlyProgressbar(
                        loadingText: '로그인하는 중...',
                      );
                    }
                    //  계정이 존재하고 닉네임이 있는 경우
                    else if (snapshot.data == true) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.fireFlyOn();
                      });
                      return MultiProvider(providers: [
                        ChangeNotifierProvider(
                          create: (BuildContext context) => MessageController(),
                        ),
                      ], child: const HomePage());
                    }
                    //  계정이 존재하고 닉네임이 없는 경우
                    else if (snapshot.data == false) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          // String printitle = "사용할 닉네임을 정해주세요";
                          // myNicknameSheet(
                          //   context,
                          //   Provider.of<UserInfoValueModel>(context,
                          //       listen: false),
                          //       ''
                          // );
                          NickName().myNicknameSheet(
                              context,
                              Provider.of<UserInfoValueModel>(
                                context,
                                listen: false,
                              ),
                              0);
                        },
                      );

                      return Container();
                    } else {
                      return Container();
                    }
                  },
                );
              } else if (scrollController.offset == 855) {
                return MultiProvider(providers: [
                  ChangeNotifierProvider(
                      create: (BuildContext context) =>
                          SearchBarController()), // count_provider.dart
                  ChangeNotifierProvider(
                      create: (BuildContext context) => CalendarController()),
                ], child: MyProfilePage(alert: alert,)
                    //const ProfilePage() // home.dart // child 하위에 모든 것들은 CountProvider에 접근 할 수 있다.
                    );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          controller.fireFly
              ? AnimatedBuilder(
                  animation: scrollController,
                  builder: (context, child) {
                    if (scrollController.offset == 600 ||
                        scrollController.offset == 855) {
                      return const NavigationToggle();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

Future<bool> _getNickNameFromFirebase(UserInfoValueModel model) async {
  if (model.userNickName.isEmpty) {
    bool userNickNameIsMade = false;
    final userCollection = FirebaseFirestore.instance.collection("users");
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('nicknameMade')) {
          userNickNameIsMade = userData['nicknameMade'];
          model.userNickName = userData['nickname'];
          model.userEmail = userData['email'];
        } else {
          print('No field');
        }
      } else {
        print('No document');
      }
    } else {
      print('User ID is null');
    }
    //  delay for loading page
    return Future.delayed(const Duration(seconds: 1), () {
      return userNickNameIsMade;
    });
  }

  return true;
}
