
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

JsonEncoder _encoder = new JsonEncoder();
JsonDecoder _decoder = new JsonDecoder();
Map<String, dynamic> messageDialogsGetState = {
  'limit': 10,
  'offsetId': 0,
  'offsetDate': 0,
  'hash': 0,
};

class SocketIoEmit {
  static connectInfoSend() async {
    var connectInfo = json.encode({
      'type': 'connectInfo',
      'authtoken': Global.profile.token,
    });
    socketInit.emit('msg', connectInfo);
  }

//  请求 会话表
  static clientOpenGroupTable() async {
//
    final dbHelper = DatabaseHelper.instance;
    var futureGroupArr = <Future>[
//      dbHelper
//          .contactMultipleCondition(['userId'], [Global.profile.user.userId]),
      dbHelper.userAll(),
      dbHelper.groupRoomAll(),
      dbHelper
          .groupUserMultipleCondition(['userId'], [Global.profile.user.userId]),
      dbHelper.getChatListAllRows(),
    ];

    var backArr = await Future.wait(futureGroupArr);
//    List contacts = backArr[0] == null ? [] : backArr[0];
    List users = backArr[0] == null ? [] : backArr[0];
    List groupRooms = backArr[1] == null ? [] : backArr[1];
    List groupUsers = backArr[2] == null ? [] : backArr[2];
    List chatListAll = backArr[3] == null ? [] : backArr[3];
//        发送本地contact 对应的user表 最后更新时间戳, 同步服务器联系人信息，减少流量拉取
//    List sendContacts = [];
    List sendGroupRoom = [];
    List sendUser = [];
    List sendLastMessage = [];
    List sendGroupUser = [];
//    获取最新一条消息，与服务器对比，是否一致
    var futureGetMessageArr = <Future>[];
    for (var i = 0; i < groupUsers.length; i++) {
      var groupUser = groupUsers[i];
      if (groupUser['deleteChat'] == 1 && groupUser['id'] != 0) {
        for (var m = 0; m < users.length; m++) {
          if (users[m]['id'] == groupUser['contactId']) {
            sendUser.add({
              'id': users[m]['id'],
              'infoTimestamp': users[m]['infoTimestamp'],
            });
            break;
          }
        }
//        会话 最新一条消息id

        for (var m = 0; m < chatListAll.length; m++) {
          if (chatListAll[m]['groupId'] == groupUser['groupId']) {
            if (chatListAll[m]['messageId'] != null &&
                chatListAll[m]['messageId'] != 0) {
              futureGetMessageArr.add(dbHelper.groupMessageMultipleCondition(
                  ['id'], [chatListAll[m]['messageId']]));
//              sendLastMessage.add(chatListAll[m]['messageId']);
            }
            break;
          }
        }
        sendGroupUser.add({
          'id': groupUser['id'],
          'infoTimestamp': groupUser['infoTimestamp'],
        });
      }
    }
    var backMessageDetailArr = await Future.wait(futureGetMessageArr);
//    for (var i = 0; i < contacts.length; i++) {
//      sendContacts.add({
//        'id': contacts[i]['id'],
//        'infoTimestamp': contacts[i]['infoTimestamp'],
//      });
//      for (var m = 0; m < users.length; m++) {
//        if (users[m]['id'] == contacts[i]['contactId']) {
//          bool shouldAdd = true;
//          for (var n = 0; n < sendUser.length; n++) {
//            if (sendUser[n]['id'] == contacts[i]['contactId']) {
//              shouldAdd = false;
//            }
//          }
//          if (shouldAdd) {
//            sendUser.add({
//              'id': users[m]['id'],
//              'infoTimestamp': users[m]['infoTimestamp'],
//            });
//          }
//          break;
//        }
//      }
//    }

    if (backMessageDetailArr != null) {
//      logger.d(backMessageDetailArr);
      for (var j = 0; j < backMessageDetailArr.length; j++) {
        var jsonObj = backMessageDetailArr[j] != null &&
                backMessageDetailArr[j].length > 0
            ? backMessageDetailArr[j][0]
            : null;
//          logger.d(jsonObj);
        if (jsonObj != null) {
          sendLastMessage.add(jsonObj['id']);
          for (var m = 0; m < users.length; m++) {
            if (users[m]['id'] == jsonObj['senderId']) {
              bool shouldAdd = true;
              for (var n = 0; n < sendUser.length; n++) {
                if (sendUser[n]['id'] == jsonObj['senderId']) {
                  shouldAdd = false;
                }
              }
              if (shouldAdd) {
                sendUser.add({
                  'id': users[m]['id'],
                  'infoTimestamp': users[m]['infoTimestamp'],
                });
              }
              break;
            }
          }
        }
      }
    } else {
      // 本地 message不在，
      sendLastMessage = [];
    }
    for (var i = 0; i < groupRooms.length; i++) {
      sendGroupRoom.add({
        'id': groupRooms[i]['id'],
        'infoTimestamp': groupRooms[i]['infoTimestamp']
      });
    }
//        logger.d(sendContacts);
//        logger.d(sendGroupRoom);
//        logger.d(sendUser);
    var sendDataGroup = json.encode({
      'type': 'clientOpenGroupTable',
      'authtoken': Global.profile.token,
//      'contact': sendContacts,
      'groupRoom': sendGroupRoom,
      'sendUser': sendUser,
      'sendGroupUser': sendGroupUser,
      'sendLastMessage': sendLastMessage,
    });

    socketInit.emit('msg', sendDataGroup);
  }

