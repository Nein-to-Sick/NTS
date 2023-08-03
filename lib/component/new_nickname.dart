import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/component/button.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

void NewNickName(BuildContext context) {
  final newNameText = TextEditingController();

  void changeName(String name) {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update({"nickname": name});
      Navigator.pop(context);
      print("changed");
    } catch (e) {
      Navigator.pop(context);
      //로그아웃 실패시 실패했다는 알림을 보여줘야함.Navigator.pop(context);
      print("not changed");
    }
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
                  "새로운 닉네임을 입력해주세요.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                WrappedKoreanText(
                  "나중에 언제든지 바꿀 수 있어요",
                  style: TextStyle(
                      fontSize: 16, color: Colors.black.withOpacity(0.41)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: MyThemeColors.myGreyscale[200]!,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04),
                    child: TextField(
                      autocorrect: false,
                      controller: newNameText,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      maxLength: 12,
                      decoration: InputDecoration(
                        counter: Offstage(),
                        border: InputBorder.none,
                        hintText: "최대12글자",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: MyThemeColors.myGreyscale[300],
                          fontFamily: "SUIT",
                        ),
                      ),

                      //  enter(엔터) 키 이벤트 처리 with onSubmitted
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onTapOutside: (p) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Button(
                  function: newNameText.text.trim().isNotEmpty
                      ? () {
                          changeName(newNameText.text.trim());
                          Navigator.pop(context);
                        }
                      : () {},
                  title: "저장",
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      );
    },
  );
}
