import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/model/search_model.dart';

class MyNewCalendar extends StatefulWidget {
  final ProfileSearchModel searchModel;
  const MyNewCalendar({Key? key, required this.searchModel}) : super(key: key);

  @override
  State<MyNewCalendar> createState() => _MyNewCalendarState();
}

class _MyNewCalendarState extends State<MyNewCalendar> {
  // List<DateTime?> dialogCalendarPickerValue = [
  //   DateTime.now(),
  // ];

  @override
  void initState() {
    super.initState();
    // if (widget.searchModel.timeResult.isNotEmpty) {
    //   if (widget.searchModel.timeResult[1].compareTo('null') == 0) {
    //     dialogCalendarPickerValue[0] =
    //         DateTime.parse(widget.searchModel.timeResult[0]);
    //   } else {
    //     dialogCalendarPickerValue[0] =
    //         DateTime.parse(widget.searchModel.timeResult[0]);
    //     dialogCalendarPickerValue
    //         .add(DateTime.parse(widget.searchModel.timeResult[1]));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return buildCalendarDialog();
  }

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
        valueText = '$startDate@ $endDate';
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
        final values = await showCalendarDatePicker2DialogCustom(
          context: context,
          config: config,
          dialogSize: const Size(325, 350),
          borderRadius: BorderRadius.circular(10),
          barrierDismissible: false,
          value: widget.searchModel.dialogCalendarPickerValue,
          dialogBackgroundColor: MyThemeColors.myGreyscale.shade50,
        );
        if (values != null) {
          String temp = '';
          // print(_getValueText(
          //   config.calendarType,
          //   values,
          // ));
          // setState(() {
          //   dialogCalendarPickerValue = values;
          // });

          widget.searchModel.updateCalendarSubValue(values);

          temp = _getValueText(config.calendarType, values);
          widget.searchModel.updateCalendarValue(temp);
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
              (widget.searchModel.timeResult.isEmpty ||
                      widget.searchModel.timeResult[0].compareTo('null') == 0)
                  ? '시작 날짜'
                  : widget.searchModel.timeResult[0],
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
                (widget.searchModel.timeResult.isEmpty)
                    ? '마지막 날짜'
                    : (widget.searchModel.timeResult[1].compareTo('null') == 0)
                        ? widget.searchModel.timeResult[0]
                        : widget.searchModel.timeResult[1],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyThemeColors.myGreyscale.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<DateTime?>?> showCalendarDatePicker2DialogCustom({
  required BuildContext context,
  required CalendarDatePicker2WithActionButtonsConfig config,
  required Size dialogSize,
  List<DateTime?> value = const [],
  BorderRadius? borderRadius,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  Color? dialogBackgroundColor,
  RouteSettings? routeSettings,
  String? barrierLabel,
  TransitionBuilder? builder,
}) {
  var dialog = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    backgroundColor: dialogBackgroundColor ?? Theme.of(context).canvasColor,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      width: dialogSize.width,
      height: max(dialogSize.height, 410),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalendarDatePicker2WithActionButtonsCustom(
            value: value,
            config: config.copyWith(openedFromDialog: true),
          ),
        ],
      ),
    ),
  );

  return showDialog<List<DateTime?>>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
  );
}

class CalendarDatePicker2WithActionButtonsCustom extends StatefulWidget {
  const CalendarDatePicker2WithActionButtonsCustom({
    required this.value,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    this.onCancelTapped,
    this.onOkTapped,
    Key? key,
  }) : super(key: key);

  final List<DateTime?> value;

  /// Called when the user taps 'OK' button
  final ValueChanged<List<DateTime?>>? onValueChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The calendar configurations including action buttons
  final CalendarDatePicker2WithActionButtonsConfig config;

  /// The callback when cancel button is tapped
  final Function? onCancelTapped;

  /// The callback when ok button is tapped
  final Function? onOkTapped;

  @override
  State<CalendarDatePicker2WithActionButtonsCustom> createState() =>
      _CalendarDatePicker2WithActionButtonsCustomState();
}

class _CalendarDatePicker2WithActionButtonsCustomState
    extends State<CalendarDatePicker2WithActionButtonsCustom> {
  List<DateTime?> _values = [];
  List<DateTime?> _editCache = [];

  @override
  void initState() {
    _values = widget.value;
    _editCache = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(
      covariant CalendarDatePicker2WithActionButtonsCustom oldWidget) {
    var isValueSame = oldWidget.value.length == widget.value.length;

    if (isValueSame) {
      for (var i = 0; i < oldWidget.value.length; i++) {
        var isSame = (oldWidget.value[i] == null && widget.value[i] == null) ||
            DateUtils.isSameDay(oldWidget.value[i], widget.value[i]);
        if (!isSame) {
          isValueSame = false;
          break;
        }
      }
    }

    if (!isValueSame) {
      _values = widget.value;
      _editCache = widget.value;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.removePadding(
          context: context,
          child: CalendarDatePicker2(
            value: [..._editCache],
            config: widget.config,
            onValueChanged: (values) => _editCache = values,
            onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
          ),
        ),
        //SizedBox(height: widget.config.gapBetweenCalendarAndButtons ?? 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCancelButton(Theme.of(context).colorScheme),
            const SizedBox(width: 20),
            // if ((widget.config.gapBetweenCalendarAndButtons ?? 0) > 0)
            //   SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
            _buildOkButton(Theme.of(context).colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(ColorScheme colorScheme) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _editCache = _values;
        widget.onCancelTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnCancelTapped ?? true)) {
          Navigator.pop(context);
        }
      }),
      child: Container(
        width: 90,
        height: 40,
        decoration: BoxDecoration(
            color: MyThemeColors.myGreyscale.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Text(
            "닫기",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyThemeColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOkButton(ColorScheme colorScheme) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _values = _editCache;
        widget.onValueChanged?.call(_values);
        widget.onOkTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnOkTapped ?? true)) {
          Navigator.pop(context, _values);
        }
      }),
      child: Container(
        width: 90,
        height: 40,
        decoration: BoxDecoration(
            color: MyThemeColors.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Text(
            "확인",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyThemeColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
