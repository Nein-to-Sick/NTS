import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:provider/provider.dart';
import '../provider/backgroundController.dart';

class NavigationToggle extends StatelessWidget {
  const NavigationToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final int page = controller.page;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.movePage(600);
                        controller.changeColor(2);
                      },
                      child: HeroIcon(
                        HeroIcons.home,
                        style: HeroIconStyle.solid,
                        color: page == 2
                            ? Colors.white
                            : MyThemeColors.myGreyscale.shade500,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15,),
                    GestureDetector(
                      onTap: () {
                        controller.movePage(855);
                        controller.changeColor(3);
                      },
                      child: HeroIcon(
                        HeroIcons.user,
                        style: HeroIconStyle.solid,
                        color: page == 3
                            ? Colors.white
                            : MyThemeColors.myGreyscale.shade500,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // page == 2
            //     ? const Padding(
            //         padding: EdgeInsets.only(right: 80.0),
            //         child: Text(
            //           "홈",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 13,
            //               fontWeight: FontWeight.w700),
            //         ),
            //       )
            //     : Container(),
            // page == 3
            //     ? const Padding(
            //         padding: EdgeInsets.only(left: 75.0),
            //         child: Text(
            //           "프로필",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 13,
            //               fontWeight: FontWeight.w700),
            //         ),
            //       )
            //     : Container()
          ],
        ),
      ),
    );
  }
}
