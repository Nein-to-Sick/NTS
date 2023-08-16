import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

//  with yes and no textbutton
Dialog dialogWithYesOrNo(
  BuildContext context,
  String title,
  String subtitle,
  String yes,
  Function fuctionOnYes,
  Function fuctionOnNo,
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
      height: subtitle.isNotEmpty ? 200 : 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
            subtitle.isNotEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: MyThemeColors.myGreyscale[400]),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: subtitle.isNotEmpty ? 18 : 26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      fuctionOnNo();
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: MyThemeColors.myGreyscale[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "취소",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: MyThemeColors.myGreyscale[900]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      fuctionOnYes();
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: MyThemeColors.teritaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          yes,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: MyThemeColors.myGreyscale[0]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
