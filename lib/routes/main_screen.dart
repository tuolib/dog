import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../index.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';

BuildContext mainScreePage;
Timer timer;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 1;
  DateTime _lastPressedAt;

  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

//  头像本地地址
  bool fileExist = false;

  bool hasGetContact = false;

  @override
  void initState() {
    super.initState();
//    isSend = false; , keepPage: true, viewportFraction: 1
    _pageController = PageController(initialPage: 1, keepPage: true);
//    监听 手机打开，进入后台
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        lifecycleState = AppLifecycleState.inactive;
        // await NotificationHelper().cancelAllNotifications();
        // if (Platform.isAndroid) {
        //   if (Global.currentCallUuid != '') {
        //     logger
        //         .d('---------------currentCallUuid: ${Global.currentCallUuid}');
        //     logger.d(mainScreePage);
        //     logger.d('---------------hasCall: ${Global.hasCall}');
        //     logger.d('socketInit.connected: ${socketInit?.connected}');
        //     if (mainScreePage != null) {
        //       Timer.periodic(const Duration(seconds: 1), (timer) async {
        //         // var isAct = await callKeepIn.isCallActive(Global.currentCallUuid);
        //         if (Global.hasCall == '1' &&
        //             !callInfoSocket.callSuccess &&
        //             socketInit != null &&
        //             socketInit.connected) {
        //           timer.cancel();
        //           createOverlayView(mainScreePage, false);
        //         }
        //       });
        //     }
        //   }
        // }
      },
      // inactiveCallBack: () async {
      //   logger.d('active life');
      // },
    ));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // _pageController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    mainScreePage = context;
    // if (Platform.isAndroid) {
    //   if (Global.currentCallUuid != '') {
    //     logger.d('---------------currentCallUuid: ${Global.currentCallUuid}');
    //     logger.d(mainScreePage);
    //     if (mainScreePage != null) {
    //       Timer.periodic(const Duration(seconds: 1), (timer) async {
    //         // var isAct = await callKeepIn.isCallActive(Global.currentCallUuid);
    //         // logger.d(isAct);
    //         if (Global.hasCall == '1' &&
    //             socketInit != null &&
    //             socketInit.connected &&
    //             !callInfoSocket.callSuccess
    //         ) {
    //           timer.cancel();
    //           createOverlayView(mainScreePage, false);
    //         }
    //       });
    //     }
    //   }
    // }
    socketProviderChatListModel =
        Provider.of<ChatListModel>(context, listen: false);
    var info = Provider.of<ConversationListModel>(context, listen: false);
    socketProviderConversationListModel = info;
    var contactsProvider =
        Provider.of<ContactListModel>(context, listen: false);
    socketProviderContactListModel = contactsProvider;
    var groupMemberModelProvider =
        Provider.of<GroupMemberModel>(context, listen: false);
    socketGroupMemberModel = groupMemberModelProvider;
    var chatInfo = Provider.of<ChatInfoModel>(context, listen: false);
    chatInfoModelSocket = chatInfo;
//    socketProviderChatListModel.getChatList();
    var callInfo = Provider.of<CallInfoModel>(context, listen: false);
    callInfoSocket = callInfo;
    var deviceInfo = Provider.of<DeviceModel>(context, listen: false);
    deviceSocket = deviceInfo;

    socketTheme = Provider.of<ThemeModel>(context, listen: false);
    // if (!hasStartCall) {
    //   createOverlayView(mainScreePage, false);
    // }

