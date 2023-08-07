import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      print("일치하는 편지가 없습니다.");
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(matchingDocuments.length);
    final randomDoc = matchingDocuments[randomIndex];

    print("무작위로 선택된 일치하는 문서 ID: ${randomDoc.id}, 데이터: ${randomDoc.data()}");

    await Future.delayed(const Duration(minutes: 1)); // 1분 딜레이
    await FirebaseFirestore.instance // 저장
        .collection('users')
        .doc(userId)
        .collection('mailBox')
        .doc(randomDoc.id)
        .set(randomDoc.data() as Map<String, dynamic>);
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
      'from': userName
    });
  }
}
