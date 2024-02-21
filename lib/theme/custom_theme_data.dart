import 'package:flutter/material.dart';

class BandiColor {
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).backgroundColor;
  }

  static Color accentColor(BuildContext context) {
    return Theme.of(context).secondaryHeaderColor;
  }

  static Color errorColor(BuildContext context) {
    return Theme.of(context).errorColor;
  }

  static Color gray001Color(BuildContext context) {
    return Theme.of(context).disabledColor;
  }

  static Color gray002Color(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  static Color gray003Color(BuildContext context) {
    return Theme.of(context).focusColor;
  }

  static Color gray004Color(BuildContext context) {
    return Theme.of(context).highlightColor;
  }

  static Color gray005Color(BuildContext context) {
    return Theme.of(context).hintColor;
  }

  static Color gray006Color(BuildContext context) {
    return Theme.of(context).hoverColor;
  }

  static Color transparent(BuildContext context) {
    return Colors.transparent;
  }
}

class BandiFont {
  static TextStyle? headline1(BuildContext context) {
    return Theme.of(context).textTheme.headline1;
  }

  static TextStyle? headline2(BuildContext context) {
    return Theme.of(context).textTheme.headline2;
  }

  static TextStyle? headline3(BuildContext context) {
    return Theme.of(context).textTheme.headline3;
  }

  static TextStyle? headline4(BuildContext context) {
    return Theme.of(context).textTheme.headline4;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2;
  }

  static TextStyle? body3(BuildContext context) {
    return Theme.of(context).textTheme.headline5;
  }

  static TextStyle? normal(BuildContext context) {
    return Theme.of(context).textTheme.button;
  }

  static TextStyle? medium(BuildContext context) {
    return Theme.of(context).textTheme.caption;
  }

  static TextStyle? small(BuildContext context) {
    return Theme.of(context).textTheme.overline;
  }

  static TextStyle? small2(BuildContext context) {
    return Theme.of(context).textTheme.headline6;
  }

  static TextStyle? text1(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1;
  }

  static TextStyle? text2(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2;
  }
}

class CustomThemeData {
  static final ThemeData light = ThemeData(
    textTheme: textTheme,
    primaryColor: const Color(0xff000000),
    backgroundColor: const Color(0xffFFFFFF),
    secondaryHeaderColor: const Color(0xffFFCB46), // AccentColor
    errorColor: const Color(0xffC33025),

    //grey
    disabledColor: const Color(0xffEFEFEF), // Border
    dividerColor: const Color(0xffD5D5D5), // Button -inactive
    focusColor: const Color(0xffB4B4B4),
    highlightColor: const Color(0xff6E6E6E), // Label,
    hintColor: const Color(0xff4E4E4E), // Text,
    hoverColor: const Color(0xff2E2E2E), // Header,
  );

  static final ThemeData dark = ThemeData(
    textTheme: textTheme,
    primaryColor: const Color(0xffffffff),
    backgroundColor: const Color(0xff000000),
    secondaryHeaderColor: const Color(0xffFFCB46), // AccentColor
    errorColor: const Color(0xffC33025),

    //grey
    disabledColor: const Color(0xff1C1C1C), // Border
    dividerColor: const Color(0xff444444), // Button -inactive
    focusColor: const Color(0xff6E6E6E),
    highlightColor: const Color(0xffA2A2A2), // Label,
    hintColor: const Color(0xffC2C2C2), // Text,
    hoverColor: const Color(0xffE2E2E2), // Header,
  );

  static TextTheme textTheme = const TextTheme(
    headline1: TextStyle(
        fontFamily: "IBMPlexSansSemiBold", fontSize: 28, height: 36 / 28),
    headline2: TextStyle(
        fontFamily: "IBMPlexSansSemiBold", fontSize: 20, height: 28 / 20),
    headline3: TextStyle(
        fontFamily: "IBMPlexSansSemiBold", fontSize: 18, height: 24 / 18),
    headline4: TextStyle(
        fontFamily: "IBMPlexSansSemiBold", fontSize: 16, height: 20 / 16),
    subtitle1: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 16, height: 24 / 16),
    subtitle2: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 14, height: 20 / 14),
    headline5: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 12, height: 16 / 12),
    button: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 18, height: 24 / 18),
    caption: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 16, height: 20 / 16),
    overline: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 14, height: 16 / 14),
    headline6: TextStyle(
        fontFamily: "IBMPlexSansSemiBold", fontSize: 11, height: 22 / 11),
    bodyText1: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 16, height: 24 / 16),
    bodyText2: TextStyle(
        fontFamily: "IBMPlexSansRegular", fontSize: 12, height: 16 / 12),
  );
}
