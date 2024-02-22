import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:nts/model/preset_model.dart';

class GPTModel with ChangeNotifier {
  //  while diary anlyzing
  bool isOnLoading = false;
  //  ahen after analye done
  bool isAnalyzed = false;
  //  AI setting state
  bool isAIUsing = true;
  String diaryMainText = '';
  String diaryTitle = '';
  List<String> situationSummerization = List<String>.empty(growable: true);
  List<String> emotionSummerization = List<String>.empty(growable: true);
  List<OpenAIChatCompletionChoiceMessageModel> situationMemory = [];
  List<OpenAIChatCompletionChoiceMessageModel> emotionMemory = [];
  List<OpenAIChatCompletionChoiceMessageModel> titleMemory = [];

  //  일기 내용 저장
  void updateDiaryMainText(value) {
    diaryMainText = value.toString().trim();
    notifyListeners();
  }

  void updateAIUsingSetting(value) {
    isAIUsing = value;
    notifyListeners();
  }

  void whileLoadingStart() {
    isOnLoading = true;
    notifyListeners();
  }

  void whileLoadingDone() {
    isOnLoading = false;
    notifyListeners();
  }

  //  한 일기는 한 번만 분석
  void startAnalyzeDiary() {
    isAnalyzed = true;
    notifyListeners();
  }

  //  기록할 경우 변수 초기화
  void endAnalyzeDiary() {
    isAnalyzed = false;
    isOnLoading = false;
    situationSummerization.clear();
    emotionSummerization.clear();
    diaryMainText = '';
    diaryTitle = '';
    notifyListeners();
  }

