import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

class SocketIoListen {

  //login
  static serverToken() async {
    socketInit.on('serverToken', (data) async {

      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 0) {

        Global.profile.user = null;
        Global.profile.token = null;
        Global.saveProfile();
        socketInit.disconnect();
        isSend = false;
        navigatorKey.currentState.pushReplacementNamed('login');
      }
    });
  }
  /// dialog
// 获取dialog 列表
  static messageDialogsGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('messageDialogsGet', (data) async {
      isUpdatingGroup = true;
      socketProviderConnectModel.setUpdating(true);
      // logger.d('------------------messageDialogsGet :');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
//      logger.d(dataObj);
      if (dataObj['success'] == 1) {
        var allContact = await dbHelper
            .contactMultipleCondition(['userId'], [Global.profile.user.userId]);
        var allGroupUser = await dbHelper.groupUserMultipleCondition(
            ['userId'], [Global.profile.user.userId]);
        List<int> willGetGroupRoom = [];
        List<int> willGetUser = [];
        List<int> willGetLastMessage = [];
        List<int> willGetUnreadGroup = [];
        List<int> willGetLastReadId = [];
        //          更新本地内容的
        var futuresLocalUpdate = <Future>[];
//        var originGroupUserId = [];
        for (var j = 0; j < dataObj['groupUser'].length; j++) {
          var jsonObj = dataObj['groupUser'][j];
//          originGroupUserId.add(jsonObj['id']);

          compareDialogInfo() async {
            var chatItem;
            if (jsonObj['contactId'] != 0) {
              String condition = '''
              userId=${jsonObj['userId']}
              AND contactId=${jsonObj['contactId']}
              ''';
              chatItem = await dbHelper.groupUserQueryByString(condition);
            } else {
              String condition = '''
              userId=${jsonObj['userId']}
              AND groupId=${jsonObj['groupId']}
              ''';
              chatItem = await dbHelper.groupUserQueryByString(condition);
            }

            willGetUnreadGroup.add(jsonObj['groupId']);
            willGetLastReadId.add(jsonObj['lastReadMsgId']);
//            if (chatItem != null) {
//              /// 如果是已存在对话，如果最新和本地最新不相等，要获取未读数
//              if (chatItem[0]['latestMsgId'] != jsonObj['latestMsgId']) {
//                willGetUnreadGroup.add(jsonObj['groupId']);
//                willGetLastReadId.add(jsonObj['lastReadMsgId']);
//              }
//            } else {
//              /// 如果是新对话，如果不相等，要获取未读数
//              if (jsonObj['latestMsgId'] != jsonObj['lastReadMsgId']) {
//                willGetUnreadGroup.add(jsonObj['groupId']);
//                willGetLastReadId.add(jsonObj['lastReadMsgId']);
//              }
//            }

            /// contactId不等于0，表明是单人对话
            /// 则要先看本地是否有已存在的对话
            if (jsonObj['contactId'] != 0) {
              if (chatItem != null) {
                /// 本地 messageId 是否赋值，要看服务器最新message时间是否大于本地最新
                bool isUseBackData = false;
                if (jsonObj['latestMsgId'] != 0) {
                  /// 如果后端返回消息比本地消息要新
                  if (jsonObj['latestMsgTime'] > chatItem[0]['timestamp']) {
                    isUseBackData = true;
                  }
                }
                if (isUseBackData) {
                  await dbHelper.groupUserMerge([
                    'id',
                    'groupId',
                    'messageId',
                    'timestamp',
                    'latestMsgId',
                    'latestMsgTime',
                    'lastReadMsgId',
                    'deleteChat',
                    'lastDeleteMsgId',
                    'leaveMessageId',
                    'leaveGroupName',
                    'inviteUserId',
                    'infoTimestamp',
                  ], [
                    'contactId',
                    'userId'
                  ], [
                    jsonObj['id'],
                    jsonObj['groupId'],
                    jsonObj['latestMsgId'],
                    jsonObj['latestMsgTime'],
                    jsonObj['latestMsgId'],
                    jsonObj['latestMsgTime'],
                    jsonObj['lastReadMsgId'],
                    jsonObj['deleteChat'],
                    jsonObj['lastDeleteMsgId'],
                    jsonObj['leaveMessageId'],
                    jsonObj['leaveGroupName'],
                    jsonObj['inviteUserId'],
                    jsonObj['infoTimestamp'],
                  ], [
                    jsonObj['contactId'],
                    jsonObj['userId']
                  ]);
                } else {
                  await dbHelper.groupUserMerge([
                    'id',
                    'groupId',
                    'latestMsgId',
                    'timestamp',
                    'latestMsgTime',
                    'lastReadMsgId',
                    'deleteChat',
                    'lastDeleteMsgId',
                    'leaveMessageId',
                    'leaveGroupName',
                    'inviteUserId',
                    'infoTimestamp',
                  ], [
                    'contactId',
                    'userId'
                  ], [
                    jsonObj['id'],
                    jsonObj['groupId'],
                    jsonObj['latestMsgId'],
                    jsonObj['latestMsgTime'],
                    jsonObj['latestMsgTime'],
                    jsonObj['lastReadMsgId'],
                    jsonObj['deleteChat'],
                    jsonObj['lastDeleteMsgId'],
                    jsonObj['leaveMessageId'],
                    jsonObj['leaveGroupName'],
                    jsonObj['inviteUserId'],
                    jsonObj['infoTimestamp'],
                  ], [
                    jsonObj['contactId'],
                    jsonObj['userId']
                  ]);
                }
              } else {
                await dbHelper.groupUserMerge([
                  'contactId',
                  'userId',
                  'groupId',
                  'messageId',
                  'timestamp',
                  'latestMsgId',
                  'latestMsgTime',
                  'lastReadMsgId',
                  'deleteChat',
                  'lastDeleteMsgId',
                  'leaveMessageId',
                  'leaveGroupName',
                  'inviteUserId',
                  'infoTimestamp',
                ], [
                  'id'
                ], [
                  jsonObj['contactId'],
                  jsonObj['userId'],
                  jsonObj['groupId'],
                  jsonObj['latestMsgId'],
                  jsonObj['latestMsgTime'],
                  jsonObj['latestMsgId'],
                  jsonObj['latestMsgTime'],
                  jsonObj['lastReadMsgId'],
                  jsonObj['deleteChat'],
                  jsonObj['lastDeleteMsgId'],
                  jsonObj['leaveMessageId'],
                  jsonObj['leaveGroupName'],
                  jsonObj['inviteUserId'],
                  jsonObj['infoTimestamp'],
                ], [
                  jsonObj['id']
                ]);
              }
            } else {
              await dbHelper.groupUserMerge([
                'contactId',
                'userId',
                'groupId',
                'messageId',
                'timestamp',
                'latestMsgId',
                'latestMsgTime',
                'lastReadMsgId',
                'deleteChat',
                'lastDeleteMsgId',
                'leaveMessageId',
                'leaveGroupName',
                'inviteUserId',
                'infoTimestamp',
              ], [
                'id'
              ], [
                jsonObj['contactId'],
                jsonObj['userId'],
                jsonObj['groupId'],
                jsonObj['latestMsgId'],
                jsonObj['latestMsgTime'],
                jsonObj['latestMsgId'],
                jsonObj['latestMsgTime'],
                jsonObj['lastReadMsgId'],
                jsonObj['deleteChat'],
                jsonObj['lastDeleteMsgId'],
                jsonObj['leaveMessageId'],
                jsonObj['leaveGroupName'],
                jsonObj['inviteUserId'],
                jsonObj['infoTimestamp'],
              ], [
                jsonObj['id']
              ]);
            }
          }

          futuresLocalUpdate.add(compareDialogInfo());

          willGetCompare() async {
            var contactId = jsonObj['contactId'];
            if (contactId != 0) {
              bool hasContact = false;
              if (allContact != null) {
                for (var p = 0; p < allContact.length; p++) {
                  if (allContact[p]['contactId'] == contactId) {
                    hasContact = true;
                    break;
                  }
                }
              }
              if (!hasContact) {
                willGetUser.add(jsonObj['contactId']);
              }
            }
            var gRoom = await dbHelper.groupRoomOne(jsonObj['groupId']);
            if (gRoom == null) {
              willGetGroupRoom.add(jsonObj['groupId']);
            }
            var id = jsonObj['latestMsgId'];
            if (id != 0) {
              var gUser = await dbHelper.groupMessageOne(id);
              if (gUser == null) {
                willGetLastMessage.add(id);
              }
            }
          }

          futuresLocalUpdate.add(willGetCompare());
        }

        /// 问题待解决，删除不存在的 dialog
//        for(var m = 0; m < allGroupUser.length; m++) {
//          var isInGroup = false;
//          var gUserId = allGroupUser[m]['id'];
//          logger.d(allGroupUser[m]['pts']);
//          for (var j = 0; j < dataObj['allGroupUserArr'].length; j++) {
//            var jsonObj = dataObj['allGroupUserArr'][j];
//            if (jsonObj == gUserId) {
//              isInGroup = true;
//            }
//          }
//          if (!isInGroup) {
//            futuresLocalUpdate.add(dbHelper.groupUserDelete(gUserId));
//          }
//        }
        await Future.wait(futuresLocalUpdate);
        if (willGetGroupRoom.length > 0) {
          SocketIoEmit.messageChatGet(id: willGetGroupRoom);
        }
        if (willGetLastMessage.length > 0) {
          SocketIoEmit.messageListDetail(id: willGetLastMessage);
        }
        if (willGetUnreadGroup.length > 0) {
          SocketIoEmit.messageUnRead(
              id: willGetUnreadGroup, lastReadId: willGetLastReadId);
        }
        if (willGetUser.length > 0) {
          SocketIoEmit.userInfoGet(id: willGetUser);
          SocketIoEmit.userStatusGet(id: willGetUser);
        }
        print('------------------------------over');
//        isUpdatingGroup = false;
// 获取下一页内容
        int offsetDateNext = dataObj['offsetDateNext'];
        if (offsetDateNext != 0) {
          SocketIoEmit.messageDialogsGet(
              limit: dataObj['limit'], offsetDate: offsetDateNext);
        }
        if (socketProviderChatListModel != null) {
          await socketProviderChatListModel.getChatList();
        }
        if (socketProviderContactListModel != null) {
          socketProviderContactListModel.getContactList();
        }
//      必须发送与返回的限定字段相同 才能使用
//      if (messageDialogsGetState['limit'] == dataObj['limit'] &&
//          messageDialogsGetState['offsetId'] == dataObj['offsetId'] &&
//          messageDialogsGetState['offsetDate'] == dataObj['offsetDate'] &&
//          messageDialogsGetState['hash'] == dataObj['hash']) {
//        if (dataObj['isEmpty'] == false) {
//
//        }
//      }
      }

      isUpdatingGroup = false;
//      socketProviderConnectModel.notifyConnect();
      socketProviderConnectModel.setUpdating(false);
    });
  }

  /// Contacts
  static serverGetContacts() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverGetContacts', (data) async {
      print('------------------serverGetContacts data: ');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      List originContactsId = [];
      List allLocalContact = await dbHelper
          .contactMultipleCondition(['userId'], [Global.profile.user.userId]);
      var futuresLocalUpdate = <Future>[];
      var futuresLocalFile = <Future>[];
