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

  // await CallKeep.setup();

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
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.fileUpdateLocalUrl();
  await Global.init().then((e) => runApp(MyApp()));
  if (Global.profile.token != null) {
    socketIoItem.initCommunication();
  }

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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
//        ChangeNotifierProvider.value(value: ThemeModel()),
//        ChangeNotifierProvider.value(value: UserModel()),
//        ChangeNotifierProvider.value(value: LocaleModel()),
//        ChangeNotifierProvider.value(value: ChatListModel()),
        ChangeNotifierProvider(
          create: (_) => ThemeModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatListModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConversationListModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatInfoModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectSocketModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactListModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddPeopleModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => GroupMemberModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FloatButtonModel(),
        ),

      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
//          return BackGestureWidthTheme(
////            backGestureWidth: BackGestureWidth.fraction(1 / 2),
//            backGestureWidth: BackGestureWidth.fixed(200),
//            child: ,
//          );
          return MaterialApp(
            theme: ThemeData(
//              pageTransitionsTheme: PageTransitionsTheme(
//                  builders: {
//                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//                    // for Android - default page transition
////                      TargetPlatform.android: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
////                      // for iOS - one which considers ancestor BackGestureWidthTheme
////                      TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
//                  }
//              ),
              primarySwatch: themeModel.theme,
//              accentColor: Colors.pink,
            ),
            onGenerateTitle: (context) {
              return GmLocalizations.of(context).title;
            },
            navigatorObservers: [GetNavigationObserver()],
//            home: HomeRoute(),
            //应用主页
            locale: localeModel.getLocale(),
            //我们只支持美国英语和中文简体
            supportedLocales: [
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
              //其它Locales
            ],
            localizationsDelegates: [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate()
            ],
            localeResolutionCallback:
                (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {
                Locale locale;
                //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                //则默认使用美国英语
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  locale = Locale('en', 'US');
                }
                return locale;
              }
            },
            // 注册命名路由表
