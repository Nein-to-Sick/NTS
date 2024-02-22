import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart'; // 날짜 및 시간 포맷을 위한 패키지 import
import 'package:heroicons/heroicons.dart';
import 'package:nts/model/database_model.dart';
import 'package:nts/theme/custom_theme_data.dart';

import '../../controller/diary_controller.dart';
import '../profile_pages/read_edit_diary.dart';

class AlarmBox extends StatefulWidget {
  const AlarmBox(
      {Key? key, required this.controller, required this.searchModel})
      : super(key: key);

  final controller;
  final searchModel;

  @override
  _AlarmBoxState createState() => _AlarmBoxState();
}

class _AlarmBoxState extends State<AlarmBox> {
  List<DocumentSnapshot> alarmDocuments = [];
  late final DiaryModel diary;

  @override
  void initState() {
    super.initState();
    _fetchAlarmData();
  }

  Future<void> _fetchAlarmData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('alarm')
          .get();
      setState(() {
        alarmDocuments = snapshot.docs;
      });
    } catch (error) {
      print('Error fetching alarm data: $error');
    }
  }

  Future<void> _fetchDiaryData(String docId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('diary')
          .doc(docId)
          .get();

      setState(() {
        diary = DiaryModel.fromSnapshot(snapshot); // Modify here
      });
    } catch (error) {
      print('Error fetching diary data: $error');
    }
  }

  String formatTimestamp(DateTime timestamp) {
    // Timestamp를 DateTime으로 변환 후, 현재 시간과의 차이를 계산하여 문자열로 반환
    DateTime now = DateTime.now();
    DateTime alarmTime = timestamp;
    Duration difference = now.difference(alarmTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      // 예시로 하루 이상일 때는 날짜를 포맷하여 반환
      return DateFormat('MM월 dd일').format(alarmTime);
    }
  }

  Future<void> turnOffAlarm(String docId) async {
    DocumentReference data = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('alarm')
        .doc(docId);

    data.update({'new': true});
  }

  Future<void> deleteData(String docId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('alarm')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "알림",
          style: BandiFont.headline3(context),
        ),
      ),
      body: (alarmDocuments.isEmpty)
          ? Center(
              child: Text(
                '알람이 없습니다',
                style: BandiFont.headline3(context)?.copyWith(
                  color: BandiColor.primaryColor(context),
                ),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 29.0),
              child: ListView.builder(
                itemCount: alarmDocuments.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = alarmDocuments[index];
                  return Dismissible(
                    key: Key(document['id']),
                    direction:
                        DismissDirection.horizontal, // 좌우로만 슬라이드 가능하도록 설정
                    onDismissed: (direction) {
                      // 알림 삭제 로직
                      deleteData(document['id']);
                      turnOffAlarm(document['id']);
                      // 알림 목록에서 해당 알림을 제거합니다.
                      setState(() {
                        alarmDocuments.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        turnOffAlarm(document['id']);
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.controller.movePage(855.0);
                          widget.controller.changeColor(3);
                        });
                        _fetchDiaryData(document['docId']).then((_) {
                          // Modify here
                          showAnimatedDialog(
                            context: context,
                            barrierDismissible: false,
                            barrierColor: Colors.transparent,
                            animationType:
                                DialogTransitionType.slideFromBottomFade,
                            builder: (BuildContext context) {
                              return ReadDiaryDialog(
                                diaryContent: diary, // Modify here
                                searchModel: widget.searchModel,
                              );
                            },
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    document['type'] == 'heart'
                                        ? const HeroIcon(
                                            HeroIcons.heart,
                                            style: HeroIconStyle.solid,
                                          )
                                        : document['type'] == 'gift'
                                            ? const HeroIcon(
                                                HeroIcons.gift,
                                                style: HeroIconStyle.solid,
                                              )
                                            : Image.asset(
                                                "./assets/emo_icons/together_small.png"),
                                    const SizedBox(width: 7),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "나의 기록에 공감이 달렸어요.",
                                          style: BandiFont.body2(context),
                                        ),
                                        Text(
                                          formatTimestamp(
                                              DateTime.parse(document['time'])),
                                          style: BandiFont.text2(context)
                                              ?.copyWith(
                                                  color:
                                                      BandiColor.gray004Color(
                                                          context)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              !document['new']
                                  ? const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xffFFC341),
                                        radius: 4.5,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