//      更新 contacts
      for (var j = 0; j < dataObj['contact'].length; j++) {
        var jsonObj = dataObj['contact'][j];
        originContactsId.add(jsonObj['id']);
        var contactInsert = ContactSql(
          id: jsonObj['id'],
          contactId: jsonObj['contactId'],
          userId: jsonObj['userId'],
          firstName: jsonObj['firstName'],
          lastName: jsonObj['lastName'],
          infoTimestamp: jsonObj['infoTimestamp'],
        );
        futuresLocalUpdate.add(dbHelper.contactUpdateOrInsert(contactInsert));
      }
//      for (var j = 0; j < allLocalContact.length; j++) {
//        var jsonObj = allLocalContact[j];
//        if (!originContactsId.contains(jsonObj['id'])) {
//          futuresLocalUpdate.add(dbHelper.deleteContacts(jsonObj['id']));
//        }
//      }
      //   更新 user
      for (var j = 0; j < dataObj['user'].length; j++) {
        var jsonObj = dataObj['user'][j];
        var userInsert = UserSql(
          id: jsonObj['id'],
          username: jsonObj['username'],
          firstName: jsonObj['firstName'],
          lastName: jsonObj['lastName'],
          avatar: jsonObj['avatar'],
          colorId: jsonObj['colorId'],
          lastSeen: jsonObj['lastSeen'],
          isOnline: jsonObj['isOnline'],
          infoTimestamp: jsonObj['infoTimestamp'],
          bio: jsonObj['bio'],
        );
        futuresLocalUpdate.add(dbHelper.userUpdateOrInsertProperty(
          [
            'username',
            'firstName',
            'lastName',
            'avatar',
            'colorId',
            'infoTimestamp',
            'bio',
          ],
          ['id'],
          [
            jsonObj['username'],
            jsonObj['firstName'],
            jsonObj['lastName'],
            jsonObj['avatar'],
            jsonObj['colorId'],
            jsonObj['infoTimestamp'],
            jsonObj['bio'],
          ],
          [jsonObj['id']],
        ));
        if (jsonObj['avatar'] != 0) {
          changeFile() async {
            FileSql fileInfo = await dbHelper.fileOne(userInsert.avatar);
            FileSql insertFile;
            var res;
            if (fileInfo != null) {
              insertFile = FileSql(
                id: jsonObj['avatar'],
                name: jsonObj['avatarName'],
                fileName: jsonObj['avatarName'],
                fileOriginUrl: jsonObj['avatarUrl'],
                fileOriginLocal: fileInfo.fileOriginLocal,
                fileCompressUrl: jsonObj['avatarUrlCompress'],
                fileCompressLocal: fileInfo.fileCompressLocal,
                fileSize: fileInfo.fileSize,
                fileTime: fileInfo.fileTime,
              );

              res = await dbHelper.fileUpdate(insertFile);
              futuresLocalFile.add(Git().saveImageFileCompress(
                insertFile.id,
                insertFile.fileName,
                insertFile.fileCompressUrl,
              ));
            } else {
              insertFile = FileSql(
                id: jsonObj['avatar'],
                name: jsonObj['avatarName'],
                fileName: jsonObj['avatarName'],
                fileOriginUrl: jsonObj['avatarUrl'],
                fileOriginLocal: '',
                fileCompressUrl: jsonObj['avatarUrlCompress'],
                fileCompressLocal: '',
                fileSize: 0,
              );
              res = await dbHelper.fileAdd(insertFile);
              futuresLocalFile.add(Git().saveImageFileCompress(
                insertFile.id,
                insertFile.fileName,
                insertFile.fileCompressUrl,
              ));
            }
            return res;
          }

          futuresLocalUpdate.add(changeFile());
        }
      }
      await Future.wait(futuresLocalUpdate);
      await Future.wait(futuresLocalFile);
      await socketProviderChatListModel.getChatList();
      socketProviderContactListModel.getContactList();
