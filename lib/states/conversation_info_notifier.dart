import '../index.dart';

// 对话框聊天 对话
class ChatInfoModel extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
  final dbHelper = DatabaseHelper.instance;
  // 对话人或群info
  Map<String, dynamic> _conversationInfo;

  Map<String, dynamic> get conversationInfo => _conversationInfo;
  saveChatPosition({
    int groupId,
    int contactId = 0,
    double extentBefore = 0,
    double extentAfter = 0,
    int extentAfterId = 0,
    int extentBeforeId = 0,
  }) async {
    int userId = Global.profile.user.userId;
    await dbHelper.groupUserUpdateProperty([
      'extentBefore',
      'extentAfter',
      'extentAfterId',
      'extentBeforeId',
    ], [
      'groupId',
      'contactId',
      'userId',
    ], [
      extentBefore,
      extentAfter,
      extentAfterId,
      extentBeforeId,
    ], [
      groupId,
      contactId,
      userId,
    ]);
  }
  // 获取 对话人或群info
  getConversationInfo(int groupId, int userId, int contactId,
      {int groupType, int infoTimestamp, int userTimestamp}) async {
//    if (groupId != 0) {
//      socketProviderConversationListModelGroupId = groupId;
//      isUpdatingConversation = true;
////    获取群 变更信息
//      SocketIoEmit.clientGetOneGroup(
//        groupId: groupId,
//        groupType: groupType,
//        contactId: contactId,
//        infoTimestamp: infoTimestamp,
//        userTimestamp: userTimestamp,
//      );
////      获取群成员
//      socketGroupMemberModel.getGroupMember(groupId);
////          关闭之前聊天记录
//      socketProviderConversationListModel.resetChatHistory();
//      /// 此处要更改，先获取本地消息记录
//      SocketIoEmit.clientGetGroupMessage(
//        groupId: groupId,
//      );
////      查询群 sql
////      var groupRoomInfo =
//    } else {
//      isUpdatingConversation = false;
////    获取聊天信息
//      socketProviderConversationListModel.getConversationList(
//          groupId: groupId,
//          contactId: contactId,
//      );
//    }
//
//    logger.d('群id ${groupId}');
//
////    info.updateInfo({
////      'groupId': widget.groupId,
////      'groupType': widget.groupType,
////      'contactSqlId': widget.contactSqlId,
////      'contactId': widget.contactId,
////      'groupName': widget.groupName,
////      'username': widget.username,
////      'firstName': widget.firstName,
////      'lastName': widget.lastName,
////      'avatar': widget.avatar,
////      'fileCompressUrl': widget.fileCompressUrl,
////      'fileCompressLocal': widget.fileCompressLocal,
////      'fileOriginUrl': widget.fileOriginUrl,
////      'fileOriginLocal': widget.fileOriginLocal,
////      'isOnline': widget.isOnline,
////      'newChatNumber': widget.newChatNumber,
////      'content': widget.content,
////      'createdDate': widget.createdDate,
////      'colorId': widget.colorId,
////      'groupMembers': 1,
////      'onlineMember': 0,
////      'lastSeen': widget.lastSeen,
////      'description': widget.description,
////      'bio': widget.bio,
////    });
//    notifyListeners();
    return _conversationInfo;
  }

// 更新  对话人或群info
  void updateInfo(dynamic info) {
    if (_conversationInfo == info) return;
    _conversationInfo = info;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

// 更新  对话人或群info首次赋值，不 通知监听器， 不执行notifyListeners
  void updateInfoFirst(dynamic info) {
    if (_conversationInfo == info) return;
    _conversationInfo = info;
  }

//  更新  对话人或群info 某个属性
  void updateInfoProperty(String property, dynamic value) {
    if (_conversationInfo[property] == value) return;
    _conversationInfo[property] = value;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void updateInfoPropertyMultiple(Map<String, dynamic> valueObj) {
    valueObj.forEach((key, value) {
      if (value != null) {
        _conversationInfo[key] = valueObj[key];
      }
    });
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

//  获取大头像
  getBigAvatar(int avatar) async {
    var fileInfo = await dbHelper.fileOne(avatar);
    logger.d(fileInfo);
  }

//  从群成员中点击 查看个人信息
  Map<String, dynamic> _viewGroupInfo;

  Map<String, dynamic> get viewGroupInfo => _viewGroupInfo;

  // 从群成员 获取info
  Map<String, dynamic> getViewGroupInfo() {
//    socketProviderConversationListModelGroupId
    return _viewGroupInfo;
  }

// 从群成员 更新info
  void updateViewGroupInfo(dynamic info) {
    if (_viewGroupInfo == info) return;
    _viewGroupInfo = info;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

//  从群成员 更新某个属性
  void updateViewGroupInfoProperty(String property, dynamic value) {
    if (_viewGroupInfo[property] == value) return;
    _viewGroupInfo[property] = value;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}