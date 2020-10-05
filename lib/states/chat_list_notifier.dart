import '../index.dart';

class ChatModelNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

// 首页所有聊天人
int downloadFileId;

class ChatListModel extends ChatModelNotifier {
  final dbHelper = DatabaseHelper.instance;
  ChatListModel() {
    // logger.d('getChat');
    getChatList();
  }

  // 监听聊天列表变化
  List _chatList = [];
  int _totalNews = 0;

//  所有聊天列表
  List get chatList {
    return _chatList;
  }

  int get totalNews {
    return _totalNews;
  }

  getChatTotalNews() {
    int newTotal = 0;
    if (_chatList.length != 0) {
      for (var i = 0; i < _chatList.length; i++) {
        var itemNum = _chatList[i]['newChatNumber'];
//        logger.d(itemNum);
        if (itemNum == 0 || itemNum == null) {
          continue;
        }
        newTotal += itemNum;
      }
    }
    _totalNews = newTotal;
    return _totalNews;
  }
  getChatList() async {
//    _chatList = Global.chatListOrigin;
//    notifyListeners();
//    logger.d('getChatList');
    var st = DateTime.now().millisecondsSinceEpoch;
    var chats = [];
    var futureGroupArr = <Future>[
      dbHelper
          .contactMultipleCondition(['userId'], [Global.profile.user.userId]),
      dbHelper
          .groupUserMultipleCondition(['userId'], [Global.profile.user.userId]),
      dbHelper.groupRoomAll(),
      dbHelper.userAll(),
      dbHelper.fileAll(),
    ];
    var backArr = await Future.wait(futureGroupArr);
    var end = DateTime.now().millisecondsSinceEpoch;
    // print('首页 sql查询 time: ${end - st}');
    List contactAll = backArr[0] == null ? [] : backArr[0];
    List groupUserAll = backArr[1] == null ? [] : backArr[1];
    List groupRoomAll = backArr[2] == null ? [] : backArr[2];
    List userAll = backArr[3] == null ? [] : backArr[3];
    List fileAll = backArr[4] == null ? [] : backArr[4];
//    logger.d(chatListAll);
    var futureGetMessageArr = <Future>[];
    var futureDownloadFile = <Future>[];
    int downloadLength = 0;
    for (var i = 0; i < groupUserAll.length; i++) {
      var groupUser = groupUserAll[i];
      if (groupUser['deleteChat'] == 1) {
        /// 会话 最新一条消息id detail
        /// messageId等于0 说明是发送不成功的消息
        String condition;
        if (groupUser['messageId'] == 0) {
          condition = '''
              id=0
              AND timestamp=${groupUser['timestamp']}
              ''';
        } else if (groupUser['messageId'] != null &&
            groupUser['messageId'] != 0) {
          condition = '''
              id=${groupUser['messageId']}
              ''';
        }
        futureGetMessageArr.add(dbHelper.groupMessageQueryByStr(condition));
      }
    }
//    获取每个会话 最新一条消息详情
    var backMessageDetailArr = await Future.wait(futureGetMessageArr);
    for (var i = 0; i < groupUserAll.length; i++) {
      var groupUser = groupUserAll[i];
      if (groupUser['deleteChat'] == 1) {
        int groupId = groupUser['groupId'];
        int groupType = 1;
        String groupName = '';
        int colorId = 0;
        int avatar = 0;
        String fileCompressUrl = '';
        String fileCompressLocal = '';
        String fileOriginUrl = '';
        String fileOriginLocal = '';
        String avatarName = '';
        int createdDate;

        int contactSqlId = 0;

        int messageId = 0;
        int latestMsgId = 0;
        int latestMsgTime = 0;
        int contactId = 0;
        int newChatNumber = 0;
        int groupUserLength = 1;
        int lastDeleteMsgId = 0;

        String sendName = '';
        int senderId = 0;

        String username = '';
        String firstName = '';
        String lastName = '';

        String content = '';
        String contentName = '';
        int contentType = 1;
        bool isOnline = false;
        int timestamp = 0;
        int groupRoomInfoTimestamp = 0;
        int groupRoomUserTimestamp = 0;
        int lastSeen;

        String description = '';
        String bio = '';

        int unread = 0;

        double extentBefore = 0;
        double extentAfter = 0;
        int extentAfterId = 0;
        int extentBeforeId = 0;
        int hasGetOldest = 0;

        contactId = groupUser['contactId'];
        lastDeleteMsgId = groupUser['lastDeleteMsgId'];
        messageId = groupUser['messageId'];
        timestamp = groupUser['timestamp'];
        unread = groupUser['unread'];
        latestMsgId = groupUser['latestMsgId'];
        latestMsgTime = groupUser['latestMsgTime'];
        extentBefore = groupUser['extentBefore'];
        extentAfter = groupUser['extentAfter'];
        extentAfterId = groupUser['extentAfterId'];
        extentBeforeId = groupUser['extentBeforeId'];
        hasGetOldest = groupUser['hasGetOldest'];

        for (var j = 0; j < backMessageDetailArr.length; j++) {
          var jsonObj;
          if (backMessageDetailArr[j] != null) {
            if (backMessageDetailArr[j].length > 0) {
              jsonObj = backMessageDetailArr[j][0];
            }
          }
//          var jsonObj = backMessageDetailArr[j] != null &&
//                  backMessageDetailArr[j].length > 0
//              ? backMessageDetailArr[j][0]
////              : null;
//          if (groupUser['contactId'] == 47) {
//            logger.d(jsonObj);
//          }
          if (jsonObj != null) {
            if (messageId != 0) {
              if (jsonObj['id'] == messageId) {
                senderId = jsonObj['senderId'];
                content = jsonObj['content'];
                createdDate = jsonObj['createdDate'];
                contentType = jsonObj['contentType'];
                contentName = jsonObj['contentName'];
                /// 赋值 timestamp
                timestamp = jsonObj['timestamp'];
              }
            } else {
              /// 查找没有发送成功的消息
              if (jsonObj['id'] == messageId &&
                  timestamp == jsonObj['timestamp'] &&
                  backMessageDetailArr[j].length == 1) {
                senderId = jsonObj['senderId'];
                content = jsonObj['content'];
                createdDate = jsonObj['createdDate'];
                contentType = jsonObj['contentType'];
                contentName = jsonObj['contentName'];
//                timestamp = jsonObj['timestamp'];
              } else if (jsonObj['id'] == messageId &&
                  backMessageDetailArr[j].length > 1) {
                var jsonObj2 = backMessageDetailArr[j];
                for (var k = 0; k < jsonObj2.length; k++) {
                  logger.d(jsonObj2);
                  if (timestamp != null &&
                      timestamp != 0 &&
                      jsonObj2[k]['timestamp'] == timestamp) {
                    senderId = jsonObj2[k]['senderId'];
                    content = jsonObj2[k]['content'];
                    createdDate = jsonObj2[k]['createdDate'];
                    contentType = jsonObj2[k]['contentType'];
                    contentName = jsonObj2[k]['contentName'];
//                    timestamp = jsonObj['timestamp'];
                  }
                }
              }
            }
          }
        }
        bool hasGroup = false;
        for (var j = 0; j < groupRoomAll.length; j++) {
          var jsonObj = groupRoomAll[j];
          if (jsonObj['id'] == groupId) {
            hasGroup = true;
            groupType = jsonObj['groupType'];
            if (groupType == 1) {
              colorId = jsonObj['colorId'];
              groupName = jsonObj['groupName'];
              avatar = jsonObj['avatar'];
              description = jsonObj['description'];
              String str = groupName;
              var pieces = str.split(' ');
              if (pieces.length > 0) {
                firstName = pieces[0];
              }
              if (pieces.length > 1) {
                lastName = pieces[pieces.length - 1];
              }
            }

            if (createdDate == null) {
              createdDate = jsonObj['createdDate'];
            }
//            群本地最后修改时间戳
            groupRoomInfoTimestamp = jsonObj['infoTimestamp'];
//            群成员最后修改时间戳
            groupRoomUserTimestamp = jsonObj['userTimestamp'];
            break;
          }
        }
        if (!hasGroup) {
          groupType = 2;
          if (createdDate == null) {
            createdDate = 0;
            continue;
          }
//          createdDate = DateTime.now().toString();
        }

        for (var j = 0; j < userAll.length; j++) {
          var jsonObj = userAll[j];
          if (jsonObj['id'] == senderId) {
            sendName = jsonObj['firstName'];
          }
          if (jsonObj['id'] == contactId && groupType == 2) {
            colorId = jsonObj['colorId'];
            avatar = jsonObj['avatar'];
            groupName = '${jsonObj['firstName']}';
            if (jsonObj['lastName'] != null) {
              groupName += ' ${jsonObj['lastName']}';
            }
            firstName = jsonObj['firstName'];
            lastName = jsonObj['lastName'];
            username = jsonObj['username'];
            isOnline = jsonObj['isOnline'] == 1;
            lastSeen = jsonObj['lastSeen'];
            bio = jsonObj['bio'];
          }
        }
        for (var j = 0; j < contactAll.length; j++) {
          var jsonObj = contactAll[j];
          if (jsonObj['contactId'] == senderId) {
            sendName = jsonObj['firstName'];
          }
          if (jsonObj['contactId'] == contactId && groupType == 2) {
            groupName = jsonObj['firstName'];
            if (jsonObj['lastName'] != null) {
              groupName += ' ${jsonObj['lastName']}';
            }
            firstName = jsonObj['firstName'];
            lastName = jsonObj['lastName'];
            contactSqlId = jsonObj['id'];
          }
        }
        if (avatar != 0) {
          bool hasFile = false;
          for (var j = 0; j < fileAll.length; j++) {
            var jsonObj = fileAll[j];
            if (jsonObj['id'] == avatar) {
              hasFile = true;
              fileCompressUrl = jsonObj['fileCompressUrl'];
              fileCompressLocal = jsonObj['fileCompressLocal'];
              avatarName = jsonObj['fileName'];
              fileOriginUrl = jsonObj['fileOriginUrl'];
              fileOriginLocal = jsonObj['fileOriginLocal'];
              if (fileCompressLocal == null || fileCompressLocal == '') {
                downloadLength += 1;
                futureDownloadFile.add(Git().saveImageFileCompress(
                  avatar,
                  avatarName,
                  jsonObj['fileCompressUrl'],
                ));
              }
            }
          }
        }
//        logger.d(isOnline);
        Map<String, dynamic> item = {
          'groupId': groupUser['groupId'],
          'groupName': groupName,
          'groupType': groupType,
          'avatar': avatar,
          'fileCompressUrl': fileCompressUrl,
          'fileCompressLocal': fileCompressLocal,
          'fileOriginUrl': fileOriginUrl,
          'fileOriginLocal': fileOriginLocal,
          'avatarName': avatarName,
          'colorId': colorId,
          'content': content,
          'contentName': contentName,
          'contentType': contentType,
          'createdDate': createdDate,
          'newChatNumber': unread,
          'groupUserLength': groupUserLength,
          'contactId': contactId,
          'username': username,
          'sendName': sendName,
          'senderId': senderId,
          'isOnline': isOnline,
          'lastSeen': lastSeen,
          'groupRoomUserTimestamp': groupRoomUserTimestamp,
          'groupRoomInfoTimestamp': groupRoomInfoTimestamp,
          'firstName': firstName,
          'lastName': lastName,
          'contactSqlId': contactSqlId,
          'description': description,
          'bio': bio,
          'lastDeleteMsgId': lastDeleteMsgId,
          'messageId': messageId,
          'latestMsgId': latestMsgId,
          'latestMsgTime': latestMsgTime,
          'sending': messageId == 0,
          'timestamp': timestamp,
          'isRead': false,
          'isMe': senderId == Global.profile.user.userId,
          'extentBefore': extentBefore,
          'extentAfter': extentAfter,
          'extentAfterId': extentAfterId,
          'extentBeforeId': extentBeforeId,
          'hasGetOldest': hasGetOldest,
        };

//
//        if (groupId == 0) {
//          logger.d(item);
//        }
        chats.add(item);
//        logger.d(item);
      }
    }

    if (downloadLength > 0) {
//      logger.d(downloadLength);

//      downloadFile();
      downloadFile(futureDownloadFile);
    }
    var end2 = DateTime.now().millisecondsSinceEpoch;
    // print('将查询数据组合 执行time: ${end2 - end}');
    _chatList = chats;
    getChatTotalNews();
    notifyListeners();
//    Global.chatListOrigin = _chatList;
//    Global.saveChatList();
    return _chatList;
  }