//      if (socketProviderChatListModel != null) {
//        await socketProviderChatListModel.getChatList();
//      }
//      if (socketProviderContactListModel != null) {
//        socketProviderContactListModel.getContactList();
//      }
    });
  }

  static serverAddContacts() async {
    socketInit.on('serverAddContacts', (data) async {
      print('------------------serverAddContacts data: $data');

      final dbHelper = DatabaseHelper.instance;
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        var futuresLocalUpdate = <Future>[];
        var futuresLocalFile = <Future>[];
        if (dataObj['contactInfo'] != null) {
          var jsonObj = dataObj['contactInfo'];
          var contactInsert = ContactSql(
            id: jsonObj['id'],
            contactId: jsonObj['contactId'],
            userId: jsonObj['userId'],
            firstName: jsonObj['firstName'],
            lastName: jsonObj['lastName'],
            infoTimestamp: jsonObj['infoTimestamp'],
          );
          futuresLocalUpdate.add(dbHelper.contactUpdateOrInsert(contactInsert));
//          如果是从个人详情页面 添加的联系人，就更新对话信息
          var conversationInfo = chatInfoModelSocket.conversationInfo;
          if (conversationInfo['contactId'] == jsonObj['contactId']) {
            chatInfoModelSocket.updateInfoProperty(
                'contactSqlId', jsonObj['id']);
            chatInfoModelSocket.updateInfoProperty(
                'firstName', jsonObj['firstName']);
            chatInfoModelSocket.updateInfoProperty(
                'lastName', jsonObj['lastName']);

            var groupName = jsonObj['firstName'];
            if (jsonObj['lastName'] != null) {
              groupName += jsonObj['lastName'];
            }
            chatInfoModelSocket.updateInfoProperty('groupName', '$groupName');
          }
        }
        //   更新 user
        if (dataObj['userInfo'] != null) {
          var jsonObj = dataObj['userInfo'];
          var userInsert = UserSql(
            id: jsonObj['id'],
            username: jsonObj['username'],
            firstName: jsonObj['firstName'],
            lastName: jsonObj['lastName'],
            avatar: jsonObj['avatar'],
            colorId: jsonObj['colorId'],
            lastSeen: jsonObj['lastSeen'],
            isOnline: jsonObj['isOnline'],
            infoTimestamp: jsonObj['infoTimestamp'],
            bio: jsonObj['bio'],
          );
          futuresLocalUpdate.add(dbHelper.userUpdateOrInsert(userInsert));
          if (userInsert.avatar != 0) {
            changeFile() async {
              FileSql fileInfo = await dbHelper.fileOne(userInsert.avatar);
              FileSql insertFile;
              var res;
              if (fileInfo != null) {
                insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['avatarUrl'],
                  fileOriginLocal: fileInfo.fileOriginLocal,
                  fileCompressUrl: jsonObj['avatarUrlCompress'],
                  fileCompressLocal: fileInfo.fileCompressLocal,
                  fileSize: fileInfo.fileSize,
                  fileTime: fileInfo.fileTime,
                );

                res = await dbHelper.fileUpdate(insertFile);
                futuresLocalFile.add(Git().saveImageFileCompress(
                  insertFile.id,
                  insertFile.fileName,
                  insertFile.fileCompressUrl,
                ));
              } else {
                insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['avatarUrl'],
                  fileOriginLocal: '',
                  fileCompressUrl: jsonObj['avatarUrlCompress'],
                  fileCompressLocal: '',
                  fileSize: 0,
                );
                res = await dbHelper.fileAdd(insertFile);
                futuresLocalFile.add(Git().saveImageFileCompress(
                  insertFile.id,
                  insertFile.fileName,
                  insertFile.fileCompressUrl,
                ));
              }
              return res;
            }

            futuresLocalUpdate.add(changeFile());
          }
        }

        await Future.wait(futuresLocalUpdate);
        Future.wait(futuresLocalFile);
        socketProviderContactListModel.getContactList();

        if (isOnAddContactPage) {
          Navigator.of(addContactContext).pop();
          Navigator.of(addContactContext).pop();
        } else if (isOnEditContactPage) {
          socketProviderChatListModel.getChatList();
          Navigator.of(editContactContext).pop();
          Navigator.of(editContactContext).pop();
        }
      } else {
        if (isOnAddContactPage) {
          Navigator.of(addContactContext).pop();
          showToast(dataObj['respMsg']);
        } else if (isOnEditContactPage) {
          Navigator.of(editContactContext).pop();
          showToast(dataObj['respMsg']);
        }
      }
    });
  }

  static serverDeleteContacts() async {
    socketInit.on('serverDeleteContacts', (data) async {
      print('------------------serverDeleteContacts data: $data');

      final dbHelper = DatabaseHelper.instance;
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        var contactSqlId = dataObj['contactSqlId'];
        await dbHelper.deleteContacts(contactSqlId);
        await socketProviderContactListModel.getContactList();
        if (socketProviderConversationListModelGroupId != null) {
          var conversationInfo = chatInfoModelSocket.conversationInfo;
          chatInfoModelSocket.updateInfoProperty('contactSqlId', null);
          UserSql userInfo =
              await dbHelper.userOne(conversationInfo['contactId']);
          chatInfoModelSocket.updateInfoProperty(
              'firstName', userInfo.firstName);
          chatInfoModelSocket.updateInfoProperty('lastName', userInfo.lastName);
          var groupName = userInfo.firstName;
          if (userInfo.lastName != null) {
            groupName += ' ${userInfo.lastName}';
          }
          chatInfoModelSocket.updateInfoProperty('groupName', groupName);
          if (conversationInfo['groupId'] != 0) {
            await socketProviderChatListModel.getChatList();
          }
        }

        Navigator.of(showGroupInfoContext).pop();
        Navigator.of(showGroupInfoContext).pop();
      } else {
        if (isOnShowGroupInfoPage) {
          Navigator.of(showGroupInfoContext).pop();
          showToast(dataObj['respMsg']);
        }
      }
    });
  }

  static serverEditContacts() async {
    socketInit.on('serverEditContacts', (data) async {
      logger.d('------------------serverEditContacts data: $data');

      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.contactUpdateProperty(
          ['firstName', 'lastName', 'infoTimestamp'],
          ['id'],
          [dataObj['firstName'], dataObj['lastName'], dataObj['infoTimestamp']],
          [dataObj['contactSqlId']],
        );
//        更新个人页面详情信息
        var conversationInfo = chatInfoModelSocket.conversationInfo;
//        await socketProviderConversationListModel.getConversationInfo();
        if (conversationInfo['contactSqlId'] == dataObj['contactSqlId']) {
          chatInfoModelSocket.updateInfoProperty(
              'firstName', dataObj['firstName']);
          chatInfoModelSocket.updateInfoProperty(
              'lastName', dataObj['lastName']);
          var lastName = '';
          if (dataObj['lastName'] != null) {
            lastName = dataObj['lastName'];
          }
          chatInfoModelSocket.updateInfoProperty(
              'groupName', '${dataObj['firstName']} ${lastName}');
        }
//        更新联系人列表
        await socketProviderContactListModel.getContactList();
//        更新 聊天列表
        await socketProviderChatListModel.getChatList();
        Navigator.of(editContactContext).pop();
        Navigator.of(editContactContext).pop();
      }
    });
  }

  static contactStatusGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('contactStatusGet', (data) async {
      // logger.d('------------------contactStatusGet data: ');

      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        var futuresLocalUpdate = <Future>[];
        for (var j = 0; j < dataObj['status'].length; j++) {
          var jsonObj = dataObj['status'][j];
          futuresLocalUpdate.add(dbHelper.userUpdateOrInsertProperty(
            [
              'lastSeen',
              'isOnline',
            ],
            ['id'],
            [
              jsonObj['lastSeen'],
              jsonObj['isOnline'] ? 1 : 0,
            ],
            [jsonObj['id']],
          ));
        }
        await Future.wait(futuresLocalUpdate);
//        更新联系人列表
        await socketProviderContactListModel.getContactList();
//        更新 聊天列表
        await socketProviderChatListModel.getChatList();
      }
    });
  }

  /// chat
  //    后端 新建群组
  static serverCreateGroup() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverCreateGroup', (data) async {
      print('-----------------------serverCreateGroup: $data');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        var info = chatInfoModelSocket;
        if (dataObj['groupType'] == 1) {
          var groupRoomInsert = GroupRoomSql(
            id: dataObj['groupId'],
            groupType: dataObj['groupType'],
            groupName: dataObj['groupName'],
            createdUserId: dataObj['createdUserId'],
            createdDate: dataObj['createdDate'],
            avatar: dataObj['avatar'],
            colorId: dataObj['colorId'],
            description: '',
//            随机数
            infoTimestamp: 1,
//                首页会话列表没有拉取user信息，服务器默认为0，所以app默认为1
//              便于在点开某个群会话时，获取群成员
            userTimestamp: 1,
          );
          await dbHelper.groupRoomUpdateOrInsert(groupRoomInsert);
          SocketIoEmit.messageDialogsGet();

          if (isOnAddGroupPage &&
              Global.profile.user.userId == dataObj['operatorUser']) {
//            isUpdatingConversation = true;
            socketProviderConversationListModelGroupId = dataObj['groupId'];
//          关闭之前聊天记录
            socketProviderConversationListModel.resetChatHistory();
            if (dataObj['groupId'] != 0) {
              SocketIoEmit.clientGetGroupMessage(
                groupId: dataObj['groupId'],
              );
            }
            var firstName;
            var lastName;
            String str = dataObj['groupName'];
            var pieces = str.split(' ');
            if (pieces.length > 0) {
              firstName = pieces[0];
            }
            if (pieces.length > 1) {
              lastName = pieces[pieces.length - 1];
            }
            info.updateInfo({
              'groupId': dataObj['groupId'],
              'groupType': dataObj['groupType'],
              'contactSqlId': 0,
              'contactId': 0,
              'groupName': dataObj['groupName'],
              'username': '',
              'firstName': firstName,
              'lastName': lastName,
              'avatar': dataObj['avatar'],
              'fileCompressUrl': '',
              'fileCompressLocal': '',
              'fileOriginUrl': '',
              'fileOriginLocal': '',
              'isOnline': false,
              'newChatNumber': 0,
              'content': '',
              'createdDate': dataObj['createdDate'],
              'colorId': dataObj['colorId'],
              'groupMembers': 1,
              'onlineMember': 0,
              'lastSeen': '',
              'description': '',
              'bio': '',
            });
            logger.d('群id ${dataObj['groupId']}');
            Navigator.of(addGroupContext).pushNamed("conversation");
//            await socketProviderChatListModel.getChatList();
            if (dataObj['groupType'] == 1) {
              SocketIoEmit.clientGetOneGroup(
                groupId: dataObj['groupId'],
                groupType: dataObj['groupType'],
                contactId: dataObj['contactId'],
                infoTimestamp: 131,
                userTimestamp: 123,
              );
            }
          }
        } else {
          /// 把单人聊天未发送的消息 修改 groupId

          if (info.conversationInfo['contactId'] == dataObj['contactId']) {
            socketProviderConversationListModelGroupId = dataObj['groupId'];
          }
          var groupRoomInsert = GroupRoomSql(
            id: dataObj['groupId'],
            groupType: dataObj['groupType'],
            groupName: '',
            createdUserId: dataObj['createdUserId'],
            createdDate: dataObj['createdDate'],
            avatar: 0,
            colorId: 0,
            description: '',
//            随机数
            infoTimestamp: 1,
//                首页会话列表没有拉取user信息，服务器默认为0，所以app默认为1
//              便于在点开某个群会话时，获取群成员
            userTimestamp: 1,
          );
          await dbHelper.groupRoomUpdateOrInsert(groupRoomInsert);
//            查groupId =0 的 groupUser 表
          String gUserCon = '''
          userId = ${dataObj['createdUserId']}
          AND contactId = ${dataObj['contactId']}
          ''';
          var hasGroupUser = await dbHelper.groupUserQueryByString(gUserCon);
          if (hasGroupUser != null) {
            await dbHelper.groupUserUpdateProperty(
                ['groupId'],
                ['userId', 'contactId'],
                [dataObj['groupId']],
                [dataObj['createdUserId'], dataObj['contactId']]);
          }

//            查 id = 0 的消息
          String condition = '''
            contactId=${dataObj['contactId']}
            AND id=0
            AND senderId=${dataObj['createdUserId']}
            ''';
          var msgList = await dbHelper.groupMessageQueryByStr(condition);
          logger.d(msgList);
          if (msgList != null) {
            await dbHelper.groupMessageUpdateProperty(
                ['groupId'],
                ['senderId', 'contactId'],
                [dataObj['groupId']],
                [dataObj['createdUserId'], dataObj['contactId']]);
            await dbHelper.groupUserMerge([
              'groupId',
            ], [
              'userId',
              'contactId'
            ], [
              dataObj['groupId']
            ], [
              dataObj['createdUserId'],
              dataObj['contactId']
            ]);
            for (var i = 0; i < msgList.length; i++) {
              SocketIoEmit.clientSendGroupMessage(
                groupId: dataObj['groupId'],
                contactId: dataObj['contactId'],
                timestamp: msgList[i]['timestamp'],
                createdDate: msgList[i]['createdDate'],
                contentType: msgList[i]['contentType'],
                content: msgList[i]['content'],
                contentName: msgList[i]['contentName'],
                replyId: msgList[i]['replyId'],
              );
            }
          }
          SocketIoEmit.clientGetOneGroup(
              groupId: dataObj['groupId'],
              groupType: 2,
              contactId: dataObj['contactId'],
              infoTimestamp: 2,
              userTimestamp: 2);
          socketProviderChatListModel.getChatList();
          SocketIoEmit.messageDialogsGet();
        }
      }
    });
  }

