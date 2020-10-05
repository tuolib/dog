import '../index.dart';

class ContactNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }



}

// contact
class ContactListModel extends ContactNotifier {
  final dbHelper = DatabaseHelper.instance;
  List _contactList = [];

  List get contactList {
    return _contactList;
  }

  getContactList() async {
    var futureGroupArr = <Future>[
      dbHelper
          .contactMultipleCondition(['userId'], [Global.profile.user.userId]),
      dbHelper.userAll(),
      dbHelper.fileAll(),
    ];
    var backArr = await Future.wait(futureGroupArr);
    List contactAll = backArr[0] == null ? [] : backArr[0];
    List userAll = backArr[1] == null ? [] : backArr[1];
    List fileAll = backArr[2] == null ? [] : backArr[2];
    List contacts = [];
    for(var j = 0; j < contactAll.length; j++) {
      for(var i = 0; i < userAll.length; i++) {
        var contactObj = contactAll[j];
        var userObj = userAll[i];
        if (contactObj['contactId'] == userObj['id']) {
          String avatarUrl;
          String avatarLocal;
          for(var m = 0; m < fileAll.length; m++) {
            var fileObj = fileAll[m];
            if (fileObj['id'] == userObj['avatar']) {
              avatarUrl = fileObj['fileCompressUrl'];
              avatarLocal = fileObj['fileCompressLocal'];
            }
          }
          var item = {
            'contactSqlId': contactObj['id'],
            'contactId': contactObj['contactId'],
            'firstName': contactObj['firstName'],
            'lastName': contactObj['lastName'],
            'avatar': userObj['avatar'],
            'avatarUrl': avatarUrl,
            'avatarLocal': avatarLocal,
            'username': userObj['username'],
            'colorId': userObj['colorId'],
            'lastSeen': userObj['lastSeen'],
            'isOnline': userObj['isOnline'] == 1,
            'bio': userObj['bio'],
          };
//          logger.d(contactObj['id']);
          contacts.add(item);
          break;
        }
      }
    }
    _contactList = contacts;
//    logger.d('_contactList: $_contactList');
    notifyListeners();
    return _contactList;
  }

  void add(ContactSql item) {
    _contactList.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void updateItemProperty(int userId, String property, value) {
    for (var i = 0; i < _contactList.length; i++) {
      if (_contactList[i]['userId'] == userId) {
        _contactList[i][property] = value;
        // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
        notifyListeners();
      }
    }
  }

  void notifyContactList() {
    notifyListeners();
  }

  void reset() {
    _contactList = [];
    notifyListeners();
  }
}


