import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:provider/provider.dart';
import '../provider/backgroundController.dart';

class NavigationToggle extends StatelessWidget {
  const NavigationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final double boxScale;

    final controller = Provider.of<BackgroundController>(context);
    final int page = controller.page;

    double screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight <= 667) {
      //iPhone8
      boxScale = 0.8;
    } else if (screenHeight <= 852) {
      //iPhone14 Pro
      boxScale = 1.0;
    } else {
      boxScale = 1.2;
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform.scale(
              // Transformer.scale로 Container 크기 조절
              scale: boxScale,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                      const SizedBox(
                        width: 15,
                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
