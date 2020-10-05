import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../index.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:swipedetector/swipedetector.dart';

bool isOnShowGroupInfoPage = false;
BuildContext showGroupInfoContext;
// 默认进入群或者 个人信息详情页面，为初始0
int countGroupInfo = 0;
//  详情信息对应 数组下标 countGroupInfoArr[countGroupInfo]
List countGroupInfoArr = [];

class ShowGroupInfoRoute extends StatefulWidget {
  final bool showBigImage;
  final bool personFromGroup;

  ShowGroupInfoRoute({
    this.showBigImage,
    this.personFromGroup,
  });

  @override
  _ShowGroupInfoRouteState createState() => _ShowGroupInfoRouteState();
}

class _ShowGroupInfoRouteState extends State<ShowGroupInfoRoute>
    with SingleTickerProviderStateMixin, RouteAware {
  ScrollController _scrollController = ScrollController();
  double kExpandedHeight = 150;
  double smallAvatarSize = 40;

  bool showBigAvatar = false;
  bool showAvatar = false;

  double touchY = 0;
  double touchYMoveStart = 0;
  double touchYMoveEnd = 0;
  double theFirstTouch = 0;
  bool theFirstTouchBeforeIsBig = false;

//  是否获取过群成员
  bool isSendGetMembers = false;
  List groupMember;

  FloatingPosition floatingPosition = FloatingPosition(right: 16.0);
  double topScalingEdge = 96.0;
  TabController _tabController;
  List tabs = [
    {'id': 1, 'name': 'Members'}
  ];
  var _selectedTab;

  bool hasAvatar = false;
  BuildContext pageContext;
  var conversation;
  var conversionInfo;

  bool loadingLargeAvatar = false;

  var avatarW;
  var gAvatar;
  var photoType = 'local';
  int pageCountGroupInfo;
  bool canMoveDown = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    logger.d(123);
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void initState() {
    logger.d(backingRoute);
    conversionInfo = chatInfoModelSocket.conversationInfo;
//    如果是从群详情页面 点击某人，则要传 personFromGroup = true;
    if (widget.personFromGroup == true) {
      countGroupInfo += 1;
      countGroupInfoArr.add(Map<String, dynamic>.from(conversionInfo));
    } else {
//      从对话框进来，要重置
      countGroupInfo = 0;
      countGroupInfoArr = [];
      countGroupInfoArr.add(Map<String, dynamic>.from(conversionInfo));
    }
    pageCountGroupInfo = countGroupInfo;
//    logger.d(countGroupInfoArr);
//    logger.d(pageCountGroupInfo);
    isOnShowGroupInfoPage = true;
    showBigAvatar = widget.showBigImage;
    if (showBigAvatar) {
      kExpandedHeight = 350;
      getLargeAvatar();
    } else {
      kExpandedHeight = 150;
    }
    _scrollController.addListener(() {
//      print(_scrollController.offset);
//      setState(() {
//        if (_scrollController.offset < 130) {
//          showAvatar = false;
//        } else {
//          showAvatar = true;
//        }
//      });
    });
    if (chatInfoModelSocket.conversationInfo['groupType'] == 1) {
      tabs = [
        {'id': 1, 'name': 'Members'},
        {'id': 2, 'name': 'Media'},
        {'id': 3, 'name': 'Files'},
        {'id': 4, 'name': 'Links'},
        {'id': 5, 'name': 'Voice Messages'},
        {'id': 6, 'name': 'GIFs'},
      ];
    } else {
      tabs = [
        {'id': 2, 'name': 'Media'},
        {'id': 3, 'name': 'Files'},
        {'id': 4, 'name': 'Links'},
        {'id': 5, 'name': 'Voice Messages'},
        {'id': 6, 'name': 'GIFs'},
        {'id': 7, 'name': 'Groups'},
      ];
    }
    _selectedTab = tabs.length > 0 ? tabs[0] : null;
    _tabController = TabController(length: tabs.length, vsync: this);
//    _tabController.index = 1;
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    //为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    _tabController.dispose();
    isOnShowGroupInfoPage = false;
    super.dispose();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    logger.d(1);
  }

  @override
  Widget build(BuildContext context) {
    showGroupInfoContext = context;
    pageContext = context;
    var conversion = Provider.of<ConversationListModel>(context);
    socketGroupMemberModel = Provider.of<GroupMemberModel>(context);
//    从群信息 点击查看群成员信息
//    if (widget.personFromGroup == true) {
//      conversionInfo = conversion.viewGroupInfo;
//    } else {
//      conversionInfo = conversion.conversationInfo;
//    }

    var chatInfo = Provider.of<ChatInfoModel>(context);
    conversionInfo = chatInfo.conversationInfo;
    groupMember = socketGroupMemberModel.groupMember;

    if (conversionInfo['fileCompressUrl'] != null &&
        conversionInfo['fileCompressUrl'] != '') {
      hasAvatar = true;
    }
    return Consumer<GroupMemberModel>(builder: (BuildContext context,
        GroupMemberModel groupMemberModel, Widget child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Listener(
              onPointerUp: (PointerEvent details) => _onPointerUp(details),
              onPointerDown: (PointerEvent details) {
                _onPointerDown(details);
              },
              onPointerMove: (PointerEvent details) {
                _onPointerMove(details, hasAvatar);
              },
              child: CustomScrollView(
                key: PageStorageKey('showGroupInfo'),
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
//                  physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  //AppBar，包含一个导航栏
                  showSliverAppBar(),
                  showGroupInfo(),
                  showPerson(),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.black12,
                      height: 15,
                    ),
                  ),
                  showOtherInfo(),
                ],
              ),
            ),
            _buildFloatIcon(),
          ],
        ),
      );
    });
