import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

//  with yes and no textbutton
Dialog dialogWithYesOrNo(
  BuildContext context,
  String topBarText,
  String mainText,
  Function fuctionOnYes,
  Function fuctionOnNo,
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              topBarText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MyThemeColors.primaryColor,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              mainText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 50,
                  color: Colors.white.withOpacity(0),
                  child: ElevatedButton(
                    onPressed: () async {
                      fuctionOnYes();
                      //  pop the alert
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        elevation: 0,
                        backgroundColor: MyThemeColors.primaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                        )),
                    child: const Text(
                      '예',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 50,
                  color: Colors.white.withOpacity(0),
                  child: ElevatedButton(
                    onPressed: () {
                      fuctionOnNo();
                      //  pop the alert
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        elevation: 0,
                        backgroundColor: MyThemeColors.primaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                        )),
                    child: const Text(
                      '아니요',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
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
  );
}
