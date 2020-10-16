import 'dart:convert';

import '../index.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

bool isOnChatsPage = false;
BuildContext chatsPageContext;

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  var _groupList = <dynamic>[];
  var groupListArr;
  var listenIndex = 0;

  ChatListModel notifier;

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    notifier = Provider.of<ChatListModel>(context);
////    chatInfoModelSocket = Provider.of<ChatInfoModel>(context, listen: false);
//    if (socketProviderChatListModel != notifier) {
//      socketProviderChatListModel = notifier;
//      Future.microtask(() {
//        print(12);
//        socketProviderChatListModel.getChatList();
//      });
//    }
//  }

  @override
  void initState() {
//    logger.d(getChat);
//    if (!getChat) {
//      getChat = true;
//      socketProviderChatListModel.getChatList();
//    }
//    logger.d('===================chats 2:');
//     logger.d('===================chats :');

    isOnChatsPage = true;
    super.initState();
//    if (!getChat) {
//      getChat = true;
//      socketProviderChatListModel.getChatList();
//    }
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//         statusBarColor: Colors.white
//     ));
  }

  @override
  void dispose() {
    isOnChatsPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatsPageContext = context;
    var socketConnect = Provider.of<ConnectSocketModel>(context);
    socketProviderConnectModel = socketConnect;
//    if (!getChat) {
//      getChat = true;
//      chatListModel.getChatList();
//    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DataUtil.iosBarBgColor(),
        // textTheme: Theme.of(context).primaryColor,
        brightness: Brightness.light,
        shadowColor: Colors.white,
        elevation: 0,
        toolbarHeight: 48,
        bottom: PreferredSize(
          child: Container(
            color: DataUtil.iosBorderGreyShallow(),
            height: 0.5,
          ),
          preferredSize: Size.fromHeight(0.5),
        ),
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   width: 16,
              // ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    socketConnect.socket.connected == true
                        ? socketConnect.updating
                            ? Text(
                                "Updating...",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: DataUtil.iosLightTextBlack(),
                                ),
                              )
                            : Text(
                                "Chats",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: DataUtil.iosLightTextBlack(),
//                        fontSize: 14,
                                ),
                              )
                        : Text(
                            "Connecting...",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: DataUtil.iosLightTextBlack(),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
//            conversionInfo['groupName'] = 'sdff';
//            conversion.updateInfoProperty('groupName', '123132');
          },
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.search,
            color: DataUtil.iosLightTextBlue(),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("newMessage");
          },
        ),
        actions: <Widget>[
          // 非隐藏的菜单
          IconButton(
            icon: Icon(
              DefineIcons.compose,
              color: DataUtil.iosLightTextBlue(),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("newMessage");
            },
          ),
        ],
      ),
      body: _buildBody(context),
      // 构建主页面
//      drawer: MyDrawer(), //抽屉菜单
    );
  }

  Widget _buildBody(context) {
    return Consumer<ChatListModel>(
      builder:
          (BuildContext context, ChatListModel chatListModel, Widget child) {
        var chats = List.from(chatListModel.chatList);
        ArrayUtil.sortArray(chats, sortOrder: 0, property: 'createdDate');
//        logger.d(chats[0]);
        return ListView.separated(
          key: PageStorageKey('homePage'),
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: Divider(),
              ),
            );
          },
          reverse: false,
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            Map chat = chats[index];
//        return Text(chat['groupName']);
//            var contactId = 0;
//            if(chat['groupType'] == 2) {
//              if (chat['contactId'][0] == Global.profile.user.userId) {
//                contactId = chat['groupUserList'][1];
//              } else {
//                contactId = chat['groupUserList'][0];
//              }
//            }
            return ChatItem(
              groupId: chat['groupId'],
              contactId: chat['contactId'],
              contactSqlId: chat['contactSqlId'],
              colorId: chat['colorId'],
              groupType: chat['groupType'],
              avatar: chat['avatar'],
              fileCompressUrl: chat['fileCompressUrl'],
              fileCompressLocal: chat['fileCompressLocal'],
              fileOriginUrl: chat['fileOriginUrl'],
              fileOriginLocal: chat['fileOriginLocal'],
              groupName: chat['groupName'],
              username: chat['username'],
              isOnline: chat['isOnline'],
              newChatNumber: chat['newChatNumber'],
              sendName: chat['sendName'],
              senderId: chat['senderId'],
              content: chat['content'],
              contentName: chat['contentName'],
              contentType: chat['contentType'],
              createdDate: chat['createdDate'],
              groupUserLength: chat['groupUserLength'],
              groupRoomInfoTimestamp: chat['groupRoomInfoTimestamp'],
              groupRoomUserTimestamp: chat['groupRoomUserTimestamp'],
              lastSeen: chat['lastSeen'],
              firstName: chat['firstName'],
              lastName: chat['lastName'],
              description: chat['description'],
              sending: chat['sending'],
              isMe: chat['isMe'],
              isRead: chat['isRead'],
              latestMsgId: chat['latestMsgId'],
              latestMsgTime: chat['latestMsgTime'],
              extentBeforeId: chat['extentBeforeId'],
              extentAfterId: chat['extentAfterId'],
              extentBefore: chat['extentBefore'],
              extentAfter: chat['extentAfter'],
              timestamp: chat['timestamp'],
              messageId: chat['messageId'],
            );
          },
        );
      },
    );

//    print('chats: $chats');
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      setState(() {
        //重新构建列表
        _groupList.insertAll(
            _groupList.length - 1,
            //每次生成20个单词
            generateWordPairs().take(20).map((e) => e.asPascalCase).toList());
      });
    });
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel value, Widget child) {
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
//                    child: value.user.avatarUrl == null
//                        ? gmAvatar(value.user.avatarUrl, width: 80)
//                        : Image.asset(
//                            "imgs/avatar-default.jpg",
//                            width: 80,
//                          ),
                    child: Image.asset(
                      "imgs/avatar-default.jpg",
                      width: 80,
                    ),
                  ),
                ),
//                Text(
//                  value.isLogin
//                      ? value.user.login
//                      : GmLocalizations.of(context).login,
//                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    color: Colors.white,
//                  ),
//                )
              ],
            ),
          ),
          onTap: () {
            if (!value.isLogin) Navigator.of(context).pushNamed("login");
          },
        );
      },
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(gm.theme),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.pushNamed(context, "language"),
            ),
            if (userModel.isLogin)
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: Text(gm.logout),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      //退出账号前先弹二次确认窗
                      return AlertDialog(
                        content: Text(gm.logoutTip),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(gm.cancel),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text(gm.yes),
                            onPressed: () {
                              //该赋值语句会触发MaterialApp rebuild
                              userModel.user = null;
                              Global.profile.token = null;
                              Global.saveProfile();
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed("login");
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
