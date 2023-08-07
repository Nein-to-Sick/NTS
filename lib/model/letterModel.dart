import 'package:cloud_firestore/cloud_firestore.dart';

class LetterModel {
  final String content;
  final String date;
  final String from;
  final bool notMatch;

  LetterModel(
      {required this.content,
      required this.date,
      required this.from,
      required this.notMatch});

  static LetterModel fromSnapshot(DocumentSnapshot snap) {
    LetterModel letterModel = LetterModel(
      date: snap['date'],
      content: snap['content'],
      from: snap['from'],
      notMatch: snap['notMatch'],
    );
    return letterModel;
  }
}