//    var gAvatar;
//    User user = Global.profile.user;
//    print(user.avatarUrl);
//    if (user.avatarUrl == null ||
//        user.avatarUrl == '' ||
//        user.avatarUrlLocal == null) {
//      gAvatar = Container(
//        width: 25.0,
//        height: 25.0,
//        alignment: Alignment.center,
//        decoration: BoxDecoration(
//          shape: BoxShape.circle,
//          color: colors[rNum],
//        ),
//        child: Text(
//          user.username.substring(0, 1),
//          style: TextStyle(
//            fontWeight: FontWeight.bold,
//            fontSize: 16.0,
//            color: Colors.white,
//          ),
//          textAlign: TextAlign.center,
//        ),
//      );
//    } else {
//      gAvatar = Container(
//        width: 25.0,
//        height: 25.0,
//        decoration: new BoxDecoration(
//          shape: BoxShape.circle,
//          image: new DecorationImage(
//            colorFilter: new ColorFilter.mode(
//                Colors.black.withOpacity(1), BlendMode.dstATop),
//            image: FileImage(File("${user.avatarUrlLocal}")),
//            fit: BoxFit.cover,
////                      new AssetImage("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg")
////          FileImage(File("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg"))
//          ),
//        ),
//      );
//      gAvatar = CircleAvatar(
//        backgroundImage: NetworkImage(
//          "${user.avatarUrl}",
//        ),
////        backgroundImage: AssetImage(
////          "imgs/app_logo5.png",
////        ),
//        radius: 16,
//      );
//    }
    return WillPopScope(
      // onWillPop: AndroidBackTop.BackDeskTop,
      onWillPop: () async {
//        BackDesktop.backDesktop(); //设置为返回不退出app
//        return false;
//        MoveToBackground.moveTaskToBack();
//        return false;
//        SystemNavigator.pop();
//        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
//        return false;
//        return true;

//        if (_lastPressedAt == null ||
//            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
//          //两次点击间隔超过1秒则重新计时
//          _lastPressedAt = DateTime.now();
//          if (Platform.isAndroid) {
//            showToast('Click twice to exit');
//          }
//          return false;
//        }

        return true;

////          Navigator.of(context).pushReplacementNamed("main");
//        socketProviderConversationListModelGroupId = null;
//        Navigator.of(context).popUntil((route) => route.isFirst);
//        return false;
      },
      child: Localizations(
        locale: Locale('en', 'US'),
        delegates: <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GmLocalizationsDelegate()
        ],
        child: Scaffold(
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: <Widget>[
//          ChangeNotifierProvider.value(
//            value: ChatListModel(),
//            child: HomeRoute(),
//          ),
              ContactsPage(),
              HomeRoute(),
//          DiscoveryPage(),
//            TestSqlRoute(),
//            CustomScrollViewTestRoute(),
              SettingsPage(),
              DbPage(),
            ],
          ),
          bottomNavigationBar: Container(
            child: CupertinoTabBar(
              onTap: navigationTapped,
              currentIndex: _page,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(DefineIcons.personCircleFill),
//              title: Container(height: 0.0),
                  title: Text(GmLocalizations.of(context).contacts),
                ),
                BottomNavigationBarItem(
                  icon: IconBadge(
                    // icon: Icons.message,
                    icon: DefineIcons.chats,
                  ),
//              title: Container(height: 0.0),
                  title: Text('Chats'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    // Icons.settings,
                    // CupertinoIcons.settings_solid,
                    DefineIcons.settingFill,
                  ),
                  title: Text('Settings'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.book_solid,
                  ),
//              title: Container(height: 0.0),
                  title: Text(GmLocalizations.of(context).discovery),
                ),
              ],
            ),
            // constraints: BoxConstraints(
            //   maxHeight: 49.0,
            // ),
            // decoration: BoxDecoration(
            //   border: Border(
            //     top: BorderSide( //                    <--- top side
            //       color: DataUtil.iosBorderGreyShallow(),
            //       width: 1.0,
            //     ),
            //   ),
            // ),
          ),
        ),
      ),

    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
//    logger.d(hasGetContact);
//    if (!hasGetContact) {
//      hasGetContact = true;
//      socketProviderContactListModel.getContactList();
//    }
//    isSend = false;
    setState(() {
      this._page = page;
    });
  }
}
