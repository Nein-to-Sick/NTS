import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool positive = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "설정",
                        style: TextStyle(
                          fontSize: 20,
                          color: MyThemeColors.myGreyscale.shade900,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text(
                                    "닉네임 변경",
                                    style: TextStyle(fontSize: 16),
                                  ))),
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text(
                                "하루",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyThemeColors.myGreyscale.shade500,
                                ),
                              )),
                        ]),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text(
                                    "알림 설정",
                                    style: TextStyle(fontSize: 16),
                                  ))),
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: CustomAnimatedToggleSwitch<bool>(
                              current: positive,
                              values: [false, true],
                              dif: 0.0,
                              indicatorSize: const Size.square(30.0),
                              animationDuration:
                                  const Duration(milliseconds: 200),
                              animationCurve: Curves.linear,
                              onChanged: (b) => setState(() => positive = b),
                              iconBuilder: (context, local, global) {
                                return const SizedBox();
                              },
                              defaultCursor: SystemMouseCursors.click,
                              onTap: () => setState(() => positive = !positive),
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
                                              color: MyThemeColors
                                                  .myGreyscale.shade50,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                              border: Border.all(
                                                width: 3.0,
                                                color: MyThemeColors
                                                    .myGreyscale.shade200,
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
                                      color: MyThemeColors.myGreyscale.shade200,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MyThemeColors
                                                .myGreyscale.shade200,
                                            spreadRadius: 0.05,
                                            blurRadius: 1.1,
                                            offset: const Offset(0.0, 0.8))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: MyThemeColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "로그아웃",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "계정탈퇴",
                              style: TextStyle(
                                fontSize: 16,
                                color: MyThemeColors.secondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Text("이용약관",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ),
                            ),
                            HeroIcon(
                              HeroIcons.chevronRight,
                              color: MyThemeColors.myGreyscale.shade300,
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Text("개인정보 처리방침",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ),
                            ),
                            HeroIcon(
                              HeroIcons.chevronRight,
                              color: MyThemeColors.myGreyscale.shade300,
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: const Text("사업자 정보",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ),
                            ),
                            HeroIcon(
                              HeroIcons.chevronRight,
                              color: MyThemeColors.myGreyscale.shade300,
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
}