//    return WillPopScope(
//      onWillPop: () async {
//        if (widget.personFromGroup == true) {
////          如果是从详情页面进来的，返回的时候，要将当前信息删除
//          countGroupInfo -= 1;
//          countGroupInfoArr.removeAt(pageCountGroupInfo);
//          chatInfo.updateInfo(countGroupInfoArr[pageCountGroupInfo - 1]);
////          conversion.updateInfo({
////            'groupId': widget.groupId,
////            'groupType': widget.groupType,
////            'contactId': widget.contactId,
////            'groupName': widget.groupName,
////            'username': widget.username,
////            'fileCompressUrl': widget.fileCompressLocal != ''
////                ? widget.fileCompressLocal
////                : widget.fileCompressUrl,
////            'isOnline': widget.isOnline,
////            'newChatNumber': widget.newChatNumber,
////            'content': widget.content,
////            'createdDate': widget.createdDate,
////            'groupMembers': widget.groupUserLength,
////          });
//        }
//        return true;
//      },
//      child: ,
//    );
  }

  Widget showSliverAppBar() {
    bool isContact = conversionInfo['contactSqlId'] == null ? false : true;
    avatarW = AvatarWidget(
      avatarUrl: conversionInfo['fileCompressUrl'],
      avatarLocal: conversionInfo['fileCompressLocal'],
      firstName: conversionInfo['firstName'],
      lastName: conversionInfo['lastName'],
      width: smallAvatarSize,
      height: smallAvatarSize,
      colorId: conversionInfo['colorId'],
    );
    if (conversionInfo['avatar'] != 0) {
      if (conversionInfo['fileOriginLocal'] != null &&
          conversionInfo['fileOriginLocal'] != '') {
        gAvatar = Image.file(
          File("${conversionInfo['fileOriginLocal']}"),
          fit: BoxFit.cover,
        );
      } else {
        if (conversionInfo['fileCompressLocal'] != null ||
            conversionInfo['fileCompressLocal'] != '') {
          gAvatar = Image.file(
            File("${conversionInfo['fileCompressLocal']}"),
            fit: BoxFit.cover,
          );
        } else {
          gAvatar = Image.network(
            "${conversionInfo['fileCompressUrl']}",
            fit: BoxFit.cover,
          );
        }
      }
    }
    var onlineText = '';
    if (conversionInfo['groupType'] == 2) {
      if (conversionInfo['isOnline']) {
        onlineText = 'online';
      } else {
        onlineText = TimeUtil.lastSeen(conversionInfo['lastSeen']);
      }
    } else {
      var isMultiple = 'member';
      if (conversionInfo['groupMembers'] > 1) {
        isMultiple = 'members';
      }
      onlineText = '${conversionInfo['groupMembers']} $isMultiple';
      if (conversionInfo['onlineMember'] > 0) {
        onlineText += ', ${conversionInfo['onlineMember']} online';
      }
    }
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0.0,
      expandedHeight: kExpandedHeight,
      flexibleSpace: FlexibleSpaceBar(
//              titlePadding: EdgeInsets.only(top: 20, left: 60),
        titlePadding: EdgeInsets.symmetric(
            vertical: 6.0, horizontal: _horizontalTitlePadding),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!showBigAvatar)
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Container(
                      width: smallAvatarSize,
                      height: smallAvatarSize,
                      constraints: BoxConstraints(
                          maxWidth: smallAvatarSize,
                          maxHeight: smallAvatarSize),
                      decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(smallAvatarSize / 2),
//                                  borderRadius: BorderRadius.all(
//                                    const Radius.circular(8.0),
//                                  shape: BoxShape.circle,
//                                  color: Theme.of(context).primaryColor,
                          ),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius:
                            BorderRadius.circular(smallAvatarSize / 2),
                        child: InkWell(
                          child: avatarW,
                          onTap: () async {
                            showPhotoView();
                          },
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextOneLine(
                        "${conversionInfo['groupName']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "$onlineText",
                        style: TextStyle(
//                                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        background: showBigAvatar
            ? Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  gAvatar,
                  loadingLargeAvatar
                      ? Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              )
            : SizedBox(),
      ),
      actions: <Widget>[
        if (conversionInfo['groupType'] == 1)
          IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              handleClickMenu('edit_group_info');
            },
          ),
        PopupMenuButton(
          onSelected: handleClickMenu,
          icon: Icon(
            Icons.more_vert,
          ),
          itemBuilder: (BuildContext context) {
            if (conversionInfo['groupType'] == 1) {
              return [
                PopupMenuItem(
                  value: 'add_member',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.group_add,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 4),
                          child: Text("Add member"),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete_leave_group',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 4),
                          child: Text("Delete and leave group"),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            } else {
              return [
                if (!isContact)
                  PopupMenuItem(
                    value: 'add_contact',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 4),
                            child: Text("Add to contacts"),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isContact)
                  PopupMenuItem(
                    value: 'edit_contact',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 4),
                            child: Text("Edit contact"),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isContact)
                  PopupMenuItem(
                    value: 'delete_contact',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 4),
                            child: Text("Delete contact"),
                          ),
                        ],
                      ),
                    ),
                  ),
              ];
            }

