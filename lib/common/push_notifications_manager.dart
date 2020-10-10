import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_voip_push_notification/flutter_voip_push_notification.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_call_kit/flutter_call_kit.dart';
import 'package:callkeep/callkeep.dart';
import 'package:flutter_apns/apns.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_callkeep/flutter_callkeep.dart' as flutterCallKeep;
import 'package:is_lock_screen/is_lock_screen.dart';

import '../index.dart';

class Call {
  Call(this.number);

  String number;
  bool held = false;
  bool muted = false;
}

// int callFriendId;
// int callGroupId;
// 是否正有拨打过来的通话，但是还未接
// bool hasCall;
// bool _configured;
// String callerName;
// String currentCallUuid;

// List callArr = [];
String newUUID() => Uuid().v4();
FlutterCallkeep callKeepIn = FlutterCallkeep();
Map<String, Call> calls = {};

FlutterCallKit callKitIn = FlutterCallKit();

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  FlutterVoipPushNotification _voipPush = FlutterVoipPushNotification();

  Future<void> init() async {
    if (Platform.isIOS) {
      configureVoip();
      configureCallKit();
    } else {
      configureCallKeep();
    }
    // android ios 通用
    configureApns();
  }

  Future<void> configureFirebase() async {
    // _firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //       sound: true, badge: true, alert: true, provisional: false),
    // );
    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: onLaunch,
      onResume: onResume,
    );

    // For testing purposes print the Firebase Messaging token
    String token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");
    if (Global.firebaseToken != token) {
      logger.d('Global.firebaseToken: ${Global.firebaseToken}');
      logger.d('firebase is change');
      Global.firebaseToken = token;
      Global.saveFirebaseToken(token);
    }

    // _initialized = true;
  }
  Future<void> configureApns() async {
    final connector = createPushConnector();
    connector.configure(
      onLaunch: onLaunch,
      onResume: onResume,
      onMessage: onMessage,
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
    connector.requestNotificationPermissions();
    connector.token.addListener(() {
      var tokenNew = connector.token.value;
      if (Platform.isIOS) {
        logger.d('old apns Token ${Global.apnsToken}');
        if (tokenNew != Global.apnsToken) {
          logger.d('new apns Token $tokenNew');
          Global.apnsToken = tokenNew;
          Global.saveApnsToken(tokenNew);
        }
      } else {
        logger.d('old firebase Token ${Global.firebaseToken}');
        if (tokenNew != Global.firebaseToken) {
          logger.d('new firebase Token $tokenNew');
          Global.firebaseToken = tokenNew;
          Global.saveFirebaseToken(tokenNew);
        }
      }
    });
  }
  // Configures a voip push notification
  Future<void> configureVoip() async {
    // request permission (required)
    await _voipPush.requestNotificationPermissions();

    logger.d('old voipToken: ${Global.voipToken}');
    // listen to voip device token changes
    _voipPush.onTokenRefresh.listen(onTokenVoip);

    // do configure voip push
    _voipPush.configure(onMessage: onMessageVoip, onResume: onResumeVoip);

  }
  Future<void> configureCallKeep() async {

    callKeepIn.on(CallKeepPerformAnswerCallAction(), answerCall);
    callKeepIn.on(CallKeepDidPerformDTMFAction(), didPerformDTMFAction);
    callKeepIn.on(
        CallKeepDidReceiveStartCallAction(), didReceiveStartCallAction);
    callKeepIn.on(CallKeepDidToggleHoldAction(), didToggleHoldCallAction);
    callKeepIn.on(
        CallKeepDidPerformSetMutedCallAction(), didPerformSetMutedCallAction);
    callKeepIn.on(CallKeepPerformEndCallAction(), endCall);

    callKeepIn.setup(<String, dynamic>{
      'ios': {
        'appName': 'Dog',
      },
      'android': {
        'alertTitle': 'Permissions required',
        'alertDescription':
        'This application needs to access your phone accounts',
        'cancelButton': 'Cancel',
        'okButton': 'ok',
      },
    });
  }
  Future<void> configureCallKit() async {
    callKitIn.configure(
      IOSOptions("Dog",
          imageName: 'voip_icon',
          supportsVideo: true,
          maximumCallGroups: 1,
          maximumCallsPerCallGroup: 1),
      didReceiveStartCallAction: _didReceiveStartCallAction,
      performAnswerCallAction: _performAnswerCallAction,
      performEndCallAction: _performEndCallAction,
      didActivateAudioSession: _didActivateAudioSession,
      didDisplayIncomingCall: _didDisplayIncomingCall,
      didPerformSetMutedCallAction: _didPerformSetMutedCallAction,
      didPerformDTMFAction: _didPerformDTMFAction,
      didToggleHoldAction: _didToggleHoldAction,
    );
  }

  // showLocalNotification(Map<String, dynamic> notification) {
  //   String alert = notification["aps"]["alert"];
  //   _voipPush.presentLocalNotification(LocalNotification(
  //     alertBody: "Hello $alert",
  //   ));
  // }
}

