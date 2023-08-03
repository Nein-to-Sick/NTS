import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/home/home.dart';
import 'package:nts/main.dart';
import 'package:nts/model/user_info_model.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:provider/provider.dart';

void myNicknameSheet(
    BuildContext context, UserInfoValueModel userInfoProvider) {
  final userNickNameController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
              color: MyThemeColors.whiteColor,
              borderRadius: BorderRadius.circular(25)),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 35,
              ),
              Text("사용할 닉네임을 정해주세요"),
              const SizedBox(
                height: 5,
              ),
              Text("나중에 언제든지 바꿀 수 있어요"),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyThemeColors.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: TextField(
                      autocorrect: false,
                      controller: userNickNameController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "최대 12글자",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: MyThemeColors.myGreyscale.shade50,
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
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (userNickNameController.text.trim().isNotEmpty)
                    ? () {
                        userNickNameUpdate(
                            context, userNickNameController.text.trim());
                        userInfoProvider.userNickNameUpdate(
                            userNickNameController.text.trim());

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => BackgroundController(),
                                  ),
                                ],
                                child: const MyApp(),
                              ),
                            ),
                            (route) => false);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor:
                      (userNickNameController.text.trim().isNotEmpty)
                          ? MyThemeColors.whiteColor
                          : MyThemeColors.myGreyscale.shade900,
                  backgroundColor:
                      (userNickNameController.text.trim().isNotEmpty)
                          ? MyThemeColors.primaryColor
                          : MyThemeColors.myGreyscale.shade100,
                  surfaceTintColor: MyThemeColors.myGreyscale.shade100,
                  padding: const EdgeInsets.fromLTRB(45, 10, 45, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  '전송',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

//  user nickname firebase update
Future<void> userNickNameUpdate(
    BuildContext context, String newNickName) async {
  final userCollection = FirebaseFirestore.instance.collection("users");
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  await userCollection.doc(userId).update(
    {
      "nickname": newNickName,
      "nicknameMade": true,
    },
  );
}
