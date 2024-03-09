import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nts/controller/background_controller.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

void z(BuildContext context, BackgroundController provider) {
  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser!.providerData.first;
      // currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance.collection("users").doc(userId).delete();

      provider.movePage(0);

      AuthCredential credential;
      UserCredential? temp;

      for (UserInfo userInfo
          in FirebaseAuth.instance.currentUser!.providerData) {
        // providerId가 "google.com"이면 구글 로그인
        if (userInfo.providerId == 'google.com') {
          GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          GoogleSignInAuthentication googleAuth =
              await googleUser!.authentication;
          credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          temp = await FirebaseAuth.instance.currentUser
              ?.reauthenticateWithCredential(credential);
        }
        // providerId가 "apple.com"이면 애플 로그인
        else if (userInfo.providerId == 'apple.com') {
          final AuthorizationCredentialAppleID appleCredential =
              await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          final OAuthProvider oAuthProvider = OAuthProvider("apple.com");

          credential = oAuthProvider.credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );

          temp = await FirebaseAuth.instance.currentUser
              ?.reauthenticateWithCredential(credential);
        }
      }

      await temp!.user!.delete().then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } catch (e) {
      await Future.delayed(Duration.zero).then((value) {
        // Handle exceptions
        Navigator.pop(context);
        // 계정 탈퇴 실패시 실패했다는 알림을 보여줘야함.Navigator.pop(context);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('계정 탈퇴중 오류가 발생하였습니다.'),
            dismissDirection: DismissDirection.vertical,
          ),
        );
      });
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
    shape: const RoundedRectangleBorder(
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
                const AutoSizeText(
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
                        textColor: MyThemeColors.primaryColor,
                        word: "탈퇴하기",
                        onTap: () async {
                          _reauthenticateAndDelete();
                        }),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    buildCustomButton(
                        backgroundColor: MyThemeColors.primaryColor,
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