/// Called when the device token changes
void onTokenVoip(String token) {
  // send token to your apn provider server
  // _pushToken = token;
  if (Global.voipToken != token) {
    logger.d('voipToken is change: $token');
    Global.voipToken = token;
    Global.saveVoipToken(token);
  }
  // print(token);
}

//
// /// Called to receive notification when app is in foreground
// ///
// /// [isLocal] is true if its a local notification or false otherwise (remote notification)
// /// [payload] the notification payload to be processed. use this to present a local notification
Future<dynamic> onMessageVoip(bool isLocal, Map<String, dynamic> payload) {
  // handle foreground notification
  logger.d("received on foreground payload: $payload, isLocal=$isLocal");
  logger.d("hasCall: ${Global.hasCall}");
  logger.d("callGroupId: ${Global.callGroupId}");
  var data = payload['data'];
  if (data['type'] == 'callInvite') {
    // 如果正在通话中，则不显示新通知
    if (Global.hasCall == '0') {
      // currentCallUuid = data['uuid'];
      Global.saveUuid(data['uuid']);
      // callGroupId = int.parse(data['groupId']);
      Global.saveCallGroupId(data['groupId']);
      displayIncomingCall(data['callerName'], uuid: data['uuid']);
    }
  }
  if (data['type'] == "cancelInvite") {
    if (Global.hasCall == '1' && Global.callGroupId == data['groupId']) {
      logger.d('cancel call: ${Global.currentCallUuid}');
      if (Platform.isIOS) {
        // callKitIn.endCall(currentCallUuid);
        // reportEndCallWithUUID(currentCallUuid, EndReason.remoteEnded);
        callKitIn.endCall(data['uuid']);
        reportEndCallWithUUID(data['uuid'], EndReason.remoteEnded);
      } else {
        callKeepIn.endCall(data['uuid']);
      }
    }
  }
  return null;
}

/// Called to receive notification when app is resuming from background
///
/// [isLocal] is true if its a local notification or false otherwise (remote notification)
/// [payload] the notification payload to be processed. use this to present a local notification
Future<dynamic> onResumeVoip(bool isLocal, Map<String, dynamic> payload) {

  lifecycleState = AppLifecycleState.detached;
  // handle background notification
  logger.d("received on background payload: $payload, isLocal=$isLocal");
  logger.d("hasCall: ${Global.hasCall}");
  logger.d("callGroupId: ${Global.callGroupId}");
  var data = payload['data'];
  if (data['type'] == 'callInvite') {
    // 如果已经有通话中，则不显示新通知
    if (Global.hasCall == '1') {
      // currentCallUuid = data['uuid'];
      Global.saveUuid(data['uuid']);
      // callGroupId = int.parse(data['groupId']);
      Global.saveCallGroupId(data['groupId']);
      displayIncomingCall(data['callerName'], uuid: data['uuid']);
    }
  }
  if (data['type'] == "cancelInvite") {
    if (Global.hasCall == '1' && Global.callGroupId == data['groupId']) {
      logger.d('cancel call: ${Global.currentCallUuid}');
      if (Platform.isIOS) {
        // callKitIn.endCall(currentCallUuid);
        // reportEndCallWithUUID(currentCallUuid, EndReason.remoteEnded);
        callKitIn.endCall(data['uuid']);
        reportEndCallWithUUID(data['uuid'], EndReason.remoteEnded);
      } else {
        callKeepIn.endCall(data['uuid']);
      }
    }
  }
  // showLocalNotification(payload);
  return null;
}

