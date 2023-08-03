import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();
String time = DateFormat('yyyy/MM/dd HH:mm').format(now);

class DatabaseService {

  void writeDiary(String title, String content, List<String> situation, List<String> emotion) {
    // DocumentReference dr = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection(todayDate)
    //     .doc("mission${missionIndex + 1}");
    //
    // dr.update({
    //   'faceIndex': faceIndex,
    //   'text1': text1,
    //   'text2': text2,
    //   'text3': text3,
    //   'complete': true
    // });
  }

}