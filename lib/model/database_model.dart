import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:nts/model/preset_model.dart';
import 'package:nts/view/component/notification.dart';

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

    // 내가 보낸 일기에서 찾기
    final documents = await getSelfMailBox(situation, selectedEmotion);

    if (documents.isNotEmpty) {
      sendAlert(documents, messageController);
    } else {
      // 내가 보낸 일기에서 없을때 filterMail에서 찾기
      final matchingDocuments =
          await getDocumentsWithMatchingSituationsAndEmotions(
              situation, selectedEmotion);

      if (matchingDocuments.isEmpty) {
        notMatch(messageController, situation, emotion);
        return;
      }

      sendAlert(matchingDocuments, messageController);
    }
  }

  Future<void> sendAlert(matchingDocuments, messageController) async {
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

    doc.update({'date': formattedNow, 'docId': doc.id});

    messageController.getMessage();
    FlutterLocalNotification.showNotification(); // 알림
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('selfMailBox')
        .doc(randomDoc.id)
        .delete();
  }

  Future<List<DocumentSnapshot>> getDocumentsWithMatchingSituationsAndEmotions(
      List<dynamic> situations, List<String> selectedEmotion) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('filterMail')
        .where('situation', isEqualTo: situations)
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

  Future<List<DocumentSnapshot>> getSelfMailBox(
      List<dynamic> situations, List<String> selectedEmotion) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('selfMailBox')
        .where('situation', isEqualTo: situations)
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
        String endDateString = document['endDate'].replaceAll('/', '-');
        if (DateTime.parse(endDateString).compareTo(DateTime.now()) <= 0) {
          filteredDocuments.add(document);
        }
      }
    }

    return filteredDocuments;
  }

  Future<void> notMatch(messageController, situation, emotion) async {
    print("일치하는 편지가 없습니다.");

    Random rand = Random();
    int min = 5;
    int max = 10;
    int randomNumber = min + rand.nextInt(max - min + 1);
    await Future.delayed(Duration(minutes: randomNumber));
    // await Future.delayed(Duration(seconds: 30)); // 5~10분 랜덤 딜레이

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
      'notMatch': true,
      'heart': false,
      'docId': "notMatch",
      'from_uid': 'notMatch',
      'situation': situation,
      'emotion': emotion
    });
    messageController.getMessage();
    FlutterLocalNotification.showNotification(); // 알림
  }

  // 수정된 selfMessage
  Future<String> selfMessage(String content, List<String> situation,
      List<String> emotion, String time, String userName) async {
    CollectionReference dr = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("selfMailBox");
    DateTime initialDateTime = DateTime.parse(time.replaceAll('/', '-'));
    // 1달을 추가한 날짜 및 시간
    DateTime oneMonthLater = initialDateTime.add(const Duration(days: 31));
    String endDate = DateFormat("yyyy/MM/dd 00:00").format(oneMonthLater);

    DocumentReference docRef = await dr.add({
      'content': content,
      'situation': situation,
      'emotion': emotion,
      'date': time,
      'endDate': endDate,
      'from': userName,
      'from_uid': userId,
      'notMatch': false,
      'heart': false,
      'heart_count': 0
    });
    return docRef.id;
  }

// 수정된 someoneMessage
  Future<String> someoneMessage(String content, List<String> situation,
      List<String> emotion, String userName, String time) async {
    CollectionReference dr = FirebaseFirestore.instance.collection('everyMail');

    DocumentReference docRef = await dr.add({
      'content': content,
      'situation': situation,
      'emotion': emotion,
      'date': time,
      'from': userName,
      'from_uid': userId,
      'notMatch': false,
      'heart': false,
      'heart_count': 0,
    });

    await docRef.update({'docId': docRef.id});

    return docRef.id;
  }

  Future<void> clickHeart(String id, bool heart, String fromUid) async {
    DocumentReference dr = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('mailBox')
        .doc(id);

    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('mailBox')
        .doc(id)
        .get();
    int heartCount = data['heart_count'];
    heartCount++;
    dr.update({'heart': heart, 'heart_count': heartCount});

    greenFireFly(heartCount, fromUid);
  }

  Future<void> greenFireFly(int heartCount, String fromUid) async {
    if (heartCount == 1) {
      DocumentReference data =
          FirebaseFirestore.instance.collection('users').doc(fromUid);
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(fromUid)
          .get();
      int green = doc['green'];
      green++;
      data.update({'green': green});
    }
  }
}