//      修改群组
  static serverEditGroup() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverEditGroup', (data) async {
      print('-----------------------serverEditGroup: $data');
      if (isOnAddGroupPage) {
        final parsed = json.decode(data);
        var dataObj = Map<String, dynamic>.from(parsed);
        if (socketProviderChatListModel != null) {
          if (dataObj['success'] == 1) {
            var jsonObj = dataObj;
            var index = await dbHelper.getChat(jsonObj['groupId']);
            String groupAvatarLocal = '';
            if (index != null && jsonObj["groupAvatar"] != '') {
              groupAvatarLocal = index.groupAvatarLocal;
            }
            var contactId = 0;
            if (jsonObj['groupType'] == 2) {
              if (jsonObj['groupUserList'][0] == Global.profile.user.userId) {
                contactId = jsonObj['groupUserList'][1];
              } else {
                contactId = jsonObj['groupUserList'][0];
              }
            }
            var objInsert = ChatListSql(
              groupId: dataObj["groupId"],
              groupUserLength: dataObj["groupUserList"].length,

//                groupAvatar: dataObj["groupAvatar"],
//                groupAvatarLocal: groupAvatarLocal,
//                avatarName: dataObj["avatarName"],
//                groupName: dataObj["groupName"],
//                username: dataObj["username"],
            );
//              if (index.groupAvatar != objInsert.groupAvatar &&
//                      objInsert.groupAvatar != '' ||
//                  (groupAvatarLocal == '' && objInsert.groupAvatar != '')) {
//                Git().saveChatListAvatar(objInsert);
//              }
            int groupId = objInsert.groupId;
//              String condition =
//                  'groupAvatar = ?, groupAvatarLocal = ?, avatarName = ?, groupName = ?, username = ?, groupUserLength = ? WHERE groupId = ?';
            String condition = 'groupUserLength = ? WHERE groupId = ?';
            List valueArr = [
              objInsert.groupUserLength,
              groupId,
//                objInsert.groupAvatar,
//                objInsert.groupAvatarLocal,
//                objInsert.avatarName,
//                objInsert.groupName,
//                objInsert.username,
            ];
            await dbHelper.chatListUpdateMultiple(condition, valueArr, groupId);
            await socketProviderChatListModel.getChatList();
          }
        }
      }
    });
  }

  static serverEditGroupSimple() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverEditGroupSimple', (data) async {
      logger.d('-------------serverEditGroupSimple: $data');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        await dbHelper.groupRoomUpdateProperty(
          ['groupName', 'avatar', 'description', 'infoTimestamp'],
          ['id'],
          [
            dataObj['groupName'],
            dataObj['avatar'],
            dataObj['description'],
            dataObj['infoTimestamp']
          ],
          [dataObj['groupId']],
        );
        //        更新群详情信息
        var conversationInfo = chatInfoModelSocket.conversationInfo;
//        await socketProviderConversationListModel.getConversationInfo();
        if (conversationInfo['groupId'] == dataObj['groupId']) {
          String str = dataObj['groupName'];
          var firstName;
          var lastName;
          var pieces = str.split(' ');
          if (pieces.length > 0) {
            firstName = pieces[0];
          }
          if (pieces.length > 1) {
            lastName = pieces[pieces.length - 1];
          }
          chatInfoModelSocket.updateInfoProperty('firstName', firstName);
          chatInfoModelSocket.updateInfoProperty('lastName', lastName);
          chatInfoModelSocket.updateInfoProperty(
              'groupName', '${dataObj['groupName']}');
          chatInfoModelSocket.updateInfoProperty(
              'description', '${dataObj['description']}');

          if (dataObj['avatar'] != 0) {
            FileSql fileInfo = await dbHelper.fileOne(dataObj['avatar']);
            FileSql insertFile;
            if (fileInfo != null) {
              insertFile = FileSql(
                id: fileInfo.id,
                name: fileInfo.name,
                fileName: fileInfo.fileName,
                fileOriginUrl: dataObj['groupAvatarUrl'],
                fileOriginLocal: fileInfo.fileOriginLocal,
                fileCompressUrl: dataObj['groupAvatarCompress'],
                fileCompressLocal: fileInfo.fileCompressLocal,
                fileSize: fileInfo.fileSize,
                fileTime: fileInfo.fileTime,
              );
              await dbHelper.fileUpdate(insertFile);
              await Git().saveImageFileCompress(
                insertFile.id,
                insertFile.fileName,
                insertFile.fileCompressUrl,
              );
            } else {
              insertFile = FileSql(
                id: dataObj['avatar'],
                name: dataObj['avatarName'],
                fileName: dataObj['avatarName'],
                fileOriginUrl: dataObj['groupAvatarUrl'],
                fileOriginLocal: '',
                fileCompressUrl: dataObj['groupAvatarCompress'],
                fileCompressLocal: '',
                fileSize: 0,
              );
              await dbHelper.fileAdd(insertFile);
              await Git().saveImageFileCompress(
                insertFile.id,
                insertFile.fileName,
                insertFile.fileCompressUrl,
              );
            }
            if (chatInfoModelSocket.conversationInfo['avatar'] !=
                dataObj['avatar']) {
              chatInfoModelSocket.updateInfoProperty('fileOriginUrl', '');
              chatInfoModelSocket.updateInfoProperty('fileOriginLocal', '');
            }
            chatInfoModelSocket.updateInfoProperty('avatar', dataObj['avatar']);
            chatInfoModelSocket.updateInfoProperty(
                'fileCompressUrl', dataObj['groupAvatarCompress']);
            FileSql fileInfo2 = await dbHelper.fileOne(dataObj['avatar']);
            chatInfoModelSocket.updateInfoProperty(
                'fileCompressLocal', fileInfo2.fileCompressLocal);
          } else {
            chatInfoModelSocket.updateInfoProperty('fileCompressUrl', '');
            chatInfoModelSocket.updateInfoProperty('fileCompressLocal', '');
            chatInfoModelSocket.updateInfoProperty('fileOriginUrl', '');
            chatInfoModelSocket.updateInfoProperty('fileOriginLocal', '');
          }
        }
//        更新 聊天列表
        await socketProviderChatListModel.getChatList();
        Navigator.of(editGroupInfoContext).pop();
        Navigator.of(editGroupInfoContext).pop();
      }
    });
  }

//      获取群资料
  static serverGetOneGroup() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverGetOneGroup', (data) async {
      print('-----------------------serverGetOneGroup: ');