Future<dynamic> onResume(Map<String, dynamic> payload) {
  // handle background notification
  logger.d("onResume payload: $payload");
  var data = payload['data'];
  if (data['type'] == "cancelInvite") {
    if (Global.hasCall == '1' && Global.callGroupId == data['groupId']) {
      logger.d('cancel call: ${Global.currentCallUuid}');
      if (Platform.isIOS) {
        callKitIn.endCall(data['uuid']);
        reportEndCallWithUUID(data['uuid'], EndReason.remoteEnded);
      } else {
        callKeepIn.endCall(data['uuid']);
      }
    }
  }

  // print("onResume: $payload");
//          var payload = ;
//          var decodeSucceeded = false;
  var channelInfo = payload['data'];
  if (channelInfo == null) return null;
//          try {
////          var x = json.decode(payload) as Map<String, dynamic>;
//            channelInfo = json.decode(payload) as Map<String, dynamic>;
//            decodeSucceeded = true;
//          } on FormatException catch (e) {
//            print('The provided string is not valid JSON');
//          }
//          if (decodeSucceeded == false) return;
//   print('groupId: ${channelInfo['groupId']}');
  if (channelInfo['groupId'] != null) {
    // navigatorKey.currentState.pushNamed('conversation', arguments: {
    //   'groupId': channelInfo['groupId'],
    //   'groupType': channelInfo['groupType'],
    //   'groupName': channelInfo['groupName'],
    //   'groupAvatar': channelInfo['groupAvatar'],
    //   'isOnline': false,
    //   'content': channelInfo['content'],
    //   'createdDate': channelInfo['createdDate'],
    //   'groupMembers': 1,
    // });
  }
  return null;
}

Future<dynamic> onMessage(Map<String, dynamic> payload) {
  // handle background notification
  logger.d("onMessage payload: $payload");
  var data = payload['data'];
  // logger.d('${data['type'] == "callInvite"}');
  // logger.d('${data['groupId']}');
  if (Platform.isAndroid) {
    if (data['type'] == "callInvite") {
      logger.d('Global.hasCall: ${Global.hasCall}');
      if (Global.hasCall == '0') {
        // callGroupId = int.parse(data['groupId']);
        Global.saveCallGroupId(data['groupId']);
        logger.d(Global.callGroupId);
        // callerName = 'Dog call[${data['callerName']}]';
        Global.saveCallerName('Dog call (${data['callerName']})');
        // currentCallUuid = data['uuid'];
        Global.saveUuid(data['uuid']);
        displayIncomingCall(Global.callerName, uuid: data['uuid']);
      }
    }
  }
  if (data['type'] == "cancelInvite") {

    if (Global.hasCall == '1' && Global.callGroupId == data['groupId']) {
      logger.d('cancel call: ${Global.currentCallUuid}');
      if (Platform.isIOS) {
        callKitIn.endCall(data['uuid']);
        reportEndCallWithUUID(data['uuid'], EndReason.remoteEnded);
      } else {
        callKeepIn.endCall(data['uuid']);
      }
    }
  }
  return null;
}

Future<dynamic> onLaunch(Map<String, dynamic> payload) {
  // handle background notification
  logger.d("onLaunch payload: $payload");
  return null;
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  lifecycleState = AppLifecycleState.detached;
  final dynamic data = message['data'];
  logger.d(data);
  logger.d(' hasCall: ${Global.hasCall}');
  logger.d(' callGroupId: ${Global.callGroupId}');
  logger.d('cancel call: ${Global.currentCallUuid}');
  if (data['type'] == "cancelInvite") {
    await callKeepIn.endCall(data['uuid']);
    // if (Global.hasCall == '1' && Global.callGroupId == data['groupId']) {
    //   logger.d('cancel call: ${Global.currentCallUuid}');
    //   await callKeepIn.endCall(data['uuid']);
    // }
  } else {
    if (Global.hasCall == '0') {
      // callGroupId = int.parse(data['groupId']);
      Global.saveCallGroupId(data['groupId']);
      logger.d(Global.callGroupId);
      // callerName = data['callerName'];
      Global.saveCallerName('Dog call (${data['callerName']})');
      // callerName = 'Dog call[${data['callerName']}]';
      // currentCallUuid = data['uuid'];
      Global.saveUuid(data['uuid']);
      displayIncomingCall(Global.callerName, uuid: data['uuid']);
    }
  }
  // if (message.containsKey('data')) {
// Handle data message

  // }

//   if (message.containsKey('notification')) {
// // Handle notification message
//     final dynamic notification = message['notification'];
//     logger.d(notification);
//   }
}


void removeCall(String callUUID) {
  // setState(() {
  //   calls.remove(callUUID);
  // });
  calls.remove(callUUID);
}

void setCallHeld(String callUUID, bool held) {
  // setState(() {
  //   calls[callUUID].held = held;
  // });
  calls[callUUID].held = held;
}

void setCallMuted(String callUUID, bool muted) {
  // setState(() {
  //   calls[callUUID].muted = muted;
  // });
  calls[callUUID].muted = muted;
}