  /// dialog
  //  请求 会话表 新方式
  static messageDialogsGet({
    int limit = 20,
    int offsetId = 0,
    int offsetDate = 0,
    int offsetPage = 0,
  }) async {
//    logger.d('---------------------limit: $limit');
//    logger.d('---------------------offsetDate: $offsetDate');

    isUpdatingGroup = true;
    final dbHelper = DatabaseHelper.instance;
    var futureGroupArr = <Future>[
      dbHelper
          .groupUserMultipleCondition(['userId'], [Global.profile.user.userId]),
    ];
    var backArr = await Future.wait(futureGroupArr);
    List groupUsers = backArr[0] == null ? [] : backArr[0];
    List dialogList = [];
    int hash = 0;
    if (groupUsers.length > 0) {
//      ArrayUtil.sortArray(groupUsers, 1, )
      for(var i = 0; i < groupUsers.length; i++) {
        var jsonObj = groupUsers[i];
        if (jsonObj['deleteChat'] == 1) {
          int groupId = jsonObj['groupId'];
          int latestMsgTime = jsonObj['latestMsgTime'];
          int pts = jsonObj['pts'];

          if (groupId != 0 && groupId != null) {
            Map item = {
              "groupId": groupId,
              "latestMsgTime": latestMsgTime == null ? 0 : latestMsgTime,
              "pts": pts == null ? 0 : pts,
            };
            dialogList.add(item);
          }

        }
      }
    }
    ArrayUtil.sortArray(dialogList, sortOrder: 0, property: 'latestMsgTime');
    List<int> ids = [];
//    int len = dialogList.length > limit ?  limit : dialogList.length;
    int hasAddCount = 0;
//    logger.d('---------------------hasAddCount: $hasAddCount');
    for (var i = 0; i < dialogList.length; i++) {
      if (offsetDate == 0) {
//        int id = dialogList[i]['latestMsgTime'];
        int id = dialogList[i]['pts'];
        ids.add(id);
        hasAddCount += 1;
      } else {
        if (dialogList[i]['latestMsgTime'] < offsetDate) {
//          int id = dialogList[i]['latestMsgTime'];
          int id = dialogList[i]['pts'];
          ids.add(id);
          hasAddCount += 1;
        }
      }
      if (hasAddCount >= limit) break;
    }
//    if (dialogList.length > 0) {
//      offsetId = dialogList[0]['groupId'];
//      offsetDate = dialogList[0]['latestMsgTime'];
//    }
    if (ids.length > 0) {
      // logger.d(ids.join(','));
      /// 之前是latestMsgTime的hash值，更改为pts
      hash = ArrayUtil.createHash(ids);
    }
    var sendData = {
      'type': 'messageDialogsGet',
      'authtoken': Global.profile.token,
      'hash': hash,
      'limit': limit,
      'offsetId': offsetId,
      'offsetDate': offsetDate,
    };
    if (offsetDate == 0) {
      messageDialogsGetState = {
        'limit': limit,
        'offsetId': offsetId,
        'offsetDate': 0,
        'hash': hash,
      };
    }
//    logger.d(sendData);
    socketInit.emit('msg', json.encode(sendData));
  }

  /// Contacts
//增删改联系人
  static clientGetContacts({
    String username,
    String firstName,
    String lastName,
  }) async {
    final dbHelper = DatabaseHelper.instance;
    var contactAll = await dbHelper
        .contactMultipleCondition(['userId'], [Global.profile.user.userId]);
    var hash = 0;
    if (contactAll != null) {
      List contacts = List.from(contactAll);
      ArrayUtil.sortArray(contacts, sortOrder: 1, property: 'id');
      List<int> ids = [];
      for (var i = 0; i < contacts.length; i++) {
        int id = contacts[i]['infoTimestamp'];
        ids.add(id);
      }
      if (ids.length > 0) {
        hash = ArrayUtil.createHash(ids);
      }
    }
    var sendData = json.encode({
      'type': 'clientGetContacts',
      'authtoken': Global.profile.token,
      'hash': hash,
    });
    socketInit.emit('msg', sendData);
  }