//            return menuList.map((choice) {
//              return PopupMenuItem(
//                value: choice['value'],
//                child: ListTile(
//                  leading: choice['leading'],
//                  title: Text(choice['text'])
//                ),
//              );
//            }).toList();
          },
        ),
      ],
    );
  }

  showPhotoView() {
    if (hasAvatar) {
      var arg = {
        'imageProvider': conversionInfo['fileCompressUrl'],
        'fileId': conversionInfo['avatar'],
        'tag': 'imageG'
      };
      if (photoType != '') {
        arg = {
          'imageProvider': conversionInfo['fileCompressLocal'],
          'type': photoType,
          'fileId': conversionInfo['avatar'],
          'tag': 'imageG'
        };
      }
      Navigator.of(context).pushNamed('photoView', arguments: json.encode(arg));
    }
  }

  getLargeAvatar() async {
    if (conversionInfo['avatar'] != null && conversionInfo['avatar'] != 0) {
      final dbHelper = DatabaseHelper.instance;
      setState(() {
        loadingLargeAvatar = true;
      });
      FileSql fileInfo = await dbHelper.fileOne(conversionInfo['avatar']);
      if (fileInfo.fileOriginLocal == null || fileInfo.fileOriginLocal == '') {
        var downloadInfo = await Git().saveImageFileOrigin(
          fileInfo.id,
          fileInfo.fileName,
          fileInfo.fileOriginUrl,
        );
        if (downloadInfo['pathUrl'] != null) {
          chatInfoModelSocket.updateInfoProperty(
              'fileOriginLocal', downloadInfo['pathUrl']);
          setState(() {
            loadingLargeAvatar = false;
//            gAvatar = FileImage(File("${downloadInfo['pathUrl']}"));
            gAvatar = Image.file(
              File("${downloadInfo['pathUrl']}"),
//              fit: BoxFit.cover,
            );
          });
          socketProviderChatListModel.getChatList();
        }
      } else {
        setState(() {
          loadingLargeAvatar = false;
          chatInfoModelSocket.updateInfoProperty(
              'fileOriginLocal', "${fileInfo.fileOriginLocal}");
//          gAvatar = FileImage(File("${fileInfo.fileOriginLocal}"));
          gAvatar = Image.file(
            File("${fileInfo.fileOriginLocal}"),
//            fit: BoxFit.cover,
          );
        });
      }
    }
  }

  handleClickMenu(String value) async {
    logger.d(value);
    switch (value) {
      case 'add_member':
        var addPeople = Provider.of<AddPeopleModel>(context, listen: false);
        addPeople.reset();
        Navigator.of(context).pushNamed('addMember');
        break;
      case 'delete_leave_group':
        showDeleteConfirmGroup();
        break;
      case 'edit_group_info':
        setState(() {
          showBigAvatar = false;
          kExpandedHeight = 150;
          smallAvatarSize = 40;
          _scrollController.jumpTo(0);
        });
        Navigator.of(context).pushNamed('editGroupInfo', arguments: {
          "avatarUrl": conversionInfo['fileCompressUrl'],
          "avatarLocal": conversionInfo['fileCompressLocal'],
          "firstName": conversionInfo['firstName'],
          "lastName": conversionInfo['lastName'],
          "colorId": conversionInfo['colorId'],
          "groupId": conversionInfo['groupId'],
          "avatar": conversionInfo['avatar'],
          'description': conversionInfo['description'],
        });
        break;
      case 'add_contact':
        Navigator.of(context).pushNamed('editContact', arguments: {
          "avatarUrl": conversionInfo['fileCompressUrl'],
          "avatarLocal": conversionInfo['fileCompressLocal'],
          "firstName": conversionInfo['firstName'],
          "lastName": conversionInfo['lastName'],
          "colorId": conversionInfo['colorId'],
          "userId": conversionInfo['contactId'],
          "username": conversionInfo['username'],
          "contactSqlId": conversionInfo['contactSqlId'],
          "isAdd": true,
        });
        break;
      case 'edit_contact':
        if (conversionInfo['groupType'] == 2) {
          logger.d(conversionInfo['firstName']);
          Navigator.of(context).pushNamed('editContact', arguments: {
            "avatarUrl": conversionInfo['fileCompressUrl'],
            "avatarLocal": conversionInfo['fileCompressLocal'],
            "firstName": conversionInfo['firstName'],
            "lastName": conversionInfo['lastName'],
            "colorId": conversionInfo['colorId'],
            "userId": conversionInfo['contactId'],
            "username": conversionInfo['username'],
            "contactSqlId": conversionInfo['contactSqlId'],
            "isAdd": false,
          });
        }
        break;
      case 'delete_contact':
        await showDeleteConfirmContact();
        break;
    }
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTab = tabs[_tabController.index];
    });
  }

  // 弹出对话框 删除联系人
  Future<bool> showDeleteConfirmContact() {
    return showDialog<bool>(
      context: showGroupInfoContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete contact"),
          content: Text('Are you sure you want to delete this contact?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.pop(showGroupInfoContext),
            ),
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                showLoading(showGroupInfoContext);
                SocketIoEmit.clientDeleteContacts(
                    contactSqlId: conversionInfo['contactSqlId']);
//                Navigator.pop(pageContext);
              },
            ),
          ],
        );
      },
    );
  }

