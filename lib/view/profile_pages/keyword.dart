import 'package:flutter/material.dart';

import '../Theme/theme_colors.dart';
import '../model/preset.dart';

class Keyword extends StatefulWidget {
  const Keyword({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  State<Keyword> createState() => _KeywordState();
}

class _KeywordState extends State<Keyword> {
  late List<List<bool>> isSelected2 = [];

  @override
  void initState() {
    super.initState();
    isSelected2 = List.generate(widget.title.length,
        (i) => List.generate(widget.title[i].length, (j) => false));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: widget.title.length == Preset().situation.length ? 200 : 160,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.title.length,
        itemBuilder: (BuildContext context, int index1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.title[index1].length,
                itemBuilder: (BuildContext context, int index2) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected2[index1][index2] =
                            !isSelected2[index1][index2];
                        // if (isSelected2[index1][index2]) {
                        //   count2++;
                        // } else {
                        //   count2--;
                        // }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 9.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected2[index1][index2]
                              ? MyThemeColors.primaryColor // 수정
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: MyThemeColors.myGreyscale.shade700,
                          ), // 수정
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Text(
                            widget.title[index1][index2],
                            style: TextStyle(
                                fontSize: 16,
                                color: isSelected2[index1][index2]
                                    ? Colors.white
                                    : MyThemeColors.myGreyscale.shade900,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
