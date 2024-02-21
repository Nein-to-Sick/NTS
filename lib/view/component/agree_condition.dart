import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/component/webView.dart';
import 'package:path_provider/path_provider.dart';

class AgreementSheet {
  void agreementTermSheet(BuildContext context, dynamic pageController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      barrierColor: Colors.transparent,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return AgreementStatful(
          pageController: pageController,
        );
      },
    );
  }
}

class AgreementStatful extends StatefulWidget {
  final dynamic pageController;

  const AgreementStatful({super.key, this.pageController});

  @override
  State<AgreementStatful> createState() => _AgreementStatfulState();
}

class _AgreementStatfulState extends State<AgreementStatful> {
  bool allSelected = false;
  bool option1Selected = false;
  bool option2Selected = false;
  bool option3Selected = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: MyThemeColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: 390,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "이용 약관 동의",
                  style: TextStyle(
                    color: MyThemeColors.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    '전체 동의',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SUITE',
                    ),
                  ),
                  activeColor: MyThemeColors.primaryColor,
                  value: allSelected,
                  onChanged: (newValue) {
                    setState(() {
                      allSelected = newValue!;
                      option1Selected = newValue;
                      option2Selected = newValue;
                      option3Selected = newValue;
                    });
                  }),
              Container(
                width: double.maxFinite,
                height: 1.5,
                decoration:
                    const BoxDecoration(color: MyThemeColors.blackColor),
              ),
              CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    '(필수) 만 14세 이상이신가요?',
                    style: TextStyle(fontSize: 13),
                  ),
                  activeColor: MyThemeColors.primaryColor,
                  value: option1Selected,
                  onChanged: (newValue) {
                    setState(() {
                      option1Selected = newValue!;
                      allSelected =
                          option1Selected && option2Selected && option3Selected;
                    });
                  }),
              CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebView(
                                    title: "person",
                                  )));
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '(필수) '),
                          TextSpan(
                            text: '개인정보처리동의서',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: '에 동의하시나요?'),
                        ],
                      ),
                    ),
                  ),
                  activeColor: MyThemeColors.primaryColor,
                  value: option2Selected,
                  onChanged: (newValue) {
                    setState(() {
                      option2Selected = newValue!;
                      allSelected =
                          option1Selected && option2Selected && option3Selected;
                    });
                  }),
              CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebView(
                                    title: "service",
                                  )));
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: '(필수) '),
                          TextSpan(
                            text: '이용약관',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: '에 동의하시나요?'),
                        ],
                      ),
                    ),
                  ),
                  activeColor: MyThemeColors.primaryColor,
                  value: option3Selected,
                  onChanged: (newValue) {
                    setState(() {
                      option3Selected = newValue!;
                      allSelected =
                          option1Selected && option2Selected && option3Selected;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (allSelected) {
                    userAgreementFirebaseUpdate();
                    widget.pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: (allSelected)
                      ? MyThemeColors.whiteColor
                      : MyThemeColors.myGreyscale.shade900,
                  backgroundColor: (allSelected)
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
                  '다음',
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
  }

  //  user agreement firebase update
  Future<void> userAgreementFirebaseUpdate() async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await userCollection.doc(userId).update(
      {
        "isAgreed": true,
        "last_agreed_at": DateTime.now(),
      },
    );
  }
}