//  弹出对话框 退出群
  Future<bool> showDeleteConfirmGroup() {
    return showDialog<bool>(
      context: showGroupInfoContext,
      builder: (context) {
        return AlertDialog(
          title: Container(
            child: Row(
              children: [
                avatarW,
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
              text: "${conversionInfo["groupName"]}",
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
              onPressed: () => Navigator.pop(showGroupInfoContext),
            ),
            FlatButton(
              child: Text(
                'DELETE CHAT',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                showLoading(showGroupInfoContext);
                SocketIoEmit.clientDeleteGroupMember(
                  groupId: socketProviderConversationListModelGroupId,
                  memberId: Global.profile.user.userId,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatIcon() {
    if (conversionInfo['groupType'] == 2) {
      final double defaultFabSize = 56.0;
      final double paddingTop = MediaQuery.of(context).padding.top;
      final double defaultTopMargin = kExpandedHeight +
          paddingTop +
          (floatingPosition.top ?? 0) -
          defaultFabSize / 2;

      final double scale0edge = kExpandedHeight - kToolbarHeight;
      final double scale1edge = defaultTopMargin - topScalingEdge;

      double top = defaultTopMargin;
      double scale = 1.0;
      if (_scrollController.hasClients) {
        double offset = _scrollController.offset;
        top -= offset > 0 ? offset : 0;
        if (offset < scale1edge) {
          scale = 1.0;
        } else if (offset > scale0edge) {
          scale = 0.0;
        } else {
          scale = (scale0edge - offset) / (scale0edge - scale1edge);
        }
      }

      return Positioned(
        top: top,
        right: floatingPosition.right,
        left: floatingPosition.left,
        child: Transform(
          transform: Matrix4.identity()..scale(scale, scale),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () => _goToChat(),
            child: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  //阴影
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0)
                ],
              ),
              child: Icon(Icons.textsms, color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget showGroupInfo() {
    var child;
    var description = 'Nothing';
    if (conversionInfo['description'] != null &&
        conversionInfo['description'] != '') {
      description = conversionInfo['description'];
    }
    if (conversionInfo['groupType'] == 1) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'Info',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ),
          Container(
//            height: 60,
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$description',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'description',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
//                Divider(
//                  height: 1,
//                ),
              ],
            ),
          )
        ],
      );
    } else {
      child = SizedBox();
    }
    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget showPerson() {
    var child;
    var bio = 'Nothing';
    if (conversionInfo['bio'] != null) {
      bio = conversionInfo['bio'];
    }
    if (conversionInfo['groupType'] == 2) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'Info',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ),
          Container(
//            height: 60,
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@' + conversionInfo['username'],
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Username',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '$bio',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Bio',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      );
    } else {
      child = SizedBox();
    }
    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget showOtherInfo() {
    var myList = [];
    Widget contentW;
    if (_selectedTab != null && _selectedTab['id'] == 1) {
//      myList = List.from(groupMember);
////      sortChats(myList, sortOrder: 0);
////      logger.d(myList);
//      ArrayUtil.sortArray(myList, sortOrder: 0, property: 'lastSeen');
      contentW = memberArray();
    }

    if (tabs.length > 0) {
      var len = myList.length == 0 ? 1 : myList.length;
      return SliverStickyHeader(
        header: Container(
          height: 60.0,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            tabs: tabs.map((e) => Tab(text: e['name'])).toList(),
          ),
        ),
        sliver: SliverList(
//          delegate: SliverChildBuilderDelegate(
//                (BuildContext context, int index) {
//                  return _buildMembers(myList[index], index);
//            },
//            childCount: len,
//          ),
          delegate: SliverChildListDelegate([
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 140,
              ),
              child: contentW,
//              child: showGroupMember(),
            ),
            SizedBox(),
          ]),
        ),
      );
//      SliverChildBuilderDelegate
//      SliverChildListDelegate
    } else {
      return SliverToBoxAdapter(
        child: Expanded(
          child: SizedBox(
//            height: ,
              ),
        ),
      );
    }
  }

  Widget memberArray() {
    List myList = List.from(groupMember);
    ArrayUtil.sortArray(myList, sortOrder: 0, property: 'lastSeen');
    ArrayUtil.sortArray(myList, sortOrder: 0, property: 'isOnline');
    var allMember = <Widget>[];
    bool isOwner = false;
    for (var i = 0; i < myList.length; i++) {
      if (myList[i]['isOwner']) {
        if (myList[i]['id'] == Global.profile.user.userId) {
          isOwner = true;
        }
        break;
      }
    }
    for (var i = 0; i < myList.length; i++) {
      var item = Container(
//        height: 80,
        child: _buildDefineMembers(myList[i], isOwner),
      );
      allMember.add(item);
    }
    return Wrap(
//      spacing: 8.0, // gap between adjacent chips
//      runSpacing: 4.0, // gap between lines
      children: <Widget>[...allMember],
    );
  }

  Widget _buildDefineMembers(Map friend, bool isOwner) {
    var nameStr = '${friend['firstName']}';
    if (friend['lastName'] != null && friend['lastName'] != '') {
      nameStr += ' ${friend['lastName']}';
    }
    var gAvatar;
    gAvatar = AvatarWidget(
      avatarUrl: friend['fileCompressUrl'],
      avatarLocal: friend['fileCompressLocal'],
      firstName: friend['firstName'],
      lastName: friend['lastName'],
      width: 40,
      height: 40,
      colorId: friend['colorId'],
    );
    var secondaryActions = <Widget>[
      if (isOwner && friend['id'] != Global.profile.user.userId)
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteSlideAction(friend),
        ),
    ];
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          if (friend['id'] != Global.profile.user.userId) {
            _viewPersonInfo(friend);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 0),
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
                    )),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        "${friend['isOwner'] ? 'Owner' : ''}",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 70,
                  child: Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
      secondaryActions: secondaryActions,
