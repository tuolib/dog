import 'dart:math';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  ContactListModel contactNotifier;
  bool sortByLastSeen = true;
  bool hasGetContact = false;
  List contacts = [];

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (!hasGetContact) {
//      hasGetContact = true;
//      Future.microtask(() {
//        print(13);
//        socketProviderContactListModel.getContactList();
//      });
//    }
////    contactNotifier = Provider.of<ContactListModel>(context);
////    if (socketProviderContactListModel != contactNotifier) {
////      socketProviderContactListModel = contactNotifier;
////      Future.microtask(() {
////        print(13);
////        socketProviderContactListModel.getContactList();
////      });
////    }
//  }

  @override
  Widget build(BuildContext context) {
    if (!hasGetContact) {
      hasGetContact = true;
      socketProviderContactListModel.getContactList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: <Widget>[
          // 非隐藏的菜单
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addContacts(context);
            },
          ),
          sortByLastSeen
              ? IconButton(
                  icon: Icon(Icons.timer),
                  onPressed: () {
                    setState(() {
                      sortByLastSeen = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.sort_by_alpha),
                  onPressed: () {
                    setState(() {
                      sortByLastSeen = true;
                    });
                  },
                )
        ],
      ),
      body: _buildBody(context), // 构建主页面
    );
  }

  Widget _buildBody(context) {
    return Consumer<ContactListModel>(
      builder: (BuildContext context, ContactListModel contactListModel,
          Widget child) {
        contacts = contactListModel.contactList;

        return memberArray();
      },
    );
  }

  Widget memberArray() {
    List myList = List.from(contacts);
    if (myList.length == 0) return SizedBox();
    if (myList.length > 0) {
      if (sortByLastSeen) {
        ArrayUtil.sortArray(myList, sortOrder: 0, property: 'lastSeen');
        ArrayUtil.sortArray(myList, sortOrder: 0, property: 'isOnline');
      } else {
        ArrayUtil.sortArray(myList, sortOrder: 1, property: 'firstName');
      }
    }
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      key: PageStorageKey('contactsPage'),
//      separatorBuilder: (BuildContext context, int index) {
//        return Align(
//          alignment: Alignment.centerRight,
//          child: Container(
//            height: 0.5,
//            width: MediaQuery.of(context).size.width / 1.3,
//            child: Divider(),
//          ),
//        );
//      },
      itemCount: myList.length,
      itemBuilder: (BuildContext context, int index) {
        Map friend = myList[index];
        return _buildDefineMembers(friend);
      },
    );
  }

  Widget _buildDefineMembers(Map friend) {
    var nameStr = '${friend['firstName']}';
    if (friend['lastName'] != null && friend['lastName'] != '') {
      nameStr += ' ${friend['lastName']}';
    }
    var gAvatar;
    gAvatar = AvatarWidget(
      avatarUrl: friend['avatarUrl'],
      avatarLocal: friend['avatarLocal'],
      firstName: friend['firstName'],
      lastName: friend['lastName'],
      width: 40,
      height: 40,
      colorId: friend['colorId'],
    );
    return InkWell(
      onTap: () {
        _goToChat(friend);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 15),
//      padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: gAvatar,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextOneLine(
                            "$nameStr",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            friend['isOnline']
                                ? 'online'
                                : TimeUtil.lastSeen(friend['lastSeen']),
                            style: TextStyle(
                              color: friend['isOnline']
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width - 65,
                child: Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addContacts(context) async {
    Navigator.of(context).pushNamed("addContact");
  }

  _goToChat(friend) {
    var info = Provider.of<ChatInfoModel>(context, listen: false);
    var fullName = '${friend['firstName']}';
    if (friend['lastName'] != null) {
      fullName += ' ${friend['lastName']}';
    }
    int groupId = 0;
    List chats = socketProviderChatListModel.chatList;
    for (var i = 0; i < chats.length; i++) {
      if (chats[i]['contactId'] == friend['contactId']) {
        groupId = chats[i]['groupId'];
      }
    }

    socketProviderConversationListModelGroupId = groupId;
    isUpdatingConversation = false;

    /// 先初始赋值，方便后面的查询，更新info
    info.updateInfo({
      'groupId': groupId,
      'groupType': 2,
      'contactSqlId': friend['contactSqlId'],
      'contactId': friend['contactId'],
      'groupName': fullName,
      'username': friend['username'],
      'avatar': friend['avatar'],
      'fileCompressUrl': friend['avatarUrl'],
      'fileCompressLocal': friend['avatarLocal'],
      'fileOriginUrl': friend['avatarUrl'],
      'fileOriginLocal': friend['avatarLocal'],
      'colorId': friend['colorId'],
      'isOnline': friend['isOnline'],
      'lastSeen': friend['lastSeen'],
      'firstName': friend['firstName'],
      'lastName': friend['lastName'],
      'bio': friend['bio'],
      'newChatNumber': 0,
      'content': '',
      'createdDate': friend['lastSeen'],
      'groupMembers': 2,
      'onlineMember': 1,
    });
//          关闭之前聊天记录
    socketProviderConversationListModel.resetChatHistory();
    socketProviderConversationListModel.getConversationList(
        groupId: groupId, contactId: friend['contactId'], groupType: 2);
    //// 即使聊天列表里有这个单人聊天，但是可能还没创建好groupId
    if (groupId != 0) {
      SocketIoEmit.clientGetGroupMessage(
        groupId: groupId,
      );
    } else {}
    logger.d('groupId: $groupId');
    Navigator.of(context).pushNamed("conversation");
  }
}
