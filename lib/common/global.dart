
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

import '../index.dart';

// // 提供可选主题色
List exampleColor = [
  // 52, 120, 246 蓝色
  Color.fromRGBO(52, 120, 246, 1).value,
  //87, 190, 232
  Color.fromRGBO(87, 190, 232, 1).value,
  // 89, 176, 64
  Color.fromRGBO(89, 176, 64, 1).value,
  //220, 115, 162
  Color.fromRGBO(220, 115, 162, 1).value,
  //225, 136, 50
  Color.fromRGBO(225, 136, 50, 1).value,
  // 143, 114, 231
  Color.fromRGBO(143, 114, 231, 1).value,
  //194, 65, 38
  Color.fromRGBO(194, 65, 38, 1).value,
  //228, 182, 62
  Color.fromRGBO(228, 182, 62, 1).value,
  //113, 130, 156
  Color.fromRGBO(113, 130, 156, 1).value,
  //0, 0, 0 light模式主文字包含黑色，去掉白色
  Color.fromRGBO(0, 0, 0, 1).value,
];
//
// List themesDark = [
//   //52, 120, 246 蓝色
//   Color.fromRGBO(52, 120, 246, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(225, 136, 50, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(89, 176, 64, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(220, 115, 162, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(225, 136, 50, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(143, 114, 231, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(194, 65, 38, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(228, 182, 62, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(113, 130, 156, 1).value,
//   //255, 255, 255 dark模式主颜色包含白色，去掉黑色
//   Color.fromRGBO(255, 255, 255, 1).value,
// ];
//
// // 提供可选消息背景色
// List themesDayMessage = [
//   // 52, 120, 246 蓝色
//   Color.fromRGBO(52, 120, 246, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(87, 190, 232, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(89, 176, 64, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(220, 115, 162, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(225, 136, 50, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(143, 114, 231, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(194, 65, 38, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(228, 182, 62, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(113, 130, 156, 1).value,
//   //0, 0, 0 light模式主文字包含黑色，去掉白色
//   Color.fromRGBO(0, 0, 0, 1).value,
// ];
//
// List themesDarkMessage = [
//   //52, 120, 246 蓝色
//   Color.fromRGBO(52, 120, 246, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(87, 190, 232, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(89, 176, 64, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(220, 115, 162, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(225, 136, 50, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(143, 114, 231, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(194, 65, 38, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(228, 182, 62, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(113, 130, 156, 1).value,
//   //255, 255, 255 dark模式主颜色包含白色，去掉黑色
//   Color.fromRGBO(255, 255, 255, 1).value,
// ];
//
// // day模式 主题颜色对应聊天页面背景颜色
// List themesDayBg = [
//   // 52, 120, 246 蓝色
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(255, 255, 255, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(255, 255, 255, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //255, 255, 255
//   Color.fromRGBO(255, 255, 255, 1).value,
// ];
//
// // dark模式 主题颜色对应聊天页面背景颜色
// List themesDarkBg = [
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(0, 0, 0, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(0, 0, 0, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //0, 0, 0
//   Color.fromRGBO(0, 0, 0, 1).value,
// ];
//
//
// // day模式 主题颜色对应聊天页面背景颜色 渐变色
// List themesDayBg2 = [
//   // 52, 120, 246 蓝色
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(255, 255, 255, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(255, 255, 255, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(255, 255, 255, 1).value,
//   //255, 255, 255
//   Color.fromRGBO(255, 255, 255, 1).value,
// ];
//
// // dark模式 主题颜色对应聊天页面背景颜色 渐变色
// List themesDarkBg2 = [
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //87, 190, 232
//   Color.fromRGBO(0, 0, 0, 1).value,
//   // 89, 176, 64
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //220, 115, 162
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //225, 136, 50
//   Color.fromRGBO(0, 0, 0, 1).value,
//   // 143, 114, 231
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //194, 65, 38
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //228, 182, 62
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //113, 130, 156
//   Color.fromRGBO(0, 0, 0, 1).value,
//   //0, 0, 0
//   Color.fromRGBO(0, 0, 0, 1).value,
// ];

List dayList = [
  {
    'primary': Color.fromRGBO(52, 120, 246, 1).value,
    'message': Color.fromRGBO(52, 120, 246, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  //52, 120, 246
  // 230, 96, 237
  {
    'primary': Color.fromRGBO(52, 120, 246, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'background2': null,
    'message': Color.fromRGBO(52, 120, 246, 1).value,
    'message2': Color.fromRGBO(230, 96, 237, 1).value,
  },
  //180, 229, 99
  //77, 173, 154
  {
    'primary': Color.fromRGBO(77, 173, 154, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'background2': null,
    'message': Color.fromRGBO(180, 229, 99, 1).value,
    'message2': Color.fromRGBO(77, 173, 154, 1).value,
  },

  //243, 216, 72
  //194, 64, 37
  {
    'primary': Color.fromRGBO(194, 64, 37, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'background2': null,
    'message': Color.fromRGBO(243, 216, 72, 1).value,
    'message2': Color.fromRGBO(194, 64, 37, 1).value,
  },

  //221, 143, 232
  //86, 189, 232
  {
    'primary': Color.fromRGBO(221, 143, 232, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'background2': null,
    'message': Color.fromRGBO(221, 143, 232, 1).value,
    'message2': Color.fromRGBO(86, 189, 232, 1).value,
  },

  {
    'primary': Color.fromRGBO(87, 190, 232, 1).value,
    'message': Color.fromRGBO(87, 190, 232, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(89, 176, 64, 1).value,
    'message': Color.fromRGBO(89, 176, 64, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(220, 115, 162, 1).value,
    'message': Color.fromRGBO(220, 115, 162, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(225, 136, 50, 1).value,
    'message': Color.fromRGBO(225, 136, 50, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(143, 114, 231, 1).value,
    'message': Color.fromRGBO(143, 114, 231, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(194, 65, 38, 1).value,
    'message': Color.fromRGBO(194, 65, 38, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(228, 182, 62, 1).value,
    'message': Color.fromRGBO(228, 182, 62, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(113, 130, 156, 1).value,
    'message': Color.fromRGBO(113, 130, 156, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(0, 0, 0, 1).value,
    'message': Color.fromRGBO(0, 0, 0, 1).value,
    'background': Color.fromRGBO(255, 255, 255, 1).value,
    'message2': null,
    'background2': null,
  },
];


List darkList = [
  {
    'primary': Color.fromRGBO(52, 120, 246, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'background2': null,
    'message': Color.fromRGBO(52, 120, 246, 1).value,
    'message2': null,
  },
  //52, 120, 246
  // 230, 96, 237
  {
    'primary': Color.fromRGBO(52, 120, 246, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'background2': null,
    'message': Color.fromRGBO(52, 120, 246, 1).value,
    'message2': Color.fromRGBO(230, 96, 237, 1).value,
  },
  //180, 229, 99
  //77, 173, 154
  {
    'primary': Color.fromRGBO(77, 173, 154, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'background2': null,
    'message': Color.fromRGBO(180, 229, 99, 1).value,
    'message2': Color.fromRGBO(77, 173, 154, 1).value,
  },

  //243, 216, 72
  //194, 64, 37
  {
    'primary': Color.fromRGBO(194, 64, 37, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'background2': null,
    'message': Color.fromRGBO(243, 216, 72, 1).value,
    'message2': Color.fromRGBO(194, 64, 37, 1).value,
  },

  //221, 143, 232
  //86, 189, 232
  {
    'primary': Color.fromRGBO(221, 143, 232, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'background2': null,
    'message': Color.fromRGBO(221, 143, 232, 1).value,
    'message2': Color.fromRGBO(86, 189, 232, 1).value,
  },


  {
    'primary': Color.fromRGBO(87, 190, 232, 1).value,
    'message': Color.fromRGBO(87, 190, 232, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(89, 176, 64, 1).value,
    'message': Color.fromRGBO(89, 176, 64, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(220, 115, 162, 1).value,
    'message': Color.fromRGBO(220, 115, 162, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(225, 136, 50, 1).value,
    'message': Color.fromRGBO(225, 136, 50, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(143, 114, 231, 1).value,
    'message': Color.fromRGBO(143, 114, 231, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(194, 65, 38, 1).value,
    'message': Color.fromRGBO(194, 65, 38, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(228, 182, 62, 1).value,
    'message': Color.fromRGBO(228, 182, 62, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(113, 130, 156, 1).value,
    'message': Color.fromRGBO(113, 130, 156, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
  {
    'primary': Color.fromRGBO(255, 255, 255, 1).value,
    'message': Color.fromRGBO(255, 255, 255, 1).value,
    'background': Color.fromRGBO(0, 0, 0, 1).value,
    'message2': null,
    'background2': null,
  },
];
// Map<int, Map> dayTheme = <int, Map>{
//   0: {
//     'primary': Color.fromRGBO(52, 120, 246, 1).value,
//     'message': Color.fromRGBO(52, 120, 246, 1).value,
//     'background': Color.fromRGBO(255, 255, 255, 1).value,
//   },
//   1: {
//
//   },
//   2: {
//
//   },
// };
//
// Map<int, Map> darkTheme = <int, Map>{
//   0: {
//     'primary': Color.fromRGBO(52, 120, 246, 1).value,
//     'message': Color.fromRGBO(52, 120, 246, 1).value,
//     'background': Color.fromRGBO(0, 0, 0, 1).value,
//   },
//   1: {
//
//   },
//   2: {
//
//   },
// };
//
// Map<int, Map> backgroundGradient = <int, Map>{
//   0: {
//     'primary': Color.fromRGBO(52, 120, 246, 1).value,
//     'message': Color.fromRGBO(52, 120, 246, 1).value,
//     'background': Color.fromRGBO(0, 0, 0, 1).value,
//   },
//   1: {
//
//   },
//   2: {
//
//   },
// };


class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  // 网络缓存对象
  static NetCache netCache = NetCache();

  // 可选的主题列表
  static List get themes {
    if (profile.themeMode == 1) {
      return profile.dayList == null || profile.dayList.length == 0
          ? dayList
          : profile.dayList;
    } else if (profile.themeMode == 2) {
      return profile.darkList == null || profile.darkList.length == 0
          ? darkList
          : profile.darkList;
    } else {
      return profile.dayList == null || profile.dayList.length == 0
          ? dayList
          : profile.dayList;
    }
  }

  // profile.themeMode == 2 ? themesDark : themesDay;

  // 可选的 消息背景色
  // static List get themesMessage {
  //   if (profile.themeMode == 1) {
  //     return profile.themesDayMessage == null
  //         ? themesDayMessage
  //         : profile.themesDayMessage;
  //   } else if (profile.themeMode == 2) {
  //     return profile.themesDarkMessage == null
  //         ? themesDarkMessage
  //         : profile.themesDarkMessage;
  //   } else {
  //     return profile.themesDayMessage == null
  //         ? themesDayMessage
  //         : profile.themesDayMessage;
  //   }
  // }
  //
  // // 可选的聊天页面背景主题列表
  // static List get themesBg {
  //   if (profile.themeMode == 1) {
  //     return profile.themesDayBg == null ? themesDayBg : profile.themesDayBg;
  //   } else if (profile.themeMode == 2) {
  //     return profile.themesDarkBg == null ? themesDarkBg : profile.themesDarkBg;
  //   } else {
  //     return profile.themesDayBg == null ? themesDayBg : profile.themesDayBg;
  //   }
  // }
  //
  // // 可选的聊天页面背景主题列表 渐变色
  // static List get themesBg2 {
  //   if (profile.themeMode == 1) {
  //     return profile.themesDayBg2 == null ? themesDayBg : profile.themesDayBg2;
  //   } else if (profile.themeMode == 2) {
  //     return profile.themesDarkBg2 == null ? themesDarkBg : profile.themesDarkBg2;
  //   } else {
  //     return profile.themesDayBg2 == null ? themesDayBg : profile.themesDayBg2;
  //   }
  // }



  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static List chatPositionList = [];

  static String voipToken = '';
  static String firebaseToken = '';
  static String apnsToken = '';

  // 视频或者语音 uuid
  static String currentCallUuid = '';

  // 显示系统拨打电话界面 0 没有 1 有
  static String hasCall = '0';

  // 拨打朋友 ID
  static String callFriendId = '0';

  // 拨打 group ID
  static String callGroupId = '0';

  // 呼叫人 名字
  static String callerName = '';

  // 背景图片
  static String backgroundImage;
  static String backgroundImageUrl;

  static String appVersion;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
        // day 主题 list
        if (profile.dayList == null) {
          profile.dayList = dayList;
        }
        // dark 主题 list
        if (profile.darkList == null) {
          profile.darkList = darkList;
        }
        saveProfile();
      } catch (e) {
        print(e);
      }
    } else {
      profile.dayList = dayList;
      profile.darkList = darkList;
    }
    voipToken = _prefs.getString("voipToken");
    firebaseToken = _prefs.getString("firebaseToken");
    apnsToken = _prefs.getString("apnsToken");
    // 视频或者语音 uuid
    currentCallUuid = _prefs.getString("currentCallUuid");
    // 是否显示系统拨打电话界面
    hasCall = _prefs.getString("hasCall");
    // 拨打朋友 ID
    callFriendId = _prefs.getString("callFriendId");
    // 拨打 group ID
    callGroupId = _prefs.getString("callGroupId");
    // 呼叫人 名字
    callerName = _prefs.getString("callerName");

    backgroundImage  = _prefs.getString("backgroundImage");
    backgroundImageUrl  = _prefs.getString("backgroundImageUrl");

    appVersion = _prefs.getString("appVersion");

    if (currentCallUuid == null) {
      _prefs.setString("currentCallUuid", '');
      currentCallUuid = '';
    }
    if (hasCall == null) {
      _prefs.setString("hasCall", '0');
      hasCall = '0';
    }
    if (callFriendId == null) {
      _prefs.setString("callFriendId", '0');
      callFriendId = '0';
    }
    if (callGroupId == null) {
      _prefs.setString("callGroupId", '0');
      callGroupId = '0';
    }
    if (callerName == null) {
      callerName = '';
      _prefs.setString("callerName", '');
    }
    if (appVersion == null) {
      appVersion = '1.0.0';
      _prefs.setString("appVersion", '1.0.0');
    }

//    chatPositionList = jsonDecode(_prefs.getString("chatPositionList"));
    // 如果没有缓存策略，设置默认缓存策略
//    profile.cache = profile.cache ?? CacheConfig()
//      ..enable = true
//      ..maxAge = 3600
//      ..maxCount = 100;

    //初始化网络请求相关配置
    Git.init();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    // print('app version: $version');
    if (version != appVersion) {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.fileUpdateLocalUrl();

      if (backgroundImage != null) {
        final dbHelper = DatabaseHelper.instance;
        FileSql fileInfo = dbHelper.fileOne(int.parse(backgroundImage));
        if (fileInfo != null) {
          backgroundImageUrl = fileInfo.fileOriginLocal;
        }
      }
      saveAppVersion(version);
    }

  }

  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));

  static saveHistory(List list) =>
      _prefs.setString("chatPositionList", jsonEncode(list));

  static savePosition({
    int group = 0,
    int contactId = 0,
    double extentBefore,
    double extentAfter,
    int extentAfterId,
    int extentBeforeId,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    int userId = Global.profile.user.userId;
    Map info = {
      "extentBefore": extentBefore,
      "extentAfter": extentAfter,
      "extentAfterId": extentAfterId,
      "extentBeforeId": extentBeforeId,
    };
    prefs.setString("$group-$userId-$contactId", jsonEncode(info));
  }

  static getPosition({
    int group = 0,
    int contactId = 0,
    double extentBefore,
    double extentAfter,
    int extentAfterId,
    int extentBeforeId,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    int userId = Global.profile.user.userId;
    var info = prefs.getString("$group-$userId-$contactId");
    return info == null ? null : jsonDecode(info);
  }

  // ios VoIP token
  static saveVoipToken(String value) =>
      _prefs.setString("voipToken", value);

  // firebase notification device token
  static saveFirebaseToken(String value) =>
      _prefs.setString("firebaseToken", value);

  // apns notification device token
  static saveApnsToken(String value) =>
      _prefs.setString("apnsToken", value);

  // call 类别
  static saveUuid(String value) {
    Global.currentCallUuid = value;
    _prefs.setString("currentCallUuid", value);
  }

  static saveHasCall(String value) {
    Global.hasCall = value;
    _prefs.setString("hasCall", value);
  }

  static saveCallFriendId(String value) {
    Global.callFriendId = value;
    _prefs.setString("callFriendId", value);
  }

  static saveCallGroupId(String value) {
    Global.callGroupId = value;
    _prefs.setString("callGroupId", value);
  }

  static saveCallerName(String value) {
    Global.callerName = value;
    _prefs.setString("callerName", value);
  }


  static saveBackgroundImage(String value, String url) {
    Global.backgroundImage = value;
    Global.backgroundImageUrl = url;
    _prefs.setString("backgroundImage", value);
    _prefs.setString("backgroundImageUrl", url);
  }
  static saveAppVersion(String value) {
    Global.appVersion = value;
    _prefs.setString("appVersion", value);
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