//      actions: <Widget>[
//        IconSlideAction(
//          caption: 'Archive',
//          color: Colors.blue,
//          icon: Icons.archive,
////          onTap: () => _showSnackBar('Archive'),
//        ),
//        IconSlideAction(
//          caption: 'Share',
//          color: Colors.indigo,
//          icon: Icons.share,
////          onTap: () => _showSnackBar('Share'),
//        ),
//      ],
//        secondaryActions: <Widget>[
//        IconSlideAction(
//          caption: 'More',
//          color: Colors.black45,
//          icon: Icons.more_horiz,
////          onTap: () => _showSnackBar('More'),
//        ),
//      ]
    );
  }

  _viewPersonInfo(Map friend) {
    countGroupInfoArr[pageCountGroupInfo] = conversionInfo;
    var nameStr = '${friend['firstName']}';
    if (friend['lastName'] != null && friend['lastName'] != '') {
      nameStr += ' ${friend['lastName']}';
    }
    chatInfoModelSocket.updateInfo({
      'groupId': 0,
      'groupType': 2,
      'contactSqlId': friend['contactSqlId'],
      'contactId': friend['contactId'],
      'groupName': nameStr,
      'username': friend['username'],
      'avatar': friend['avatar'],
      'fileCompressUrl': friend['fileCompressUrl'],
      'fileCompressLocal': friend['fileCompressLocal'],
      'fileOriginUrl': friend['fileCompressUrl'],
      'fileOriginLocal': friend['fileCompressLocal'],
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
      'extentBeforeId': conversionInfo['extentBeforeId']
    });
    Navigator.of(context).pushNamed("showGroupInfo", arguments: {
      "showBigImage": false,
      "personFromGroup": true
    }).then((val) {
//      logger.d(val);
//      var chatInfo = Provider.of<ChatInfoModel>(context, listen: false);
//      if (widget.personFromGroup == true) {
////          如果是从详情页面进来的，返回的时候，要将当前信息删除
//        countGroupInfo -= 1;
//        countGroupInfoArr.removeAt(pageCountGroupInfo);
//        chatInfo.updateInfo(countGroupInfoArr[pageCountGroupInfo - 1]);
//      }
//      logger.d(1);
    });
  }

  _goToChat() {
    Map friend = countGroupInfoArr[pageCountGroupInfo];
    var info = chatInfoModelSocket;
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
//    info.updateInfo({
//      'groupId': groupId,
//      'groupType': 2,
//      'contactSqlId': friend['contactSqlId'],
//      'contactId': friend['contactId'],
//      'groupName': fullName,
//      'username': friend['username'],
//      'avatar': friend['avatar'],
//      'fileCompressUrl': friend['fileCompressUrl'],
//      'fileCompressLocal': friend['fileCompressLocal'],
//      'fileOriginUrl': friend['fileCompressUrl'],
//      'fileOriginLocal': friend['fileCompressLocal'],
//      'colorId': friend['colorId'],
//      'isOnline': friend['isOnline'],
//      'lastSeen': friend['lastSeen'],
//      'firstName': friend['firstName'],
//      'lastName': friend['lastName'],
//      'bio': friend['bio'],
//      'newChatNumber': 0,
//      'content': '',
//      'createdDate': friend['lastSeen'],
//      'groupMembers': 2,
//      'onlineMember': 1,
//    });
    if (groupId != 0) {
// 即使聊天列表里有这个单人聊天，但是可能还没创建好groupId
      info.updateInfoProperty('groupId', groupId);
      SocketIoEmit.clientGetGroupMessage(
        groupId: groupId,
      );
    } else {
      socketProviderConversationListModel.getConversationList(
          groupId: groupId, contactId: friend['contactId']);
    }
    Navigator.of(context).pushNamed("conversation");
  }

