import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:fluttercallKeepIn/fluttercallKeepIn.dart';
// import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:callkeep/callkeep.dart';

import 'package:uuid/uuid.dart';

// import 'package:flutter_call_kit/flutter_call_kit.dart';
// import 'package:flutter_voip_push_notification/flutter_voip_push_notification.dart';

import 'package:device_info/device_info.dart';

// import 'package:plain_notification_token/plain_notification_token.dart';
// import 'package:flutter_apns/apns.dart';

import '../index.dart';

class Call {
  Call(this.number);

  String number;
  bool held = false;
  bool muted = false;
}

final FlutterCallkeep callKeepIn = FlutterCallkeep();
Map<String, Call> calls = {};

String newUUID() => Uuid().v4();
BuildContext appContext;
// String _pushToken = '';
// FlutterVoipPushNotification _voipPush = FlutterVoipPushNotification();
//
// String _currentCallId;
// FlutterCallKit _callKit = FlutterCallKit();

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    initPlatformState();

    // final connector = createPushConnector();
    // connector.configure(
    //   // onLaunch: onResume,
    //   onResume: _onResume,
    //   onMessage: _onMessage,
    // );
    // connector.token.addListener(() {
    //   print('Token ${connector.token.value}');
    // });
    // connector.requestNotificationPermissions();
    logger.d('init no');
    // if (Platform.isIOS){
    //   configure();
    //   configureIosCall();
    // }
    if (!_initialized) {
      // For iOS request permission first.

      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          displayIncomingCall('123456');
        },
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
//          var payload = ;
//          var decodeSucceeded = false;
          var channelInfo = message['data'];
          if (channelInfo == null) return;