Future<void> answerCall(CallKeepPerformAnswerCallAction event) async {
  final String callUUID = event.callUUID;
  // final String number = callerName;
  logger.d('[answerCall] $callUUID, callerName: ${Global.callerName}');
  // currentCallUuid = callUUID;
  Global.saveUuid(callUUID);
  // callKeepIn.startCall(event.callUUID, 'generic', Global.callerName);
  Timer(const Duration(seconds: 1), () {
    // logger.d('[setCurrentCallActive] $callUUID, number: $number');
    callKeepIn.setCurrentCallActive(callUUID);
  });

  // navigatorKey.currentState.pushNamed('callVideo', arguments: {
  //   "invite": false,
  // });
  logger.d('---------------hasCall: ${Global.hasCall}');
  // logger.d('socketInit.connected: ${socketInit?.connected}');
  bool result = await isLockScreen();
  if (!result) {
    callKeepIn.backToForeground();
  }

  // createOverlayView(mainScreePage, false);
}
Future<void> endCall(CallKeepPerformEndCallAction event) async {
  logger.d('endCall: ${event.callUUID}');
  removeCall(event.callUUID);
  // currentCallUuid = null;
  overCallAll(system: false);
  // hasCall = false;
  // callKeepIn.endCall(event.callUUID);
  // currentCallUuid = null;
  // if (hasStartCall) {
  //   hangUpCall();
  // }
  //
  // if (!callInfoSocket.callSuccess) {
  //   // sendCallBye = true;
  //   SocketIoEmit.callBye(
  //     groupId: callGroupId,
  //   );
  // }
}

Future<void> didPerformDTMFAction(CallKeepDidPerformDTMFAction event) async {
  logger.d('[didPerformDTMFAction] ${event.callUUID}, digits: ${event.digits}');
}

Future<void> didReceiveStartCallAction(
    CallKeepDidReceiveStartCallAction event) async {
  if (event.handle == null) {
    // @TODO: sometime we receive `didReceiveStartCallAction` with handle` undefined`
    return;
  }
  final String callUUID = event.callUUID ?? newUUID();
  calls[callUUID] = Call(event.handle);
  // setState(() {
  //   calls[callUUID] = Call(event.handle);
  // });
  logger.d('[didReceiveStartCallAction] $callUUID, number: ${event.handle}');

  callKeepIn.startCall(callUUID, event.handle, event.handle);

  Timer(const Duration(seconds: 1), () {
    logger.d('[setCurrentCallActive] $callUUID, number: ${event.handle}');
    callKeepIn.setCurrentCallActive(callUUID);
  });
}

Future<void> didPerformSetMutedCallAction(
    CallKeepDidPerformSetMutedCallAction event) async {
  final String number = calls[event.callUUID].number;
  logger.d(
      '[didPerformSetMutedCallAction] ${event.callUUID}, number: $number (${event.muted})');

  setCallMuted(event.callUUID, event.muted);
  muteMic(event.muted);
}

Future<void> didToggleHoldCallAction(
    CallKeepDidToggleHoldAction event) async {
  final String number = calls[event.callUUID].number;
  logger.d(
      '[didToggleHoldCallAction] ${event.callUUID}, number: $number (${event.hold})');

  setCallHeld(event.callUUID, event.hold);
}

//
// Future<void> hangup(String callUUID) async {
//   callKeepIn.endCall(callUUID);
//   removeCall(callUUID);
// }

Future<void> setOnHold(String callUUID, bool held) async {
  callKeepIn.setOnHold(callUUID, held);
  final String handle = calls[callUUID].number;
  logger.d('[setOnHold: $held] $callUUID, number: $handle');
  setCallHeld(callUUID, held);
}

Future<void> setMutedCall(String callUUID, bool muted) async {
  callKeepIn.setMutedCall(callUUID, muted);
  final String handle = calls[callUUID].number;
  logger.d('[setMutedCall: $muted] $callUUID, number: $handle');
  setCallMuted(callUUID, muted);
}

Future<void> updateDisplay(String callUUID) async {
  final String number = calls[callUUID].number;
  // Workaround because Android doesn't display well displayName, se we have to switch ...
  if (isIOS) {
    callKeepIn.updateDisplay(callUUID,
        displayName: 'New Name', handle: number);
  } else {
    callKeepIn.updateDisplay(callUUID,
        displayName: number, handle: 'New Name');
  }

  logger.d('[updateDisplay: $number] $callUUID');
}

