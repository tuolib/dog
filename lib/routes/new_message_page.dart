import 'dart:math';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

class NewMessagePage extends StatefulWidget {
  @override
  _NewMessagePageState createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  List colors = Colors.primaries;
  static Random random = Random();

//  var friends = [];+
//  List friends = List.generate(13, (index)=>{
//    "firstName": names[random.nextInt(10)],
//    "lastName": names[random.nextInt(10)],
//    "avatarLocal": "assets/cm${random.nextInt(10)}.jpeg",
//    "status": "Anything could be here",
//    "avatar": "Anything could be here",
//    "avatarUrl": "Anything could be here",
////  "isAccept": random.nextBool(),
//  });
  ContactListModel contactNotifier;
  List contacts = [];
  bool sortByLastSeen = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactNotifier = Provider.of<ContactListModel>(context);
    if (socketProviderContactListModel != contactNotifier) {
      socketProviderContactListModel = contactNotifier;
      Future.microtask(() {
        print(13);
        socketProviderContactListModel.getContactList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (socketProviderConversationListModel == null) {
      var info = Provider.of<ConversationListModel>(context, listen: false);
      socketProviderConversationListModel = info;
    }

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('New Message'),
          ],
        ),
        actions: [
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
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: _width,
                    child: _buildMenus(context),
                  ),
                  Container(
                    height: 30,
                    width: _width,
                    color: Colors.black12,
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sorted by ${sortByLastSeen ? 'last seen time' : 'name'}',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildBody(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 构建主页面
    );
  }

  Widget _buildBody(context) {
    return Consumer<ContactListModel>(
      builder: (BuildContext context, ContactListModel contactListModel,
          Widget child) {
        var friends = contactListModel.contactList;
        contacts = friends;
        return memberArray();
      },
    );

//    print('chats: $chats');
  }

  // 构建菜单项
  Widget _buildMenus(context) {
    var addPeople = Provider.of<AddPeopleModel>(context, listen: false);
    return ListView(
      children: <Widget>[
        ListTile(
            leading: const Icon(Icons.group),
            title: Text('New Group'),
            onTap: () {
              addPeople.reset();
              Navigator.pushNamed(context, "newGroup");
            }),
//        ListTile(
//          leading: const Icon(Icons.lock_outline),
//          title: Text('New Secret Chat'),
//          onTap: () => Navigator.pushNamed(context, "language"),
//        ),
      ],
    );
  }

  Widget memberArray() {
    List myList = List.from(contacts);
    if (myList.length == 0) return SizedBox();
    if (sortByLastSeen) {
      ArrayUtil.sortArray(myList, sortOrder: 0, property: 'lastSeen');
      ArrayUtil.sortArray(myList, sortOrder: 0, property: 'isOnline');
    } else {
      ArrayUtil.sortArray(myList, sortOrder: 1, property: 'firstName');
    }
//    var allMember = <Widget>[];
//    for (var i = 0; i < myList.length; i++) {
//      var item = Container(
////        height: 80,
//        child: _buildDefineMembers(myList[i]),
//      );
//      allMember.add(item);
//    }
    return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return _buildDefineMembers(myList[index]);
        }
//      spacing: 8.0, // gap between adjacent chips
//      runSpacing: 4.0, // gap between lines
//      children: <Widget>[...allMember],
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
//          关闭之前聊天记录
        socketProviderConversationListModel.resetChatHistory();
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
// 即使聊天列表里有这个单人聊天，但是可能还没创建好groupId
        if (groupId != 0) {
          SocketIoEmit.clientGetGroupMessage(
            groupId: groupId,
          );
        } else {
          socketProviderConversationListModel.getConversationList(
              groupId: groupId, contactId: friend['contactId']);
        }
        Navigator.of(context).pushNamed("conversation");
      },
      child: Padding(
        padding: EdgeInsets.only(left: 0),
//      padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.only(right: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
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
                              : '${TimeUtil.lastSeen(friend['lastSeen'])}',
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
              ),
            ),
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
}
