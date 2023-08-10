import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';

int selectedIcon = 0;

void myShowBottomSheet(BuildContext context) {
  final opinionController = TextEditingController();

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 460,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  // color: AppColors.haruPrimary.shade300,
                  color: MyThemeColors.myGreyscale[50],
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //  emoji radio buttons
              const IconRadioButtonsGroup(),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: AppColors.whiteColor,
                      color: Colors.white),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                          child: TextField(
                            autocorrect: false,
                            controller: opinionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "궁금하거나 불편하거나 제안하고 싶은 점이 있다면\n얘기해주세요!",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                // color: AppColors.haruGreyscale.shade300,
                                color: Color(0xffB0B0B0),
                                fontFamily: "SUIT",
                              ),
                            ),

                            //  enter(엔터) 키 이벤트 처리 with onSubmitted
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onTapOutside: (p) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (opinionController.text.trim().isNotEmpty)
                    ? () {
                        userOpinionupdate(
                            context, opinionController.text.trim());
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('소중한 의견 감사드립니다!'),
                            dismissDirection: DismissDirection.vertical,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // foregroundColor: (opinionController.text.trim().isNotEmpty)
                  //     ? AppColors.whiteColor
                  //     : AppColors.haruGreyscale.shade900,
                  // backgroundColor: (opinionController.text.trim().isNotEmpty)
                  //     ? AppColors.primaryColor
                  //     : AppColors.haruGreyscale.shade100,
                  // surfaceTintColor: AppColors.haruGreyscale.shade100,
                  padding: const EdgeInsets.fromLTRB(45, 10, 45, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  '전송',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

class IconRadioButtonsGroup extends StatefulWidget {
  const IconRadioButtonsGroup({super.key});

  @override
  State<IconRadioButtonsGroup> createState() => _IconRadioButtonsGroupState();
}

class _IconRadioButtonsGroupState extends State<IconRadioButtonsGroup> {
  void _onIconSelected(int index) {
    setState(() {
      selectedIcon = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                RadioIconButtonDesign(
                  icon: HeroIcons.handThumbUp,
                  isSelected: selectedIcon == 0,
                  onPressed: () => _onIconSelected(0),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('좋아요'),
              ],
            ),
            Column(
              children: [
                RadioIconButtonDesign(
                  icon: HeroIcons.handThumbDown,
                  isSelected: selectedIcon == 1,
                  onPressed: () => _onIconSelected(1),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('아쉬워요'),
              ],
            ),
            Column(
              children: [
                RadioIconButtonDesign(
                  icon: HeroIcons.handRaised,
                  isSelected: selectedIcon == 2,
                  onPressed: () => _onIconSelected(2),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('의견이 있어요'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RadioIconButtonDesign extends StatelessWidget {
  final HeroIcons icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const RadioIconButtonDesign({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              // ? Theme.of(context).colorScheme.primary
              // : Theme.of(context).colorScheme.onPrimary,
              ? Colors.black
              : MyThemeColors.myGreyscale[50],
        ),
        child: HeroIcon(
          icon,
          style: HeroIconStyle.solid,
          // color: AppColors.whiteColor,

          color: isSelected
              // ? Theme.of(context).colorScheme.primary
              // : Theme.of(context).colorScheme.onPrimary,
              ? Colors.white
              : MyThemeColors.myGreyscale[400],
        ),
      ),
    );
  }
}

//  user opinion firebase update
Future<void> userOpinionupdate(BuildContext context, String opinion) async {
  String? userNickName;
  String userOpinion = '';
  final opinionCollection = FirebaseFirestore.instance.collection("opinions");
  final userCollection = FirebaseFirestore.instance.collection("users");
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('nickname')) {
        userNickName = userData['nickname'];
      } else {
        print('No field');
      }
    } else {
      print('No document');
    }
  } else {
    print('User ID is null');
  }

  if (selectedIcon == 0) {
    userOpinion = 'like';
  } else if (selectedIcon == 1) {
    userOpinion = 'dislike';
  } else {
    userOpinion = 'propsal';
  }

  await opinionCollection.doc('${DateTime.now()} - ${userNickName!}').set(
    {
      "nickname": userNickName,
      "userUid": userId,
      "date": DateTime.now(),
      "opinion": opinion,
      "emoji": userOpinion,
    },
  );
}