//  删除群成员
  _deleteSlideAction(friend) {
    SocketIoEmit.clientDeleteGroupMember(
      groupId: socketProviderConversationListModelGroupId,
      memberId: friend['id'],
    );
  }

  _onPointerUp(PointerEvent details) {
    touchYMoveEnd = details.position.dy;
    if (touchYMoveEnd - touchYMoveStart < 50 && showBigAvatar == false) {
      setState(() {
        smallAvatarSize = 40;
        kExpandedHeight = 150;
      });
    }
//          向上移动小于50，并且移动之前是大图，则弹回原来位置
    if (touchYMoveEnd - touchYMoveStart > -140 &&
        0 > touchYMoveEnd - touchYMoveStart &&
        showBigAvatar == true) {
      setState(() {
        kExpandedHeight = 350;
        _scrollController.jumpTo(0);
      });
    }

    //     当页面是显示大图时， 向下移动小于40，则弹回原来位置
    if (touchYMoveEnd - touchYMoveStart > 0 && showBigAvatar == true) {
      setState(() {
        kExpandedHeight = 350;
        _scrollController.jumpTo(0);
      });
    }
  }

  _onPointerDown(PointerEvent details) {
    touchYMoveStart = details.position.dy;
    theFirstTouch = details.position.dy;
    theFirstTouchBeforeIsBig = showBigAvatar;
  }

  _onPointerMove(PointerEvent details, bool hasAvatar) {
    if (backingRoute) return;
//    从小图状态向下移动
    if (details.position.dy - touchYMoveStart > 0 &&
        _scrollController.offset > 0 &&
        showBigAvatar == false) {
      touchYMoveStart = details.position.dy;
    }
//    logger.d('_scrollController.offset ${_scrollController.offset}');
//    从大图状态向下移动，如果在小图时开始触碰屏幕移动变为大图后要重置移动距离为0
//    然后变为大图后，再向下移动
    if (details.position.dy - theFirstTouch > 50 &&
        _scrollController.offset == 0 &&
        showBigAvatar == true &&
        kExpandedHeight >= 350 &&
        theFirstTouch == touchYMoveStart &&
        !theFirstTouchBeforeIsBig) {
      touchYMoveStart = details.position.dy;
    }

    //          向上移动大于50，并且移动之前是大图，则显示小图且跳到0
    if (details.position.dy - touchYMoveStart < -140 && showBigAvatar == true) {
      setState(() {
        showBigAvatar = false;
        kExpandedHeight = 150;
        smallAvatarSize = 40;
        _scrollController.jumpTo(0);
      });
    }
//          在向下移动，且是小图，且是offset是0，则让小图慢慢变大
    if (details.position.dy - touchYMoveStart > 0 &&
        showBigAvatar == false &&
        _scrollController.offset == 0 &&
        hasAvatar) {
      setState(() {
        smallAvatarSize = 40 + ((details.position.dy - touchYMoveStart) / 2);
        kExpandedHeight = 150 + details.position.dy - touchYMoveStart;
      });
    }
    if (details.position.dy - touchYMoveStart > 50 &&
        showBigAvatar == false &&
        _scrollController.offset == 0 &&
        hasAvatar) {
      setState(() {
        showBigAvatar = true;
        kExpandedHeight = 350;
        smallAvatarSize = 40;
        _scrollController.jumpTo(0);
        getLargeAvatar();
      });
    }
    //          在向下移动，且页面显示大图的状态，且是offset是0，则让大图慢慢变大
//    移动距离大于150时，跳转页面到 浏览图片页面
    if (details.position.dy - touchYMoveStart > 0 &&
        showBigAvatar == true &&
        _scrollController.offset == 0 &&
        hasAvatar &&
        kExpandedHeight >= 350) {
      setState(() {
        kExpandedHeight = 350 + details.position.dy - touchYMoveStart;
      });
    }
    if (details.position.dy - touchYMoveStart > 150 &&
        showBigAvatar == true &&
        hasAvatar) {
      setState(() {
        kExpandedHeight = 350;
      });
      showPhotoView();
    }

//    显示小图时，向上移动，恢复图片原来大小
    if (_scrollController.offset > 0) {
      setState(() {
        smallAvatarSize = 40;
      });
    }
//    if (details.position.dy - touchYMoveStart > 0 &&
//        showBigAvatar == false &&
//        _scrollController.offset > 0 &&
//        hasAvatar) {
//      setState(() {
//        smallAvatarSize = 40 + ((details.position.dy - touchYMoveStart) / 2);
//        kExpandedHeight = 150 + details.position.dy - touchYMoveStart;
//      });
//    }
  }

  _onSwipeRight() {
    logger.d('canMoveDown');
  }

  double get _horizontalTitlePadding {
    const kBasePadding = 40.0;
    const kMultiplier = 0.5;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        var p =
            (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier + kBasePadding;
        return p < kBasePadding ? kBasePadding : p;
      }

      // In case 0%-50% of the expanded height is viewed
      var p = (_scrollController.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding;
      return p < kBasePadding ? kBasePadding : p;
    }
    print(kBasePadding);

    return kBasePadding;
  }

