import 'dart:io';
import 'dart:math';

import '../index.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';

BuildContext mainScreePage;
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;
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
    _pageController = PageController(initialPage: 0, keepPage: true);
//    监听 手机打开，进入后台
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      lifecycleState = AppLifecycleState.inactive;
      // await NotificationHelper().cancelAllNotifications();
    }));
  }

//  @override
//  void dispose() {
//    super.dispose();
//    _pageController.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    mainScreePage = context;

    socketProviderChatListModel = Provider.of<ChatListModel>(context, listen: false);
    var info = Provider.of<ConversationListModel>(context, listen: false);
    socketProviderConversationListModel = info;
    var contactsProvider = Provider.of<ContactListModel>(context, listen: false);
    socketProviderContactListModel = contactsProvider;
    var groupMemberModelProvider = Provider.of<GroupMemberModel>(context, listen: false);
    socketGroupMemberModel = groupMemberModelProvider;
    var chatInfo = Provider.of<ChatInfoModel>(context, listen: false);
    chatInfoModelSocket = chatInfo;
//    socketProviderChatListModel.getChatList();
    var callInfo = Provider.of<CallInfoModel>(context, listen: false);
    callInfoSocket = callInfo;


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
            HomeRoute(),
            ContactsPage(),
//          DiscoveryPage(),
//            TestSqlRoute(),
//            CustomScrollViewTestRoute(),
            DbPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Theme.of(context).primaryColor,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
//          primaryColor: Theme.of(context).accentColor,
            primaryColor: Colors.pink,
            textTheme: Theme.of(context).textTheme.copyWith(
//                caption: TextStyle(color: Colors.grey[500]),
                  caption: TextStyle(color: Colors.white),
                ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: IconBadge(
                  icon: Icons.message,
                ),
//              title: Container(height: 0.0),
                title: Text('Chats'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.group,
                ),
//              title: Container(height: 0.0),
                title: Text(GmLocalizations.of(context).contacts),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.sentiment_satisfied,
                ),
//              title: Container(height: 0.0),
                title: Text(GmLocalizations.of(context).discovery),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
//gAvatar
//                backgroundColor: Colors.pink,
//              title: Container(height: 0.0),
                title: Text('Settings'),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
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
