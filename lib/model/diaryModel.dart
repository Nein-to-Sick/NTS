import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String title;
  final String content;
  final List<dynamic> situation;
  final List<dynamic> emotion;
  final String date;

  Diary({
    required this.title,
    required this.content,
    required this.situation,
    required this.emotion,
    required this.date,
  });

  static Diary fromSnapshot(DocumentSnapshot snap) {
    Diary diary = Diary(
      title: snap['title'],
      content: snap['content'],
      situation: snap['situation'],
      emotion: snap['emotion'],
      date: snap['date'],
    );
    return diary;
  }
}
