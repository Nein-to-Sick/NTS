import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AuthService {
  Future signInWithGoogle() async {
    //begin interactive sign in process
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? gUser = await _googleSignIn.signIn();

    if (gUser == null) {
      return null;
    }

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // final userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    final userCollection = FirebaseFirestore.instance.collection("users");

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    final docRef = userCollection.doc(userId);
    DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
    } else {
      await docRef.set({
        "nickname": "",
        "email": userEmail,
        "created_at": FieldValue.serverTimestamp(),
        "green": 0,
        "yellow": 0,
      });
    }

    DateTime selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String todayDate = selectedDate.toString().substring(0, 10);

    final dateDocRef = docRef.collection("mailBox").doc("firstMessage");

    // DocumentSnapshot snapshotDate = await dateDocRef.get();

    /*
    final String content;
    final String date;
    final String from;
    final bool notMatch;
    final bool heart;
    final String id;
    final String fromUid;
    final List<dynamic> situation;
    final List<dynamic> emotion;
     */
    if (snapshot.exists) {
    } else {
      await dateDocRef.set({
        "content": "와! 정말 당신이네요. 먼 곳에서 바라만 보다가 이렇게 직접 이야기를 나눌 수 있어 얼마나 신나고 기쁜지 몰라요.\n\n앗, 제 소개가 늦었네요. 제 이름은 반디예요. 당신의 세상, 그 너머에서 당신을 바라보던 작은 반딧불이랍니다.\n\n이곳은 제가 사는 곳이자, 이야기가 넘치는 장소에요.\n\n이야기는 당신이자, 우리이자, 모든 것이에요. 어제도, 지금도, 그리고 다가올 순간도 결국은 하나의 이야기로서 당신을, 그리고 우리 모두를 존재하게 만들기 때문이에요.\n\n삶이 무료할 때, 잡생각이 넘쳐나 홍수 칠 때, 하루를 정리할 때, 혹은 말할 사람이 없을 때조차도 말이에요. 혹시 당신도 당신의 이야기를 정리하고 싶거나 나누고 싶다면 언제든지 이곳을 찾아와 일기를 적어보세요. 저 반디가 함께 있어 드릴게요.\n\n아, 그리고 작은 부탁 하나 해도 될까요? 당신의 글과 이야기를 다양한 사람들에게 전해주세요!\n\n세상에는 행복한 사람도, 슬픈 사람도 있어요. 각자만의 이야기를 가지고 있지만, 때때로 그 이야기를 풀어나가지 못한 채 끙끙 앓고 있는 사람들이 있어요. 정말 아름다운 이야기가 될 수 있지만, 홀로 그것을 가지고만 있다면 그것은 곪아 자신을 아프게만 만들 거예요.\n\n모든 사람이 완벽할 수 없어요. 서로 다른 우리 모두가 각자만의 길을 걸어가지만, 그만큼 서로 이야기를 나누며 도울 수 있어요. 자신을 사랑하는 마음처럼 남을 사랑한다면, 자신의 이야기를 사랑하는 만큼 그 이야기를 나누며 사랑해 준다면, 더 큰 사랑이 우리게 있을 거라고 생각해요.\n\n저 반디는 당신과 함께 빛나고 있어요. 항상 응원해요! 지치지 않고 빛나고 있을 테니, 당신도 그 희망을 잃지 않기를!",
        "from": "반디",
        "date": DateFormat("yyyy/MM/dd HH:mm").format(DateTime.now()),
        "notMatch": false,
        "heart": false,
        "docId": "firstMessage",
        "from_uid": "반디",
        "situation": [],
        "emotion": []
      });
    }

    //finally, lets sign in

    return FirebaseAuth.instance.currentUser;
  }
}
