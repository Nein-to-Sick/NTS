import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    Widget delete = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.03,
          MediaQuery.of(context).size.width * 0.045,
          MediaQuery.of(context).size.height * 0.02),
      child: Center(
        child: Column(
          children: [
            const Text(
              "정말로 떠나시는 건가요?",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            WrappedKoreanText(
              "계정 탈퇴시 기존에 저장된 데이터는 모두 삭제되고 복구가 불가능합니다.",
              style: TextStyle(
                  fontSize: 16, color: Colors.black.withOpacity(0.41)),
            ),
            Row(
              children: [
                TextButton(onPressed: () {}, child: Text("탈퇴하기")),
                TextButton(onPressed: () {}, child: Text("취소")),
              ],
            )
          ],
        ),
      ),
    );

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Stack(
            children: [
              delete,
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Opacity(
                  opacity: 0.2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: HeroIcon(
                          HeroIcons.xMark,
                          size: 23,
                        )),
                  ),
                ),
              )
            ],
          )),
    );
    ;
  }
}