  void tryAnalyzeDiary(String prompt) async {
    List<String> randomEmotionList = [];

    // 각각의 List에서 5개씩 랜덤으로 선택하여 새로운 List에 추가
    for (List<String> subList in Preset().emotion) {
      subList.shuffle(); // 각 List를 섞음
      randomEmotionList
          .addAll(subList.take(5)); // 각 List에서 5개씩 선택하여 새로운 List에 추가
    }

    String selectedEmotionsString = randomEmotionList.join(', ');
    print(selectedEmotionsString);

    // 시스템 설정 (역할 부여)
    final situationMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "너는 상황 분석가로 요구에따라 핵심 상황을 파악해야해. 다음의 일기에서 파악되는 상황을 <가족, 연애, 친구관계, 직장, 학교, 군대, 진로, 일상생활, 공부, 일, 건강, 종교, 운동, 취미생활, 돈, 불면, 자존감, 날씨> 중에서만 최대 3개를 선택해서 정리해. <$prompt>, 정리한 내용은 반드시 다음 형식으로 만들어 <[단어, 단어, ...]>",
          )
        ]);
    situationMemory.clear();
    situationMemory.add(situationMessage);

    if (isAIUsing == true && isAnalyzed == false) {
      String emotionsTemp = '';
      String situationTemp = '';
      OpenAI.apiKey = dotenv.env['OpenAI_apiKey']!;
      try {
        //  situation analysis
        final situationGPT = await OpenAI.instance.chat.create(
          //  사용하는 모델
          model: 'gpt-3.5-turbo',
          //  출력의 최대 토큰 수 (기본값; 50)
          maxTokens: 50,
          //  창의성, 수치와 비례함 (기본값: 0.5)
          temperature: 0,
          //  답변의 확률 분포 상위 p%, 단어의 다양성 (기본값: 1)
          topP: 1,
          //  중복되는 구문 생성 방지 (기본값: 0)
          frequencyPenalty: 0,
          //  답변의 특정 키워드 제거 (기본값: 0)
          presencePenalty: 0,
          messages: situationMemory,
          /*
            OpenAIChatCompletionChoiceMessageModel(
              content:
                  "너는 전문 상황 분석가로 요구에따라 핵심 상황을 파악해야해. 다음의 일기에서 파악되는 상황을 <가족, 연애, 친구관계, 직장, 학교, 군대, 진로, 일상생활, 공부, 일, 건강, 종교, 운동, 취미생활, 돈, 불면, 자존감, 날씨> 중에서만 최대 3개를 선택해서 정리해. <$prompt>, 정리한 내용은 반드시 다음 형식으로 만들어 <[단어, 단어, ...]>",
              role: OpenAIChatMessageRole.system,
            ),
            */
        );

        // 시스템 설정 (역할 부여)
        final emotionMessage = OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "너는 감정 분석가로 요구에따라 핵심 감정을 파악해야해. 다음의 일기에서 파악되는 감정을 <$selectedEmotionsString> 중에서 최대한 유사한 것을 5개 선택해. <$prompt>, 정리한 내용은 반드시 다음 형식으로 만들어 <[단어, 단어, ...]>",
              )
            ]);
        emotionMemory.clear();
        emotionMemory.add(emotionMessage);

        //  emotion analysis
        final emotionGPT = await OpenAI.instance.chat.create(
          //  사용하는 모델
          model: 'gpt-3.5-turbo',
          //  출력의 최대 토큰 수 (기본값; 50)
          maxTokens: 100,
          //  창의성, 수치와 비례함 (기본값: 0.5)
          temperature: 0.5,
          //  답변의 확률 분포 상위 p%, 단어의 다양성 (기본값: 1)
          topP: 1,
          //  중복되는 구문 생성 방지 (기본값: 0)
          frequencyPenalty: 0,
          //  답변의 특정 키워드 제거 (기본값: 0)
          presencePenalty: 0,
          messages: emotionMemory,
          /*
            OpenAIChatCompletionChoiceMessageModel(
              content:
                  "너는 전문 감정 분석가로 요구에따라 핵심 감정을 파악해야해. 다음의 일기에서 파악되는 감정을 <기쁨, 감사함, 기대됨, 설렘, 놀람, 지루함, 피곤함, 답답함, 짜증남, 무기력함, 우울함, 슬픔, 화남, 걱정, 두려움> 중에서만 최대 3개를 선택해서 정리해. <$prompt>, 정리한 내용은 반드시 다음 형식으로 만들어 <[단어, 단어, ...]>",
              role: OpenAIChatMessageRole.system,
            ),
            */
        );

        // 시스템 설정 (역할 부여)
        final titleMessage = OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "글의 내용을 15자 이내의 한 구절로 요약해줘. <$prompt>",
              )
            ]);
        titleMemory.clear();
        titleMemory.add(titleMessage);

        // diary title
        final titleGPT = await OpenAI.instance.chat.create(
          //  사용하는 모델
          model: 'gpt-3.5-turbo',
          //  출력의 최대 토큰 수 (기본값; 50)
          maxTokens: 25,
          //  창의성, 수치와 비례함 (기본값: 0.5)
          temperature: 0,
          //  답변의 확률 분포 상위 p%, 단어의 다양성 (기본값: 1)
          topP: 1,
          //  중복되는 구문 생성 방지 (기본값: 0)
          frequencyPenalty: 0,
          //  답변의 특정 키워드 제거 (기본값: 0)
          presencePenalty: 0,
          messages: titleMemory,
          /*
            OpenAIChatCompletionChoiceMessageModel(
              content: "글의 내용을 15자 이내의 한 구절로 요약해줘. <$prompt>",
              role: OpenAIChatMessageRole.system,
            ),
          */
        );

        //  result to variables
        situationTemp = situationGPT.choices.first.message.content!.first.text!;
        emotionsTemp = emotionGPT.choices.first.message.content!.first.text!;
        diaryTitle = titleGPT.choices.first.message.content!.first.text!;

        //  split emotions into List<String>
        emotionSummerization = emotionsTemp
            .substring(1, emotionsTemp.length - 1)
            .split(', ')
            .map((value) => value.trim())
            .toList();
        situationSummerization = situationTemp
            .substring(1, situationTemp.length - 1)
            .split(', ')
            .map((value) => value.trim())
            .toList();

        // print(situationGPT.choices.first.message.content);
        // print(emotionGPT.choices.first.message.content);
        // for (int i = 0; i < emotionSummerization.length; i++) {
        //   print(emotionSummerization[i]);
        // }
        // for (int i = 0; i < situationSummerization.length; i++) {
        //   print(situationSummerization[i]);
        // }

        startAnalyzeDiary();
      } on RequestFailedException catch (e) {
        debugPrint(e.message);
        situationSummerization.add('error');
        emotionSummerization.add('error');
        diaryTitle =
            "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}의 일기";
        startAnalyzeDiary();
      }
    }
    //  when Ai setting off
    else {
      situationSummerization.add('none');
      emotionSummerization.add('none');
      diaryTitle =
          "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}의 일기";
      startAnalyzeDiary();
    }
    notifyListeners();
    //return chatCompletion.choices.first.message.content;
  }

  Future<bool> watiFetchDiaryData() async {
    if (isAIUsing == false || isAnalyzed) {
      return true;
    }

    //  delay for loading page
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (situationSummerization.isNotEmpty &&
            emotionSummerization.isNotEmpty) {
          return true;
        }
        return false;
      },
    );
  }
}
