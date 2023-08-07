import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/component/button.dart';
import 'package:nts/component/new_nickname.dart';
import 'package:nts/component/suggestionsButton.dart';
import 'package:nts/model/settingsInfos.dart';
import 'package:nts/component/delete_account.dart';
import 'package:nts/oss_licenses.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:provider/provider.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';
import '../provider/backgroundController.dart';

import 'notification.dart';

class ProfileSettings extends StatefulWidget {
  final BackgroundController provider;
  const ProfileSettings({Key? key, required this.provider}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool positive = false;
  int index = 1; //1==메인설정, 2== 이용약관, 3==개인정보 처리방침, 4==사업자 정보, 5==라이센스, 6==프로필편집

  // static Future<List<String>> loadLicenses() async {
  // final ossKeys = ossLicenses.keys.toList();
  // return ossKeys..sort();
  // }

  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of<BackgroundController>(context);

    Widget mainSettings = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Center(
        child: Column(
          children: [
            const Text(
              "설정",
              style: TextStyle(fontSize: 20, color: Color(0xff393939)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            // mainsettingView(),
            Expanded(child: mainsettingView()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.045),
              child: Button(
                function: () {
                  Navigator.pop(context);
                },
                title: '닫기',
              ),
            ),
          ],
        ),
      ),
    );
    Widget termsOfUse = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Center(
        child: Column(
          children: [
            const Text(
              "이용약관",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: termsOfUseText()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.045),
              child: Button(
                function: () {
                  setState(() {
                    index = 1;
                  });
                },
                title: '이전',
              ),
            ),
          ],
        ),
      ),
    );
    Widget privacypolicy = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Center(
        child: Column(
          children: [
            const Text(
              "개인정보 처리방침",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: privacyPolicyText()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.045),
              child: Button(
                function: () {
                  setState(() {
                    index = 1;
                  });
                },
                title: '이전',
              ),
            ),
          ],
        ),
      ),
    );
    Widget companyInfo = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Center(
        child: Column(
          children: [
            const Text(
              "개인정보 처리방침",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: companyInfoView()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.045),
              child: Button(
                function: () {
                  setState(() {
                    index = 1;
                  });
                },
                title: '이전',
              ),
            ),
          ],
        ),
      ),
    );
    Widget openLicense = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Center(
        child: Column(
          children: [
            const Text(
              "오픈 라이센스",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: Container()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.045),
              child: Button(
                function: () {
                  setState(() {
                    index = 1;
                  });
                },
                title: '이전',
              ),
            ),
          ],
        ),
      ),
    );
    Widget manageAccount = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Column(
        children: [
          const Text(
            "계정 관리",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Expanded(
            child: manageAccountView(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.045),
            child: Button(
              function: () {
                setState(() {
                  index = 1;
                });
              },
              title: '이전',
            ),
          ),
        ],
      ),
    );

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ), //openLicense
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Stack(
            children: [
              index == 1
                  ? mainSettings
                  : index == 2
                      ? termsOfUse
                      : index == 3
                          ? privacypolicy
                          : index == 4
                              ? companyInfo
                              : index == 5
                                  ? openLicense
                                  : manageAccount,
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

  Widget buildCustomContainer({
    required Color backgroundColor,
    required Widget inside,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      child: inside,
    );
  }

  Widget buildCustomButton(
      {required Color backgroundColor,
      required Widget inside,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 5,
            //     blurRadius: 7,
            //     offset: Offset(0, 3), // changes position of shadow
            //   ),
            // ],
          ),
          child: inside),
    );
  }

  Widget termsOfUseText() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            for (int i = 0; i < CompanyInfo().termsOfUse.length; i++)
              Container(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: WrappedKoreanText(
                        CompanyInfo().termsOfUse[i][0],
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: WrappedKoreanText(
                        CompanyInfo().termsOfUse[i][1],
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget privacyPolicyText() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            for (int i = 0; i < CompanyInfo().privacyPolicy.length; i++)
              Container(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: WrappedKoreanText(
                        CompanyInfo().privacyPolicy[i][0],
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: WrappedKoreanText(
                        CompanyInfo().privacyPolicy[i][1],
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              width: MediaQuery.of(context).size.width,
              child: WrappedKoreanText(
                CompanyInfo().privacyPolicyExplain,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainsettingView() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            //계정관리
            buildCustomButton(
              onTap: () {
                setState(() {
                  index = 6;
                });
              },
              backgroundColor: Colors.white.withOpacity(0.9),
              inside: Row(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "계정 관리",
                          style: TextStyle(fontSize: 16),
                        ))),
                HeroIcon(
                  HeroIcons.chevronRight,
                  color: Color(0xffBFBFBF),
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //알림설정
            buildCustomContainer(
              backgroundColor: Colors.white.withOpacity(0.9),
              inside: Row(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "알림 설정",
                          style: TextStyle(fontSize: 16),
                        ))),
                alarmButton(),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            //오픈 라이센스
            buildCustomButton(
              backgroundColor: Colors.white.withOpacity(0.9),
              onTap: () {
                setState(() {
                  index = 5;
                });
              },
              inside: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text("오픈 라이센스",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                HeroIcon(
                  HeroIcons.chevronRight,
                  color: Color(0xffBFBFBF),
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //이용약관
            buildCustomButton(
              backgroundColor: Colors.white.withOpacity(0.9),
              onTap: () {
                setState(() {
                  index = 2;
                });
              },
              inside: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text("이용약관",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                HeroIcon(
                  HeroIcons.chevronRight,
                  color: Color(0xffBFBFBF),
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //개인정보 처리방침
            buildCustomButton(
              backgroundColor: Colors.white.withOpacity(0.9),
              onTap: () {
                setState(() {
                  index = 3;
                });
              },
              inside: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text("개인정보 처리방침",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                HeroIcon(
                  HeroIcons.chevronRight,
                  color: Color(0xffBFBFBF),
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //사업자 정보
            buildCustomButton(
              backgroundColor: Colors.white.withOpacity(0.9),
              onTap: () {
                setState(() {
                  index = 4;
                });
              },
              inside: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text("사업자 정보",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                HeroIcon(
                  HeroIcons.chevronRight,
                  color: Color(0xffBFBFBF),
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            //건의함
            suggestions(),
          ],
        ),
      ),
    );
  }

  Widget alarmButton() {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: CustomAnimatedToggleSwitch<bool>(
        current: positive,
        values: [false, true],
        dif: 0.0,
        indicatorSize: Size.square(30.0),
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.linear,
        onChanged: (b) => setState(() => positive = b),
        iconBuilder: (context, local, global) {
          return const SizedBox();
        },
        defaultCursor: SystemMouseCursors.click,
        onTap: () {
          setState(() => positive = !positive);
          // if (positive) {
          //   alarmsettings();
          // }
          // else {
          //   FlutterLocalNotification.requestNotificationPermissionOff();
          //   print("notification is turned offed");
          //   FlutterLocalNotification.showNotification();
          // }
        },
        iconsTappable: false,
        wrapperBuilder: (context, global, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  left: 10.0,
                  right: 10.0,
                  height: 20.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          width: 3.0,
                          color: Color(0xffC6C6C6),
                        )),
                  )),
              child,
            ],
          );
        },
        foregroundIndicatorBuilder: (context, global) {
          return SizedBox.fromSize(
            size: global.indicatorSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xffC6C6C6),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xffC6C6C6),
                      spreadRadius: 0.05,
                      blurRadius: 1.1,
                      offset: Offset(0.0, 0.8))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget companyInfoView() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                CompanyInfo().companyName,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: WrappedKoreanText(
                CompanyInfo().info,
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.53)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget suggestions() {
    return ElevatedButton(
      onPressed: () {
        myShowBottomSheet(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Color(0xffFCE181),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Column(
        children: [
          HeroIcon(
            HeroIcons.handRaised,
            // color: AppColors.blackColor,
            color: Colors.black,
            style: HeroIconStyle.mini,
          ),
          SizedBox(
            height: 9,
            width: 50,
          ),
          Text(
            '건의함',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget manageAccountView() {
    return Container(
      child: Center(
        child: Column(
          children: [
            buildCustomContainer(
              backgroundColor: Colors.white,
              inside: Row(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "이메일",
                          style: TextStyle(fontSize: 16),
                        ))),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: AutoSizeText(
                      "xxxxxxxxx@gmail.com",
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, color: Color(0xff868686)),
                    )),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            buildCustomButton(
              onTap: () {
                NewNickName(context);
              },
              backgroundColor: Colors.white,
              inside: Row(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "닉네임 변경",
                          style: TextStyle(fontSize: 16),
                        ))),
                Container(
                    child: Text(
                  "하루",
                  style: TextStyle(fontSize: 16, color: Color(0xff868686)),
                )),
                HeroIcon(
                  HeroIcons.chevronRight,
                  color: Color(0xffBFBFBF),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                )
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            //로그아웃
            buildCustomButton(
              backgroundColor: Color(0xffFCE181),
              onTap: () {
                print("click");
                // controller.movePage(0);
                Provider.of<UserInfoValueModel>(context, listen: false)
                    .userNickNameClear();
                FirebaseAuth.instance.signOut();
                widget.provider.movePage(0);
                Navigator.pop(context);
              },
              inside: Center(
                child: Text(
                  "로그아웃",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //계정탈퇴
            buildCustomButton(
              backgroundColor: Colors.white,
              onTap: () {
                Provider.of<UserInfoValueModel>(context, listen: false)
                    .userNickNameClear();
                DeleteAccount(context, widget.provider);
              },
              inside: Center(
                child: Text(
                  "계정탈퇴",
                  style: TextStyle(fontSize: 16, color: Color(0xffFCE181)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
