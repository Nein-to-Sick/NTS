import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/provider/calendarController.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int firstWeekdayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }

  int year = 2023;
  int month = 8;

  int count = 0;
  Map<String, bool> selected = {};

  @override
  Widget build(BuildContext context) {
    int days = daysInMonth(year, month);
    int padDays = daysInMonth(year, month - 1);
    int firstWeekday = firstWeekdayOfMonth(year, month);

    final calendarController = Provider.of<CalendarController>(context);

    List<TableRow> tableRows = [];

    tableRows.add(
      TableRow(
        children: ['일', '월', '화', '수', '목', '금', '토']
            .map(
              (day) => Container(
                alignment: Alignment.center,
                child: Text(day),
              ),
            )
            .toList(),
      ),
    );

    List<Widget> paddingDays = List.generate(
      firstWeekday,
      (index) => Container(
        height: (firstWeekday + days) > 35 ? 30 : 36,
        alignment: Alignment.center,
        child: Text(
          '${padDays - firstWeekday + index + 1}',
          style: TextStyle(
              fontSize: (firstWeekday + days) > 35 ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000).withOpacity(0.1)),
        ),
      ),
    );

    List<Widget> daysList = List.generate(
      days,
      (index) {
        String uniqueKey =
            '$year${month.toString().padLeft(2, '0')}${(index + 1).toString().padLeft(2, '0')}';
        bool isSelected = selected[uniqueKey] ?? false;
        return GestureDetector(
          onTap: () {
            setState(() {
              selected[uniqueKey] = !isSelected;
              if (!isSelected) {
                count++;
              } else {
                count--;
              }
              if (count > 2) {
                selected = {};
                count = 0;
              }
              if(count == 2) {
                calendarController.setSelected(selected);
                calendarController.setCount(count);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
            child: Container(
              height: (firstWeekday + days) > 35 ? 30 : 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? MyThemeColors.primaryColor
                    : Colors.transparent, // Add this line
                borderRadius: BorderRadius.circular(4), // Add this line
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: (firstWeekday + days) > 35 ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? Colors.white : Colors.black, // Add this line
                ),
              ),
            ),
          ),
        );
      },
    );

    List<Widget> allDays = []
      ..addAll(paddingDays)
      ..addAll(daysList);
    int remainingCells =
        (allDays.length % 7 == 0) ? 0 : (7 - allDays.length % 7);

    for (int i = 0; i < remainingCells; i++) {
      allDays.add(Container());
    }

    for (int i = 0; i < allDays.length; i += 7) {
      tableRows.add(
        TableRow(
          children: allDays.sublist(i, i + 7),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.449,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.9),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 24, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$month월 $year년",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 13,
                          color: MyThemeColors.myGreyscale[300],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (month == 1) {
                                  year--;
                                  month = 12;
                                } else {
                                  month--;
                                }
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: MyThemeColors.myGreyscale[100],
                                size: 22,
                              ),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (month == 12) {
                                  year++;
                                  month = 1;
                                } else {
                                  month++;
                                }
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: MyThemeColors.myGreyscale[100],
                                size: 22,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                Table(
                  children: tableRows,
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  defaultColumnWidth: const IntrinsicColumnWidth(flex: 1),
                ),
                Divider(
                  color: MyThemeColors.myGreyscale[100],
                  thickness: 1,
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        spacing: 40.0, // gap between adjacent chips
                        children: (selected.keys
                                .where((key) => selected[key]!)
                                .toList()
                              ..sort((a, b) => a.compareTo(b))) // 정렬 추가
                            .map<Widget>((date) {
                          int year = int.parse(date.substring(0, 4));
                          int month =
                              int.parse(date.substring(4, 6)); // 숫자로 변환해 0 제거
                          int day =
                              int.parse(date.substring(6, 8)); // 숫자로 변환해 0 제거

                          return Chip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            backgroundColor: MyThemeColors.myGreyscale[100],
                            label: Text('$year년 $month월 $day일'),
                            labelStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          );
                        }).toList(),
                      ),
                    ),
                    count == 2
                        ? const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "~",
                                  style: TextStyle(fontSize: 16),
                                )),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
