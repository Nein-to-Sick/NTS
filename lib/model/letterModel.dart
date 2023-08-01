import 'package:cloud_firestore/cloud_firestore.dart';

class LetterModel {
  final String content;
  final String time;
  final String from;

  LetterModel({
    required this.content,
    required this.time,
    required this.from,
  });

  static LetterModel fromSnapshot(DocumentSnapshot snap) {
    LetterModel letterModel = LetterModel(
      time: snap['time'],
      content: snap['content'],
      from: snap['from'],
    );
    return letterModel;
  }
}
