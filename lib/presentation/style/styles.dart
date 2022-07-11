import 'package:flutter/material.dart';

class Utils {
  // -------------------  Colors  ------------------------
  static const DARK_BLUE_COLOR = Color.fromARGB(255, 31, 71, 97);
  static const YELLOW_COLOR = Color.fromARGB(255, 255, 197, 25);
  static const ORANGE_COLOR = Color.fromARGB(255, 252, 163, 0);
  static const WHITE_COLOR = Color.fromARGB(255, 255, 255, 255);

// -------------------  Styles  -------------------------
  static TextStyle getStyle(
          {double size = 16.0,
          FontWeight fontWeight = FontWeight.normal,
          Color textColor = DARK_BLUE_COLOR,
          Color backColor = YELLOW_COLOR}) =>
      TextStyle(
        fontFamily: 'Comfortaa',
        fontSize: size,
        fontWeight: fontWeight,
        color: textColor,
        backgroundColor: backColor,
      );

  static TextStyle getDarkStyle({required double size, required FontWeight fontWeight}) =>
      getStyle(
          size: size,
          fontWeight: fontWeight,
          textColor: DARK_BLUE_COLOR,
          backColor: YELLOW_COLOR);

  static TextStyle getLightStyle({required double size, required FontWeight fontWeight}) =>
      getStyle(
          size: size,
          fontWeight: fontWeight,
          textColor: YELLOW_COLOR,
          backColor: DARK_BLUE_COLOR);

  static TextStyle getAppBarStyle({double size = 20,}) => getStyle(
        size: size,
        fontWeight: FontWeight.bold,
        textColor: Utils.WHITE_COLOR,
        backColor: Utils.DARK_BLUE_COLOR,
      );

  static TextStyle getWhiteOnOrangeStyle({double size = 20,}) => getStyle(
      size: size,
      fontWeight: FontWeight.bold,
      backColor: Utils.ORANGE_COLOR,
      textColor: Utils.WHITE_COLOR);

  static TextStyle getWhiteOnYellowStyle({double size = 20,}) => getStyle(
      size: size,
      fontWeight: FontWeight.bold,
      backColor: Utils.YELLOW_COLOR,
      textColor: Utils.WHITE_COLOR);
}