//            routes: <String, WidgetBuilder>{
//              "login": (context) => LoginRoute(),
//              "themes": (context) => ThemeChangeRoute(),
//              "language": (context) => LanguageRoute(),
//            },
//            判断是否登录
            initialRoute: "main",
            navigatorKey: navigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    String routeName = settings.name;
                    // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
                    // 引导用户登录；其它情况则正常打开路由。

                    UserModel userModel = Provider.of<UserModel>(context);
                    currentPage = routeName;
                    var goPage;
                    if (!userModel.isLogin) {
                      if (routeName == 'register') {
                        return RegisterRoute();
                      }
                      return LoginRoute();
//                      return LoginRoute();
                    } else {
                      if (routeName == 'themes') {
                        return ThemeChangeRoute();
//                        return ThemeChangeRoute();
                      } else if (routeName == 'language') {
                        return LanguageRoute();
//                        return LanguageRoute();
                      } else if (routeName == 'conversation') {
//                        不能这样做:
//                        return ChangeNotifierProvider(
//                          create: (_) => ConversationListModel(),
//                          child: Conversation(),
//                        );

//                      这样: 问题见 https://github.com/rrousselGit/provider/issues/168
//                        return ChangeNotifierProvider.value(
//                          value: ConversationListModel(),
//                          child: Conversation(),
//                        );
//                        return ChangeNotifierProvider.value(
//                          value: ConversationListModel(),
//                          child: Conversation(),
//                        );
                        Map<String, dynamic> arg = settings.arguments;
                        return Conversation(
//                          groupId: arg['groupId'],
//                          groupType: arg['groupType'],
//                          groupName: arg['groupName'],
//                          groupAvatar: arg['groupAvatar'],
//                          isOnline: arg['isOnline'],
//                          newChatNumber: arg['newChatNumber'],
//                          content: arg['content'],
//                          createdDate: arg['createdDate'],
//                          groupMembers: arg['groupMembers'],
                        );
                      } else if (routeName == 'photoView') {
                        Map<String, dynamic> arg =
                        json.decode(settings.arguments);
                        if (arg['type'] == 'local') {
                          return PhotoViewSimpleScreen(
                            imageProvider:
                            FileImage(File("${arg['imageProvider']}")),
                            heroTag: 'PhotoView',
                            fileId: arg['fileId'],
                          );
                        } else {
                          return PhotoViewSimpleScreen(
                            imageProvider: NetworkImage(arg['imageProvider']),
                            heroTag: 'PhotoView',
                            fileId: arg['fileId'],
                          );
                        }
//                        return PhotoViewSimpleScreen(
//                          imageProvider:NetworkImage(arg['imageProvider']),
//                          heroTag: arg['heroTag'],
//                        );
                      } else if (routeName == 'videoPlay') {
                        Map<String, dynamic> arg =
                        json.decode(settings.arguments);
                        var videoUrl = arg['videoUrl'];
                        return VideoPlayRoute(videoUrl);
//                        return PhotoViewSimpleScreen(
//                          imageProvider:NetworkImage(arg['imageProvider']),
//                          heroTag: arg['heroTag'],
//                        );
                      } else if (routeName == 'testSql') {
                        return TestSqlRoute();
                      } else if (routeName == 'editProfile') {
                        return EditProfileRoute();
                      } else if (routeName == 'editUsername') {
                        return EditUsernameRoute();
                      } else if (routeName == 'addContact') {
                        return AddContactRoute();
                      } else if (routeName == 'newMessage') {
                        return NewMessagePage();
                      } else if (routeName == 'newGroup') {
                        return NewGroupPage();
                      } else if (routeName == 'newGroupInfo') {
                        return NewGroupInfoPage();
                      } else if (routeName == 'editGroupInfo') {
                        Map<String, dynamic> arg = settings.arguments;
                        return EditGroupInfoRoute(
                          groupId: arg['groupId'],
                          firstName: arg['firstName'],
                          lastName: arg['lastName'],
                          colorId: arg['colorId'],
                          avatarUrl: arg['avatarUrl'],
                          avatarLocal: arg['avatarLocal'],
                          avatar: arg['avatar'],
                          description: arg['description'],
                        );
                      } else if (routeName == 'showGroupInfo') {
                        Map<String, dynamic> arg = settings.arguments;
                        var personFromGroup = false;
                        if (arg['personFromGroup'] == true) {
                          personFromGroup = true;
                        }
                        return ShowGroupInfoRoute(
                          showBigImage: arg['showBigImage'],
                          personFromGroup: personFromGroup,
                        );
                      } else if (routeName == 'addMember') {
                        return AddMemberRoute();
                      } else if (routeName == 'editContact') {
                        Map<String, dynamic> arg = settings.arguments;
                        return EditContactRoute(
                            firstName: arg['firstName'],
                            lastName: arg['lastName'],
                            colorId: arg['colorId'],
                            avatarUrl: arg['avatarUrl'],
                            avatarLocal: arg['avatarLocal'],
                            userId: arg['userId'],
                            contactSqlId: arg['contactSqlId'],
                            isAdd: arg['isAdd'],
                            username: arg['username']);
                      } else if (routeName == 'callVideo') {
                        Map<String, dynamic> arg = settings.arguments;
                        return CallVideoTest(
                          invite: arg['invite'] == null ? false : true,
                        );
                      } else {
                        return MainScreen();

//                        return ChangeNotifierProvider.value(
//                          value: ChatListModel(),
//                          child: HomeRoute(),
//                        );
                      }
//                      return HomeRoute();
                    }
//                    return goPage;
                  });
            },
          );
        },
      ),
    );
  }
}
class GetNavigationObserver extends NavigatorObserver {
  @override
  void didStartUserGesture(Route route, Route previousRoute) {
//    logger.d('back page');
    backingRoute = true;
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
//    logger.d('back page end');
    backingRoute = false;
  }

}