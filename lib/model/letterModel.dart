import 'package:cloud_firestore/cloud_firestore.dart';

class LetterModel {
  final String content;
  final String date;
  final String from;
  final bool notMatch;
  final bool heart;
  final String id;
  final String fromUid;
  final List<dynamic> situation;
  final List<dynamic> emotion;

  LetterModel(
      {required this.content,
      required this.date,
      required this.from,
      required this.notMatch,
      required this.heart,
      required this.id,
      required this.fromUid,
      required this.situation,
      required this.emotion});

  static LetterModel fromSnapshot(DocumentSnapshot snap) {
    LetterModel letterModel = LetterModel(
        date: snap['date'],
        content: snap['content'],
        from: snap['from'],
        notMatch: snap['notMatch'],
        heart: snap['heart'],
        id: snap['docId'],
        fromUid: snap['from_uid'],
        situation: snap['situation'],
        emotion: snap['emotion']);
    return letterModel;
  }
}
