import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/controller/diary_controller.dart';
import 'package:nts/controller/search_controller.dart';
import 'package:nts/view/Theme/theme_colors.dart';

class ReadDiaryDialog extends StatefulWidget {
  final DiaryModel diaryContent;
  final ProfileSearchModel searchModel;
  const ReadDiaryDialog({
    super.key,
    required this.diaryContent,
    required this.searchModel,
  });

  @override
  State<ReadDiaryDialog> createState() => _ReadDiaryDialogState();
}

class _ReadDiaryDialogState extends State<ReadDiaryDialog> {
  TextEditingController diaryTextController = TextEditingController();
  TextEditingController diaryTitleController = TextEditingController();
  bool editMode = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    diaryTextController.text = widget.diaryContent.content;
    diaryTitleController.text = widget.diaryContent.title;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String firstContent = widget.diaryContent.content;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: MyThemeColors.myGreyscale[25],
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
            child: Column(
              children: [
                //  close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Opacity(
                        opacity: 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: HeroIcon(
                              HeroIcons.xMark,
                              size: 23,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  '일기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyThemeColors.myGreyscale.shade900,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //  diary content and close button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (!editMode)
                                  ? Colors.transparent
                                  : MyThemeColors.myGreyscale.shade200,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (!editMode)
                                    ? Colors.transparent
                                    : MyThemeColors.myGreyscale.shade100,
                                blurRadius:
                                (!editMode) ? 0 : 0.5, // 그림자의 흐림 정도
                                spreadRadius: 0.25, // 그림자의 확장 정도
                                offset: const Offset(0, 1), // 그림자의 위치
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: MyThemeColors.myGreyscale.shade50,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: TextField(
                              focusNode: _focusNode,
                              onSubmitted: (value) {
                                FocusScope.of(context)
                                    .unfocus();
                              },
                              onTapOutside: (p) {
                                FocusScope.of(context)
                                    .unfocus();
                              },
                              readOnly: !editMode,
                              controller: diaryTitleController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Dodam',
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Dodam",
                                  color: MyThemeColors
                                      .myGreyscale[300],
                                ),
                              ),
                              maxLines: null,
                              // maxLength: 300,
                              keyboardType:
                              TextInputType.multiline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom *
                                        0.4),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(_focusNode);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: (!editMode)
                                        ? Colors.transparent
                                        : MyThemeColors.myGreyscale.shade200,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (!editMode)
                                          ? Colors.transparent
                                          : MyThemeColors.myGreyscale.shade100,
                                      blurRadius:
                                          (!editMode) ? 0 : 0.5, // 그림자의 흐림 정도
                                      spreadRadius: 0.25, // 그림자의 확장 정도
                                      offset: const Offset(0, 1), // 그림자의 위치
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyThemeColors.myGreyscale.shade50,
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 13, 15, 13),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            TextField(
                                              focusNode: _focusNode,
                                              onSubmitted: (value) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              onTapOutside: (p) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              onChanged: (value) {},
                                              readOnly: !editMode,
                                              controller: diaryTextController,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Dodam',
                                              ),
                                              decoration: InputDecoration(
                                                counterText: "",
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Dodam",
                                                  color: MyThemeColors
                                                      .myGreyscale[300],
                                                ),
                                              ),
                                              maxLines: null,
                                              // maxLength: 300,
                                              keyboardType:
                                                  TextInputType.multiline,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${diaryTextController.text.length} 자",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                MyThemeColors.myGreyscale[200],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        //  close button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              //  close button
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color:
                                            MyThemeColors.myGreyscale.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Text(
                                        (!editMode) ? "수정" : "취소",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: MyThemeColors.primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      editMode = !editMode;
                                    });
                                    if (editMode) {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNode);
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              //
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: MyThemeColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Text(
                                        (!editMode) ? "닫기" : "저장",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: MyThemeColors.whiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!editMode) {
                                      Navigator.pop(context);
                                    }
                                    //  update diary content
                                    else {
                                      widget.searchModel.refreshBuilder();
                                      //  실제로 수정된 경우만 파이어베이스 쓰기
                                      if (firstContent.compareTo(
                                              diaryTextController.text) !=
                                          0) {
                                        String? userId = FirebaseAuth
                                            .instance.currentUser?.uid;
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(userId)
                                            .collection("diary")
                                            .doc(widget.diaryContent.path)
                                            .update({
                                          "title": diaryTitleController.text,
                                          "content":
                                              diaryTextController.text.trim()
                                        });
                                        widget.diaryContent.updateDiaryContent(
                                            diaryTextController.text.trim());
                                      }
                                      setState(() {
                                        editMode = !editMode;
                                      });
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            '일기가 저장되었습니다!',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          duration:
                                              Duration(milliseconds: 2000),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
