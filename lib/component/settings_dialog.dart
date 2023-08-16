import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class SettingDialog extends StatefulWidget {
  final BackgroundController provider;
  final UserInfoValueModel user;
  final int type;

  const SettingDialog(
      {Key? key,
      required this.provider,
      required this.user,
      required this.type})
      : super(key: key);

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    void _logout() {
      print("로그아웃");
      widget.user.userInfoClear();
      FirebaseAuth.instance.signOut();
      widget.provider.movePage(0);
      widget.provider.fireFlyOff();
      Navigator.pop(context);
      Navigator.pop(context);
    }

    Future<void> _deleteAccount() async {
      print("계정탈퇴");
      widget.user.userInfoClear();
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance.collection("users").doc(userId).delete();
      await FirebaseAuth.instance.currentUser?.delete();
      widget.provider.movePage(0);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return Dialog(
      backgroundColor: MyThemeColors.myGreyscale[25],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ), //openLicense
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: (widget.type == 1)
            ? MediaQuery.of(context).size.height * 0.225
            : MediaQuery.of(context).size.height * 0.18,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.01,
              MediaQuery.of(context).size.height * 0.04,
              MediaQuery.of(context).size.width * 0.01,
              MediaQuery.of(context).size.height * 0.01),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: (widget.type == 1)
                      ? MediaQuery.of(context).size.width * 0.45
                      : MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (widget.type == 1)
                            ? "정말로 떠나시는 건가요?"
                            : "정말로 로그아웃하시는 건가요?",
                        style: TextStyle(
                            fontSize: 20,
                            color: MyThemeColors.myGreyscale[900],
                            fontWeight: FontWeight.bold),
                      ),
                      (widget.type == 1)
                          ? Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: WrappedKoreanText(
                                    "계정 탈퇴시 기존에 저장된 데이터는 모두 삭제되고 복구가 불가능합니다.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: MyThemeColors.myGreyscale[400],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                              ],
                            )
                          : SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          // color: MyThemeColors.myGreyscale[200],
                          width: MediaQuery.of(context).size.width * 0.275,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: MyThemeColors.myGreyscale[200],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "취소",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyThemeColors.myGreyscale[900]),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.275,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: MyThemeColors.teritaryColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            (widget.type == 1) ? "탈퇴하기" : "로그아웃",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: MyThemeColors.whiteColor),
                          ),
                        ),
                        onTap: () {
                          (widget.type == 1) ? _deleteAccount() : _logout();
                        },
                      ),
                    ],
                  ),
                )
                // mainsettingView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
