import 'package:flutter/cupertino.dart';
import '../index.dart';


class DataUtil {

  static Color iosLightGrey() {
    Color colorValue;
    colorValue = Color.fromRGBO(239, 239, 244, 1);
    // colorValue = CupertinoColors.lightBackgroundGray;
    return colorValue;
  }

  static Color iosBarBgColor() {
    Color colorValue;
    colorValue = CupertinoColors.secondarySystemBackground;
    // colorValue = CupertinoTheme.of(mainScreePage).barBackgroundColor;
    return colorValue;
  }
  //144, 144, 144
  static Color iosLightTextColor() {
    Color colorValue;
    colorValue = Color.fromRGBO(144, 144, 144, 1);
    // colorValue = CupertinoColors.lightBackgroundGray;
    return colorValue;
  }

  static Color iosLightTextBlue() {
    Color colorValue;
    // colorValue = Color.fromRGBO(144, 144, 144, 1);
    colorValue = CupertinoColors.systemBlue;
    return colorValue;
  }
  
  static Color  iosLightTextGrey() {

    Color colorValue;
    colorValue = Color.fromRGBO(186, 185, 190, 1);
    return colorValue;
  }

  static Color iosLightTextBlack() {
    Color colorValue;
    colorValue = Color.fromRGBO(0, 0, 0, 1);
    // colorValue = CupertinoColors.lightBackgroundGray;
    return colorValue;
  }

  static Color iosActiveBlue() {
    Color colorValue;
    colorValue = CupertinoColors.activeBlue;
    return colorValue;
  }
  
  static Color iosBorderGreyShallow() {
    Color colorValue;
    colorValue = Color.fromRGBO(207, 206, 213, 1);
    return colorValue;
    
  }

  static Color iosBorderGreyDeep() {
    Color colorValue;
    colorValue = Color.fromRGBO(207, 206, 213, 1);
    return colorValue;

  }
}