//  Widget showGroupMember() {
//    var memberWidget;
//
//    List myList = List.from(groupMember);
//    ArrayUtil.sortArray(myList, sortOrder: 0, property: 'lastSeen');
//    if (conversionInfo['groupType'] == 1) {
//      memberWidget = ListView.separated(
//        shrinkWrap: true,
//        key: PageStorageKey('groupMembers'),
//        padding: EdgeInsets.all(10),
//        separatorBuilder: (BuildContext context, int index) {
//          return Align(
//            alignment: Alignment.centerRight,
//            child: Container(
//              height: 0.5,
//              width: MediaQuery.of(context).size.width / 1.3,
//              child: Divider(),
//            ),
//          );
//        },
//        itemCount: myList.length,
//        itemBuilder: (BuildContext context, int index) {
//          Map friend = myList[index];
//          return _buildMembers(friend, index);
//        },
//      );
//    } else {
//      memberWidget = SizedBox();
//    }
//
//    return memberWidget;
//  }
//
//  Widget _buildMembers(friendObj, index) {
//    Map friend = friendObj;
//    var nameStr = '${friend['firstName']}';
//    if (friend['lastName'] != null && friend['lastName'] != '') {
//      nameStr += ' ${friend['lastName']}';
//    }
//    var gAvatar;
//    gAvatar = AvatarWidget(
//      avatarUrl: friend['fileCompressUrl'],
//      avatarLocal: friend['fileCompressLocal'],
//      firstName: friend['firstName'],
//      lastName: friend['lastName'],
//      width: 40,
//      height: 40,
//      colorId: friend['colorId'],
//    );
//    return Padding(
//      padding: EdgeInsets.only(left: 15),
////      padding: const EdgeInsets.symmetric(horizontal: 8.0),
//      child: Column(
////        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Container(
//            height: 60,
//            child: ListTile(
////              dense: true,
//              contentPadding: EdgeInsets.all(0),
//              leading: Stack(
//                children: <Widget>[gAvatar],
//              ),
//              title: Text(
//                "$nameStr",
//                maxLines: 1,
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//              subtitle: Text(
//                friend['isOnline']
//                    ? 'online'
//                    : friend['lastSeen'] == null || friend['lastSeen'] == ''
//                    ? 'last seen a long time ago'
//                    : 'last seen' + friend['lastSeen'],
//                style: TextStyle(
//                  color: friend['isOnline']
//                      ? Theme.of(context).primaryColor
//                      : null,
//                ),
//                overflow: TextOverflow.ellipsis,
//                maxLines: 1,
//              ),
//              trailing: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(height: 10),
//                  Padding(
//                    padding: EdgeInsets.only(right: 15),
//                    child: Text(
//                      "${friend['isOwner'] ? 'Owner' : ''}",
//                      style: TextStyle(
//                          fontWeight: FontWeight.w300,
//                          fontSize: 14,
//                          color: Theme.of(context).primaryColor),
//                    ),
//                  ),
//
////              SizedBox(height: 5),
//                ],
//              ),
//              onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => TabBarViewDemo()),
//                );
//              },
//            ),
//          ),
//          Align(
//            alignment: Alignment.centerRight,
//            child: Container(
//              height: 1,
//              width: MediaQuery.of(context).size.width - 70,
//              child: Divider(),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
}

///A class representing position of the widget.
///At least one value should be not null
class FloatingPosition {
  ///Can be negative. Represents how much should you change the default position.
  ///E.g. if your widget is bigger than normal [FloatingActionButton] by 20 pixels,
  ///you can set it to -10 to make it stick to the edge
  final double top;

  ///Margin from the right. Should be positive.
  ///The widget will stretch if both [right] and [left] are not nulls.
  final double right;

  ///Margin from the left. Should be positive.
  ///The widget will stretch if both [right] and [left] are not nulls.
  final double left;

  const FloatingPosition({this.top, this.right, this.left});
}
