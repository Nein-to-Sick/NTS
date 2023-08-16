import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/user_info_model.dart';

class NickName {
  void myNicknameSheet(BuildContext context,
      UserInfoValueModel userInfoProvider, int type, dynamic pageController) {
    String printitle = (type == 1) ? "새로운 닉네임을 입력해주세요" : "사용할 닉네임을 정해주세요";
    final userNickNameController = TextEditingController();
    userNickNameController.text = (userInfoProvider.userNickName.isEmpty)
        ? ""
        : userInfoProvider.userNickName;
    int nickNameLength = userNickNameController.text.length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: (type == 1) ? true : false,
      barrierColor: Colors.transparent,
      enableDrag: (type == 1) ? true : false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                  color: MyThemeColors.whiteColor,
                  borderRadius: BorderRadius.circular(25)),
              height: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  (type == 1)
                      ? Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 4,
                                  width: 61.86,
                                  color: MyThemeColors.myGreyscale[50]),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 32,
                        ),
                  Text(
                    printitle,
                    style: const TextStyle(
                        color: MyThemeColors.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "나중에 언제든지 바꿀 수 있어요",
                    style: TextStyle(
                      color: MyThemeColors.myGreyscale.shade600,
                      fontSize: 15,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(Icons.abc)),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50, bottom: 5),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "$nickNameLength/12",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MyThemeColors.myGreyscale[200],
                        ),
                      ),
                    ),
                  ),
                  //  nickname textfield
                  Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: SizedBox(
                      height: 80,
                      child: TextField(
                        controller: userNickNameController,
                        keyboardType: TextInputType.multiline,
                        autocorrect: false,
                        maxLength: 12,

                        //  enter(엔터) 키 이벤트 처리 with onSubmitted
                        textInputAction: TextInputAction.go,

                        onChanged: (value) {
                          nickNameLength = userNickNameController.text.length;
                          if (userNickNameController.text.trim().isNotEmpty) {
                            userInfoProvider.valueUpdate();
                          } else {
                            userInfoProvider.valueDeUpdate();
                          }
                        },
                        onSubmitted: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        onTapOutside: (p) {
                          FocusScope.of(context).unfocus();
                        },

                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: MyThemeColors.myGreyscale.shade200,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: MyThemeColors.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: MyThemeColors.myGreyscale.shade50,
                          filled: true,
                          hintText: '최대 12글자',
                          hintStyle: TextStyle(
                            color: MyThemeColors.myGreyscale.shade200,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: (userInfoProvider.isValueEntered)
                        ? () {
                            userNickNameFirebaseUpdate(
                                context, userNickNameController.text.trim());
                            userInfoProvider.userNickNameUpdate(
                                userNickNameController.text.trim());

                            if (type == 0) {
                              pageController.animateToPage(4,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            }

                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: (userInfoProvider.isValueEntered)
                          ? MyThemeColors.whiteColor
                          : MyThemeColors.myGreyscale.shade900,
                      backgroundColor: (userInfoProvider.isValueEntered)
                          ? MyThemeColors.primaryColor
                          : MyThemeColors.myGreyscale.shade100,
                      surfaceTintColor: MyThemeColors.myGreyscale.shade100,
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 2 - 55,
                          15,
                          MediaQuery.of(context).size.width / 2 - 55,
                          15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//  user nickname firebase update
  Future<void> userNickNameFirebaseUpdate(
      BuildContext context, String newNickName) async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await userCollection.doc(userId).update(
      {
        "nickname": newNickName,
      },
    );
  }
}