  static clientAddContacts({
    String username,
    String firstName,
    String lastName,
  }) async {
    var clientAddContacts = json.encode({
      'type': 'clientAddContacts',
      'authtoken': Global.profile.token,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    });
    socketInit.emit('msg', clientAddContacts);
  }

  static clientEditContacts({
    int contactSqlId,
    String firstName,
    String lastName,
  }) async {
    var clientEditContactsStr = json.encode({
      'type': 'clientEditContacts',
      'authtoken': Global.profile.token,
      'contactSqlId': contactSqlId,
      'firstName': firstName,
      'lastName': lastName,
    });
    socketInit.emit('msg', clientEditContactsStr);
  }

  static clientDeleteContacts({
    int contactSqlId,
  }) async {
    var clientDeleteContactsStr = json.encode({
      'type': 'clientDeleteContacts',
      'authtoken': Global.profile.token,
      'contactSqlId': contactSqlId,
    });
    socketInit.emit('msg', clientDeleteContactsStr);
  }
  static contactStatusGet() async {
    var sendData = {
      'type': 'contactStatusGet',
      'authtoken': Global.profile.token
    };
    socketInit.emit('msg', json.encode(sendData));
  }

  /// chat
//  创建群
  static clientCreateGroup({
    int groupType,
    List groupUserArr,
    String groupName,
    int avatar,
    String groupAvatar,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'clientCreateGroup',
      'authtoken': Global.profile.token,
      'groupType': groupType == null ? 1 : groupType,
      'groupUserArr': groupUserArr,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
      'avatar': avatar,
    };
    socketInit.emit('msg', json.encode(sendData));
  }

//  获取群资料
  static clientGetOneGroup({
    int groupId,
    int groupType,
    int contactId,
    int infoTimestamp,
    int userTimestamp,
  }) async {
    Map<String, dynamic> sendDataGroup = {
      'type': 'clientGetOneGroup',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'groupType': groupType,
      'contactId': contactId,
      'infoTimestamp': infoTimestamp,
      'userTimestamp': userTimestamp,
    };
    socketInit.emit('msg', json.encode(sendDataGroup));
  }

//  修改群资料
  static clientEditGroupSimple({
    int groupId,
    String groupName,
    String groupAvatar,
    int avatar,
    String description,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'clientEditGroupSimple',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'groupName': groupName,
      'avatar': avatar,
      'groupAvatar': groupAvatar,
      'description': description,
    };
    socketInit.emit('msg', json.encode(sendData));
  }

//  添加群成员
  static clientAddGroupMember({
    int groupId,
    List memberId,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'clientAddGroupMember',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'memberId': memberId,
    };
    socketInit.emit('msg', json.encode(sendData));
  }

//  删除群成员
  static clientDeleteGroupMember({
    int groupId,
    int memberId,
    bool deleteOther = false,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'clientDeleteGroupMember',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'memberId': memberId,
      'deleteOther': deleteOther,
    };
    socketInit.emit('msg', json.encode(sendData));
  }
//  用 id 获取群info
  static messageChatGet({
    List<int> id,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'messageChatGet',
      'authtoken': Global.profile.token,
      'id': id,
    };
    socketInit.emit('msg', json.encode(sendData));
  }


