import 'dart:io';
import 'dart:math';
import 'dart:convert';

import '../index.dart';

bool isOnAddMemberPage = false;
BuildContext addMemberContext;

class AddMemberRoute extends StatefulWidget {
  @override
  _AddMemberRouteState createState() => _AddMemberRouteState();
}

class _AddMemberRouteState extends State<AddMemberRoute> {
  @override
  void initState() {
    super.initState();
    isOnAddMemberPage = true;
  }

  @override
  void dispose() {
    super.dispose();
    isOnAddMemberPage = false;
    addMemberContext = null;
  }

  @override
  Widget build(BuildContext context) {
    addMemberContext = context;

    var addPeopleArr = Provider.of<AddPeopleModel>(context).addPeopleList;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Add Members'),
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
      floatingActionButton: addPeopleArr.length > 0
          ? FloatingActionButton(
              //悬浮按钮
              child: Icon(Icons.check),
              onPressed: () {
                if (addPeopleArr.length == 0) return;
                showLoading(context);
                SocketIoEmit.clientAddGroupMember(
                  groupId: socketProviderConversationListModelGroupId,
                  memberId: addPeopleArr.map((m)=>m['contactId']).toList(),
                );
              })
          : SizedBox(),
    );
  }

  Widget _buildBody(context) {
    return Consumer<ContactListModel>(
      builder: (BuildContext context, ContactListModel contactListModel,
          Widget child) {
        var friends = contactListModel.contactList;
        List myList = List.from(friends);
        if (myList.length > 0) {
          ArrayUtil.sortArray(myList, property: 'firstName', sortOrder: 1);
        }
        return memberArray(myList);
      },
    );

//    print('chats: $chats');
  }

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

  Widget memberArray(members) {
    List myList = List.from(members);
    ArrayUtil.sortArray(myList, sortOrder: 1, property: 'firstName');

    return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return _buildDefineMembers(myList[index]);
        }
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

  Widget _buildDefineMembers(friendObj) {
    var groupMember = socketGroupMemberModel.groupMember;
    var addPeople = Provider.of<AddPeopleModel>(context);
    var addPeopleList = addPeople.addPeopleList;
    var isInGroup = false;
    bool hasAdd = false;
    var hasAddWidget;

    Map friend = friendObj;

    for (var i = 0; i < groupMember.length; i++) {
      if (groupMember[i]['id'] == friendObj['contactId']) {
        isInGroup = true;
      }
    }
    for (var i = 0; i < addPeopleList.length; i++) {
      if (addPeopleList[i]['contactId'] == friendObj['contactId']) {
        hasAdd = true;
      }
    }
    if (isInGroup) {
      hasAddWidget = Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: Icon(
          Icons.check,
          size: 20,
          color: Colors.white,
        ),
      );
    } else {
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
    }

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
    return Padding(
      padding: EdgeInsets.only(right: 15),
//      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
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
              ),
            ),
            onTap: () {
              if (!isInGroup) {
                if (hasAdd) {
                  addPeople.delete(friend['contactId']);
                } else {
                  addPeople.add(friend);
                }
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 60,
              child: Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
