import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/components/emoticon.dart';
import 'package:nts/components/icon_buttons.dart';
import 'package:nts/controller/ai_chat_controller.dart';
import 'package:nts/controller/diary_controller.dart';
import 'package:nts/controller/search_controller.dart';
import 'package:nts/model/ai_chat_model.dart';
import 'package:nts/theme/custom_theme_data.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:nts/view/loading_pages/loading_page.dart';
import 'package:provider/provider.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key, required this.searchModel2});
  final ProfileSearchModel searchModel2;

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late Future<QuerySnapshot<Object?>> _aiChatFuture;

  @override
  void initState() {
    _aiChatFuture = widget.searchModel2.aiChatSearchResults;

    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final searchModel = Provider.of<ProfileSearchModel>(context);

    AIChatController aiChatControllerState =
        Provider.of<AIChatController>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: BandiColor.backgroundColor(context),
      appBar: AppBar(
        title: Text(
          "나와 대화하기",
          style: BandiFont.headline3(context)?.copyWith(
            color: BandiColor.primaryColor(context),
          ),
        ),
        backgroundColor: BandiColor.backgroundColor(context),
        leading: IconButtons(
          function: () {
            Navigator.pop(context);
          },
          disabled: false,
        ),
      ),
      // DB서 일기 기록을 가져옴
      body: FutureBuilder(
        future: _aiChatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final List<DiaryModel> diaries = [];
              return GestureDetector(
                onTap: () {
                  if (focusNode.hasFocus) {
                    focusNode.unfocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: BandiColor.primaryColor(context),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 40,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '🚨 데이터 베이스에서 \n정보를 가져오지 못했습니다!',
                                textAlign: TextAlign.center,
                                style: BandiFont.body3(context)?.copyWith(
                                  color: BandiColor.backgroundColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: chatBubbleUI(
                              aiChatControllerState.chatLog, context)),
                      const SizedBox(
                        height: 20,
                      ),
                      messageBarUI(aiChatControllerState.chatLog, context,
                          textController, focusNode, diaries),
                    ],
                  ),
                ),
              );
            }
            final List<DiaryModel> diaries = snapshot.data!.docs
                .map((DocumentSnapshot doc) => DiaryModel.fromSnapshot(doc))
                .toList();
            return GestureDetector(
              onTap: () {
                if (focusNode.hasFocus) {
                  focusNode.unfocus();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: BandiColor.primaryColor(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        height: 40,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '개발 버전으로 최대 10개의 최근 기록만을 불러옵니다!',
                              textAlign: TextAlign.center,
                              style: BandiFont.body3(context)?.copyWith(
                                color: BandiColor.backgroundColor(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: chatBubbleUI(
                            aiChatControllerState.chatLog, context)),
                    const SizedBox(
                      height: 20,
                    ),
                    messageBarUI(aiChatControllerState.chatLog, context,
                        textController, focusNode, diaries),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: MyFireFlyProgressbar(
                loadingText: '일기 불러오는 중...',
                textColor: MyThemeColors.blackColor,
              ),
            );
          }
        },
      ),
    );
  }

  Widget chatBubbleUI(List<MessageModel> chatLog, BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: chatLog.length,
      itemBuilder: (context, index) {
        return Padding(
          //  서로 다른 사용자의 채팅 간 공백 추가
          padding: EdgeInsets.only(
              bottom: (index > 0 &&
                      chatLog[index].messagner != chatLog[index - 1].messagner)
                  ? 14
                  : 0),
          child: Padding(
            //  최상하단 채팅 공백 추가
            padding: EdgeInsets.only(
                bottom: (index == 0) ? 20 : 3.5,
                top: (index == chatLog.length - 1) ? 20 : 0),
            child: (chatLog[index].messagner == Messagner.user)
                ? userChatBubble(chatLog[chatLog.length - 1 - index])
                : aiChatBubble(chatLog[chatLog.length - 1 - index]),
          ),
        );
      },
    );
  }

  Widget userChatBubble(MessageModel chatLog) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          formatTimestamp(chatLog.messageTime),
          // 폰트 사이즈가 없음 수정 필요
          style: BandiFont.body3(context)?.copyWith(
            color: BandiColor.gray004Color(context),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        IntrinsicWidth(
          child: Container(
            constraints: BoxConstraints(
                minHeight: 31,
                maxWidth: MediaQuery.of(context).size.width * 0.55),
            decoration: BoxDecoration(
              color: BandiColor.primaryColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 3.5),
              child: Center(
                child: Text(
                  chatLog.userMessage,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: BandiFont.body2(context)
                      ?.copyWith(color: BandiColor.backgroundColor(context)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget aiChatBubble(
    MessageModel chatLog,
  ) {
    AIChatController aiChatControllerState =
        Provider.of<AIChatController>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Emotion(
                size: "medium", emotion: aiChatControllerState.emotionState),
            const SizedBox(
              width: 10,
            ),
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                    minHeight: 31,
                    maxWidth: MediaQuery.of(context).size.width * 0.5),
                decoration: BoxDecoration(
                  color: BandiColor.gray001Color(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 3.5),
                  child: Center(
                    child: Text(
                      chatLog.AIMessage,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: BandiFont.body2(context)
                          ?.copyWith(color: BandiColor.gray005Color(context)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          formatTimestamp(chatLog.messageTime),
          // 폰트 사이즈가 없음 수정 필요
          style: BandiFont.body3(context)?.copyWith(
            color: BandiColor.gray004Color(context),
          ),
        )
      ],
    );
  }

  Widget messageBarUI(
      List<MessageModel> chatLog,
      BuildContext context,
      TextEditingController textController,
      FocusNode focusNode,
      List<DiaryModel> diaries) {
    AIChatController aiChatControllerState =
        Provider.of<AIChatController>(context);

    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.5),
                    child: OSmallNoIcon(
                      title: 'test & test',
                      function: () {},
                      disabled: false,
                    ),
                  );
                }),
          ),
          */
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: BandiColor.gray001Color(context),
                      border: Border.all(
                        color: BandiColor.gray001Color(context),
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: IgnorePointer(
                    ignoring: aiChatControllerState.isloading,
                    child: Center(
                      child: TextField(
                        controller: textController,
                        focusNode: focusNode,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        cursorColor: BandiColor.gray004Color(context),
                        style: BandiFont.text2(context)?.copyWith(
                          color: BandiColor.primaryColor(context),
                        ),
                        decoration: InputDecoration(
                          hintText: (aiChatControllerState.isloading)
                              ? '답을 생각하고 있어요'
                              : '기뻤던 날들의 기록을 찾아줘...',
                          hintStyle: BandiFont.text2(context)?.copyWith(
                            color: BandiColor.gray003Color(context),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 17,
              ),
              GestureDetector(
                child: HeroIcon(
                  HeroIcons.paperAirplane,
                  style: HeroIconStyle.mini,
                  color: BandiColor.primaryColor(context),
                  size: 24,
                ),
                onTap: () {
                  if (!aiChatControllerState.isloading) {
                    aiChatControllerState.updateUserDiary(diaries);
                    aiChatControllerState.textSubmit(textController.text.trim(),
                        aiChatControllerState, chatLog);
                    textController.clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    // Timestamp를 DateTime으로 변환
    DateTime dateTime = timestamp.toDate();

    // HH:MM 형식으로 시간 포맷
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }
}
