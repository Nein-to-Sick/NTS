import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GPTModel with ChangeNotifier {
  String diaryTitle = '';
  String diaryMainText = '';
  List<String> situationSummerization = List<String>.empty(growable: true);
  List<String> emotionSummerization = List<String>.empty(growable: true);

  void updateDiaryTitle(value) {
    diaryTitle = value.toString().trim();
    notifyListeners();
  }

  void updateDiaryMainText(value) {
    diaryMainText = value.toString().trim();
    notifyListeners();
  }

  void tryAnalyzeDiary(String prompt) async {
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
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content:
                "너는 전문 상황 분석가로 요구에따라 핵심 상황을 파악해야해. 다음으로 오는 일기에서 파악되는 상황을 <가족, 연애, 친구관계, 직장, 학교, 군대, 진로, 일상생활, 공부, 일, 건강, 학업, 운동, 취미생활, 돈, 불면, 자존감, 날씨, 상황 없음> 중에서만 최대 3개를 선택해서 정리해. <$prompt>, 정리한 내용은 반드시 다음 형식으로 만들어 <[단어, 단어, ...]>",
            role: OpenAIChatMessageRole.system,
          ),
        ],
      );

      //  emotion analysis
      final emotionGPT = await OpenAI.instance.chat.create(
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
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content:
                "너는 전문 감정 분석가로 요구에따라 핵심 감정을 파악해야해. 다음으로 오는 일기에서 파악되는 감정을 <기쁨, 감사, 기대, 설렘, 놀람, 지루함, 피곤함, 짜증남, 무기력, 우울함, 슬픔, 화남, 감정 없음> 중에서만 최대 3개를 선택해서 정리해. <$prompt>, 정리한 내용은 반드시 다음 형식으로 만들어 <[단어, 단어, ...]>",
            role: OpenAIChatMessageRole.system,
          ),
        ],
      );

      //  result to variables
      situationTemp = situationGPT.choices.first.message.content;
      emotionsTemp = emotionGPT.choices.first.message.content;

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
      print(situationGPT.choices.first.message.content);
      print(emotionGPT.choices.first.message.content);
      for (int i = 0; i < emotionSummerization.length; i++) {
        print(emotionSummerization[i]);
      }
    } catch (e) {
      situationSummerization.add('error');
      emotionSummerization.add('error');
      print('Error');
    }

    notifyListeners();
    //return chatCompletion.choices.first.message.content;
  }

  //  위 함수와 합치거나, async 방식으로 api 출력 타이밍을 바꾸기
  Future<bool> watiFetchDiaryData() async {
    if (situationSummerization.isNotEmpty && emotionSummerization.isNotEmpty) {
      return true;
    }
    return false;
  }
}