  downloadFile(futureDownloadFile) async {
    var res = await Future.wait(futureDownloadFile);
//    logger.d(res);
//    下载第2次失败，就不下载了
    for (var i = 0; i < res.length; i++) {
      if (res[i]['pathUrl'] == null) {
        if (downloadFileId == res[i]['id']) {
          downloadFileId = null;
          break;
        } else {
          downloadFileId = res[i]['id'];
          socketProviderChatListModel.getChatList();
          break;
        }
      }
    }
  }

  void add(Map<String, dynamic> item) {
    _chatList.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void updateList(List chats) async {
    _chatList = chats;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void updateItemProperty(groupId, property, value, {int contactId}) {
    for (var i = 0; i < _chatList.length; i++) {
      if (groupId != 0) {
        if (_chatList[i]['groupId'] == groupId) {
          _chatList[i][property] = value;
          // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
          notifyListeners();
          break;
        }
      } else if (groupId != 0) {
        if (_chatList[i]['contactId'] == contactId) {
          _chatList[i][property] = value;
          // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
          notifyListeners();
          break;
        }
      }
    }
  }

  void updateItemPropertyMultiple(groupId, Map<String, dynamic> valueObj,
      {int contactId}) {
    for (var i = 0; i < _chatList.length; i++) {
      var chat = _chatList[i];
      if (groupId != 0 && chat['groupId'] == groupId) {
        valueObj.forEach((key, value) {
          if (value != null) {
            chat[key] = valueObj[key];
          }
        });
        // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
        notifyListeners();
        break;
      } else if (groupId == 0 && chat['contactId'] == contactId) {
        valueObj.forEach((key, value) {
          if (value != null) {
            chat[key] = valueObj[key];
          }
        });
        // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
        notifyListeners();
        break;
      }
    }
  }

  replaceItem(groupId, Map<String, dynamic> valueObj, {int contactId}) {
    for (var i = 0; i < _chatList.length; i++) {
      var chat = _chatList[i];
      if (groupId != 0 && chat['groupId'] == groupId ||
          groupId == 0 && chat['contactId'] == contactId) {
        _chatList.replaceRange(i, i, [valueObj]);
        break;
      }
    }
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void updateItemPropertyByContactId(contactId, property, value) {
    for (var i = 0; i < _chatList.length; i++) {
      if (_chatList[i]['contactId'] == contactId) {
        _chatList[i][property] = value;
        // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
        notifyListeners();
      }
    }
  }

  void updateItem(groupId, value, [isGetNewMessage]) {
    for (var i = 0; i < _chatList.length; i++) {
      var chatItem = _chatList[i];
      if (chatItem['groupId'] == groupId) {
        chatItem['content'] = value['content'];
        chatItem['contentType'] = value['contentType'];
        chatItem['contentName'] = value['contentName'];
        chatItem['createdDate'] = value['createdDate'];
        if (isGetNewMessage == true) {
          final newNum = chatItem['newChatNumber'] + 1;
          chatItem['newChatNumber'] = newNum;
        }
        // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
        notifyListeners();
      }
    }
  }

  void notifyChatList() {
    notifyListeners();
  }

  void reset() {
    _chatList = [];
    notifyListeners();
  }
}




// 连接 notifier
class ConnectModel extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class ConnectSocketModel extends ConnectModel {
  ConnectSocketModel();

  bool _updating = false;
//  连接状态
  get socket => socketInit;
  get updating => _updating;

  void notifyConnect() {
    notifyListeners();
  }
  setUpdating(bool value) {
    _updating = value;
    notifyListeners();
  }
}

//class ConversationInfoModel extends ChatModelNotifier {
//  // 监听聊天列表变化
//  Map<String, dynamic> _conversationInfo;
//  ConversationInfoModel();
////  所有聊天列表
//  Map<String, dynamic> get conversationInfo => _conversationInfo;
//
//  Map<String, dynamic> getConversationInfo() {
//    return _conversationInfo;
//  }
//
//  void updateInfo(dynamic info) {
//    if (_conversationInfo == info) return;
//    _conversationInfo = info;
//    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
//    notifyListeners();
//  }
//}
