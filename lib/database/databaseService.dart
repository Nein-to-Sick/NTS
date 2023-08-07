import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../component/notification.dart';
import '../model/preset.dart';

String userId = FirebaseAuth.instance.currentUser!.uid;

class DatabaseService {
  Future<void> writeDiary(String title, String content, List<String> situation,
      List<String> emotion, messageController, String time) async {
    CollectionReference dr = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("diary");

    dr.add({
      'title': title,
      'content': content,
      'situation': situation,
      'emotion': emotion,
      'date': time
    });

    List<String> selectedEmotion = [];

    for (int i = 0; i < emotion.length; i++) {
      for (int j = 0; j < Preset().emotion.length; j++) {
        if (Preset().emotion[j].contains(emotion[i])) {
          for (var element in Preset().emotion[j]) {
            selectedEmotion.add(element);
          }
        }
      }
    }

    // message pull
    final matchingDocuments =
        await getDocumentsWithMatchingSituationsAndEmotions(
            situation, selectedEmotion);

    if (matchingDocuments.isEmpty) {
      notMatch(messageController);
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(matchingDocuments.length);
    final randomDoc = matchingDocuments[randomIndex];

    print("무작위로 선택된 일치하는 문서 ID: ${randomDoc.id}, 데이터: ${randomDoc.data()}");

    Random rand = Random();
    int min = 5;
    int max = 10;
    int randomNumber = min + rand.nextInt(max - min + 1);
    await Future.delayed(Duration(minutes: randomNumber)); // 5~10분 랜덤 딜레이
    // await Future.delayed(Duration(seconds: 30)); // 5~10분 랜덤 딜레이

    await FirebaseFirestore.instance // 저장
        .collection('users')
        .doc(userId)
        .collection('mailBox')
        .doc(randomDoc.id)
        .set(randomDoc.data() as Map<String, dynamic>);

    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
    .doc(userId)
        .collection('mailBox')
        .doc(randomDoc.id);

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm');
    String formattedNow = formatter.format(now);

    doc.update({
      'date': formattedNow,
    });

    messageController.getMessage();
    FlutterLocalNotification.showNotification(); // 알림
  }

  Future<List<DocumentSnapshot>> getDocumentsWithMatchingSituationsAndEmotions(
      List<dynamic> situations, List<String> selectedEmotion) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('filterMail')
        .where('situation', arrayContainsAny: situations)
        .get();

    List<DocumentSnapshot> filteredDocuments = [];

    for (DocumentSnapshot document in querySnapshot.docs) {
      bool emotionMatches = false;

      for (String emotion in selectedEmotion) {
        if (document['emotion'].contains(emotion)) {
          emotionMatches = true;
          break;
        }
      }

      if (emotionMatches) {
        // Check if the document with the same ID exists in the users collection.
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('mailBox')
            .doc(document.id)
            .get();

        if (!userDoc.exists) {
          filteredDocuments.add(document);
        }
      }
    }

    return filteredDocuments;
  }

  Future<void> notMatch(messageController) async {
    print("일치하는 편지가 없습니다.");

    Random rand = Random();
    int min = 5;
    int max = 10;
    int randomNumber = min + rand.nextInt(max - min + 1);
    // await Future.delayed(Duration(minutes: randomNumber));
    await Future.delayed(Duration(seconds: 30)); // 5~10분 랜덤 딜레이


    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm');
    String formattedNow = formatter.format(now);
    await FirebaseFirestore.instance // 저장
        .collection('users')
        .doc(userId)
        .collection('mailBox')
        .doc("notMatch")
    .set({
      'content': '나와 같은 상황에 있는 사람들을 위해 편지를 써보는것은 어떨까?',
      'date': formattedNow,
      'from': '반딧불이',
      'notMatch': true
    });
    messageController.getMessage();
    FlutterLocalNotification.showNotification(); // 알림
  }

  void selfMessage(String content, List<String> situation, List<String> emotion,
      String time) {
    CollectionReference dr = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("selfMailBox");

    dr.add({
      'content': content,
      'situation': situation,
      'emotion': emotion,
      'date': time
    });
  }

  void someoneMessage(String content, List<String> situation,
      List<String> emotion, String userName, String time) {
    CollectionReference dr = FirebaseFirestore.instance.collection('everyMail');

    dr.add({
      'content': content,
      'situation': situation,
      'emotion': emotion,
      'date': time,
      'from': userName,
      'notMatch': false
    });
  }
}
