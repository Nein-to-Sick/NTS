import 'package:cloud_firestore/cloud_firestore.dart';

class LetterModel {
  final String content;
  final String date;
  final String from;

  LetterModel({
    required this.content,
    required this.date,
    required this.from,
  });

  static LetterModel fromSnapshot(DocumentSnapshot snap) {
    LetterModel letterModel = LetterModel(
      date: snap['date'],
      content: snap['content'],
      from: snap['from'],
    );
    return letterModel;
  }
}
