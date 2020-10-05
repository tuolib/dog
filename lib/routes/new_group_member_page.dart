import 'dart:math';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

class NewGroupPage extends StatefulWidget {
  @override
  _NewGroupPageState createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var addPeopleArr = Provider.of<AddPeopleModel>(context).addPeopleList;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('New Group'),
          ],
        ),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 30.0,
                      maxHeight: 120,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: addPeopleArr.length == 0
                          ? Container(
                              child: Text('Add people...'),
                            )
                          : ListView(
                              children: [
                                _buildSelectPeople(context),
                              ],
                            ),
                    ),
                  ),
                  Divider(
                    height: 2,
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
      floatingActionButton: FloatingActionButton(
          //悬浮按钮
          child: Icon(Icons.arrow_forward),
          onPressed: () {
            if (addPeopleArr.length == 0) return;
            Navigator.pushNamed(context, "newGroupInfo");
          }),
      // 构建主页面
    );
  }

  Widget _buildBody(context) {
    var addPeople = Provider.of<AddPeopleModel>(context, listen: false);
    return Consumer<ContactListModel>(
      builder: (BuildContext context, ContactListModel contactListModel,
          Widget child) {
        var friends = contactListModel.contactList;
        contacts = friends;
        return memberArray();
      },
    );
  }

//  Widget _buildSelectPeople(context) {
//    var addPeople = Provider.of<AddPeopleModel>(context);
//    return Consumer<AddPeopleModel>(
//      builder:
//          (BuildContext context, AddPeopleModel addPeopleModel, Widget child) {
//        var friends = addPeopleModel.addPeopleList;
//        List<Widget> allPeople() {
//          List<Widget> allW = [];
//          for (var i = 0; i < friends.length; i++) {
//            int rNum = random.nextInt(18);
//            Map friend = friends[i];
//            var nameStr = '';
//            var gAvatar;
//            ContactSql user = ContactSql.fromMap(friend);
//            if (user.firstName != null && user.firstName != '') {
//              nameStr += user.firstName.substring(0, 1);
//            }
//            if (user.lastName != null && user.lastName != '') {
//              nameStr += user.lastName.substring(0, 1);
//            }
//            allW.add(InkWell(
//              child: Container(
//                decoration: BoxDecoration(
//                  color: Color.fromRGBO(218, 220, 224, 0.99),
//                  borderRadius: BorderRadius.circular(17.5),
//                ),
//                child: Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: [
//                    gAvatar,
//                    Padding(
//                      padding: EdgeInsets.only(left: 8, right: 8),
//                      child: Text(user.firstName + ' ' + user.lastName),
//                    )
//                  ],
//                ),
//              ),
//              onTap: () {
//                addPeople.delete(user.contactId);
//              },
//            ));
//          }
//          return allW;
//        }
//        return Wrap(spacing: 8, runSpacing: 8, children: allPeople());
//      },
//    );
//
////    print('chats: $chats');
//  }

  Widget _buildSelectPeople(context) {
    var addPeople = Provider.of<AddPeopleModel>(context);
    return Consumer<AddPeopleModel>(
      builder:
          (BuildContext context, AddPeopleModel addPeopleModel, Widget child) {
        var friends = addPeopleModel.addPeopleList;
        List<Widget> allPeople() {
          List<Widget> allW = [];
          for (var i = 0; i < friends.length; i++) {
            Map friend = friends[i];
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
            allW.add(InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(218, 220, 224, 0.99),
                  borderRadius: BorderRadius.circular(17.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    gAvatar,
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: TextOneLine('$nameStr'),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                addPeople.delete(friend['contactId']);
              },
            ));
          }
          return allW;
        }

        return Wrap(spacing: 8, runSpacing: 8, children: allPeople());
      },
    );
  }
  Widget memberArray() {
    List myList = List.from(contacts);
    if (myList.length == 0) return SizedBox();
    ArrayUtil.sortArray(myList, sortOrder: 1, property: 'firstName');
    return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return _buildDefineMembers(myList[index]);
        }
//      spacing: 8.0, // gap between adjacent chips
//      runSpacing: 4.0, // gap between lines
//      children: <Widget>[...allMember],
    );
//    var allMember = <Widget>[];
//    for (var i = 0; i < myList.length; i++) {
//      var item = Container(
////        height: 80,
//        child: _buildDefineMembers(myList[i]),
//      );
//      allMember.add(item);
//    }
//    return Wrap(
////      spacing: 8.0, // gap between adjacent chips
////      runSpacing: 4.0, // gap between lines
//      children: <Widget>[...allMember],
//    );
  }

  Widget _buildDefineMembers(Map friend) {
    var addPeople = Provider.of<AddPeopleModel>(context);
    var addPeopleList = addPeople.addPeopleList;
    var nameStr = '${friend['firstName']}';
    if (friend['lastName'] != null && friend['lastName'] != '') {
      nameStr += ' ${friend['lastName']}';
    }
    var gAvatar;
    bool hasAdd = false;
    var hasAddWidget;
    for (var i = 0; i < addPeopleList.length; i++) {
      if (addPeopleList[i]['contactId'] == friend['contactId']) {
        hasAdd = true;
      }
    }
    if (hasAdd == true) {
      hasAddWidget = Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: Icon(
          Icons.check,
          size: 20,
          color: Colors.white,
        ),
      );
    } else {
      hasAddWidget = SizedBox();
    }
    gAvatar = AvatarWidget(
      avatarUrl: friend['avatarUrl'],
      avatarLocal: friend['avatarLocal'],
      firstName: friend['firstName'],
      lastName: friend['lastName'],
      width: 40,
      height: 40,
      colorId: friend['colorId'],
    );
    return Padding(
      padding: EdgeInsets.only(right: 15),
//      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (hasAdd) {
                addPeople.delete(friend['contactId']);
              } else {
                addPeople.add(friend);
              }
            },
            child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: Stack(
                        children: [
                          gAvatar,
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: hasAddWidget,
                          ),
                        ],
                      ),
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
                )),
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
    );
  }
}
