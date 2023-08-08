import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

class MyNewCalendar extends StatefulWidget {
  const MyNewCalendar({Key? key}) : super(key: key);

  @override
  State<MyNewCalendar> createState() => _MyNewCalendarState();
}

class _MyNewCalendarState extends State<MyNewCalendar> {
  @override
  Widget build(BuildContext context) {
    return buildCalendarDialog();
  }

  List<String> timeResult = List<String>.empty(growable: true);

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
  ];

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate @ $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  buildCalendarDialog() {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: const TextStyle(
          color: MyThemeColors.blackColor, fontWeight: FontWeight.w700),
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: MyThemeColors.primaryColor,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: MyThemeColors.blackColor,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: MyThemeColors.blackColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: const TextStyle(
          color: MyThemeColors.whiteColor, fontWeight: FontWeight.w700),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        return textStyle;
      },
      /*
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      */
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyThemeColors.secondaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    //  calendar button
    return GestureDetector(
      onTap: () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: _dialogCalendarPickerValue,
          dialogBackgroundColor: Colors.white,
        );
        if (values != null) {
          String temp = '';
          // ignore: avoid_print
          print(_getValueText(
            config.calendarType,
            values,
          ));
          setState(() {
            _dialogCalendarPickerValue = values;
          });

          temp = _getValueText(config.calendarType, values);

          timeResult = temp
              .substring(1, temp.length - 1)
              .split('@ ')
              .map((value) => value.trim())
              .toList();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MyThemeColors.myGreyscale.shade200,
                width: 2,
              ),
            ),
            child: Center(
                child: Text(
              (timeResult.isNotEmpty) ? timeResult[0] : '시작 날짜',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyThemeColors.myGreyscale.shade600,
              ),
            )),
          ),
          Text(
            '~',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyThemeColors.myGreyscale.shade600,
            ),
          ),
          Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MyThemeColors.myGreyscale.shade200,
                width: 2,
              ),
            ),
            child: Center(
                child: Text(
              (timeResult.isNotEmpty) ? timeResult[1] : '마지막 날짜',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyThemeColors.myGreyscale.shade600,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
