import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nts/component/firefly.dart';
import 'package:nts/component/navigationToggle.dart';
import 'package:nts/component/nickName_Sheet.dart';
import 'package:nts/login/login.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/profile/profile.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "SUITE"),
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

  void initState() {
    // 초기화
    FlutterLocalNotification.init();

    // 3초 후 권한 요청
    Future.delayed(const Duration(seconds: 1),
        FlutterLocalNotification.requestNotificationPermission());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final ScrollController scrollController = controller.scrollController;

    return Stack(children: [
      ListView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        children: [
          Container(
            width: 1300,
            child: Image.asset(
              'assets/back.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      const FireFly(),
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
                if (snapshot.data == true) {
                  return ChangeNotifierProvider.value(
                    value: MessageController(),
                    child: const HomePage(),
                  );
                } else if (snapshot.data == false) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      myNicknameSheet(
                        context,
                        Provider.of<UserInfoValueModel>(context, listen: false),
                      );
                    },
                  );

                  return Container();
                } else {
                  return Container();
                }
              },
            );
          } else if (scrollController.offset == 855) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (BuildContext context) => SearchBarController()), // count_provider.dart
                  ChangeNotifierProvider(
                      create: (BuildContext context) => CalendarController())
                ],
                child: const ProfilePage() // home.dart // child 하위에 모든 것들은 CountProvider에 접근 할 수 있다.
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          if (scrollController.offset != 0) {
            return const NavigationToggle();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    ]);
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
        } else {
          print('No field');
        }
      } else {
        print('No document');
      }
    } else {
      print('User ID is null');
    }

    return userNickNameIsMade;
  }
  return true;
}