//      logger.d(data);
      if (socketProviderConversationListModel != null) {
        final parsed = json.decode(data);
        var dataObj = Map<dynamic, dynamic>.from(parsed);
//        logger.d(dataObj);
        if (chatInfoModelSocket.conversationInfo != null &&
            dataObj['groupId'] ==
                chatInfoModelSocket.conversationInfo['groupId']) {
//            socketProviderConversationListModel
//                .updateInfo(dataObj['groupInfo']);
          chatInfoModelSocket.updateInfoProperty(
              'groupMembers', dataObj['groupUserLength']);
          chatInfoModelSocket.updateInfoProperty(
              'onlineMember', dataObj['onlineMember']);
          compareData() async {
            GroupRoomSql groupRoomInfo =
                await dbHelper.groupRoomOne(dataObj['groupId']);
//            if (groupRoomInfo != null) {
//              更新本地内容的
            var futuresLocalFile = <Future>[];
            var futuresLocalUpdate = <Future>[];
            if (dataObj['infoTimestamp'] != groupRoomInfo.infoTimestamp) {
              var jsonObj = dataObj['groupInfo'];
              var groupRoomInsert = GroupRoomSql(
                id: jsonObj['id'],
                groupType: jsonObj['groupType'],
                groupName: jsonObj['groupName'],
                createdUserId: jsonObj['createdUserId'],
                createdDate: jsonObj['createdDate'],
                avatar: jsonObj['avatar'],
                colorId: jsonObj['colorId'],
                description: jsonObj['description'],
                infoTimestamp: jsonObj['infoTimestamp'],
                userTimestamp: jsonObj['userTimestamp'],
              );
              await dbHelper.groupRoomUpdateOrInsert(groupRoomInsert);
              chatInfoModelSocket.updateInfoProperty(
                  'avatar', jsonObj['avatar']);
              if (jsonObj['avatar'] != 0) {
                FileSql insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['avatarOriginUrl'],
                  fileOriginLocal: '',
                  fileCompressUrl: jsonObj['fileCompressUrl'],
                  fileCompressLocal: '',
                  fileSize: 0,
                );
                await dbHelper.fileUpdateOrInsert(insertFile);
                chatInfoModelSocket.updateInfoProperty(
                    'fileCompressUrl', jsonObj['fileCompressUrl']);
                var fileInfo = await Git().saveImageFileCompress(
                    jsonObj['avatar'],
                    jsonObj['avatarName'],
                    jsonObj['fileCompressUrl']);
                if (fileInfo['pathUrl'] != null) {
                  chatInfoModelSocket.updateInfoProperty(
                      'fileCompressLocal', fileInfo['pathUrl']);
                }
              } else {
                chatInfoModelSocket.updateInfoProperty('fileCompressUrl', '');
                chatInfoModelSocket.updateInfoProperty('fileCompressLocal', '');
              }
            } else {
//                更新两个字段
              await dbHelper.groupRoomUpdateProperty([
                'infoTimestamp',
                'userTimestamp',
              ], [
                'id'
              ], [
                dataObj['infoTimestamp'],
                dataObj['userTimestamp'],
              ], [
                dataObj['groupId']
              ]);
            }
            if (dataObj['userTimestamp'] != groupRoomInfo.userTimestamp) {
              List localGroupUser = await dbHelper.groupUserMultipleCondition(
                ['groupId'],
                [dataObj['groupId']],
              );
              List originGroupUserArr = [];
              // 本地 groupUser 更新
              for (var j = 0; j < dataObj['groupUser'].length; j++) {
                var jsonObj = dataObj['groupUser'][j];
                originGroupUserArr.add(jsonObj['id']);
                futuresLocalUpdate.add(dbHelper.groupUserMerge([
                  'contactId',
                  'userId',
                  'groupId',
                  'lastReadMsgId',
                  'deleteChat',
                  'lastDeleteMsgId',
                  'leaveMessageId',
                  'leaveGroupName',
                  'inviteUserId',
                  'infoTimestamp',
                ], [
                  'id'
                ], [
                  0,
                  jsonObj['userId'],
                  jsonObj['groupId'],
                  jsonObj['lastReadMsgId'],
                  jsonObj['deleteChat'],
                  jsonObj['lastDeleteMsgId'],
                  jsonObj['leaveMessageId'],
                  jsonObj['leaveGroupName'],
                  jsonObj['inviteUserId'],
                  jsonObj['infoTimestamp'],
                ], [
                  jsonObj['id']
                ]));
              }
//删除已经不在的群成员
              if (localGroupUser != null) {
                for (var m = 0; m < localGroupUser.length; m++) {
                  if (!originGroupUserArr.contains(localGroupUser[m]['id'])) {
                    int groupUserId;
                    groupUserId = localGroupUser[m]['id'];
                    int userId = localGroupUser[m]['userId'];
//                    如果服务器没有返回自己，是因为节省流量，没有返回
                    if (userId != Global.profile.user.userId) {
                      logger.d(userId);
                      futuresLocalUpdate
                          .add(dbHelper.groupUserDelete(groupUserId));
                    }
                  }
                }
              }
              //   更新 user
              for (var j = 0; j < dataObj['user'].length; j++) {
                var jsonObj = dataObj['user'][j];
                var userInsert = UserSql(
                  id: jsonObj['id'],
                  username: jsonObj['username'],
                  firstName: jsonObj['firstName'],
                  lastName: jsonObj['lastName'],
                  avatar: jsonObj['avatar'],
                  colorId: jsonObj['colorId'],
                  lastSeen: jsonObj['lastSeen'],
                  isOnline: jsonObj['isOnline'],
                  infoTimestamp: jsonObj['infoTimestamp'],
                  bio: jsonObj['bio'],
                );
                futuresLocalUpdate.add(dbHelper.userUpdateOrInsert(userInsert));
                if (userInsert.avatar != 0) {
                  changeFile() async {
                    FileSql fileInfo =
                        await dbHelper.fileOne(userInsert.avatar);
                    FileSql insertFile;
                    var res;
                    if (fileInfo != null) {
                      insertFile = FileSql(
                        id: jsonObj['avatar'],
                        name: jsonObj['avatarName'],
                        fileName: jsonObj['avatarName'],
                        fileOriginUrl: fileInfo.fileOriginUrl,
                        fileOriginLocal: fileInfo.fileOriginLocal,
                        fileCompressUrl: jsonObj['avatarUrlCompress'],
                        fileCompressLocal: fileInfo.fileCompressLocal,
                        fileSize: fileInfo.fileSize,
                        fileTime: fileInfo.fileTime,
                      );

                      res = await dbHelper.fileUpdate(insertFile);
                      futuresLocalFile.add(Git().saveImageFileCompress(
                        insertFile.id,
                        insertFile.fileName,
                        insertFile.fileCompressUrl,
                      ));
                    } else {
                      insertFile = FileSql(
                        id: jsonObj['avatar'],
                        name: jsonObj['avatarName'],
                        fileName: jsonObj['avatarName'],
                        fileOriginUrl: '',
                        fileOriginLocal: '',
                        fileCompressUrl: jsonObj['avatarUrlCompress'],
                        fileCompressLocal: '',
                        fileSize: 0,
                      );
                      res = await dbHelper.fileAdd(insertFile);
                      futuresLocalFile.add(Git().saveImageFileCompress(
                        insertFile.id,
                        insertFile.fileName,
                        insertFile.fileCompressUrl,
                      ));
                    }
                    return res;
                  }

                  futuresLocalUpdate.add(changeFile());
                }
              }
//                  logger.d('聊天对话框 更新完成');
            }

//              logger.d(dataObj['lastSeenUser']);
            for (var j = 0; j < dataObj['lastSeenUser'].length; j++) {
              var jsonObj = dataObj['lastSeenUser'][j];
              futuresLocalUpdate.add(dbHelper.userUpdateProperty(
                ['lastSeen', 'isOnline'],
                ['id'],
                [jsonObj['lastSeen'], jsonObj['isOnline'] ? 1 : 0],
                [jsonObj['id']],
              ));
            }
            await Future.wait(futuresLocalUpdate);
            await socketGroupMemberModel.getGroupMember(dataObj['groupId']);
            socketGroupMemberModel.getGroupOnline();
            await Future.wait(futuresLocalFile);
//            }
          }

          compareData();
          isUpdatingConversation = false;
        }
      }
    });
  }

// 添加群成员
  static serverAddGroupMember() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverAddGroupMember', (data) async {
      print('-----------------------serverAddGroupMember: ');
      if (socketProviderConversationListModel != null) {
        final parsed = json.decode(data);
        var dataObj = Map<String, dynamic>.from(parsed);
        if (dataObj['groupId'] == socketProviderConversationListModelGroupId) {
//              更新本地内容的
          var futuresLocalFile = <Future>[];
          var futuresLocalUpdate = <Future>[];
//                更新字段
          futuresLocalUpdate.add(dbHelper.groupRoomUpdateProperty([
            'userTimestamp',
          ], [
            'id'
          ], [
            dataObj['userTimestamp'],
          ], [
            dataObj['groupId']
          ]));
          // 本地 groupUser 更新
          for (var j = 0; j < dataObj['groupUser'].length; j++) {
            var jsonObj = dataObj['groupUser'][j];
            var groupUserInsert = GroupUserSql(
              id: jsonObj['id'],
              groupId: jsonObj['groupId'],
              userId: jsonObj['userId'],
              lastReadMsgId: jsonObj['lastReadMsgId'],
              deleteChat: jsonObj['deleteChat'],
              lastDeleteMsgId: jsonObj['lastDeleteMsgId'],
              leaveMessageId: jsonObj['leaveMessageId'],
              leaveGroupName: jsonObj['leaveGroupName'],
              inviteUserId: jsonObj['inviteUserId'],
              infoTimestamp: jsonObj['infoTimestamp'],
              contactId: 0,
            );
            futuresLocalUpdate
                .add(dbHelper.groupUserUpdateOrInsert(groupUserInsert));
          }

          //   更新 user
          for (var j = 0; j < dataObj['users'].length; j++) {
            var jsonObj = dataObj['users'][j];
            var userInsert = UserSql(
              id: jsonObj['id'],
              username: jsonObj['username'],
              firstName: jsonObj['firstName'],
              lastName: jsonObj['lastName'],
              avatar: jsonObj['avatar'],
              colorId: jsonObj['colorId'],
              lastSeen: jsonObj['lastSeen'],
              isOnline: jsonObj['isOnline'],
              infoTimestamp: jsonObj['infoTimestamp'],
              bio: jsonObj['bio'],
            );
            futuresLocalUpdate.add(dbHelper.userUpdateOrInsert(userInsert));
            if (userInsert.avatar != 0) {
              changeFile() async {
                FileSql fileInfo = await dbHelper.fileOne(userInsert.avatar);
                FileSql insertFile;
                var res;
                if (fileInfo != null) {
                  insertFile = FileSql(
                    id: jsonObj['avatar'],
                    name: jsonObj['avatarName'],
                    fileName: jsonObj['avatarName'],
                    fileOriginUrl: jsonObj['avatarUrl'],
                    fileOriginLocal: fileInfo.fileOriginLocal,
                    fileCompressUrl: jsonObj['avatarUrlCompress'],
                    fileCompressLocal: fileInfo.fileCompressLocal,
                    fileSize: fileInfo.fileSize,
                    fileTime: fileInfo.fileTime,
                  );

                  res = await dbHelper.fileUpdate(insertFile);
                  futuresLocalFile.add(Git().saveImageFileCompress(
                    insertFile.id,
                    insertFile.fileName,
                    insertFile.fileCompressUrl,
                  ));
                } else {
                  insertFile = FileSql(
                    id: jsonObj['avatar'],
                    name: jsonObj['avatarName'],
                    fileName: jsonObj['avatarName'],
                    fileOriginUrl: jsonObj['avatarUrl'],
                    fileOriginLocal: '',
                    fileCompressUrl: jsonObj['avatarUrlCompress'],
                    fileCompressLocal: '',
                    fileSize: 0,
                  );
                  res = await dbHelper.fileAdd(insertFile);
                  futuresLocalFile.add(Git().saveImageFileCompress(
                    insertFile.id,
                    insertFile.fileName,
                    insertFile.fileCompressUrl,
                  ));
                }
                return res;
              }

              futuresLocalUpdate.add(changeFile());
            }
          }
          await Future.wait(futuresLocalUpdate);
//          更新群成员
          await socketGroupMemberModel.getGroupMember(dataObj['groupId']);
//          更新在线人数
          socketGroupMemberModel.getGroupOnline();
//          socketProviderConversationListModel.updateInfoProperty(
//              'onlineMember', dataObj['onlineMember']);
//          更新群成员人数
          chatInfoModelSocket.updateInfoProperty(
              'groupMembers', socketGroupMemberModel.groupMember.length);
          await Future.wait(futuresLocalFile);
          if (addMemberContext != null) {
            Navigator.of(addMemberContext).pop();
            Navigator.of(addMemberContext).pop();
          }
          socketProviderChatListModel.getChatList();
        }
      }
    });
  }