//          try {
////          var x = json.decode(payload) as Map<String, dynamic>;
//            channelInfo = json.decode(payload) as Map<String, dynamic>;
//            decodeSucceeded = true;
//          } on FormatException catch (e) {
//            print('The provided string is not valid JSON');
//          }
//          if (decodeSucceeded == false) return;
          print('groupId: ${channelInfo['groupId']}');
          if (channelInfo['groupId'] != null) {
            navigatorKey.currentState.pushNamed('conversation', arguments: {
              'groupId': channelInfo['groupId'],
              'groupType': channelInfo['groupType'],
              'groupName': channelInfo['groupName'],
              'groupAvatar': channelInfo['groupAvatar'],
              'isOnline': false,
              'content': channelInfo['content'],
              'createdDate': channelInfo['createdDate'],
              'groupMembers': 1,
            });
          }
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      await Git().requestPermissionsPhone();

      // CallKeep.ondidDisplayIncomingCall();

      // callKeepIn.setup(<String, dynamic>{
      //   'ios': {
      //     'appName': 'CallKeepDemo',
      //   },
      //   'android': {
      //     'alertTitle': 'Permissions required',
      //     'alertDescription':
      //     'This application needs to access your phone accounts',
      //     'cancelButton': 'Cancel',
      //     'okButton': 'ok',
      //   },
      // });

      _initialized = true;
    }
  }

  // Configures a voip push notification
  // Future<void> configure() async {
  //   // request permission (required)
  //   await _voipPush.requestNotificationPermissions();
  //
  //   // listen to voip device token changes
  //   _voipPush.onTokenRefresh.listen(onToken);
  //
  //   // do configure voip push
  //   _voipPush.configure(onMessage: onMessage, onResume: onResume);
  //
  //
  //   // final plainNotificationToken = PlainNotificationToken();
  //   // // (iOS Only) Need requesting permission of Push Notification.
  //   // if (Platform.isIOS) {
  //   //   // plainNotificationToken.requestPermission();
  //   //
  //   //   // If you want to wait until Permission dialog close,
  //   //   // you need wait changing setting registered.
  //   //   await plainNotificationToken.onIosSettingsRegistered.first;
  //   // }
  //   //
  //   // final String token = await plainNotificationToken.getToken();
  //   // logger.d('token: $token');
  // }
  //
  // /// Called when the device token changes
  // void onToken(String token) {
  //   // send token to your apn provider server
  //   _pushToken = token;
  //   logger.d(token);
  // }
  //
  Future<dynamic> _onMessage(Map<String, dynamic> payload) {
    // handle foreground notification
    print("received on foreground payload: $payload, ");
    return null;
  }

  Future<dynamic> _onResume(Map<String, dynamic> payload) {
    // handle background notification
    print("received on background payload: $payload,");
    // showLocalNotification(payload);
    return null;
  }

  //
  // /// Called to receive notification when app is in foreground
  // ///
  // /// [isLocal] is true if its a local notification or false otherwise (remote notification)
  // /// [payload] the notification payload to be processed. use this to present a local notification
  // Future<dynamic> onMessage(bool isLocal, Map<String, dynamic> payload) {
  //   // handle foreground notification
  //   print("received on foreground payload: $payload, isLocal=$isLocal");
  //   return null;
  // }
  //
  // /// Called to receive notification when app is resuming from background
  // ///
  // /// [isLocal] is true if its a local notification or false otherwise (remote notification)
  // /// [payload] the notification payload to be processed. use this to present a local notification
  // Future<dynamic> onResume(bool isLocal, Map<String, dynamic> payload) {
  //   // handle background notification
  //   print("received on background payload: $payload, isLocal=$isLocal");
  //   showLocalNotification(payload);
  //   return null;
  // }
  //
  // showLocalNotification(Map<String, dynamic> notification) {
  //   String alert = notification["aps"]["alert"];
  //   _voipPush.presentLocalNotification(LocalNotification(
  //     alertBody: "Hello $alert",
  //   ));
  // }
  //
  // Future<void> configureIosCall() async {
  //   _callKit.configure(
  //     IOSOptions("My Awesome APP",
  //         imageName: 'sim_icon',
  //         supportsVideo: false,
  //         maximumCallGroups: 1,
  //         maximumCallsPerCallGroup: 1),
  //     didReceiveStartCallAction: _didReceiveStartCallAction,
  //     performAnswerCallAction: _performAnswerCallAction,
  //     performEndCallAction: _performEndCallAction,
  //     didActivateAudioSession: _didActivateAudioSession,
  //     didDisplayIncomingCall: _didDisplayIncomingCall,
  //     didPerformSetMutedCallAction: _didPerformSetMutedCallAction,
  //     didPerformDTMFAction: _didPerformDTMFAction,
  //     didToggleHoldAction: _didToggleHoldAction,
  //   );
  //   // setState(() {
  //   //   _configured = true;
  //   // });
  // }
  //
  // /// Use startCall to ask the system to start a call - Initiate an outgoing call from this point
  // Future<void> startCall(String handle, String localizedCallerName) async {
  //   /// Your normal start call action
  //   await _callKit.startCall(currentCallId, handle, localizedCallerName);
  // }
  //
  // Future<void> reportEndCallWithUUID(String uuid, EndReason reason) async {
  //   await _callKit.reportEndCallWithUUID(uuid, reason);
  // }
  //
  // /// Event Listener Callbacks
  //
  // Future<void> _didReceiveStartCallAction(String uuid, String handle) async {
  //   // Get this event after the system decides you can start a call
  //   // You can now start a call from within your app
  // }
  //
  // Future<void> _performAnswerCallAction(String uuid) async {
  //   // Called when the user answers an incoming call
  // }
  //
  // Future<void> _performEndCallAction(String uuid) async {
  //   await _callKit.endCall(this.currentCallId);
  //   _currentCallId = null;
  // }
  //
  // Future<void> _didActivateAudioSession() async {
  //   // you might want to do following things when receiving this event:
  //   // - Start playing ringback if it is an outgoing call
  // }
  //
  // Future<void> _didDisplayIncomingCall(String error, String uuid, String handle,
  //     String localizedCallerName, bool fromPushKit) async {
  //   // You will get this event after RNCallKeep finishes showing incoming call UI
  //   // You can check if there was an error while displaying
  // }
  //
  // Future<void> _didPerformSetMutedCallAction(bool mute, String uuid) async {
  //   // Called when the system or user mutes a call
  // }
  //
  // Future<void> _didPerformDTMFAction(String digit, String uuid) async {
  //   // Called when the system or user performs a DTMF action
  // }
  //
  // Future<void> _didToggleHoldAction(bool hold, String uuid) async {
  //   // Called when the system or user holds a call
  // }
  //
  // String get currentCallId {
  //   if (_currentCallId == null) {
  //     final uuid = new Uuid();
  //     _currentCallId = uuid.v4();
  //   }
  //
  //   return _currentCallId;
  // }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    // logger.d(deviceData);

    // if (!mounted) return;
    //
    // setState(() {
    //   _deviceData = deviceData;
    // });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}


//
// Future<void> displayIncomingCall(String number) async {
//
//
//   final String callUUID = newUUID();
//   // setState(() {
//   //   calls[callUUID] = Call(number);
//   // });
//   print('Display incoming call now');
//   final bool hasPhoneAccount = await callKeepIn.hasPhoneAccount();
//   if (!hasPhoneAccount) {
//     await callKeepIn.hasDefaultPhoneAccount(mainScreePage, <String, dynamic>{
//       'alertTitle': 'Permissions required',
//       'alertDescription':
//       'This application needs to access your phone accounts',
//       'cancelButton': 'Cancel',
//       'okButton': 'ok',
//     });
//   }
//
//   print('[displayIncomingCall] $callUUID number: $number');
//   callKeepIn.displayIncomingCall(callUUID, number,
//       handleType: 'number', hasVideo: false);
// }
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
// Handle data message
    final dynamic data = message['data'];
    logger.d(data);
    displayIncomingCall('123456');
  }

  if (message.containsKey('notification')) {
// Handle notification message
    final dynamic notification = message['notification'];
    logger.d(notification);
  }

// Or do other work.
}

void removeCall(String callUUID) {
  // setState(() {
  //   calls.remove(callUUID);
  // });
  calls.remove(callUUID);
}

void setCallHeld(String callUUID, bool held) {
  calls[callUUID].held = held;
}

void setCallMuted(String callUUID, bool muted) {
  calls[callUUID].muted = muted;
}

