import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class BackDesktop {
  // 字符串常量，回到手机桌面
  static const String chanel = "back/desktop";

  // 返回到桌面事件
  static const String backDesktopEvent = "backDesktop";

  // 返回到桌面方法
  static Future<bool> backDesktop() async {
    final platform = MethodChannel(chanel);
    try {
      await platform.invokeMethod(backDesktopEvent);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(false);
  }
}
//class AndroidBackTop {
//  //初始化通信管道-设置退出到手机桌面
//  static const String CHANNEL = "android/back/desktop";
//  //设置回退到手机桌面
//  static Future<bool> backDeskTop() async {
//    final platform = MethodChannel(CHANNEL);
//    //通知安卓返回,到手机桌面
//    try {
//      final bool out = await platform.invokeMethod('backDesktop');
//      if (out) debugPrint('返回到桌面');
//    } on PlatformException catch (e) {
//      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
//      print(e.toString());
//    }
//    return Future.value(false);
//  }
//}

class AndroidBackTop {
  // Initialize the communication pipeline - set to exit to the phone desktop
  static const String CHANNEL = "android/back/desktop";

  // Set back to the phone desktop
  static Future<bool> BackDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    debugPrint('Exit to mobile desktop=Exit');
    // Notification Android returns, to the phone desktop
    try {
      final bool out = await platform.invokeMethod('setOut');
      if (out) {
        debugPrint('Setting success');
      }
    } on PlatformException catch (e) {
      debugPrint(
          "Communication failed (set fallback to Android phone desktop: setup failed)");
    }
    return Future.value(false);
  }

  // Set no processing
  static Future<bool> CancelBackDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    debugPrint('Exit to mobile desktop=Do not handle');
    // Notification Android returns, to the phone desktop
    try {
      final bool out = await platform.invokeMethod('cancelOut');
      if (out) {
        debugPrint('Setting canceled successfully');
      }
    } on PlatformException catch (e) {
      debugPrint(
          "Communication failed (set fallback to Android phone desktop: cancel failed)");
    }
    return Future.value(false);
  }
}
