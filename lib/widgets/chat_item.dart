import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:quiver/core.dart';
import 'package:intl/intl.dart';
import '../index.dart';

class ChatItem extends StatefulWidget {
  final int groupId;
  final int contactId;
  final int contactSqlId;
  final int groupType;
  final int avatar;
  final String fileCompressUrl;
  final String fileCompressLocal;
  final String fileOriginUrl;
  final String fileOriginLocal;
  final String groupName;
  final String username;
  final String firstName;
  final String lastName;

//  最后一条消息时间
  final int createdDate;

//   最后一条消息内容
  final String content;
  final bool isOnline;
  final bool sending;

//   新消息数量
  final int newChatNumber;
  final int groupUserLength;
  final String contentName;
  final int contentType;
  final int colorId;

//  发送人名字
  final String sendName;
  final int groupRoomInfoTimestamp;
  final int groupRoomUserTimestamp;
  final int lastSeen;
  final int senderId;

  final String description;
  final String bio;
  final bool isMe;
  final bool isRead;
  final int latestMsgId;
  final int latestMsgTime;
  final double extentAfter;
  final double extentBefore;
  final int extentAfterId;
  final int extentBeforeId;
  final int timestamp;
  final int messageId;

  ChatItem({
    Key key,
    this.groupId,
    this.contactId,
    this.colorId,
    this.groupType,
    this.avatar,
    this.fileCompressUrl,
    this.fileCompressLocal,
    this.fileOriginUrl,
    this.fileOriginLocal,
    this.groupName,
    this.username,
    this.createdDate,
    this.content,
    this.isOnline,
    this.newChatNumber,
    this.groupUserLength,
    this.contentName,
    this.contentType,
    this.sendName,
    this.senderId,
    this.groupRoomInfoTimestamp,
    this.groupRoomUserTimestamp,
    this.lastSeen,
    this.firstName,
    this.lastName,
    this.contactSqlId,
    this.description,
    this.bio,
    this.sending,
    this.isMe,
    this.isRead,
    this.latestMsgId,
    this.latestMsgTime,
    this.extentAfter,
    this.extentBefore,
    this.extentAfterId,
    this.extentBeforeId,
    this.timestamp,
    this.messageId,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  bool _withTree = false;
  ChatInfoModel info;

  @override
  Widget build(BuildContext context) {
    info = Provider.of<ChatInfoModel>(context, listen: false);
//    socketProviderConversationListModel = info;
//  显示用户名
//    logger.d(widget.sendName);

    var subtitleStr = widget.sendName != null && widget.sendName != ''
        ? widget.sendName + ': '
        : '';
    if (widget.senderId == Global.profile.user.userId) {
      subtitleStr = 'You: ';
    }
//  不显示用户名
//    var subtitleStr = '';
    if (widget.contentType == 1) {
      subtitleStr += widget.content;
    } else if (widget.contentType == 2) {
      subtitleStr += widget.contentName;
    } else if (widget.contentType == 3) {
      subtitleStr += 'Sticker';
    }
    var timeFormatChat = '';
//    print('createdDate: ${widget.createdDate}');
    if (widget.createdDate != null) {
//      var chatTime = DateTime.parse(widget.createdDate).toLocal();
//      int year = DateTime.now().year;
//      int month = DateTime.now().month;
//      int day = DateTime.now().day;
//      int yearChat = chatTime.year;
//      int monthChat = chatTime.month;
//      int dayChat = chatTime.day;
////    print('yearChat: $yearChat');
////    print('monthChat: $monthChat');
////    print('dayChat: $dayChat');
//      if (year != yearChat || month != monthChat || day != dayChat) {
//        timeFormatChat =
//            DateFormat.yMd().format(DateTime.parse(widget.createdDate).toLocal());
//      } else {
//        timeFormatChat =
//            DateFormat.Hm().format(DateTime.parse(widget.createdDate).toLocal());
//      }
    }
    var gAvatar = AvatarWidget(
      avatarUrl: widget.fileCompressUrl,
      avatarLocal: widget.fileCompressLocal,
      firstName: widget.firstName,
      lastName: widget.lastName,
      width: 50,
      height: 50,
      colorId: widget.colorId,
    );
    var sendingStatus;
    if (widget.isMe) {
      if (widget.sending) {
        sendingStatus = Container(
          child: SizedBox(
            child: Icon(
              Icons.access_time,
              size: 16,
            ),
          ),
          height: 16.0,
          width: 16.0,
        );
      } else {
        if (widget.isRead) {
          sendingStatus = Icon(
            DefineIcons.read,
            color: Colors.black,
            size: 16.0,
          );
        } else {
          sendingStatus = Icon(
            Icons.check,
            color: Colors.black,
            size: 16.0,
          );
        }
      }
    } else {
      sendingStatus = SizedBox();
    }
    return GestureDetector(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Stack(
              children: <Widget>[
                gAvatar,
                if (widget.groupType == 2)
                  Positioned(
                    bottom: 0.0,
                    left: 6.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      height: 11,
                      width: 11,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.isOnline
                                ? Colors.greenAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 7,
                          width: 7,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                widget.groupType == 1
                    ? Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.group,
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  child: Container(
                    child: TextOneLine(
                      "${widget.groupName}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: TextOneLine(
              "$subtitleStr",
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  height: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
//                    sending
                      sendingStatus,
                      Text(
                        "${TimeUtil.dialogTime(widget.createdDate)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                widget.newChatNumber == 0
                    ? SizedBox()
                    : Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 11,
                          minHeight: 11,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 1, left: 5, right: 5),
                          child: Text(
                            "${widget.newChatNumber}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              if (widget.groupType == 1) {
                showDeleteConfirmGroup(gAvatar);
              } else {
                showDeleteConfirmSingle(gAvatar);
              }
            },
          ),
        ],
      ),
      onTap: () {
        _goToChat();
      },
    );
  }

  _goToChat() async {
    socketProviderConversationListModelGroupId = widget.groupId;
    isUpdatingConversation = false;

    /// 先初始赋值，方便后面的查询，更新info
    info.updateInfo({
      'groupId': widget.groupId,
      'groupType': widget.groupType,
      'contactSqlId': widget.contactSqlId,
      'contactId': widget.contactId,
      'groupName': widget.groupName,
      'username': widget.username,
      'firstName': widget.firstName,
      'lastName': widget.lastName,
      'avatar': widget.avatar,
      'fileCompressUrl': widget.fileCompressUrl,
      'fileCompressLocal': widget.fileCompressLocal,
      'fileOriginUrl': widget.fileOriginUrl,
      'fileOriginLocal': widget.fileOriginLocal,
      'isOnline': widget.isOnline,
      'newChatNumber': widget.newChatNumber,
      'content': widget.content,
      'createdDate': widget.createdDate,
      'colorId': widget.colorId,
      'groupMembers': 1,
      'onlineMember': 0,
      'lastSeen': widget.lastSeen,
      'description': widget.description,
      'bio': widget.bio,
      'extentAfter': widget.extentAfter,
      'extentBefore': widget.extentBefore,
      'extentAfterId': widget.extentAfterId,
      'extentBeforeId': widget.extentBeforeId,
//      'extentAfterId': 0,
//      'extentBeforeId': 0,
      "latestMsgId": widget.latestMsgId,
      "latestMsgTime": widget.latestMsgTime,
      "timestamp": widget.timestamp,
      "messageId": widget.messageId,
    });
//    logger.d(info.conversationInfo);
    if (widget.groupType == 1) {
//      isUpdatingConversation = true;
      SocketIoEmit.clientGetOneGroup(
        groupId: widget.groupId,
        groupType: widget.groupType,
        contactId: widget.contactId,
        infoTimestamp: widget.groupRoomInfoTimestamp,
        userTimestamp: widget.groupRoomUserTimestamp,
      );
      socketGroupMemberModel.getGroupMember(widget.groupId);
    }
//          关闭之前聊天记录
    socketProviderConversationListModel.resetChatHistory();
//    logger.d('extentBeforeId: ${widget.extentBeforeId}');
//    logger.d('extentAfterId: ${widget.extentAfterId}');
    int offsetDate;
    /// 如果最新消息是 未发送成功的消息
    if (widget.messageId != 0) {
      offsetDate = widget.latestMsgTime;
    } else {
      offsetDate = widget.timestamp;
    }
    /// 如果最新消息是 发送成功的

    socketProviderConversationListModel.getConversationList(
      groupId: widget.groupId,
      contactId: widget.contactId,
      groupType: widget.groupType,
      offsetId: widget.latestMsgId,
      offsetDate: offsetDate,
      extentBeforeId: widget.extentBeforeId,
      extentAfterId: widget.extentAfterId,
//      extentBeforeId: 0,
//      extentAfterId: 0,
      addOffset: 0,
//      limit: 40,
    );
    logger.d('groupId: ${widget.groupId}');
    Navigator.of(context).pushNamed("conversation");
  }

  //  弹出对话框 退出群
  Future<bool> showDeleteConfirmGroup(gAvatar) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            child: Row(
              children: [
                gAvatar,
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("Leave group"),
                ),
              ],
            ),
          ),
          content: Text.rich(TextSpan(children: [
            TextSpan(text: "Are you sure you want to delete"),
            TextSpan(text: " and leave the group "),
            TextSpan(
              text: "${widget.groupName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
//                        color: Colors.blue
              ),
            ),
            TextSpan(text: "?"),
          ])),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                'DELETE CHAT',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                showLoading(context);
                SocketIoEmit.clientDeleteGroupMember(
                  groupId: widget.groupId,
                  memberId: Global.profile.user.userId,
                );
              },
            ),
          ],
        );
      },
    );
  }

  //  弹出对话框 退出单人对话
  Future<bool> showDeleteConfirmSingle(gAvatar) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            child: Row(
              children: [
                gAvatar,
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("Leave chat"),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: "Are you sure you want to delete"),
                  TextSpan(text: " the chat with "),
                  TextSpan(
                    text: "${widget.groupName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
//                        color: Colors.blue
                    ),
                  ),
                  TextSpan(text: "?"),
                ]),
              ),
              Row(
                children: <Widget>[
                  // 通过Builder来获得构建Checkbox的`context`，
                  // 这是一种常用的缩小`context`范围的方式
                  Builder(
                    builder: (BuildContext context) {
                      return Checkbox(
                        value: _withTree,
                        onChanged: (bool value) {
                          (context as Element).markNeedsBuild();
                          _withTree = !_withTree;
                        },
                      );
                    },
                  ),
                  Text("Also delete for ${widget.groupName}"),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                'DELETE CHAT',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                showLoading(context);
                await _deleteGroup();
                if (widget.groupId != 0) {
                  SocketIoEmit.clientDeleteGroupMember(
                    groupId: widget.groupId,
                    memberId: Global.profile.user.userId,
                    deleteOther: _withTree,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  _deleteGroup() async {
    if (widget.groupId == 0) {
      var dbHelper = DatabaseHelper.instance;
      var dataObj = {
        'groupId': widget.groupId,
        'memberId': Global.profile.user.userId,
        'userTimestamp': 2,
        'groupUserId': 0,
        'deleteChat': 0,
        'deleteOther': _withTree,
      };
      var myId = Global.profile.user.userId;
//      await dbHelper.groupMessage
      var futuresLocalUpdate = <Future>[];

      futuresLocalUpdate.add(dbHelper.groupMessageDeleteMultiple(
          ['groupId', 'senderId', 'contactId'],
          [widget.groupId, myId, widget.contactId]));
      futuresLocalUpdate.add(dbHelper.groupUserDeleteCondition(
          'userId=? AND contactId=?', [myId, widget.contactId]));
      await Future.wait(futuresLocalUpdate);
      socketProviderChatListModel.getChatList();
      Navigator.of(chatsPageContext).pop();
      Navigator.of(chatsPageContext).pop();
    }
  }
}
