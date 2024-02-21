import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nts/model/ai_chat_model.dart';

//  나와 대화하기 기능
class AIChatController with ChangeNotifier {
  bool isloading = false;
  // DB or device 저장 방법 고민 필요
  List<MessageModel> chatLog = [
    MessageModel(
        userMessage: '',
        AIMessage: '안녕! 요즘은 어떻게 지내고있어?',
        messagner: Messagner.ai,
        messgaType: MessageType.chat,
        messageTime: Timestamp.now())
  ];
  List<String> loadingMessages = ['음...', '잠시만요...', '어...', '한 번 생각해볼께요...'];
  List<OpenAIChatCompletionChoiceMessageModel> chatMemory = [];
  List<String> emotions = [
    'anger',
    'discomfort',
    'fear',
    'joy',
    'sad',
    'unkown'
  ];
  String emotionState = 'joy';

  /*
  system: 사전 설정, 역할 부여 등
  assistant: gpt의 응답, 이전 답변을 전달할 필요가 있음
  user: 사용자의 입력
  */
  void getResponse(String userInput) async {
    OpenAI.apiKey = dotenv.env['OpenAI_apiKey4.0']!;

    //  이전 대화 내역 최신화
    updateChatMemory(userInput);

    try {
      whileLoading(true);
      OpenAIChatCompletionModel chatCompletion =
          await OpenAI.instance.chat.create(
        model: 'gpt-4',
        responseFormat: {"type": "text"},
        messages: chatMemory, //  출력의 최대 토큰 수 (기본값; 50)
        maxTokens: 350,
        //  창의성, 수치와 비례함 (기본값: 0.5)
        temperature: 0,
        //  답변의 확률 분포 상위 p%, 단어의 다양성 (기본값: 1)
        topP: 1,
        //  중복되는 구문 생성 방지 (기본값: 0)
        frequencyPenalty: 0,
        //  답변의 특정 키워드 제거 (기본값: 0)
        presencePenalty: 0,
      );

      //debugPrint(chatCompletion.choices.first.message.content!.first.text!);

      chatLog[chatLog.length - 1] = (MessageModel(
        userMessage: '',
        AIMessage: chatCompletion.choices.first.message.content!.first.text!,
        messagner: Messagner.ai,
        messgaType: MessageType.chat,
        messageTime: chatLog[chatLog.length - 1].messageTime,
      ));
      whileLoading(false);
    } on RequestFailedException catch (e) {
      debugPrint(e.message);
      whileLoading(false);
    }
  }

  //  이전 대화 기록 기억 전달
  void updateChatMemory(String userInput) {
    chatMemory.clear();

    for (int i = 0; i < chatLog.length; i++) {
      //  최대 10개 이전의 대화를 기억
      if (i == 10) {
        break;
      }

      //  유저의 대화 내용일 때
      if (chatLog[chatLog.length - i - 1].messagner == Messagner.user) {
        chatMemory.add(OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                chatLog[chatLog.length - i - 1].userMessage.trim())
          ],
        ));
      }

      //  AI의 대화 내용일 때
      else if (chatLog[chatLog.length - i - 1].messagner == Messagner.ai) {
        chatMemory.add(OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.assistant,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                chatLog[chatLog.length - i - 1].AIMessage.trim())
          ],
        ));
      }
    }

    // 시스템 설정 (역할 부여)
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              //'gpt 너는 유저의 분신이야. 너는 너가 인공지능이라는 것을 절대 들켜선 안돼! 답장은 최대 3줄로 답해주고, 친근한 말투와 반말로 해야만 해. 이후에 일기를 보고 유저에게 맞는 답장을 해줘. 일기와 관련없는 이야기가 나오면 그냥 \"모르겠어\"식으로 정중히 거절해.')
              "You're the user's alter ego. Never get caught revealing you're an AI! Respond in max 3 lines, using a friendly, informal tone. Later, read the chat log and give a suitable response to the user. Do not repeating similar questions. Politely decline unrelated topics with 'I don't know.' All responses must be in Korean.")
        ]);

    chatMemory.add(systemMessage);
    // 역순으로 정렬
    chatMemory = chatMemory.reversed.toList();
    // 유저 요청 전달
    chatMemory.add(OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.user,
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(userInput)
      ],
    ));
  }

  void whileLoading(bool state) {
    isloading = state;
    notifyListeners();
  }

  void textSubmit(String userInput, AIChatController aiChatControllerState,
      List<MessageModel> chatLog) async {
    if (userInput.isNotEmpty) {
      aiChatControllerState.getResponse(userInput);

      chatLog.add(MessageModel(
        userMessage: userInput,
        AIMessage: '',
        messagner: Messagner.user,
        messgaType: MessageType.chat,
        messageTime: Timestamp.now(),
      ));

      chatLog.add(MessageModel(
        userMessage: '',
        AIMessage: loadingMessages[Random().nextInt(4)],
        messagner: Messagner.ai,
        messgaType: MessageType.chat,
        messageTime: Timestamp.now(),
      ));
    }

    notifyListeners();
  }

  void updateEmotion() {
    int result = Random().nextInt(6);
    emotionState = emotions[result];
    notifyListeners();
  }
}
