import 'package:flutter/services.dart';
import 'dart:async';
import '../index.dart';

bool hasSendOne = false;

class ConversationNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

// 对话框聊天 对话
class ConversationListModel extends ConversationNotifier {
  final dbHelper = DatabaseHelper.instance;

  // 监听聊天列表变化
  List<dynamic> _conversationList = [];

//  所有聊天消息
  List get conversationList => _conversationList;

// 获取群聊天消息
  getConversationList({
    int page = 0,
    int groupId,
    int contactId = 0,
    int groupType,
    int limit = 60,
    int offsetId = 0,
    int addOffset = 0,
    int offsetDate = 0,
    bool isEmit = true,
    bool isUpdate = false,
    List historyArr,
    bool isLast = false,
    bool isNewest = false,
    int getType = 1,
    int maxId = 0,
    int minId = 0,
    int extentAfterId = 0,
    int extentBeforeId = 0,
    bool extentAfterAdd = true,
    bool extentBeforeAdd = true,
  }) async {
//    hasGetHistoryUpOver = false;
//    hasGetHistoryDownOver = false;
//    emitHistory = true;
    if (page == 0) {
      hasJumpLastPosition = false;
      hasGetHistoryUpOver = false;
      hasGetHistoryDownOver = false;
    }

    /// 获取是否已经请求了所有消息了，hasGetOldest
    int hasGetOldest = 0;
    List chatList = socketProviderChatListModel.chatList;
    for (var h = 0; h < chatList.length; h++) {
      if (groupId != 0) {
        if (groupId == chatList[h]['groupId']) {
          hasGetOldest = chatList[h]['hasGetOldest'];
        }
      } else if (groupId != 0) {
        if (contactId == chatList[h]['contactId']) {
          hasGetOldest = chatList[h]['hasGetOldest'];
        }
      }
    }
//    logger.d(hasGetOldest);
//    if (page == 0) {
//      hasGetHistoryUpOver = false;
//    }
    var st = DateTime.now().millisecondsSinceEpoch;
    String conditionStr;
    int hash = 0;
    int copyOffsetId = 0;
    int copyAddOffset = 0;
    int copyLimit = 0;
    var sLimit = limit;
    List preSql = [];
    List nextSql = [];
    List allMessage = [];
    List allMessageUpdate = [];
    List deleteIdArr = [];
    List maxAndMin = [];
    List offsetDateMessage = [];

    /// 判断id 是否等于0
    bool offsetDateHasId = false;

    /// 未发送成功的消息
    List errorMessage = [];
    int myId = Global.profile.user.userId;
    String offsetCondition = '''
          groupId=$groupId
          AND createdDate = $offsetDate
          ''';
    var offsetGet = await dbHelper.groupMessageQueryByStr(offsetCondition);
    if (offsetGet != null) {
      offsetDateMessage = offsetGet;
      if (offsetDateMessage[0]['id'] != 0) {
        offsetDateHasId = true;
        copyOffsetId = offsetDateMessage[0]['id'];
      }
    }

//    if (maxId != 0 || minId != 0) {
//      String nextStr;
//      GroupMessageSql maxIdMessage;
//      GroupMessageSql minIdMessage;
//      if (maxId == 0 && minId != 0) {
//        minIdMessage = await dbHelper.groupMessageOne(minId);
//        nextStr = '''
//          groupId=$groupId
//          AND id > $minId
//          AND id != 0
//          ORDER BY id ASC
//          LIMIT $sLimit
//          ''';
//      } else if (maxId != 0 && minId == 0) {
//        maxIdMessage = await dbHelper.groupMessageOne(maxId);
//        nextStr = '''
//          groupId=$groupId
//          AND id < $maxId
//          AND id != 0
//          ORDER BY id DESC
//          LIMIT $sLimit
//          ''';
//      } else {
//        maxIdMessage = await dbHelper.groupMessageOne(maxId);
//        minIdMessage = await dbHelper.groupMessageOne(minId);
//        nextStr = '''
//          groupId=$groupId
//          AND id < $maxId
//          AND id > $minId
//          AND id != 0
//          LIMIT $sLimit
//          ''';
//      }
//      var nextSqlRes = await dbHelper.groupMessageQueryByStr(nextStr);
//      if (nextSqlRes != null) nextSql = nextSqlRes;
//      if (maxIdMessage != null) {
//        maxAndMin.add(maxIdMessage.toMap());
//      }
//      if (minIdMessage != null) {
//        maxAndMin.add(minIdMessage.toMap());
//      }
//    }
//    logger.d('start get message');

    if (extentBeforeId != 0 || extentAfterId != 0) {
      String nextStr;
      List beforeIdMessage;
      List afterIdMessage;
      if (extentBeforeId == 0 && extentAfterId != 0) {
//        afterIdMessage = await dbHelper.groupMessageOne(extentAfterId);
        String timeCondition = '''
          groupId=$groupId
          AND createdDate = $extentAfterId
          ''';
        afterIdMessage = await dbHelper.groupMessageQueryByStr(timeCondition);
        nextStr = '''
          groupId=$groupId
          AND createdDate > $extentAfterId
          ORDER BY createdDate ASC
          LIMIT $sLimit
          ''';
      } else if (extentBeforeId != 0 && extentAfterId == 0) {
//        beforeIdMessage = await dbHelper.groupMessageOne(extentBeforeId);

        String timeCondition = '''
          groupId=$groupId
          AND createdDate = $extentBeforeId
          ''';
        beforeIdMessage = await dbHelper.groupMessageQueryByStr(timeCondition);
//        nextStr = '''
//          groupId=$groupId
//          AND id < $extentBeforeId
//          AND id != 0
//          ORDER BY id DESC
//          LIMIT $sLimit
//          ''';
        /// 由 id 转 time
        nextStr = '''
          groupId=$groupId
          AND createdDate < $extentBeforeId
          ORDER BY createdDate DESC
          LIMIT $sLimit
          ''';
      } else {
//        beforeIdMessage = await dbHelper.groupMessageOne(extentBeforeId);
//        afterIdMessage = await dbHelper.groupMessageOne(extentAfterId);

        String timeCondition = '''
          groupId=$groupId
          AND createdDate = $extentBeforeId
          ''';
        beforeIdMessage = await dbHelper.groupMessageQueryByStr(timeCondition);

        String timeCondition2 = '''
          groupId=$groupId
          AND createdDate = $extentAfterId
          ''';
        afterIdMessage = await dbHelper.groupMessageQueryByStr(timeCondition2);
        nextStr = '''
          groupId=$groupId
          AND createdDate < $extentBeforeId
          AND createdDate > $extentAfterId
          ''';
      }

      var nextSqlRes = await dbHelper.groupMessageQueryByStr(nextStr);
//      logger.d(nextStr);
//      logger.d(nextSqlRes);
      if (nextSqlRes != null) nextSql = nextSqlRes;
//      logger.d(beforeIdMessage);
      if (beforeIdMessage != null && extentBeforeAdd) {
        maxAndMin.add(beforeIdMessage[0]);
      }
      if (afterIdMessage != null && extentAfterAdd) {
        maxAndMin.add(afterIdMessage[0]);
      }
    } else {
      if (offsetDate == 0) {
        offsetDate = TimeUtil.getUtcTimestamp();
      }
      if (addOffset == 0) {
        var preStr = '''
          groupId=$groupId
          AND createdDate < $offsetDate
          ORDER BY createdDate DESC
          LIMIT $limit
          ''';
        var preSqlRes = await dbHelper.groupMessageQueryByStr(preStr);

        /// addOffset == 0 时，直接赋值
        copyAddOffset = addOffset;

        /// 获取最大 id
        int maxIdOffset = 0;
        bool hasZeroId = false;
        int hasIdCount = 0;
        if (preSqlRes != null) {
          preSql = preSqlRes;
          for (var i = 0; i < preSql.length; i++) {
            if (preSql[i]['id'] != 0) {
              hasIdCount += 1;
              if (preSql[i]['id'] > maxIdOffset) {
                maxIdOffset = preSql[i]['id'];
              }
            } else {
              hasZeroId = true;
            }
          }
        }

        /// copyLimit 三种情况
        if (maxIdOffset == 0) {
          /// 如果全是未发送成功的
//          copyLimit = 0;
          if (preSqlRes != null) {
            /// 如果本地查询有，maxIdOffset=0，说明全是未发送成功的
            copyLimit = 0;
          } else {
            /// 如果本地查询没有，maxIdOffset=0，说明从此处开始需要从后端获取
            copyLimit = limit;
          }
        } else if (!hasZeroId) {
          /// 如果所有消息都是发送成功的
//          copyAddOffset = addOffset;
          copyLimit = limit;
        } else {
          /// 如果有发送成功 也有未发送成功的
          copyLimit = hasIdCount;
        }

        ///copyOffsetId： 如果offsetDate id 等于0， 则要重新找值
        if (!offsetDateHasId) {
          /// 如果没有，如此即可
          if (maxIdOffset != 0) {
            copyOffsetId = maxIdOffset + 1;
          }
        }

        /// 如果 copyOffsetId（==0）还是等于0，就从[_conversationList]找
        if (copyOffsetId == 0) {
          /// 这里就要反过来找了，因为这是拉取旧历史记录，找一个最小的即可
          int minIdOffset = 0;
          for (var i = 0; i < _conversationList.length; i++) {
            if (_conversationList[i]['id'] != 0) {
              if (i == 0) {
                minIdOffset = _conversationList[i]['id'];
              } else if (_conversationList[i]['id'] < minIdOffset) {
                minIdOffset = _conversationList[i]['id'];
              }
            }
          }
          if (minIdOffset != 0) {
            copyOffsetId = minIdOffset - 1;
          }
        }

        /// 如果还是等于0 ，算了，哈哈哈
      } else if (limit + addOffset == 0) {
        sLimit = -addOffset;
        var nextStr = '''
          groupId=$groupId
          AND createdDate > $offsetDate
          ORDER BY createdDate ASC
          LIMIT $sLimit
          ''';
        var nextSqlRes = await dbHelper.groupMessageQueryByStr(nextStr);
//        /// copyAddOffset 首先直接赋值
//        copyAddOffset = addOffset;
//        logger.d(nextStr);
        /// 获取最小id
        int minIdOffset = 0;
        bool hasZeroId = false;
        int hasIdCount = 0;
        if (nextSqlRes != null) {
          nextSql = nextSqlRes;
          for (var i = 0; i < nextSql.length; i++) {
            if (nextSql[i]['id'] != 0) {
              hasIdCount += 1;
              if (i == 0) {
                minIdOffset = nextSql[i]['id'];
              } else if (nextSql[i]['id'] < minIdOffset) {
                minIdOffset = nextSql[i]['id'];
              }
            } else {
              hasZeroId = true;
            }
          }

          if (!offsetDateHasId) {
            /// 如果没有，如此即可
            copyOffsetId = minIdOffset - 1;
          }
        }

        /// copyLimit 三种情况
        if (minIdOffset == 0) {
          /// 如果全是未发送成功的
          copyLimit = 0;
//          if (nextSqlRes != null) {
//            copyLimit = limit;
//            copyAddOffset = addOffset;
//          } else {
//            copyLimit = 0;
//          }
        } else if (!hasZeroId) {
          /// 如果所有消息都是发送成功的
          copyAddOffset = addOffset;
          copyLimit = limit;
        } else {
          /// 如果有发送成功 也有未发送成功的，copyLimit+copyAddOffset = 0
          /// 保证AddOffset 和 Limit 加起来等于0
          copyLimit = hasIdCount;
          copyAddOffset = -copyLimit;
        }
//        if (copyLimit != 0) {
//          copyAddOffset = -copyLimit;
//        }
//        if (!hasZeroId) {
//          copyAddOffset = addOffset;
//          copyLimit = limit;
//        }
        /// 如果 copyOffsetId（==0）还是等于0，就从[_conversationList]找
        if (copyOffsetId == 0) {
          /// 这里就要反过来找了，因为这是拉取新记录，找一个最大的
          /// 获取最大 id
          int maxIdOffset = 0;
          for (var i = 0; i < _conversationList.length; i++) {
            if (_conversationList[i]['id'] != 0) {
              if (_conversationList[i]['id'] > maxIdOffset) {
                maxIdOffset = _conversationList[i]['id'];
              }
            }
          }
//          if (maxIdOffset == 0) {
//            copyOffsetId = maxIdOffset;
//
//          }
          if (maxIdOffset != 0) {
            copyOffsetId = maxIdOffset;
          }
        }
      } else if (limit + addOffset > 0 && addOffset < 0) {
        /// copyOffsetId 在后面根据 offsetDate 值赋值
        var preStr = '''
          groupId=$groupId
          AND createdDate < $offsetDate
          ORDER BY createdDate DESC
          LIMIT ${limit + addOffset}
          ''';
        var preSqlRes = await dbHelper.groupMessageQueryByStr(preStr);

        bool hasZeroId = false;

        /// 获取旧的记录 最大id
        int maxIdOffset;
        if (preSqlRes != null) {
          preSql = preSqlRes;
          for (var i = 0; i < preSql.length; i++) {
            if (preSql[i]['id'] != 0) {
//              copyAddOffset -= 1;
              copyLimit += 1;
              if (preSql[i]['id'] > maxIdOffset) {
                maxIdOffset = preSql[i]['id'];
              }
            } else {
              hasZeroId = true;
            }
          }
        }
        var nextStr = '''
          groupId=$groupId
          AND createdDate > $offsetDate
          ORDER BY createdDate ASC
          LIMIT ${-addOffset}
          ''';
        var nextSqlRes = await dbHelper.groupMessageQueryByStr(nextStr);

        /// 获取最小id
        int minIdOffset = 0;
        if (nextSqlRes != null) {
          nextSql = nextSqlRes;
          for (var i = 0; i < nextSql.length; i++) {
            if (nextSql[i]['id'] != 0) {
              /// 负数 代表比 offsetId 大的条数
              copyAddOffset -= 1;
              copyLimit += 1;
              if (i == 0) {
                minIdOffset = nextSql[i]['id'];
              } else if (nextSql[i]['id'] < minIdOffset) {
                minIdOffset = nextSql[i]['id'];
              }
            } else {
              hasZeroId = true;
            }
          }
        }
        if (!hasZeroId) {
          copyAddOffset = addOffset;
          copyLimit = limit;
        }

        /// 如果offsetDate 的id 等于0， 就让它等于0吧，哈哈
        if (!offsetDateHasId) {
          if (minIdOffset != 0 && maxIdOffset != 0) {
            if (minIdOffset - maxIdOffset > 2) {
              copyOffsetId = maxIdOffset + 1;
            }
          }
        }
      }
    }
//    else {
//      if (addOffset == 0) {
//        var preStr = '''
//          groupId=$groupId
//          AND id < $offsetId
//          AND id != 0
//          ORDER BY id DESC
//          LIMIT $limit
//          ''';
//        var preSqlRes = await dbHelper.groupMessageQueryByStr(preStr);
//        if (preSqlRes != null) preSql = preSqlRes;
//      } else if (limit + addOffset == 0) {
//        sLimit = -addOffset;
//        var nextStr = '''
//          groupId=$groupId
//          AND id > $offsetId
//          AND id != 0
//          ORDER BY id ASC
//          LIMIT $sLimit
//          ''';
//        var nextSqlRes = await dbHelper.groupMessageQueryByStr(nextStr);
////        logger.d(nextStr);
//        if (nextSqlRes != null) nextSql = nextSqlRes;
//      } else if (limit + addOffset > 0 && addOffset < 0) {
//        var preStr = '''
//          groupId=$groupId
//          AND id < $offsetId
//          AND id != 0
//          ORDER BY id DESC
//          LIMIT ${limit + addOffset}
//          ''';
//        var preSqlRes = await dbHelper.groupMessageQueryByStr(preStr);
//        if (preSqlRes != null) preSql = preSqlRes;
//        var nextStr = '''
//          groupId=$groupId
//          AND id > $offsetId
//          AND id != 0
//          ORDER BY id ASC
//          LIMIT ${-addOffset}
//          ''';
//        var nextSqlRes = await dbHelper.groupMessageQueryByStr(nextStr);
//        if (nextSqlRes != null) nextSql = nextSqlRes;
//      }
//    }

    allMessage = [...preSql, ...nextSql];

    var end = DateTime.now().millisecondsSinceEpoch;
    print('历史数据 time: ${end - st}');

    List<int> hashIdArr = [];
//    List<Map<String, dynamic>> copyAllMessage = List.from(allMessage);
//    ArrayUtil.sortArray(copyAllMessage, sortOrder: 0, property: 'createdDate');
//    logger.d(allMessage);
    for (var i = 0; i < allMessage.length; i++) {
      if (allMessage[i]['id'] != 0) {
        hashIdArr.add(allMessage[i]['id']);
      }
    }

    /// 从大到小排序
    hashIdArr.sort((a, b) => b.compareTo(a));
    if (hashIdArr.length > 0) {
//      logger.d(hashIdArr.join(','));
      /// 获取最大offsetId
//      copyOffsetId = hashIdArr[0];
      hash = ArrayUtil.createHash(hashIdArr);
    }
//    logger.d(hash);
//    logger.d(limit);
//    logger.d(addOffset);
    List allRows = [];
    List center = [];
    if (extentBeforeId == 0 && extentAfterId == 0) {
      // 使用 offsetId 查询
//      if (offsetId != 0) {
//        GroupMessageSql messageOffset =
//            await dbHelper.groupMessageOne(offsetId);
//        if (page == 0) {
//          center = [messageOffset.toMap()];
//        }
//      }
//    使用 offsetDate 查询
      if (offsetDate != 0) {
        if (page == 0) {
          center = offsetDateMessage;
//          String errorCondition = '''
//          groupId=$groupId
//          AND createdDate = $offsetDate
//          ''';
//          var errorGet = await dbHelper.groupMessageQueryByStr(errorCondition);
//          if (errorGet != null) {
//            center = errorGet;
//          }
        }
      }
    }
    if (page == 0) {
      _conversationList = [];
    }
    if (!isUpdate) {
      allRows = [
        ...preSql,
        ...center,
        ...nextSql,
        ...maxAndMin,
//        ...errorMessage
      ];
    }

    /// 统计要删除的消息 deleteIdArr
    if (isUpdate && historyArr != null) {
//      if (maxId == 0 && minId == 0)
      /// 新增数据保存 数据库
      var futuresLocalUpdate = <Future>[];
      for (var m = 0; m < historyArr.length; m++) {
        var jsonObj = historyArr[m];
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
//      await Future.wait(futuresLocalUpdate);
//          后端返回数据进行更新不同项
      for (var q = 0; q < allMessage.length; q++) {
        /// 在返回列表中是否有，
        var hasMessage = false;
        for (var m = 0; m < historyArr.length; m++) {
          if (allMessage[q]['id'] == historyArr[m]['id']) {
            hasMessage = true;
            break;
          }
        }

        /// 没有就删除
        if (!hasMessage) {
          deleteIdArr.add(allMessage[q]['id']);
        }
      }

      /// 执行需要删除的
      if (deleteIdArr.length > 0) {
        for (var m = 0; m < deleteIdArr.length; m++) {
          for (var q = 0; q < _conversationList.length; q++) {
            if (deleteIdArr[m] != _conversationList[q]['id']) {
              _conversationList.removeAt(q);
              break;
            }
          }
        }
      }

      /// 执行需要增加的
      for (var n = 0; n < historyArr.length; n++) {
        bool converHas = false;
        for (var q = 0; q < _conversationList.length; q++) {
          if (historyArr[n]['id'] == _conversationList[q]['id']) {
            converHas = true;
          }
        }
        if (!converHas) {
          allRows.add(historyArr[n]);
        }
      }
    }

    /// allRows 不管是更新 还是本地的 都是需要增加的
    List content = [];
//    logger.d(allRows.length);
    if (allRows != null) {
      for (var i = 0; i < allRows.length; i++) {
        var jsonObj = allRows[i];
//        logger.d(jsonObj['senderId']);
//        logger.d(jsonObj);
        content.add(jsonObj['content']);
        var chatObj = {
          "id": jsonObj['id'],
          'groupId': groupId,
          'contactId': contactId,
          'senderId': jsonObj['senderId'],
          "createdDate": jsonObj['createdDate'],
          'timestamp': jsonObj['timestamp'],
          'content': jsonObj['content'],
//          'contentType': jsonObj['contentType'],
          'contentType': 1,
          'contentId': 0,
          "contentName": jsonObj['contentName'],
          "contentUrl": '',
          "replyId": jsonObj['replyId'],
          "isReply": jsonObj['replyId'] != 0,
          "replyText": "",
          "replyName": "",
          "isMe": jsonObj['senderId'] == myId,
          "isGroup": groupType == 1,
          "success": jsonObj['id'] != 0,
          "loading": jsonObj['id'] != 0,
          "sending": jsonObj['id'] == 0,
          "isUpload": jsonObj['id'] != 0,
          "downloading": jsonObj['downloading'] == 0,
          "downloadSuccess": jsonObj['downloading'] == 1,
          "isImage": false,
          "isVideo": false,
          "isAudio": false,
          "avatarUrl": "",
          "filePath": '',
          "username": 'username',
          "sender": ""
        };
//        logger.d(chatObj);
        int rowId = allRows[i]['id'];
        bool hasRow = false;
        if (rowId != 0) {
          for (var k = 0; k < _conversationList.length; k++) {
            if (rowId == _conversationList[k]['id']) {
              hasRow = true;
            }
          }
        }
        if (!hasRow) {
          _conversationList.add(chatObj);
        }
      }
    }
//    logger.d(content.join(','));
//    if (groupId == 151) {
//      dbHelper.groupUserDelete(groupId);
//    }
//    logger.d(isEmit);
//    logger.d(extentBeforeId);
//    logger.d(extentAfterId);
    if (!isUpdate) {
      if (hasGetOldest == 1 && allMessage.length < limit && addOffset == 0) {
        hasGetHistoryUpOver = true;
      }
    }
    if (groupId != 0 &&
        isEmit &&
        extentBeforeId == 0 &&
        extentAfterId == 0 &&
        !hasGetHistoryUpOver) {
      SocketIoEmit.messageHistoryGet(
        groupId: groupId,
        offsetId: copyOffsetId,
        limit: copyLimit,
        addOffset: copyAddOffset,
        hash: hash,
        maxId: maxId,
        minId: minId,
        offsetIdSave: offsetId,
        limitSave: limit,
        addOffsetSave: addOffset,
        offsetDateSave: offsetDate,
      );
    }
    ArrayUtil.sortArray(_conversationList,
        sortOrder: 0, property: 'createdDate');
    if (isLast) {
      hasGetHistoryUpOver = true;
      logger.d('isLast');
    }
    if (isNewest) {
      hasGetHistoryDownOver = true;
      logger.d('isNewest');
    }
    hasGetHistoryUp = false;
    hasGetHistoryDown = false;
    if (allRows != null) {
      notifyListeners();
    }
    return _conversationList;
  }

// 赋值群消息
  void insertFirst(Map<String, dynamic> item) {
    _conversationList.insert(0, item);
    notifyListeners();
  }

//  群消息重置为空
  void resetChatHistory() {
    _conversationList = [];
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

//  群消息新增
  void add(Map<String, dynamic> item) {
    _conversationList.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

//  群消息赋值所有
  void updateList(List conversations) {
   if (conversations == _conversationList) return;
//    print('conversations$conversations');
    _conversationList = conversations;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

//  更新某一个群 消息
  void updateListItem(int index, String property, dynamic value) {
    print(_conversationList[index]);
    _conversationList[index][property] = value;
    print(_conversationList[index]);
    notifyListeners();
  }

  void updateMultipleItem(int timestamp, Color value, Color value2) {
    // for (var i = 0; i < _conversationList.length; i++) {
    //   _conversationList[i]['topColor'] = Colors.blue;
    //   _conversationList[i]['bottomColor'] = Colors.blue;
    // }
    // for (var m = 0; m < listUpdate.length; m++) {
    //   final tile = _conversationList.firstWhere(
    //       (item) => item['timestamp'] == listUpdate[m]['timestamp']);
    //   tile['topColor'] = value;
    //   tile['bottomColor'] = value2;
    // }
    // }
    var tile = _conversationList.firstWhere(
            (item) => item['timestamp'] == timestamp);
    tile['topColor'] = value;
    tile['bottomColor'] = value2;
    // notifyListeners();
  }

  void noti() {
    notifyListeners();
  }

// 根据时间更新群消息值
  void updateListItemByTime(int groupId, int time, dynamic value) {
    for (var i = 0; i < _conversationList.length; i++) {
      var chatItem = _conversationList[i];
      if (chatItem['timestamp'] == time) {
//        chatItem[''] = value;
//        print('chatItem: $chatItem');
        chatItem['content'] = value['content'];
        chatItem['contentType'] = value['contentType'];
        chatItem['contentName'] = value['contentName'];
        chatItem['createdDate'] = value['createdDate'];
        chatItem['sending'] = value['sending'];
        chatItem['success'] = value['success'];
        chatItem['id'] = value['id'];
        notifyListeners();
        break;
      }
    }
  }

  removeRangeList(int start, int end) {
    _conversationList.removeRange(start, end);
    notifyListeners();
  }
}



class ConversationScrollModel extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }


  // 监听聊天列表变化
  List<dynamic> _scrollList = [];
  List get scrollList => _scrollList;

  updateScrollList(List list, {bool noti = true}) {
    // if (_scrollList == list) return;
    _scrollList = list;
    if (noti) {
      notifyListeners();
    }
  }

  noti() {
    notifyListeners();
  }
}

