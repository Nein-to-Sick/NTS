import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/diaryModel.dart';
import 'package:nts/model/search_model.dart';

class ReadDiaryDialog extends StatefulWidget {
  final DiaryModel diaryContent;
  final ProfileSearchModel searchModel;
  final Function refreshFunction;
  const ReadDiaryDialog(
      {super.key,
      required this.diaryContent,
      required this.searchModel,
      required this.refreshFunction});

  @override
  State<ReadDiaryDialog> createState() => _ReadDiaryDialogState();
}

class _ReadDiaryDialogState extends State<ReadDiaryDialog> {
  TextEditingController diaryTextController = TextEditingController();

  bool editMode = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    diaryTextController.text = widget.diaryContent.content;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: MyThemeColors.myGreyscale.shade50,
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.9,
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
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            MyThemeColors.myGreyscale.shade100,
                                        blurRadius: 0.5, // 그림자의 흐림 정도
                                        spreadRadius: 0.5, // 그림자의 확장 정도
                                        offset: const Offset(0, 3), // 그림자의 위치
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 13, 15, 13),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: TextField(
                                      focusNode: _focusNode,
                                      onSubmitted: (value) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      onTapOutside: (p) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      onChanged: (value) {
                                        widget.searchModel
                                            .updateDiaryContent(value.trim());
                                      },
                                      readOnly: !editMode,
                                      controller: diaryTextController,
                                      style: const TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Dodam",
                                          color: MyThemeColors.myGreyscale[300],
                                        ),
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),
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
                                      String? userId = FirebaseAuth
                                          .instance.currentUser?.uid;
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userId)
                                          .collection("diary")
                                          .doc(widget.diaryContent.path)
                                          .update({
                                        "content":
                                            widget.searchModel.diaryContent
                                      });
                                      setState(() {
                                        editMode = !editMode;
                                      });
                                      widget.refreshFunction();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            '일기가 수정되었습니다!',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          duration: Duration(seconds: 5),
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
