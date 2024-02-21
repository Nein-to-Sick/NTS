import 'package:cloud_firestore/cloud_firestore.dart';

enum Messagner { user, ai }

enum MessageType { chat, writing, image, music }

class MessageModel {
  late String userMessage;
  late String AIMessage;
  late Messagner messagner;
  late MessageType messgaType;
  late Timestamp messageTime;

  MessageModel({
    required this.userMessage,
    required this.AIMessage,
    required this.messagner,
    required this.messgaType,
    required this.messageTime,
  });
}
