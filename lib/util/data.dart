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

  static Color iosLightTextGrey() {
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

  static Brightness brightness() {
    Brightness colorValue;
    colorValue =
        Global.profile.themeMode == 1 ? Brightness.light : Brightness.dark;
    return colorValue;
  }

  // 主颜色 themes
  static Color primaryColor() {
    Color colorValue;
    colorValue = Color(Global.themes[Global.profile.theme]);
    return colorValue;
  }

  // 自己消息背景 themesMessage
  static Color messagesColor() {
    Color colorValue;
    colorValue = Color(Global.themesMessage[Global.profile.theme]);
    return colorValue;
  }

  // 对方消息背景 固定
  static Color messagesColorSide() {
    Color colorValue;
    // colorValue = Global.themes[Global.profile.theme];
    if (Global.profile.themeMode == 1) {
      //214, 221, 229
      colorValue = Color.fromRGBO(214, 221, 229, 1);
      // colorValue = CupertinoColors.lightBackgroundGray;
    } else if (Global.profile.themeMode == 2) {
      //38, 38, 40
      colorValue = Color.fromRGBO(38, 38, 40, 1);
      // colorValue = CupertinoColors.darkBackgroundGray;
    }
    return colorValue;
  }

  // 聊天页面背景颜色 themesBg
  static Color messagesChatBg() {
    Color colorValue;
    colorValue = Color(Global.themesBg[Global.profile.theme]);
    // colorValue = CupertinoColors.
    return colorValue;
  }

  //其他主题颜色
// scaffoldBackgroundColor
  static Color scaffoldBackgroundColor() {
    Color colorValue;
    // colorValue = Global.themes[Global.profile.theme];
    if (Global.profile.themeMode == 1) {
      //239, 239, 244
      colorValue = Color.fromRGBO(239, 239, 244, 1);
    } else if (Global.profile.themeMode == 2) {
      colorValue = Color.fromRGBO(0, 0, 0, 1);
    }
    return colorValue;
  }

//bar Background
  static Color barBackgroundColor() {
    Color colorValue;
    // colorValue = Global.themes[Global.profile.theme];
    if (Global.profile.themeMode == 1) {
      //246, 246, 248
      colorValue = Color.fromRGBO(248, 248, 248, 1);
    } else if (Global.profile.themeMode == 2) {
      colorValue = Color.fromRGBO(28, 28, 29, 1);
    }
    return colorValue;
  }

  // 黑色文字 bar menuList normal
  static Color normalColor() {
    Color colorValue;
    // colorValue = Global.themes[Global.profile.theme];
    if (Global.profile.themeMode == 1) {
      colorValue = Color.fromRGBO(0, 0, 0, 1);
    } else if (Global.profile.themeMode == 2) {
      //152, 152, 157
      colorValue = Color.fromRGBO(255, 255, 255, 1);
    }
    return colorValue;
  }

// 灰一点文字
  static Color inactiveColor() {
    Color colorValue;
    // colorValue = Global.themes[Global.profile.theme];
    if (Global.profile.themeMode == 1) {
      // 其他注释文字 110, 111, 115
      // bottom bar 143, 143, 143
      // 菜单栏列表 141, 141, 146
      colorValue = Color.fromRGBO(153, 153, 153, 1);
    } else if (Global.profile.themeMode == 2) {
      //152, 152, 157
      colorValue = Color.fromRGBO(117, 117, 117, 1);
    }
    return colorValue;
  }

  // self message color 白色
// 148, 148, 149 day / blue / other
// 182, 210, 252 day / blue / self
// 152, 152, 153 night / blue / other
// 147, 147, 148 night/ blue / self
// 聊天消息时间颜色
  // message 灰一点文字
  static Color inactiveColorMessage(bool self) {
    Color colorValue;
    if (Global.profile.themeMode == 1) {
      if (self) {
        colorValue = Color.fromRGBO(182, 210, 252, 1);
      } else {
        colorValue = Color.fromRGBO(148, 148, 149, 1);
      }
    } else if (Global.profile.themeMode == 2) {
      if (self) {
        colorValue = Color.fromRGBO(147, 147, 148, 1);
      } else {
        colorValue = Color.fromRGBO(152, 152, 153, 1);
      }
    }
    return colorValue;
  }

// 聊天输入框颜色
// 133, 142, 153 亮图标
// 133, 142, 153 灰线
// 143, 143, 143

// search 背景颜色
// dark 15, 15, 15
// day 226, 227, 231


  static int calcRanks(ranks) {
    double multiplier = .5;
    return (multiplier * ranks).round();
  }

}