// 删除群成员
  static serverDeleteGroupMember() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverDeleteGroupMember', (data) async {
      logger.d('-----------------------serverDeleteGroupMember: ');
      final parsed = json.decode(data);
      logger.d('$parsed');
      var dataObj = Map<String, dynamic>.from(parsed);
//              更新本地内容的
      var futuresLocalFile = <Future>[];
      var futuresLocalUpdate = <Future>[];

//      var myId = Global.profile.user.userId;
//      futuresLocalUpdate.add(dbHelper.groupMessageDeleteMultiple(
//          ['groupId','senderId', 'contactId'],
//          [dataObj['groupId'], myId, dataObj['contactId']]));
//      futuresLocalUpdate.add(dbHelper.groupUserDeleteCondition(
//          'userId=? AND contactId=?',
//          [myId, dataObj['contactId']]));
//                更新字段
      futuresLocalUpdate.add(dbHelper.groupRoomUpdateProperty([
        'userTimestamp',
      ], [
        'id'
      ], [
        dataObj['userTimestamp'],
      ], [
        dataObj['groupId']
      ]));
      if (Global.profile.user.userId == dataObj['memberId']) {
        futuresLocalUpdate.add(dbHelper
            .groupMessageDeleteMultiple(['groupId'], [dataObj['groupId']]));
      }
      // 本地 groupUser 更新
      if (dataObj['deleteOther'] == true) {
        futuresLocalUpdate.add(dbHelper.groupUserUpdateProperty([
          'infoTimestamp',
          'deleteChat'
        ], [
          'groupId'
        ], [
          dataObj['userTimestamp'],
          dataObj['deleteChat'],
        ], [
          dataObj['groupId']
        ]));
        futuresLocalUpdate.add(dbHelper
            .groupMessageDeleteMultiple(['groupId'], [dataObj['groupId']]));
      } else {
        futuresLocalUpdate.add(dbHelper.groupUserUpdateProperty([
          'infoTimestamp',
          'deleteChat'
        ], [
          'id'
        ], [
          dataObj['userTimestamp'],
          dataObj['deleteChat'],
        ], [
          dataObj['groupUserId']
        ]));
      }
      await Future.wait(futuresLocalUpdate);
      if (chatInfoModelSocket.conversationInfo != null &&
          dataObj['groupId'] ==
              chatInfoModelSocket.conversationInfo['groupId']) {
//          获取群成员
        await socketGroupMemberModel.getGroupMember(dataObj['groupId']);
//          更新在线人数
        socketGroupMemberModel.getGroupOnline();
        int groupMemberLen = socketGroupMemberModel.groupMember.length;
//      更新chat list 会话表
        await dbHelper.chatListUpdateProperty(['groupUserLength'], ['groupId'],
            [groupMemberLen], [dataObj['groupId']]);
//          更新群成员人数
        chatInfoModelSocket.updateInfoProperty('groupMembers', groupMemberLen);
      }
      socketProviderChatListModel.getChatList();
      if (Global.profile.user.userId == dataObj['memberId']) {
        if (chatInfoModelSocket.conversationInfo != null &&
            dataObj['groupId'] == socketProviderConversationListModelGroupId) {
          Navigator.of(showGroupInfoContext).popUntil((route) => route.isFirst);
          Navigator.of(showGroupInfoContext).pushReplacementNamed("main");
        } else if (isOnChatsPage) {
          Navigator.of(chatsPageContext).pop();
          Navigator.of(chatsPageContext).pop();
        } else {
          Navigator.of(mainScreePage).pop();
          Navigator.of(mainScreePage).pop();
        }
      }
    });
  }

// 获取chat 基本信息
  static messageChatGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('messageChatGet', (data) async {
      logger.d('-----------------------messageChatGet: ');
      final parsed = json.decode(data);
//      logger.d('$parsed');
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
//              更新本地内容的
        var futuresLocalUpdate = <Future>[];
        var futuresLocalFile = <Future>[];

//          更新 groupRoom
        for (var j = 0; j < dataObj['chat'].length; j++) {
          var jsonObj = dataObj['chat'][j];
          compareGroupInfo() async {
            GroupRoomSql index = await dbHelper.groupRoomOne(jsonObj['id']);
            if (index != null) {
              var groupRoomInsert = GroupRoomSql(
                id: jsonObj['id'],
                groupType: jsonObj['groupType'],
                groupName: jsonObj['groupName'],
                createdUserId: jsonObj['createdUserId'],
                createdDate: jsonObj['createdDate'],
                avatar: jsonObj['avatar'],
                colorId: jsonObj['colorId'],
                description: jsonObj['description'],
                infoTimestamp: jsonObj['infoTimestamp'],
//                首页会话列表没有拉取user信息，所以保持原来的值
                userTimestamp: index.userTimestamp,
              );
              await dbHelper.groupRoomUpdate(groupRoomInsert);
            } else {
              var groupRoomInsert = GroupRoomSql(
                id: jsonObj['id'],
                groupType: jsonObj['groupType'],
                groupName: jsonObj['groupName'],
                createdUserId: jsonObj['createdUserId'],
                createdDate: jsonObj['createdDate'],
                avatar: jsonObj['avatar'],
                colorId: jsonObj['colorId'],
                description: jsonObj['description'],
                infoTimestamp: jsonObj['infoTimestamp'],
//                首页会话列表没有拉取user信息，服务器默认为0，所以app默认为1
//              便于在点开某个群会话时，获取群成员
                userTimestamp: 1,
              );
              await dbHelper.groupRoomAdd(groupRoomInsert);
            }
          }

          futuresLocalUpdate.add(compareGroupInfo());
          if (jsonObj['avatar'] != 0) {
            changeFile() async {
              FileSql fileInfo = await dbHelper.fileOne(jsonObj['avatar']);
              FileSql insertFile;
              var res;
              if (fileInfo != null) {
                insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['groupAvatarUrl'],
                  fileOriginLocal: fileInfo.fileOriginLocal,
                  fileCompressUrl: jsonObj['groupAvatarCompress'],
                  fileCompressLocal: fileInfo.fileCompressLocal,
                  fileSize: fileInfo.fileSize,
                  fileTime: fileInfo.fileTime,
                );
                res = await dbHelper.fileUpdate(insertFile);
                futuresLocalFile.add(Git().saveImageFileCompress(
                  insertFile.id,
                  insertFile.fileName,
                  insertFile.fileCompressUrl,
                ));
              } else {
                insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['groupAvatarUrl'],
                  fileOriginLocal: '',
                  fileCompressUrl: jsonObj['groupAvatarCompress'],
                  fileCompressLocal: '',
                  fileSize: 0,
                );
                res = await dbHelper.fileAdd(insertFile);
                futuresLocalFile.add(Git().saveImageFileCompress(
                  insertFile.id,
                  insertFile.fileName,
                  insertFile.fileCompressUrl,
                ));
              }
              return res;
            }

            futuresLocalUpdate.add(changeFile());
          }
        }
        await Future.wait(futuresLocalUpdate);
        await Future.wait(futuresLocalFile);
        await socketProviderChatListModel.getChatList();
      }
      isUpdatingGroup = false;
    });
  }

  /// message
  //    获取某一个聊天聊天所有记录
  static serverGetGroupMessage() async {
    socketInit.on('serverGetGroupMessage', (data) {
      print('-----------------------serverGetGroupMessage: ');
      if (socketProviderConversationListModel != null) {
        final parsed = json.decode(data);
        var dataObj = Map<dynamic, dynamic>.from(parsed);
        if (dataObj['type'] == 'serverGetGroupMessage' &&
            dataObj['groupId'] ==
                chatInfoModelSocket.conversationInfo['groupId']) {
          socketProviderConversationListModel
              .updateList(dataObj['groupMessageList'].reversed.toList());
        }
      }
    });
  }

// 未读数量
  static messageUnRead() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('messageUnRead', (data) async {
      print('-----------------------messageUnRead: ');
      final parsed = json.decode(data);
      var dataObj = Map<dynamic, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        var futuresLocalUpdate = <Future>[];
        for (var j = 0; j < dataObj['unRead'].length; j++) {
          var jsonObj = dataObj['unRead'][j];
          compareInfo() async {
            await dbHelper.groupUserMerge(
              ['unread'],
              ['groupId'],
              [jsonObj['unread']],
              [jsonObj['groupId']],
            );
          }

          futuresLocalUpdate.add(compareInfo());
        }
        await Future.wait(futuresLocalUpdate);
        await socketProviderChatListModel.getChatList();
      }
      isUpdatingGroup = false;
    });
  }

