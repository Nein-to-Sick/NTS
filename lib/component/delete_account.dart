import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../provider/backgroundController.dart';

void DeleteAccount(BuildContext context, BackgroundController provider) {
  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser!.providerData.first;
      // currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance.collection("users").doc(userId).delete();

      await FirebaseAuth.instance.currentUser?.delete();

      provider.movePage(0);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Handle exceptions
      Navigator.pop(context);
      //로그아웃 실패시 실패했다는 알림을 보여줘야함.Navigator.pop(context);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('소중한 의견 감사드립니다!'),
          dismissDirection: DismissDirection.vertical,
        ),
      );
    }
  }

  Widget buildCustomButton(
      {required Color backgroundColor,
      required Color textColor,
      required String word,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: AutoSizeText(
            word,
            style: TextStyle(color: textColor, fontSize: 16),
          )),
    );
  }

  showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    // color: AppColors.haruPrimary.shade300,
                    color: MyThemeColors.myGreyscale[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                AutoSizeText(
                  "정말로 떠나시는 건가요?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Expanded(
                  child: WrappedKoreanText(
                    "계정 탈퇴시 기존에 저장된 데이터는 모두 삭제되고 복구가 불가능합니다.",
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.41)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCustomButton(
                        backgroundColor: MyThemeColors.myGreyscale[200]!,
                        textColor: MyThemeColors.primaryColor!,
                        word: "탈퇴하기",
                        onTap: () async {
                          _reauthenticateAndDelete();
                        }),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    buildCustomButton(
                        backgroundColor: MyThemeColors.primaryColor!,
                        textColor: MyThemeColors.myGreyscale[0]!,
                        word: "취소",
                        onTap: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      );
    },
  );
}