Future<void> displayIncomingCall(String callerName, {String uuid}) async {
  // hasCall = true;
  Global.saveHasCall('1');
  logger.d('hasCall: ${Global.hasCall}');
  if (Platform.isIOS) {
    // currentCallUuid = newUUID();
    logger.d('Global.currentCallUuid: ${Global.currentCallUuid}');
    logger.d('uuid: $uuid');
    // startCall("generic", callerName, uuid: uuid);
    callKitIn.displayIncomingCall(uuid, "generic", callerName);
  } else {
    // final String callUUID = newUUID();
    // setState(() {
    //   calls[callUUID] = Call(number);
    // });
    // currentCallUuid = callUUID;
    calls[Global.currentCallUuid] = Call(callerName);
    bool hasPhoneAccount = await callKeepIn.hasPhoneAccount();
    if (!hasPhoneAccount) {
      await callKeepIn.hasDefaultPhoneAccount(mainScreePage, <String, dynamic>{
        'alertTitle': 'Permissions required',
        'alertDescription':
        'This application needs to access your phone accounts',
        'cancelButton': 'Cancel',
        'okButton': 'ok',
      });
    }
    // logger.d('hasPhoneAccount: $hasPhoneAccount');

    logger.d('[displayIncomingCall] ${Global.currentCallUuid} callerName: $callerName');
    await callKeepIn.displayIncomingCall(Global.currentCallUuid, callerName,
        handleType: 'generic', hasVideo: true);
  }
  // logger.d('Call socketInit.connected: ${socketInit?.connected}');
  // displayConnectedCall(callerName, uuid: uuid);
  // if (socketInit != null) {
  //   // logger.d('has connect socket');
  //   displayConnectedCall(number);
  //   // navigatorKey.currentState.pushNamed('callVideo');
  // } else {
  //   // logger.d('not connect socket');
  //   // await Global.init();
  //
  //   await Global.init().then((e) => runApp(MyApp()));
  //   socketIoItem.initCommunication();
  //   socketInit.on('connect', (_) async {
  //     if (hasCall) {
  //       displayConnectedCall(number);
  //       // navigatorKey.currentState.pushNamed('callVideo', arguments: {
  //       //   "invite": false,
  //       // });
  //       // Navigator.push(thisContext, MaterialPageRoute(builder: (context) {
  //       //   return NewPage(
  //       //       title: "New Page"
  //       //   );
  //       // }));
  //     }
  //   });
  // }
  // return;


}


/// Use startCall to ask the system to start a call - Initiate an outgoing call from this point
Future<void> startCall(String handle, String localizedCallerName, {String uuid}) async {
  /// Your normal start call action
  // var startUuid = uuid;
  // startUuid = Global.currentCallUuid;
  await callKitIn.startCall(uuid, handle, localizedCallerName);
  logger.d('startCall');
}

Future<void> reportEndCallWithUUID(String uuid, EndReason reason) async {
  await callKitIn.reportEndCallWithUUID(uuid, reason);
  logger.d('reportEndCallWithUUID');
}

/// Event Listener Callbacks

Future<void> _didReceiveStartCallAction(String uuid, String handle) async {
  // Get this event after the system decides you can start a call
  // You can now start a call from within your app
  logger.d('_didReceiveStartCallAction');
}

Future<void> _performAnswerCallAction(String uuid) async {
  // Called when the user answers an incoming call
  logger.d('_performAnswerCallAction');
  createOverlayView(mainScreePage, false);
}
// iOS 点击 关闭
Future<void> _performEndCallAction(String uuid) async {
  // await callKitIn.endCall(uuid);
  // currentCallUuid = null;
  // Global.saveUuid('');
  logger.d('_performEndCallAction');
  overCallAll(system: false);
}

Future<void> _didActivateAudioSession() async {
  // you might want to do following things when receiving this event:
  // - Start playing ringback if it is an outgoing call
  logger.d('_didActivateAudioSession');
}

Future<void> _didDisplayIncomingCall(String error, String uuid, String handle,
    String localizedCallerName, bool fromPushKit) async {
  // You will get this event after RNCallKeep finishes showing incoming call UI
  // You can check if there was an error while displaying
  logger.d('_didDisplayIncomingCall');
}

Future<void> _didPerformSetMutedCallAction(bool mute, String uuid) async {
  // Called when the system or user mutes a call
  logger.d('_didPerformSetMutedCallAction');
  logger.d(mute);
  muteMic(mute);
}

Future<void> _didPerformDTMFAction(String digit, String uuid) async {
  // Called when the system or user performs a DTMF action
  logger.d('_didPerformDTMFAction');
}

Future<void> _didToggleHoldAction(bool hold, String uuid) async {
  // Called when the system or user holds a call
  logger.d('_didToggleHoldAction');
  createOverlayView(mainScreePage, false);
}

// String get currentCallId {
//   if (currentCallUuid == null) {
//     final uuid = new Uuid();
//     currentCallUuid = uuid.v4();
//   }
//
//   return currentCallUuid;
// }
//
// enum HandleType {
//   generic,
//   number,
//   email,
// }