//接收别人发送消息
  static serverSendGroupMessage() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverSendGroupMessage', (data) async {
      print('-----------------------serverSendGroupMessage:');
      print('-----------------------currentPage: $currentPage');
      var myId = Global.profile.user.userId;
      final parsed = json.decode(data);
      var dataObj = Map<dynamic, dynamic>.from(parsed);
      print(
          '************************socketProviderConversationListModelGroupId: $socketProviderConversationListModelGroupId');
      print('************************groupId: ${dataObj['groupId']}');

      var jsonObj = dataObj['groupMessage'];

      var index = await dbHelper.getChat(jsonObj["groupId"]);
      var isOnline = false;
      var newChatNumber = 1;
      String groupAvatarLocal = "";
      print('dataObj senderid : ${dataObj["senderId"]}');
      print('myId : $myId');
      if (index != null) {
//         isOnline = index.isOnline;
// //          如果发送人是本人，就不用增加一条未读消息
//         if (dataObj['senderId'] == myId) {
//           newChatNumber = index.newChatNumber;
//         } else {
//           newChatNumber = index.newChatNumber + 1;
//         }
//         groupAvatarLocal = index.groupAvatarLocal;
//         print('--------------index.isOnline: ${index.isOnline}');
      } else {
        if (dataObj['senderId'] == myId) {
          newChatNumber = 0;
        }
      }

//          var contactId = 0;
//          if (jsonObj['groupType'] == 2) {
//            if (jsonObj['groupUserList'][0] == Global.profile.user.userId) {
//              contactId = jsonObj['groupUserList'][1];
//            } else {
//              contactId = jsonObj['groupUserList'][0];
//            }
//          }
      var objInsert = ChatListSql(
        groupId: jsonObj["groupId"],
        createdDate: jsonObj["createdDate"],
        newChatNumber: newChatNumber,
        groupUserLength: jsonObj['groupUserLength'],

//            contactId: jsonObj["contactId"],
//            content: jsonObj["content"],
//            isOnline: isOnline,
//            contentName: jsonObj["contentName"],
//            contentType: jsonObj["contentType"],
//            sendName: jsonObj["sendName"],
//            colorId: jsonObj["colorId"],
//            groupType: jsonObj["groupType"],
//            groupAvatar: jsonObj["groupAvatar"],
//            groupAvatarLocal: groupAvatarLocal,
//            avatarName: jsonObj["avatarName"],
//            groupName: jsonObj["groupName"],
//            username: jsonObj["username"],
      );
//            await dbHelper.chatListUpdateList(objInsert);
      if (index != null) {
//              print('index: not null');
        await dbHelper.chatListUpdate(objInsert);
      } else {
//              print('chatListInsert: start');
        var inNum = await dbHelper.chatListInsert(objInsert);

//            if (objInsert.groupAvatar != '') {
//              Git().saveChatListAvatar(objInsert);
//            }
//              print('chatListInsert: $inNum');
      }
      await socketProviderChatListModel.getChatList();

// 如果app 在打开【foreground】的情况下，发送消息是当前聊天界面的消息，则不显示
//       if (socketProviderConversationListModelGroupId != dataObj['groupId']) {
//         if (Platform.isAndroid) {
//           if (lifecycleState == AppLifecycleState.inactive) {
//             await NotificationHelper()
//                 .showNotification(dataObj['groupMessage']);
//           }
//         } else {
//           await NotificationHelper().showNotification(dataObj['groupMessage']);
//         }
//       }
      if (socketProviderConversationListModel != null) {
        if (dataObj['type'] == 'serverSendGroupMessage' &&
            dataObj['groupId'] == socketProviderConversationListModelGroupId) {
          socketProviderConversationListModel
              .insertFirst(dataObj['groupMessage']);
        }
      }
      print('socketProviderChatListModel: $socketProviderChatListModel');
//        if (socketProviderChatListModel != null) {
//          socketProviderChatListModel.updateItem(
//              dataObj['groupId'], dataObj['groupMessage'], true);
//        }
    });
  }

//      自己发送消息的返回结果
  static serverSendGroupMessageSelf() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverSendGroupMessageSelf', (data) async {
      print('-----------------------serverSendGroupMessageSelf:');
      print('-----------------------currentPage: $currentPage');
      final parsed = json.decode(data);
      var dataObj = Map<dynamic, dynamic>.from(parsed);
      if (dataObj['groupId'] == socketProviderConversationListModelGroupId) {
        socketProviderConversationListModel.updateListItemByTime(
            dataObj['groupId'],
            dataObj['groupMessage']['timestamp'],
            dataObj['groupMessage']);
      }
      String condition = '''
            groupId=${dataObj['groupId']}
            AND senderId=${dataObj['groupMessage']['senderId']}
            AND timestamp=${dataObj['groupMessage']['timestamp']}
            ''';
      var msgList = await dbHelper.groupMessageQueryByStr(condition);
      if (msgList != null) {
//        logger.d(msgList);
//更新发送成功状态
        await dbHelper.groupMessageUpdateProperty([
          'id',
          'createdDate'
        ], [
          'groupId',
          'senderId',
          'timestamp'
        ], [
          dataObj['groupMessage']['id'],
          dataObj['groupMessage']['createdDate']
        ], [
          dataObj['groupId'],
          dataObj['groupMessage']['senderId'],
          dataObj['groupMessage']['timestamp']
        ]);
      }
      String gUserCon = '''
          userId = ${Global.profile.user.userId}
          AND groupId = ${dataObj['groupId']}
          ''';
      var hasGroupUser = await dbHelper.groupUserQueryByString(gUserCon);
      if (hasGroupUser != null) {
        if (hasGroupUser[0]['timestamp'] ==
            dataObj['groupMessage']['timestamp']) {
          await dbHelper.groupUserUpdateProperty([
            'messageId',
            'latestMsgId',
            'latestMsgTime'
          ], [
            'userId',
            'groupId'
          ], [
            dataObj['groupMessage']['id'],
            dataObj['groupMessage']['id'],
            dataObj['groupMessage']['createdDate']
          ], [
            Global.profile.user.userId,
            dataObj['groupId']
          ]);
        }
      }
      socketProviderChatListModel.getChatList();
    });
  }

//      后端 返回已读成功
  static serverGroupMessageRead() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverGroupMessageRead', (data) async {
      print('-----------------------serverGroupMessageRead: $data');
      if (socketProviderChatListModel != null) {
        final parsed = json.decode(data);
        var dataObj = Map<dynamic, dynamic>.from(parsed);
        int groupId = dataObj['groupId'];
        String condition = 'newChatNumber = ? WHERE groupId = ?';
        List valueArr = [0, groupId];
        var index =
            await dbHelper.chatListUpdateMultiple(condition, valueArr, groupId);
        print('serverGroupMessageRead: $index');
        await socketProviderChatListModel.getChatList();
//          if (dataObj['type'] == 'serverGroupMessageRead') {
//            socketProviderChatListModel.updateItemProperty(
//                dataObj['groupId'], 'newChatNumber', 0);
//          }
      }
    });
  }

//     获取 message detail
  static messageListDetail() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('messageListDetail', (data) async {
      print('-----------------------messageListDetail:');
      final parsed = json.decode(data);
      var dataObj = Map<dynamic, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        var futuresLocalUpdate = <Future>[];
        for (var j = 0; j < dataObj['message'].length; j++) {
          var jsonObj = dataObj['message'][j];
          var groupMessageInsert = GroupMessageSql(
            id: jsonObj['id'],
            groupId: jsonObj['groupId'],
            senderId: jsonObj['senderId'],
            createdDate: jsonObj['createdDate'],
            content: jsonObj['content'],
            contentName: jsonObj['contentName'],
            contentType: jsonObj['contentType'],
            contentId: jsonObj['contentId'],
            contactId: 0,
            replyId: jsonObj['replyId'],
            timestamp: jsonObj['timestamp'],
            downloading: 0,
          );
          futuresLocalUpdate
              .add(dbHelper.groupMessageUpdateOrInsert(groupMessageInsert));
        }
        await Future.wait(futuresLocalUpdate);
        await socketProviderChatListModel.getChatList();
      }
      isUpdatingGroup = false;
    });
  }

  //    获取 分页 聊天记录
  static messageHistoryGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('messageHistoryGet', (data) async {
      print('-----------------------messageHistoryGet: ');
      emitHistory = false;
      final parsed = json.decode(data);
      var dataObj = Map<dynamic, dynamic>.from(parsed);
      List historyArr = [];
      historyArr.addAll(dataObj['preMessage']);
      historyArr.addAll(dataObj['nextMessage']);
//      var conModel = socketProviderConversationListModel;
      /// 如果是最旧消息页
      if (dataObj['isLast']) {
//        lastDeleteMsgTime
        await dbHelper.groupUserMerge(['hasGetOldest'], ['groupId', 'userId'],
            [1], [dataObj['groupId'], Global.profile.user.userId]);
        socketProviderChatListModel.getChatList();
//        List chatList = socketProviderChatListModel.chatList;
//        int groupId = dataObj['groupId'];
//        for(var h = 0; h < chatList.length; h++) {
//          if (groupId == chatList[h]['groupId']) {
//            hasGetOldest = chatList[h]['hasGetOldest'];
//          }
//        }
      }
      if (dataObj['isEmpty'] != true) {
        if (dataObj['groupId'] ==
            chatInfoModelSocket.conversationInfo['groupId']) {
          /// 如果还在当前对话，则
          socketProviderConversationListModel.getConversationList(
            limit: dataObj['limitSave'],
            offsetId: dataObj['offsetIdSave'],
            addOffset: dataObj['addOffsetSave'],
            historyArr: historyArr,
            isEmit: false,
            isUpdate: true,
            page: 1,
            isLast: dataObj['isLast'],
            isNewest: dataObj['isNewest'],
          );
        } else {
          /// 如果不在当前对话，则
          GroupMessageSql offsetMsg =
              await dbHelper.groupMessageOne(dataObj['offsetId']);
          if (offsetMsg != null) {
            historyArr.add(offsetMsg.toMap());
          }
          var futuresLocalUpdate = <Future>[];
          for (var j = 0; j < historyArr.length; j++) {
            var jsonObj = historyArr[j];
            List prop = [
              'groupId',
              'senderId',
              'createdDate',
              'content',
              'contentName',
              'contentType',
              'contentId',
              'replyId',
              'timestamp',
            ];
            List cond = ['id'];
            List propV = [
              jsonObj['groupId'],
              jsonObj['senderId'],
              jsonObj['createdDate'],
              jsonObj['content'],
              jsonObj['contentName'],
              jsonObj['contentType'],
              jsonObj['contentId'],
              jsonObj['replyId'],
              jsonObj['timestamp'],
            ];
            List condV = [jsonObj['id']];
            futuresLocalUpdate.add(dbHelper.groupMessageUpdateOrInsertProperty(
                prop, cond, propV, condV));
          }
          await Future.wait(futuresLocalUpdate);
        }
        //            pageList.preMessage nextMessage

      } else {
        if (dataObj['groupId'] ==
            chatInfoModelSocket.conversationInfo['groupId']) {
          /// 如果还在当前对话，则
          socketProviderConversationListModel.getConversationList(
            limit: dataObj['limitSave'],
            offsetId: dataObj['offsetIdSave'],
            addOffset: dataObj['addOffsetSave'],
            historyArr: historyArr,
            isEmit: false,
            isUpdate: true,
            page: 1,
            isLast: dataObj['isLast'],
            isNewest: dataObj['isNewest'],
          );
        }
      }
    });
  }

  /// user