Future<void> answerCall(CallKeepPerformAnswerCallAction event) async {
  final String callUUID = event.callUUID;
  final String number = calls[callUUID].number;
  print('[answerCall] $callUUID, number: $number');

  callKeepIn.startCall(event.callUUID, number, number);
  Timer(const Duration(seconds: 1), () {
    print('[setCurrentCallActive] $callUUID, number: $number');
    callKeepIn.setCurrentCallActive(callUUID);
  });
}

Future<void> endCall(CallKeepPerformEndCallAction event) async {
  print('endCall: ${event.callUUID}');
  removeCall(event.callUUID);
}

Future<void> didPerformDTMFAction(CallKeepDidPerformDTMFAction event) async {
  print('[didPerformDTMFAction] ${event.callUUID}, digits: ${event.digits}');
}

Future<void> didReceiveStartCallAction(
    CallKeepDidReceiveStartCallAction event) async {
  if (event.handle == null) {
    // @TODO: sometime we receive `didReceiveStartCallAction` with handle` undefined`
    return;
  }
  final String callUUID = event.callUUID ?? newUUID();

  calls[callUUID] = Call(event.handle);
  print('[didReceiveStartCallAction] $callUUID, number: ${event.handle}');

  callKeepIn.startCall(callUUID, event.handle, event.handle);

  Timer(const Duration(seconds: 1), () {
    print('[setCurrentCallActive] $callUUID, number: ${event.handle}');
    callKeepIn.setCurrentCallActive(callUUID);
  });
}

Future<void> didPerformSetMutedCallAction(
    CallKeepDidPerformSetMutedCallAction event) async {
  final String number = calls[event.callUUID].number;
  print(
      '[didPerformSetMutedCallAction] ${event.callUUID}, number: $number (${event.muted})');

  setCallMuted(event.callUUID, event.muted);
}

Future<void> didToggleHoldCallAction(CallKeepDidToggleHoldAction event) async {
  final String number = calls[event.callUUID].number;
  print(
      '[didToggleHoldCallAction] ${event.callUUID}, number: $number (${event.hold})');

  setCallHeld(event.callUUID, event.hold);
}

Future<void> hangup(String callUUID) async {
  callKeepIn.endCall(callUUID);
  removeCall(callUUID);
}

Future<void> setOnHold(String callUUID, bool held) async {
  callKeepIn.setOnHold(callUUID, held);
  final String handle = calls[callUUID].number;
  print('[setOnHold: $held] $callUUID, number: $handle');
  setCallHeld(callUUID, held);
}

Future<void> setMutedCall(String callUUID, bool muted) async {
  callKeepIn.setMutedCall(callUUID, muted);
  final String handle = calls[callUUID].number;
  print('[setMutedCall: $muted] $callUUID, number: $handle');
  setCallMuted(callUUID, muted);
}

Future<void> updateDisplay(String callUUID) async {
  final String number = calls[callUUID].number;
  // Workaround because Android doesn't display well displayName, se we have to switch ...
  if (isIOS) {
    callKeepIn.updateDisplay(callUUID, displayName: 'New Name', handle: number);
  } else {
    callKeepIn.updateDisplay(callUUID, displayName: number, handle: 'New Name');
  }

  print('[updateDisplay: $number] $callUUID');
}

Future<void> displayIncomingCallDelayed(String number) async {
  Timer(const Duration(seconds: 3), () {
    displayIncomingCall(number);
  });
}

Future<void> displayIncomingCall(String number) async {
  final String callUUID = newUUID();

  calls[callUUID] = Call(number);
  print('Display incoming call now');
  final bool hasPhoneAccount = await callKeepIn.hasPhoneAccount();
  if (!hasPhoneAccount) {
    await callKeepIn.hasDefaultPhoneAccount(appContext, <String, dynamic>{
      'alertTitle': 'Permissions required',
      'alertDescription':
          'This application needs to access your phone accounts',
      'cancelButton': 'Cancel',
      'okButton': 'ok',
    });
  }

  print('[displayIncomingCall] $callUUID number: $number');
  callKeepIn.displayIncomingCall(callUUID, number,
      handleType: 'number', hasVideo: false);
}

// @override
// void initState() {
//   super.initState();
//   callKeepIn.on(CallKeepPerformAnswerCallAction(), answerCall);
//   callKeepIn.on(CallKeepDidPerformDTMFAction(), didPerformDTMFAction);
//   callKeepIn.on(
//       CallKeepDidReceiveStartCallAction(), didReceiveStartCallAction);
//   callKeepIn.on(CallKeepDidToggleHoldAction(), didToggleHoldCallAction);
//   callKeepIn.on(
//       CallKeepDidPerformSetMutedCallAction(), didPerformSetMutedCallAction);
//   callKeepIn.on(CallKeepPerformEndCallAction(), endCall);
//
//   callKeepIn.setup(<String, dynamic>{
//     'ios': {
//       'appName': 'CallKeepDemo',
//     },
//     'android': {
//       'alertTitle': 'Permissions required',
//       'alertDescription':
//       'This application needs to access your phone accounts',
//       'cancelButton': 'Cancel',
//       'okButton': 'ok',
//     },
//   });
// }
