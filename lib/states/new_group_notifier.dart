import '../index.dart';

class NewGroupNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

// contact
class AddPeopleModel extends NewGroupNotifier {
  List _addPeopleList = [];

  List get addPeopleList {
    return _addPeopleList;
  }

  void add(item) {
    _addPeopleList.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void delete(int contactId) {
    _addPeopleList.removeWhere((item) => item['contactId'] == contactId);
    notifyListeners();
  }

  void updateList(List people) async {
    _addPeopleList = people;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void getAddPeopleList() async {
//    _addPeopleList = people;
//    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
//    notifyListeners();
  }

  void reset() {
    _addPeopleList = [];
    notifyListeners();
  }
}

class GroupMemberModel extends NewGroupNotifier {
  List _groupMember = [];

  List get groupMember {
    return _groupMember;
  }

  void add(item) {
    _groupMember.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void delete(int id) {
    _groupMember.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  void updateList(List people) async {
    _groupMember = people;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  getGroupMember(int groupId) async {
//    _addPeopleList = people;
    final dbHelper = DatabaseHelper.instance;

    var st = DateTime.now().millisecondsSinceEpoch;
    var members = [];
    var futureGroupArr = <Future>[
      dbHelper
          .contactMultipleCondition(['userId'], [Global.profile.user.userId]),
      dbHelper.groupUserMultipleCondition(['groupId'], [groupId]),
      dbHelper.groupRoomAll(),
      dbHelper.userAll(),
      dbHelper.fileAll(),
    ];
    var backArr = await Future.wait(futureGroupArr);
    var end = DateTime.now().millisecondsSinceEpoch;
//    logger.d('获取群成员时间: ${end - st}');
    List contactAll = backArr[0] == null ? [] : backArr[0];
    List groupUserAll = backArr[1] == null ? [] : backArr[1];
    List groupRoomAll = backArr[2] == null ? [] : backArr[2];
    List userAll = backArr[3] == null ? [] : backArr[3];
    List fileAll = backArr[4] == null ? [] : backArr[4];
    if (groupUserAll.length > 0) {
      for (var i = 0; i < groupUserAll.length; i++) {
        if (groupUserAll[i]['deleteChat'] == 1) {
          int id;
          String username;
          String firstName;
          String lastName;
          int avatar;
          int colorId;
          int lastSeen;
          bool isOnline;
          int infoTimestamp;
          String fileCompressUrl;
          String fileCompressLocal;

          bool isOwner = false;
          String bio;
          int contactSqlId;
          int contactId;

          id = groupUserAll[i]['userId'];
          for (var j = 0; j < userAll.length; j++) {
            var jsonObj = userAll[j];
//          if (jsonObj['id'] == 1) {
//            logger.d(jsonObj['isOnline']);
//          }
            if (id == jsonObj['id']) {
              colorId = jsonObj['colorId'];
              avatar = jsonObj['avatar'];
              username = jsonObj['username'];
              lastSeen = jsonObj['lastSeen'];
              isOnline = jsonObj['isOnline'] == 1;
              infoTimestamp = jsonObj['infoTimestamp'];
              firstName = jsonObj['firstName'];
              lastName = jsonObj['lastName'];
              bio = jsonObj['bio'];
              contactId = jsonObj['id'];
            }
          }
          for (var j = 0; j < contactAll.length; j++) {
            var jsonObj = contactAll[j];
            if (id == jsonObj['contactId']) {
              firstName = jsonObj['firstName'];
              lastName = jsonObj['lastName'];
              contactSqlId = jsonObj['id'];
            }
          }

          for (var j = 0; j < groupRoomAll.length; j++) {
            var jsonObj = groupRoomAll[j];
            if (id == jsonObj['createdUserId'] &&
                jsonObj['id'] == groupId) {
              isOwner = true;
              break;
            }
          }
          for (var j = 0; j < fileAll.length; j++) {
            var jsonObj = fileAll[j];
            if (avatar == jsonObj['id']) {
              fileCompressUrl = jsonObj['fileCompressUrl'];
              fileCompressLocal = jsonObj['fileCompressLocal'];
            }
          }

          var item = {
            "id": id,
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "avatar": avatar,
            "colorId": colorId,
            "lastSeen": lastSeen,
            "isOnline": isOnline,
            "infoTimestamp": infoTimestamp,
            "fileCompressUrl": fileCompressUrl,
            "fileCompressLocal": fileCompressLocal,
            "isOwner": isOwner,
            "bio": bio,
            "contactId": contactId,
            "contactSqlId": contactSqlId,
          };
          members.add(item);
        }
      }
    }
    _groupMember = members;
    getGroupOnline();
    chatInfoModelSocket.updateInfoProperty(
        'groupMembers', _groupMember.length);
//    logger.d('获取群成员: ${_groupMember.length}');
//    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  getGroupOnline() {
    int onlineNumber = 0;
    for (var i = 0; i < _groupMember.length; i++) {
      if (_groupMember[i]['isOnline'] == true) {
        onlineNumber += 1;
      }
    }
    if (chatInfoModelSocket.conversationInfo != null) {
      chatInfoModelSocket.updateInfoProperty(
          'onlineMember', onlineNumber);
    }
    notifyListeners();
    return onlineNumber;
  }

  void reset() {
    _groupMember = [];
    notifyListeners();
  }
}