//  user info
  static userInfoGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('userInfoGet', (data) async {
      print('------------------userInfoGet data: ');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);

      if (dataObj['success'] == 1) {
        var futuresLocalUpdate = <Future>[];
        var futuresLocalFile = <Future>[];
        //   更新 user
        for (var j = 0; j < dataObj['user'].length; j++) {
          var jsonObj = dataObj['user'][j];
          var userInsert = UserSql(
            id: jsonObj['id'],
            username: jsonObj['username'],
            firstName: jsonObj['firstName'],
            lastName: jsonObj['lastName'],
            avatar: jsonObj['avatar'],
            colorId: jsonObj['colorId'],
            lastSeen: jsonObj['lastSeen'],
            isOnline: jsonObj['isOnline'],
            infoTimestamp: jsonObj['infoTimestamp'],
            bio: jsonObj['bio'],
          );
          futuresLocalUpdate.add(dbHelper.userUpdateOrInsertProperty(
            [
              'username',
              'firstName',
              'lastName',
              'avatar',
              'colorId',
              'infoTimestamp',
              'bio',
            ],
            ['id'],
            [
              jsonObj['username'],
              jsonObj['firstName'],
              jsonObj['lastName'],
              jsonObj['avatar'],
              jsonObj['colorId'],
              jsonObj['infoTimestamp'],
              jsonObj['bio'],
            ],
            [jsonObj['id']],
          ));
          if (jsonObj['avatar'] != 0) {
            changeFile() async {
              FileSql fileInfo = await dbHelper.fileOne(userInsert.avatar);
              FileSql insertFile;
              var res;
              if (fileInfo != null) {
                insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['avatarUrl'],
                  fileOriginLocal: fileInfo.fileOriginLocal,
                  fileCompressUrl: jsonObj['avatarUrlCompress'],
                  fileCompressLocal: fileInfo.fileCompressLocal,
                  fileSize: fileInfo.fileSize,
                  fileTime: fileInfo.fileTime,
                );

                res = await dbHelper.fileUpdate(insertFile);
                futuresLocalFile.add(Git().saveImageFileCompress(
                  insertFile.id,
                  insertFile.fileName,
                  insertFile.fileCompressUrl,
                ));
              } else {
                insertFile = FileSql(
                  id: jsonObj['avatar'],
                  name: jsonObj['avatarName'],
                  fileName: jsonObj['avatarName'],
                  fileOriginUrl: jsonObj['avatarUrl'],
                  fileOriginLocal: '',
                  fileCompressUrl: jsonObj['avatarUrlCompress'],
                  fileCompressLocal: '',
                  fileSize: 0,
                );
                res = await dbHelper.fileAdd(insertFile);
                futuresLocalFile.add(Git().saveImageFileCompress(
                  insertFile.id,
                  insertFile.fileName,
                  insertFile.fileCompressUrl,
                ));
              }
              return res;
            }

            futuresLocalUpdate.add(changeFile());
          }
          await Future.wait(futuresLocalUpdate);
          downloadFile() async {
            await Future.wait(futuresLocalFile);
            if (socketProviderChatListModel != null) {
              await socketProviderChatListModel.getChatList();
            }
          }

          downloadFile();
          if (socketProviderChatListModel != null) {
            await socketProviderChatListModel.getChatList();
          }
          if (socketProviderContactListModel != null) {
            socketProviderContactListModel.getContactList();
          }
        }
      }
      isUpdatingGroup = false;
    });
  }

  // 在线状态
  static userStatusGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('userStatusGet', (data) async {
      print('------------------userStatusGet data: ');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);

      if (dataObj['success'] == 1) {
        var futuresLocalUpdate = <Future>[];
        for (var j = 0; j < dataObj['status'].length; j++) {
          var jsonObj = dataObj['status'][j];
          futuresLocalUpdate.add(dbHelper.userUpdateOrInsertProperty(
            [
              'lastSeen',
              'isOnline',
            ],
            ['id'],
            [
              jsonObj['lastSeen'],
              jsonObj['isOnline'] ? 1 : 0,
            ],
            [jsonObj['id']],
          ));
        }
        await Future.wait(futuresLocalUpdate);
//        更新 聊天列表
        await socketProviderChatListModel.getChatList();
      }
      isUpdatingGroup = false;
    });
  }

  ///上线离线通知
  static serverUserOnline() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('serverUserOnline', (data) async {
      print('------------------serverUserOnline data: $data');

      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);
      if (dataObj['success'] == 1) {
        int userId = dataObj['userId'];
        int isOnline = dataObj['isOnline'] ? 1 : 0;
        int lastSeen = dataObj['lastSeen'];
        if (userId.toString() == Global.callFriendId &&
            callInfoSocket.inCalling &&
            callInfoSocket.callSuccess &&
            !dataObj['isOnline']) {
          overCallAll(emit: false);
        }
        UserSql index = await dbHelper.userOne(userId);
        if (index != null) {
//            print(index.id);
          UserSql row = UserSql(
            id: index.id,
            username: index.username,
            firstName: index.firstName,
            lastName: index.lastName,
            avatar: index.avatar,
            colorId: index.colorId,
            lastSeen: lastSeen,
            isOnline: isOnline == 1,
            infoTimestamp: index.infoTimestamp,
            bio: index.bio,
          );
          await dbHelper.userUpdate(row);
          if (chatInfoModelSocket.conversationInfo != null) {
            var groupType = chatInfoModelSocket.conversationInfo['groupType'];
            var contactId = chatInfoModelSocket.conversationInfo['contactId'];
            if (groupType == 2 && contactId == index.id) {
              chatInfoModelSocket.updateInfoProperty('isOnline', isOnline == 1);
              chatInfoModelSocket.updateInfoProperty('lastSeen', lastSeen);
            }
          }
          if (socketProviderChatListModel != null) {
            socketProviderChatListModel.updateItemPropertyByContactId(
              index.id,
              'isOnline',
              isOnline == 1,
            );
          }
          if (socketProviderContactListModel != null) {
            await socketProviderContactListModel.getContactList();
            if (socketProviderConversationListModelGroupId != null) {
              await socketGroupMemberModel
                  .getGroupMember(socketProviderConversationListModelGroupId);
            }
          }
        }
//          else {
//            await dbHelper.userInsertProperty(
//              ['isOnline', 'id'],
//              [isOnline, userId],
//            );
//          }
      }
    });
  }

  static deviceGet() async {
    final dbHelper = DatabaseHelper.instance;
    socketInit.on('deviceGet', (data) async {
      print('------------------deviceGet data: ');
      final parsed = json.decode(data);
      var dataObj = Map<String, dynamic>.from(parsed);

      var futuresLocalUpdate = <Future>[];
      if (dataObj['success'] == 1) {
        await dbHelper.deviceDeleteByUser(Global.profile.user.userId);

        List device = dataObj['devices'];
        bool inDevice = false;
        for(var i = 0; i < device.length; i++) {
          var jsonObj = device[i];
          if (jsonObj['id'] == Global.profile.user.tokenId) {
            inDevice = true;
          }
          var de = DeviceSql(
            id: jsonObj['id'],
            userId: Global.profile.user.userId,
            loginType: jsonObj['loginType'],
            deviceInfo: jsonObj['deviceInfo'],
            authtoken: '',
          );
          futuresLocalUpdate.add(dbHelper.deviceUpdateOrInsert(de));
          // await dbHelper.deviceUpdateOrInsert(de);
          // deviceSocket.updateDeviceList();
        }
        await Future.wait(futuresLocalUpdate);
        if (!inDevice) {
          Global.profile.user = null;
          Global.profile.token = null;
          Global.saveProfile();
          socketInit.disconnect();
          isSend = false;
          navigatorKey.currentState.pushReplacementNamed('login');
        }
        deviceSocket.getDevice();
      }
    });
  }

}
