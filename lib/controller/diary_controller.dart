import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryModel with ChangeNotifier {
  final String title;
  late String content;
  final List<dynamic> situation;
  final List<dynamic> emotion;
  final String date;
  final String path;
  final int gift;
  final int heart;
  final int together;

  DiaryModel({
    required this.title,
    required this.content,
    required this.situation,
    required this.emotion,
    required this.date,
    required this.path,
    required this.gift,
    required this.heart,
    required this.together,
  });

  static DiaryModel fromSnapshot(DocumentSnapshot snap) {
    DiaryModel diaryModel = DiaryModel(
      title: snap['title'],
      content: snap['content'],
      situation: snap['situation'],
      emotion: snap['emotion'],
      date: snap['date'],
      path: snap.id,
      gift: snap['gift'],
      heart: snap['heart'],
      together: snap['together'],
    );
    return diaryModel;
  }

  void updateDiaryContent(value) {
    content = value;
    notifyListeners();
  }
}
