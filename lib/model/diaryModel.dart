import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String title;
  final String content;
  final List<dynamic> situation;
  final List<dynamic> emotion;
  final String date;
  final String path;

  DiaryModel({
    required this.title,
    required this.content,
    required this.situation,
    required this.emotion,
    required this.date,
    required this.path,
  });

  static DiaryModel fromSnapshot(DocumentSnapshot snap) {
    DiaryModel diaryModel = DiaryModel(
      title: snap['title'],
      content: snap['content'],
      situation: snap['situation'],
      emotion: snap['emotion'],
      date: snap['date'],
      path: snap.id,
    );
    return diaryModel;
  }
}
