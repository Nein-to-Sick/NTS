import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String title;
  final String content;
  final List<dynamic> keyword;
  final String date;

  Diary({
    required this.title,
    required this.content,
    required this.keyword,
    required this.date,
  });

  static Diary fromSnapshot(DocumentSnapshot snap) {
    Diary diary = Diary(
      title: snap['title'],
      content: snap['content'],
      keyword: snap['keyword'],
      date: snap['date'],
    );
    return diary;
  }
}
