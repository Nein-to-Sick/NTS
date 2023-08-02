import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
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
                      const Text(
                        "설정",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff393939)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "닉네임 변경",
                                    style: TextStyle(fontSize: 16),
                                  ))),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Text(
                                "하루",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff868686)),
                              )),
                        ]),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "알림 설정",
                                    style: TextStyle(fontSize: 16),
                                  ))),
                          // CustomAnimatedToggleSwitch<bool>(
                          //   current: positive,
                          //   values: [false, true],
                          //   dif: 0.0,
                          //   indicatorSize: Size.square(30.0),
                          //   animationDuration:
                          //       const Duration(milliseconds: 200),
                          //   animationCurve: Curves.linear,
                          //   onChanged: (b) => setState(() => positive = b),
                          //   iconBuilder: (context, local, global) {
                          //     return const SizedBox();
                          //   },
                          //   defaultCursor: SystemMouseCursors.click,
                          //   onTap: () => setState(() => positive = !positive),
                          //   iconsTappable: false,
                          //   wrapperBuilder: (context, global, child) {
                          //     return Stack(
                          //       alignment: Alignment.center,
                          //       children: [
                          //         Positioned(
                          //             left: 10.0,
                          //             right: 10.0,
                          //             height: 20.0,
                          //             child: DecoratedBox(
                          //               decoration: BoxDecoration(
                          //                 color: Colors.black26,
                          //                 borderRadius: const BorderRadius.all(
                          //                     Radius.circular(50.0)),
                          //               ),
                          //             )),
                          //         child,
                          //       ],
                          //     );
                          //   },
                          //   foregroundIndicatorBuilder: (context, global) {
                          //     return SizedBox.fromSize(
                          //       size: global.indicatorSize,
                          //       child: DecoratedBox(
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(50.0)),
                          //           boxShadow: const [
                          //             BoxShadow(
                          //                 color: Colors.black38,
                          //                 spreadRadius: 0.05,
                          //                 blurRadius: 1.1,
                          //                 offset: Offset(0.0, 0.8))
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ]),
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