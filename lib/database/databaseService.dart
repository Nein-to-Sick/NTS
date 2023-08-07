import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String userId = FirebaseAuth.instance.currentUser!.uid;

class DatabaseService {
  void writeDiary(String title, String content, List<String> situation,
      List<String> emotion, String time) {
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
      List<String> emotion, String time) {
    CollectionReference dr = FirebaseFirestore.instance.collection('everyMail');

    dr.add({
      'content': content,
      'situation': situation,
      'emotion': emotion,
      'date': time
    });
  }
}
