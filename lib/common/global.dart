import '../index.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 提供可选主题色
List themesDay = [
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

List themesDark = [
  //52, 120, 246 蓝色
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
  //255, 255, 255 dark模式主颜色包含白色，去掉黑色
  Color.fromRGBO(255, 255, 255, 1).value,
];

// 提供可选消息背景色
List themesDayMessage = [
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

List themesDarkMessage = [
  //52, 120, 246 蓝色
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
  //255, 255, 255 dark模式主颜色包含白色，去掉黑色
  Color.fromRGBO(255, 255, 255, 1).value,
];

// day模式 主题颜色对应聊天页面背景颜色
List themesDayBg = [
  // 52, 120, 246 蓝色
  Color.fromRGBO(255, 255, 255, 1).value,
  //87, 190, 232
  Color.fromRGBO(255, 255, 255, 1).value,
  // 89, 176, 64
  Color.fromRGBO(255, 255, 255, 1).value,
  //220, 115, 162
  Color.fromRGBO(255, 255, 255, 1).value,
  //225, 136, 50
  Color.fromRGBO(255, 255, 255, 1).value,
  // 143, 114, 231
  Color.fromRGBO(255, 255, 255, 1).value,
  //194, 65, 38
  Color.fromRGBO(255, 255, 255, 1).value,
  //228, 182, 62
  Color.fromRGBO(255, 255, 255, 1).value,
  //113, 130, 156
  Color.fromRGBO(255, 255, 255, 1).value,
  //255, 255, 255
  Color.fromRGBO(255, 255, 255, 1).value,
];

// dark模式 主题颜色对应聊天页面背景颜色
List themesDarkBg = [
  Color.fromRGBO(0, 0, 0, 1).value,
  //87, 190, 232
  Color.fromRGBO(0, 0, 0, 1).value,
  // 89, 176, 64
  Color.fromRGBO(0, 0, 0, 1).value,
  //220, 115, 162
  Color.fromRGBO(0, 0, 0, 1).value,
  //225, 136, 50
  Color.fromRGBO(0, 0, 0, 1).value,
  // 143, 114, 231
  Color.fromRGBO(0, 0, 0, 1).value,
  //194, 65, 38
  Color.fromRGBO(0, 0, 0, 1).value,
  //228, 182, 62
  Color.fromRGBO(0, 0, 0, 1).value,
  //113, 130, 156
  Color.fromRGBO(0, 0, 0, 1).value,
  //0, 0, 0
  Color.fromRGBO(0, 0, 0, 1).value,
];


// day模式 主题颜色对应聊天页面背景颜色 渐变色
List themesDayBg2 = [
  // 52, 120, 246 蓝色
  Color.fromRGBO(255, 255, 255, 1).value,
  //87, 190, 232
  Color.fromRGBO(255, 255, 255, 1).value,
  // 89, 176, 64
  Color.fromRGBO(255, 255, 255, 1).value,
  //220, 115, 162
  Color.fromRGBO(255, 255, 255, 1).value,
  //225, 136, 50
  Color.fromRGBO(255, 255, 255, 1).value,
  // 143, 114, 231
  Color.fromRGBO(255, 255, 255, 1).value,
  //194, 65, 38
  Color.fromRGBO(255, 255, 255, 1).value,
  //228, 182, 62
  Color.fromRGBO(255, 255, 255, 1).value,
  //113, 130, 156
  Color.fromRGBO(255, 255, 255, 1).value,
  //255, 255, 255
  Color.fromRGBO(255, 255, 255, 1).value,
];

// dark模式 主题颜色对应聊天页面背景颜色 渐变色
List themesDarkBg2 = [
  Color.fromRGBO(0, 0, 0, 1).value,
  //87, 190, 232
  Color.fromRGBO(0, 0, 0, 1).value,
  // 89, 176, 64
  Color.fromRGBO(0, 0, 0, 1).value,
  //220, 115, 162
  Color.fromRGBO(0, 0, 0, 1).value,
  //225, 136, 50
  Color.fromRGBO(0, 0, 0, 1).value,
  // 143, 114, 231
  Color.fromRGBO(0, 0, 0, 1).value,
  //194, 65, 38
  Color.fromRGBO(0, 0, 0, 1).value,
  //228, 182, 62
  Color.fromRGBO(0, 0, 0, 1).value,
  //113, 130, 156
  Color.fromRGBO(0, 0, 0, 1).value,
  //0, 0, 0
  Color.fromRGBO(0, 0, 0, 1).value,
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
      return profile.themesDay == null || profile.themesDay.length == 0
          ? themesDay
          : profile.themesDay;
    } else if (profile.themeMode == 2) {
      return profile.themesDark == null || profile.themesDark.length == 0
          ? themesDark
          : profile.themesDark;
    } else {
      return profile.themesDay == null || profile.themesDay.length == 0
          ? themesDay
          : profile.themesDay;
    }
  }

  // profile.themeMode == 2 ? themesDark : themesDay;

  // 可选的 消息背景色
  static List get themesMessage {
    if (profile.themeMode == 1) {
      return profile.themesDayMessage == null
          ? themesDayMessage
          : profile.themesDayMessage;
    } else if (profile.themeMode == 2) {
      return profile.themesDarkMessage == null
          ? themesDarkMessage
          : profile.themesDarkMessage;
    } else {
      return profile.themesDayMessage == null
          ? themesDayMessage
          : profile.themesDayMessage;
    }
  }

  // 可选的聊天页面背景主题列表
  static List get themesBg {
    if (profile.themeMode == 1) {
      return profile.themesDayBg == null ? themesDayBg : profile.themesDayBg;
    } else if (profile.themeMode == 2) {
      return profile.themesDarkBg == null ? themesDarkBg : profile.themesDarkBg;
    } else {
      return profile.themesDayBg == null ? themesDayBg : profile.themesDayBg;
    }
  }

  // 可选的聊天页面背景主题列表 渐变色
  static List get themesBg2 {
    if (profile.themeMode == 1) {
      return profile.themesDayBg2 == null ? themesDayBg : profile.themesDayBg2;
    } else if (profile.themeMode == 2) {
      return profile.themesDarkBg2 == null ? themesDarkBg : profile.themesDarkBg2;
    } else {
      return profile.themesDayBg2 == null ? themesDayBg : profile.themesDayBg2;
    }
  }

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

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
        // logger.d(profile.themesDay);
        if (profile.themesDay == null) {
          profile.themesDay = themesDay;
        }
        // logger.d(profile.themesDay);
        if (profile.themesDark == null) {
          profile.themesDark = themesDark;
        }
        if (profile.themesDayMessage == null) {
          profile.themesDayMessage = themesDayMessage;
        }
        if (profile.themesDarkMessage == null) {
          profile.themesDarkMessage = themesDarkMessage;
        }
        // logger.d(profile.themesDayBg);
        if (profile.themesDayBg == null) {
          profile.themesDayBg = themesDayBg;
        }
        if (profile.themesDarkBg == null) {
          profile.themesDarkBg = themesDarkBg;
        }
        // logger.d(profile.themesDayBg);
        if (profile.themesDayBg2 == null) {
          profile.themesDayBg2 = themesDayBg2;
        }
        if (profile.themesDarkBg2 == null) {
          profile.themesDarkBg2 = themesDarkBg2;
        }
        saveProfile();
      } catch (e) {
        print(e);
      }
    } else {
      profile.themesDay = themesDay;
      profile.themesDark = themesDark;
      profile.themesDayMessage = themesDayMessage;
      profile.themesDarkMessage = themesDarkMessage;
      profile.themesDayBg = themesDayBg;
      profile.themesDarkBg = themesDarkBg;
      profile.themesDayBg2 = themesDayBg2;
      profile.themesDarkBg2 = themesDarkBg2;
    }
    voipToken = _prefs.getString("voipToken");
    firebaseToken = _prefs.getString("firebaseToken");
    apnsToken = _prefs.getString("apnsToken");

    _prefs.setString("currentCallUuid", '');
    _prefs.setString("hasCall", '0');
    _prefs.setString("callFriendId", '0');
    _prefs.setString("callGroupId", '0');
    _prefs.setString("callerName", '');
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

