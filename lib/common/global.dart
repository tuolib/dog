import '../index.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.grey,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  // 网络缓存对象
  static NetCache netCache = NetCache();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static List chatPositionList = [];

  static String voipToken = '';
  static String firebaseToken = '';
  static String apnsToken = '';

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    voipToken = _prefs.getString("voipToken");
    firebaseToken = _prefs.getString("firebaseToken");
    apnsToken = _prefs.getString("apnsToken");
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
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


