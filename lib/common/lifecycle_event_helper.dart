import '../index.dart';
import 'package:flutter/foundation.dart';

// 全局app 判断是打开 还是进入后台
AppLifecycleState lifecycleState = AppLifecycleState.inactive;
class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        lifecycleState = state;
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
        lifecycleState = state;
        print('AppLifecycleState===========================: $state');
        var activeCall = await callKeepIn.isCallActive(callingUuid);
        logger.d(activeCall);
        break;
      case AppLifecycleState.paused:
        lifecycleState = state;
        print('AppLifecycleState===========================: $state');
        break;
      case AppLifecycleState.detached:
        lifecycleState = state;
        print('AppLifecycleState===========================: $state');
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}