//    chatPositionList = jsonDecode(_prefs.getString("chatPositionList"));
    // 如果没有缓存策略，设置默认缓存策略
//    profile.cache = profile.cache ?? CacheConfig()
//      ..enable = true
//      ..maxAge = 3600
//      ..maxCount = 100;

    //初始化网络请求相关配置
    Git.init();
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
  static saveVoipToken(String voipToken) =>
      _prefs.setString("voipToken", voipToken);

  // firebase notification device token
  static saveFirebaseToken(String firebaseToken) =>
      _prefs.setString("firebaseToken", firebaseToken);

  // apns notification device token
  static saveApnsToken(String apnsToken) =>
      _prefs.setString("apnsToken", apnsToken);

  // call 类别
  static saveUuid(String uuid) {
    Global.currentCallUuid = uuid;
    _prefs.setString("currentCallUuid", uuid);
  }

  static saveHasCall(String hasCall) {
    Global.hasCall = hasCall;
    _prefs.setString("hasCall", hasCall);
  }

  static saveCallFriendId(String callFriendId) {
    Global.callFriendId = callFriendId;
    _prefs.setString("callFriendId", callFriendId);
  }

  static saveCallGroupId(String callGroupId) {
    Global.callGroupId = callGroupId;
    _prefs.setString("callGroupId", callGroupId);
  }

  static saveCallerName(String callerName) {
    Global.callerName = callerName;
    _prefs.setString("callerName", callerName);
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
