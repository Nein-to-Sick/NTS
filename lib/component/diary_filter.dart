import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/Theme/theme_colors.dart';

class SearchFilterDialog extends StatefulWidget {
  const SearchFilterDialog({super.key});

  @override
  State<SearchFilterDialog> createState() => _SearchFilterDialogState();
}

class _SearchFilterDialogState extends State<SearchFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),

                        //  Date
                        Text(
                          '날짜',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SUIT',
                            color: MyThemeColors.myGreyscale.shade900,
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        //  situation
                        Text(
                          '상황',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SUIT',
                            color: MyThemeColors.myGreyscale.shade900,
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        //  emotion
                        Text(
                          '감정',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SUIT',
                            color: MyThemeColors.myGreyscale.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
