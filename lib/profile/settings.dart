import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nts/component/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/button.dart';
import 'package:nts/component/nickname_sheet.dart';
import 'package:nts/component/suggestions_button.dart';
import 'package:nts/model/settingsInfos.dart';
import 'package:nts/oss_licenses.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/provider/gpt_model.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';
import '../component/notification.dart';
import '../provider/backgroundController.dart';

class ProfileSettings extends StatefulWidget {
  final BackgroundController provider;
  final UserInfoValueModel user;
  final GPTModel gptprovider;
  final bool alert;

  // final controller = Provider.of<BackgroundController>(context);
  // final userInfo = Provider.of<UserInfoValueModel>(context);
  // final userName = userInfo.userNickName;
  const ProfileSettings(
      {Key? key,
      required this.provider,
      required this.user,
      required this.gptprovider,
      required this.alert})
      : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  int index =
      1; //1==메인설정, 2== 이용약관, 3==개인정보 처리방침, 4==사업자 정보, 5==라이센스, 6==프로필편집, 7==oss
  bool positive = false;

  @override
  void initState() {
    positive = widget.alert;
    super.initState();
  }

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
            Text(
              "설정",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MyThemeColors.myGreyscale[900]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            // mainsettingView(),
            Expanded(child: mainsettingView()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02),
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
                  horizontal: MediaQuery.of(context).size.width * 0.02),
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
                  horizontal: MediaQuery.of(context).size.width * 0.02),
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
              "사업자 정보",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: companyInfoView()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02),
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
                  horizontal: MediaQuery.of(context).size.width * 0.02),
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
          Text(
            "계정 관리",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: MyThemeColors.myGreyscale[900]),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Expanded(
            child: manageAccountView(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
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
    Widget oss_licenses = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Column(
        children: [
          Text(
            "오픈 라이센스",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: MyThemeColors.myGreyscale[900]),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Expanded(
            child: ossLicensesView(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
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
      backgroundColor: MyThemeColors.myGreyscale[25],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ), //openLicense
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
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
                                  : index == 6
                                      ? manageAccount
                                      : oss_licenses,
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
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: WrappedKoreanText(
                        CompanyInfo().termsOfUse[i][1],
                        style: const TextStyle(
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
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: WrappedKoreanText(
                        CompanyInfo().privacyPolicy[i][1],
                        style: const TextStyle(
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
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.normal),
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
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text(
                          "계정 관리",
                          style: TextStyle(fontSize: 16),
                        ))),
                const HeroIcon(
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
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          "알림 설정",
                          style: TextStyle(
                              fontSize: 16,
                              color: FlutterLocalNotification
                                      .hasNotificationPermission
                                  ? MyThemeColors.blackColor
                                  : MyThemeColors.myGreyscale[200]!),
                        ))),
                alarmButton(),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //인공지능설정
            buildCustomContainer(
              backgroundColor: Colors.white.withOpacity(0.9),
              inside: Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          "AI정리 사용",
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.gptprovider.isAIUsing
                                ? MyThemeColors.blackColor
                                : MyThemeColors.myGreyscale[200]!,
                          ),
                        ))),
                AIButton(),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            //오픈 라이센스
            buildCustomButton(
              backgroundColor: Colors.white.withOpacity(0.9),
              onTap: () {
                setState(() {
                  index = 7;
                });
              },
              inside: Row(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text("오픈 라이센스",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                const HeroIcon(
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
                    margin: const EdgeInsets.only(left: 20),
                    child: Text("이용약관",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: MyThemeColors.myGreyscale[900]),
                  ),
                ),),
                const HeroIcon(
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
                    margin: const EdgeInsets.only(left: 20),
                    child: Text("개인정보 처리방침",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: MyThemeColors.myGreyscale[900]),)
                  ),
                ),
                const HeroIcon(
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
                    margin: const EdgeInsets.only(left: 20),
                    child: Text("사업자 정보",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: MyThemeColors.myGreyscale[900]),)
                  ),
                ),
                const HeroIcon(
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
      margin: const EdgeInsets.only(right: 15),
      child: CustomAnimatedToggleSwitch<bool>(
        current: FlutterLocalNotification.hasNotificationPermission,
        values: const [false, true],
        dif: 0.0,
        indicatorSize: const Size.square(30.0),
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.linear,
        onChanged: (b) => setState(
            () => FlutterLocalNotification.hasNotificationPermission = b),
        iconBuilder: (context, local, global) {
          return const SizedBox();
        },
        defaultCursor: SystemMouseCursors.click,
        onTap: () {
          setState(() => FlutterLocalNotification.hasNotificationPermission =
              !FlutterLocalNotification.hasNotificationPermission);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.white,
              content: const Text(
                '알림이 설정되었습니다!',
                style: TextStyle(color: Colors.black),
              ),
              duration: const Duration(seconds: 3),
              //올라와있는 시간
              action: SnackBarAction(
                textColor: MyThemeColors.primaryColor,
                //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
                label: '취소하기',
                //버튼이름
                onPressed: () {
                  FlutterLocalNotification.hasNotificationPermission =
                      !FlutterLocalNotification.hasNotificationPermission;
                },
              ),
            ),
          );
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
                        color:
                            FlutterLocalNotification.hasNotificationPermission
                                ? Color(0xffFCE181)
                                : MyThemeColors.myGreyscale[50],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          width: 3.0,
                          color:
                              FlutterLocalNotification.hasNotificationPermission
                                  ? Color(0xffFCE181)
                                  : MyThemeColors.myGreyscale[200]!,
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
                color: FlutterLocalNotification.hasNotificationPermission
                    ? MyThemeColors.blackColor
                    : MyThemeColors.myGreyscale[200]!,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                boxShadow: [
                  BoxShadow(
                      color: FlutterLocalNotification.hasNotificationPermission
                          ? MyThemeColors.blackColor
                          : MyThemeColors.myGreyscale[200]!,
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

  Widget AIButton() {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: CustomAnimatedToggleSwitch<bool>(
        current: widget.gptprovider.isAIUsing,
        values: const [false, true],
        dif: 0.0,
        indicatorSize: const Size.square(30.0),
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.linear,
        onChanged: (b) => setState(() => widget.gptprovider.isAIUsing = b),
        iconBuilder: (context, local, global) {
          return const SizedBox();
        },
        defaultCursor: SystemMouseCursors.click,
        onTap: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          widget.gptprovider
              .updateAIUsingSetting(!widget.gptprovider.isAIUsing);

          //  local variable update
          prefs.setBool('isAIUsing', widget.gptprovider.isAIUsing);
          setState(() {});
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
                        color: widget.gptprovider.isAIUsing
                            ? MyThemeColors.secondaryColor
                            : MyThemeColors.myGreyscale[50],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          width: 3.0,
                          color: widget.gptprovider.isAIUsing
                              ? MyThemeColors.secondaryColor
                              : MyThemeColors.myGreyscale[200]!,
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
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                boxShadow: [
                  BoxShadow(
                      color: widget.gptprovider.isAIUsing
                          ? MyThemeColors.blackColor
                          : MyThemeColors.myGreyscale[200]!,
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
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
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
        foregroundColor: MyThemeColors.myGreyscale.shade100,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const HeroIcon(
            HeroIcons.handRaised,
            // color: AppColors.blackColor,
            color: Colors.black,
            style: HeroIconStyle.mini,
          ),
          const SizedBox(
            height: 9,
            width: 50,
          ),
          Text(
            '건의함',
            style: TextStyle(fontSize: 13, color: MyThemeColors.myGreyscale[900], fontWeight: FontWeight.w500),
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
                Flexible(
                    flex: 2,
                    child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text(
                          "이메일",
                          style: TextStyle(fontSize: 16),
                        ))),
                Flexible(
                  flex: 5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: AutoSizeText(
                        widget.user.userEmail,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: MyThemeColors.myGreyscale[500],
                            fontWeight: FontWeight.w700),
                      )),
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            buildCustomButton(
              onTap: () {
                // NewNickName(context);
                NickName().myNicknameSheet(context, widget.user, 1, null);
              },
              backgroundColor: Colors.white,
              inside: Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text(
                          "닉네임 변경",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff393939)),
                        ))),
                Text(
                  widget.user.userNickName,
                  style: TextStyle(
                      fontSize: 16,
                      color: MyThemeColors.myGreyscale[500],
                      fontWeight: FontWeight.w700),
                ),
                const HeroIcon(
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
            Button(
              function: () {
                // widget.user.userInfoClear();
                // FirebaseAuth.instance.signOut();
                // widget.provider.movePage(0);
                // widget.provider.fireFlyOff();
                // Navigator.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return dialogWithYesOrNo(
                      context,
                      '로그아웃 하시겠나요?',
                      '',
                      '로그아웃',
                      //  on Yes
                      () {
                        _logout();
                      },
                      //  on No
                      () {
                        Navigator.pop(context);
                      },
                    );

                    /*
                    SettingDialog(
                      provider: widget.provider,
                      user: widget.user,
                      type: 0,
                    );
                    */
                  },
                );
              },
              title: "로그아웃",
              color: MyThemeColors.teritaryColor,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //계정탈퇴
            TextButton(
              onPressed: () {
                // widget.user.userInfoClear();
                // DeleteAccount(context, widget.provider);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return dialogWithYesOrNo(
                      context,
                      '정말로 떠나시는 건가요?',
                      '계정 탈퇴시 기존에 저장된 데이터는\n모두 삭제되고 복구가 불가능합니다.',
                      '탈퇴하기',
                      //  on Yes
                      () {
                        _deleteAccount();
                      },
                      //  on No
                      () {
                        Navigator.pop(context);
                      },
                    );

                    /*
                    SettingDialog(
                      provider: widget.provider,
                      user: widget.user,
                      type: 1,
                    );
                    */
                  },
                );
              },
              child: const Text(
                "계정탈퇴",
                style: TextStyle(
                    fontSize: 16,
                    color: MyThemeColors.teritaryColor,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ossLicensesView() {
    return Container(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: ossLicenses.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              backgroundColor: MyThemeColors.whiteColor,
              textColor: MyThemeColors.blackColor,
              collapsedBackgroundColor: MyThemeColors.whiteColor,
              collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(ossLicenses[index].name[0].toUpperCase() +
                  ossLicenses[index].name.substring(1)),
              subtitle: Text(ossLicenses[index].description),
              tilePadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              childrenPadding: EdgeInsets.all(10),
              children: [
                ListTile(
                  title: Text(
                    ossLicenses[index].license!,
                    style: TextStyle(
                        fontSize: 12, color: MyThemeColors.myGreyscale[600]),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("로그아웃");
    widget.user.userInfoClear();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    widget.provider.movePage(0);
    widget.provider.fireFlyOff();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> _deleteAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("계정탈퇴");
    widget.user.userInfoClear();
    await prefs.clear();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection("users").doc(userId).delete();
    GoogleSignIn().disconnect();
    await FirebaseAuth.instance.currentUser?.delete();
    widget.provider.movePage(0);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
