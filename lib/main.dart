import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';

// import 'package:flutter_callkeep/flutter_callkeep.dart';
// import 'package:callkeep/callkeep.dart';


import 'index.dart';

void main() async {

  // Sets up timezone and culture information
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await CallKeep.setup();
  // }

//  var newHash;
//  var pathDir = await Git().getSaveDirectory();
//  var newHashPath = pathDir.path;
//
//  var n1 = newHashPath.split('/');
//  for(var i = 0; i < n1.length; i++) {
//    if (n1[i] == 'Application') {
//      newHash = n1[i + 1];
//      break;
//    }
//  }
  await Global.init().then((e) => runApp(MyApp()));
  socketIoItem.initCommunication();

//  if (didReceiveLocalNotificationSubject != null) {
//    didReceiveLocalNotificationSubject.close();
//  }
//  if (selectNotificationSubject != null) {
//    selectNotificationSubject.close();
//  }
//
//  notificationAppLaunchDetails =
//      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

 var initializationSettingsAndroid = AndroidInitializationSettings('app_logo');
 // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
 // of the `IOSFlutterLocalNotificationsPlugin` class
 var initializationSettingsIOS = IOSInitializationSettings(
     requestAlertPermission: false,
     requestBadgePermission: false,
     requestSoundPermission: false,
     onDidReceiveLocalNotification:
         (int id, String title, String body, String payload) async {
       didReceiveLocalNotificationSubject.add(ReceivedNotification(
           id: id, title: title, body: body, payload: payload));
     });
 var initializationSettings = InitializationSettings(
     initializationSettingsAndroid, initializationSettingsIOS);
 await flutterLocalNotificationsPlugin.initialize(initializationSettings,
     onSelectNotification: (String payload) async {
   if (payload != null) {
     debugPrint('notification payload: ' + payload);
   }
   selectNotificationSubject.add(payload);
 });
 NotificationHelper().requestIOSPermissions();
 NotificationHelper().configureSelectNotificationSubject();

  await TimeMachine.initialize({
    'rootBundle': rootBundle,
  });
  // logger.d('Hello, ${DateTimeZone.local} from the Dart Time Machine!\n');
//1598000220688
  var t = DateTime.fromMillisecondsSinceEpoch(1598001088836, isUtc: true);
  // logger.d('$t');
//  DateTime.now().toUtc().toIso8601String()

//  var tzdb = await DateTimeZoneProviders.tzdb;
//  var paris = await tzdb["Europe/Paris"];
//
//  var now = Instant.now();
//
//  logger.d('Basic');
//  logger.d('UTC Time: $now');
//  logger.d('Local Time: ${now.inLocalZone()}');
//  logger.d('Paris Time: ${now.inZone(paris)}\n');
//
//  logger.d('Formatted');
//  logger.d('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm')}');
//  logger.d('Local Time: ${now.inLocalZone().toString('dddd yyyy-MM-dd HH:mm')}\n');
//
//  var french = await Cultures.getCulture('fr-FR');
//  logger.d('Formatted and French ($french)');
//  logger.d('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm', french)}');
//  logger.d('Local Time: ${now.inLocalZone().toString('dddd yyyy-MM-dd HH:mm', french)}\n');
//
//  logger.d('Parse French Formatted ZonedDateTime');
//
//  // without the 'z' parsing will be forced to interpret the timezone as UTC
//  var localText = now
//      .inLocalZone()
//      .toString('dddd yyyy-MM-dd HH:mm z', french);
//
//  var localClone = ZonedDateTimePattern
//      .createWithCulture('dddd yyyy-MM-dd HH:mm z', french)
//      .parse(localText);
//
//  logger.d(localClone.value);
//  LifecycleEventHandler()

 // if(Platform.isAndroid) {
 //   PushNotificationsManager().init();
 // }
  PushNotificationsManager().init();


}
