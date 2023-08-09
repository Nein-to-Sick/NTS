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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: subtitle.isNotEmpty ? 10 : 5,),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          subtitle.isNotEmpty ? Column(
            children: [
              const SizedBox(height: 8,),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MyThemeColors.myGreyscale[400]),
              ),
            ],
          ) : Container(),
          SizedBox(height: subtitle.isNotEmpty ? 16 : 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  fuctionOnNo();
                },
                child: Container(
                  width: 120,
                  height: 50,
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
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  fuctionOnYes();
                },
                child: Container(
                  width: 120,
                  height: 50,
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
            ],
          )
        ],
      ),
    ),
  );
}