  /// message
// 一次请求所有群消息
  static clientGetGroupMessage({
    int groupId,
  }) async {
//    Map<String, dynamic> sendDataGroup = {
//      'type': 'clientGetGroupMessage',
//      'authtoken': Global.profile.token,
//      'groupId': groupId,
//    };
//    socketInit.emit('msg', json.encode(sendDataGroup));
  }

//  发送消息板块
  static clientSendGroupMessage({
    int groupId,
    int contactId,
    int senderId,
    int timestamp,
    int createdDate,
    int id,
    int contentType,
    String content,
    String contentName,
    int replyId,
    int downloading,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'clientSendGroupMessage',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'contactId': contactId,
      'timestamp': timestamp,
      'createdDate': createdDate,
      'contentType': contentType,
      'content': content,
      'contentName': contentName,
      'replyId': replyId,
    };
    socketInit.emit('msg', json.encode(sendData));
  }
  static messageSend({
    int groupId,
    int contactId,
    int senderId,
    int timestamp,
    int createdDate,
    int id,
    int contentType,
    String content,
    String contentName,
    int replyId,
    int downloading,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'messageSend',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'contactId': contactId,
      'timestamp': timestamp,
      'createdDate': createdDate,
      'contentType': contentType,
      'content': content,
      'contentName': contentName,
      'replyId': replyId,
    };
    socketInit.emit('msg', json.encode(sendData));
  }


//  获取历史消息
  static messageHistoryGet({
    int groupId,
    int offsetId = 0,
    int limit = 40,
    int addOffset = 0,
    int hash = 0,
    int maxId = 0,
    int minId = 0,
    int offsetIdSave,
    int limitSave,
    int addOffsetSave,
    int offsetDateSave,
  }) async {
    Map<String, dynamic> sendData = {
      'type': 'messageHistoryGet',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'offsetId': offsetId,
      'limit': limit,
      'addOffset': addOffset,
      'hash': hash,
      'maxId': maxId,
      'minId': minId,
      'offsetIdSave': offsetIdSave,
      'limitSave': limitSave,
      'addOffsetSave': addOffsetSave,
      'offsetDateSave': offsetDateSave,
    };
    socketInit.emit('msg', json.encode(sendData));
  }

//  通过id获取消息
  static messageListDetail({
    List<int> id,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'messageListDetail',
      'authtoken': Global.profile.token,
      'id': id,
    };
    socketInit.emit('msg', json.encode(sendData));
  }
//  通过id获取未读数量
  static messageUnRead({
    List<int> id,
    List<int> lastReadId,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'messageUnRead',
      'authtoken': Global.profile.token,
      'id': id,
      'lastReadId': lastReadId,
    };
    socketInit.emit('msg', json.encode(sendData));
  }

  /// user
//  通过id获取user
  static userInfoGet({
    List<int> id,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'userInfoGet',
      'authtoken': Global.profile.token,
      'id': id,
    };
    socketInit.emit('msg', json.encode(sendData));
  }
//  通过id获取user status
  static userStatusGet({
    List<int> id,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'userStatusGet',
      'authtoken': Global.profile.token,
      'id': id,
    };
    socketInit.emit('msg', json.encode(sendData));
  }


  /// call

//  发出通话邀请
  static callInvite({
    int fromId,
    int toId,
    int groupId,

    String uuid,
    String handle,
    bool hasVideo = false,
    String callerName,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callInvite',
      'authtoken': Global.profile.token,
      'fromId': fromId,
      'toId': toId,
      'groupId': groupId,
      'uuid': uuid,
      'handle': handle,
      'hasVideo': hasVideo,
      'callerName': callerName,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }
  //  发出通话邀请
  static cancelInvite({
    int fromId,
    int toId,
    int groupId,
    String uuid,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'cancelInvite',
      'authtoken': Global.profile.token,
      'fromId': fromId,
      'toId': toId,
      'groupId': groupId,
      'uuid': uuid,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }
  //  发出 candidate
  static callCandidate({
    int fromId,
    int toId,
    int groupId,
    dynamic candidate,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callCandidate',
      'authtoken': Global.profile.token,
      'fromId': fromId,
      'toId': toId,
      'groupId': groupId,
      'candidate': candidate,
    };

    socketInit.emit('msg', _encoder.convert(sendData));
  }
  //  发出 candidate
  static callCandidateGet({
    int fromId,
    int toId,
    int groupId,
    Map candidate,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callCandidateGet',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'fromId': fromId,
      'toId': toId,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }
  //  发出 candidate
  static callDescriptionGet({
    int fromId,
    int toId,
    int groupId,
    Map candidate,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callDescriptionGet',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'fromId': fromId,
      'toId': toId,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }
  //  发出 candidate
  static callOffer({
    int fromId,
    int toId,
    int groupId,
    Map description,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callOffer',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'fromId': fromId,
      'toId': toId,
      'description': description,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }

  //  发出 candidate
  static callAnswer({
    int fromId,
    int toId,
    int groupId,
    Map description,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callAnswer',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'fromId': fromId,
      'toId': toId,
      'description': description,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }
  //  发出 candidate
  static callBye({
    int fromId,
    int toId,
    int groupId,
    bool reject = false,
  }) async {
//    isUpdatingGroup = true;
    Map<String, dynamic> sendData = {
      'type': 'callBye',
      'authtoken': Global.profile.token,
      'groupId': groupId,
      'fromId': fromId,
      'toId': toId,
    };
    socketInit.emit('msg', _encoder.convert(sendData));
  }
}
