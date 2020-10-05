import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:convert';

import '../index.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';



int preOffset = 0;
Timer getHistoryTime;
bool emitHistory = false;

var getHistory;
// 保存滚动位置
var saveHistoryTime;
// 首次打开聊天界面，是否已跳转到上次滚动位置
bool hasJumpLastPosition = false;

/// 往上 加载历史数据
/// 是否已加载完 历史数据
bool hasGetHistoryUp = false;
bool hasGetHistoryUpOver = false;

/// 往下 加载新数据
bool hasGetHistoryDown = false;
bool hasGetHistoryDownOver = false;

// 是否还在渲染中
bool afterBuilding = false;

class Conversation extends StatefulWidget {
  final int groupId;
  final int contactId;
  final int groupType;
  final String groupAvatar;
  final String groupName;

//  最后一条消息时间
  final int createdDate;

//   最后一条消息内容
  final String content;
  final bool isOnline;

//   新消息数量
  final int newChatNumber;

  Conversation({
    Key key,
    this.groupId,
    this.contactId,
    this.groupType,
    this.groupAvatar,
    this.groupName,
    this.createdDate,
    this.content,
    this.isOnline,
    this.newChatNumber,
  }) : super(key: key);

//  AudioCoders({localFileSystem})
//      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  StickyHeaderController _stickyHeaderController = StickyHeaderController();
  ScrollController _sliverController = ScrollController();
  double touchY = 0;
  double touchYMoveStart = 0;
  double touchYMoveEnd = 0;
  double theFirstTouch = 0;
  double moveNum = 0;
  bool theFirstTouchBeforeIsBig = false;
  bool showFloatButton = false;

//  群详情 页面过渡动画
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// 是否发送过获取群消息
  bool isSendGroup = false;

//  录音 相关变量
  Recording _recording = new Recording();
  bool _isRecording = false;

//  重置或删除录音
  bool _isResetRecord = true;
  TextEditingController _controllerRecord = new TextEditingController();
  int secondsPassed = 0;
  String recodeTime = '00:00:00';
  Timer recodeTimeout;

//  输入消息变量
  ConversationListModel conversionBox;
  TextEditingController _unameController = TextEditingController();
  FocusNode focusNode1 = new FocusNode();
  String groupName;
  bool isSendConversation = false;
  int lastReadId;

//  image_picker 选择插件 相关变量
  File _image;
  final picker = ImagePicker();
  String _filePath;

//  file_picker 插件
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = new TextEditingController();

  Map<String, dynamic> arguments;

  List colors = Colors.primaries;
  static Random random = Random();

//  int rNum = random.nextInt(18);
  int rNum;
  ConversationListModel conversion;
  var conversionInfo;
  var bottomWidget;
  var avatarW;
  bool showBigImage = false;
  AddPeopleModel addPeople;
  ConnectSocketModel socketConnect;
  String onlineText = '';

  List converList = [];
  bool showCenterSliver = true;
  var goToKey;
  BuildContext pageContext;
  ChatInfoModel chatInfo;

  @override
  void initState() {
    super.initState();
    scrollWidgetList = [];
    //监听滚动事件，打印滚动位置
    _sliverController.addListener(() {
      FloatButtonModel fbModel =
          Provider.of<FloatButtonModel>(context, listen: false);
      if (_sliverController.position.extentBefore < 30) {
        if (fbModel.showFloatButton) {
          fbModel.setButtonState(false);
        }
      }
      _scrollPosition();
    });
  }

  @override
  void dispose() {
    super.dispose();
    preOffset = 0;
    hasGetHistoryUpOver = false;
    hasGetHistoryDownOver = false;
    socketProviderConversationListModelGroupId = null;
//    logger.d(converList.length);
    recodeTimeout?.cancel();
    _sliverController.dispose();

//    if (_isRecording) {
//      AudioRecorder.stop();
//    }
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;
    addPeople = Provider.of<AddPeopleModel>(context, listen: false);
    socketProviderAddPeopleModel = addPeople;
    socketConnect = Provider.of<ConnectSocketModel>(context);

    conversion = Provider.of<ConversationListModel>(context);
    socketProviderConversationListModel = conversion;
    conversionBox = conversion;

    chatInfo = Provider.of<ChatInfoModel>(context);
    conversionInfo = chatInfo.conversationInfo;
    socketProviderConversationListModelGroupId = conversionInfo['groupId'];
    return Consumer<ConversationListModel>(
      builder: (BuildContext context,
          ConversationListModel conversationListModel, Widget child) {
        List conversationList = conversationListModel.conversationList;
        converList = conversationList;
        return GestureDetector(
          onTap: () {
            focusNode1.unfocus();
          },
          child: Scaffold(
            appBar: _buildAppBar(),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: _buildListBox(conversationList),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomAppBar(
                      elevation: 10,
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: _buildBottomInput(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: _floatingActionButton(),
          ),
//            DefaultStickyHeaderController(
//              child:
//            ),
        );
      },
    );
//    return WillPopScope(
//      onWillPop: () async {
////          Navigator.of(context).pushReplacementNamed("main");
////        await _scrollPosition();
//        socketProviderConversationListModelGroupId = null;
//        Navigator.of(context).popUntil((route) => route.isFirst);
//
//        FloatButtonModel fbModel =
//            Provider.of<FloatButtonModel>(context, listen: false);
//        fbModel.setButtonState(false);
//        return true;
//      },
//      child: ,
//    );
  }

  _floatingActionButton() {
    return Consumer<FloatButtonModel>(
      builder: (BuildContext context, FloatButtonModel floatButtonModel,
          Widget child) {
        return Container(
          margin: EdgeInsets.only(bottom: 60),
          width: 40,
          height: 40,
//      color: Colors.blue,
          child: floatButtonModel.showFloatButton
              ? FloatingActionButton(
                  child: Icon(Icons.keyboard_arrow_down),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
//          final double offset =
//              DefaultStickyHeaderController.of(context).stickyHeaderScrollOffset;
//          final double offset =
//              StickyHeaderController().stickyHeaderScrollOffset;
//          _sliverController.animateTo(
//            0.0,
//            duration: Duration(milliseconds: 300),
//            curve: Curves.easeIn,
//          );
                    _getHistoryDown(type: 1);
//                logger.d(_sliverController.position.extentBefore);
//                _sliverController.animateTo(
//                  -_sliverController.position.extentBefore,
//                  duration: Duration(milliseconds: 500),
//                  curve: Curves.easeIn,
//                );
                  },
                )
              : SizedBox(),
        );
      },
    );
  }

  _buildAppBar() {
    rNum = conversionInfo['colorId'];
//    if (isUpdatingConversation) {
//      onlineText = 'Connecting';
//    } else {
//      if (conversionInfo['groupType'] == 2) {
//        if (conversionInfo['isOnline']) {
//          onlineText = 'online';
//        } else {
//          onlineText = TimeUtil.lastSeen(conversionInfo['lastSeen']);
//        }
//      } else {
//        var isMultiple = 'member';
//        if (conversionInfo['groupMembers'] > 1) {
//          isMultiple = 'members';
//        }
//        onlineText = '${conversionInfo['groupMembers']} $isMultiple';
//        if (conversionInfo['onlineMember'] > 0) {
//          onlineText += ', ${conversionInfo['onlineMember']} online';
//        }
////        '${conversionInfo['groupType'] == 2 ? conversionInfo['isOnline'] ? 'Online' : 'Offline' : '${conversionInfo['groupMembers']} members'}'
//      }
//    }
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
//        '${conversionInfo['groupType'] == 2 ? conversionInfo['isOnline'] ? 'Online' : 'Offline' : '${conversionInfo['groupMembers']} members'}'
    }
    avatarW = AvatarWidget(
      avatarUrl: conversionInfo['fileCompressUrl'],
      avatarLocal: conversionInfo['fileCompressLocal'],
      firstName: conversionInfo['firstName'],
      lastName: conversionInfo['lastName'],
      width: 45,
      height: 45,
      colorId: conversionInfo['colorId'],
    );

    if (conversionInfo['fileCompressUrl'] != null &&
        conversionInfo['fileCompressUrl'] != '') {
      showBigImage = true;
    } else {
      showBigImage = false;
    }
    return AppBar(
      elevation: 3,
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 10.0),
            child: InkWell(
              child: avatarW,
              onTap: () {
                Navigator.of(context).pushNamed("showGroupInfo",
                    arguments: {"showBigImage": showBigImage});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextOneLine(
                    "${conversionInfo['groupName']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  socketConnect.socket.connected
                      ? Text(
                          "$onlineText",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        )
                      : Text(
                          "Waiting connecting...",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed("showGroupInfo",
                    arguments: {"showBigImage": false});
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.call,
          ),
          onPressed: () async {

            // Navigator.of(context).pushNamed("callVideo");
            displayIncomingCall('123456');
            // displayOutCall();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.videocam,
          ),
          onPressed: () async {

            Navigator.of(context).pushNamed("callVideo", arguments: {
              "invite": true,
            });
          },
        ),
      ],
    );
  }

  _buildBottomInput() {
    if (_isResetRecord) {
      bottomWidget = Container(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
//                          color: Theme.of(context).accentColor,
              ),
              onPressed: () {
//                            getImage();
//                            getFilePath();
                showAttachmentBottomSheet(context);
              },
            ),
            Flexible(
              child: TextField(
                controller: _unameController,
                focusNode: focusNode1,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).textTheme.title.color,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "Write your message...",
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                ),
                maxLines: null,
              ),
            ),
//                            IconButton(
//                              icon: Icon(
//                                Icons.mic,
////                          color: Theme.of(context).accentColor,
//                              ),
//                              onPressed: () {},
//                            ),
//                            AudioCoders(),
            IconButton(
              icon: Icon(
                Icons.mic,
                color: Theme.of(context).textTheme.title.color,
              ),
              onPressed: () {
                _start();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.send,
//                          color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                var textInput = _unameController.text.trim();
                if (textInput == null || textInput == '') {
                  return;
                }
//              focusNode1.unfocus();
                _unameController.clear();
                sendWordMessage(
                    groupId: conversionInfo['groupId'], textInput: textInput);
              },
            ),
          ],
        ),
      );
    } else {
      bottomWidget = Container(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_isRecording == false)
              IconButton(
                icon: Icon(
                  Icons.delete,
                  //                          color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  _deleteRecode();
                },
              ),
            if (_isRecording == false)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [PlayerWidget(url: _recording.path)],
                ),
              ),
            if (_isRecording == true)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$recodeTime'),
                  ],
                ),
              ),
//                            IconButton(
//                              icon: Icon(
//                                Icons.mic,
////                          color: Theme.of(context).accentColor,
//                              ),
//                              onPressed: () {},
//                            ),
//                            AudioCoders(),
            _isRecording
                ? IconButton(
                    icon: Icon(
                      Icons.pause,
                      color: Theme.of(context).textTheme.title.color,
                    ),
                    onPressed: () {
                      _stop();
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.send,
                      //                          color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      uploadFile(
                          groupId: socketProviderConversationListModelGroupId,
                          filePath: _recording.path,
                          fileDeter: 'audio');
                      _deleteRecode();
                    },
                  ),
          ],
        ),
      );
    }
    return bottomWidget;
  }

  List keyList = [];

  _buildListBox(List conversationList) {
    if (conversationList.length == 0) {
      return SizedBox();
    }
    keyList = [];
//    ArrayUtil.sortArray(conversationList,
//        sortOrder: 0, property: 'createdDate');
    const Key centerKey = ValueKey('second-sliver-list');
    List slivers = <Widget>[];
    List sliversNew = <Widget>[];
    List typeArray = [];
    List typeArrayNew = [];
    int count = 0;
    int countNew = 0;
//    logger.d(conversationList.length);
    List oldList = [];
    List newList = [];
    for (var i = 0; i < conversationList.length; i++) {
      /// 判断是否已经包含最新消息，
      if (conversationList[i]['timestamp'] == conversionInfo['timestamp']) {
        hasGetHistoryDownOver = true;
      }
      if (conversionInfo['extentBeforeId'] == 0) {
        oldList.add(conversationList[i]);
      } else {
        if (conversationList[i]['createdDate'] >
            conversionInfo['extentBeforeId']) {
//          newList.add(conversationList[i]);
          newList.insert(0, conversationList[i]);
        } else {
          oldList.add(conversationList[i]);
        }
      }
    }
    for (var i = 0; i < oldList.length; i++) {
      Map msg = oldList[i];
      if (isFirstMessage(oldList, msg, i)) {
        typeArray.add([]);
        count = count + 1;
      }
      typeArray[count - 1].add(oldList[i]);
    }
//    ArrayUtil.sortArray(newList, sortOrder: 1, property: 'createdDate');
    for (var i = 0; i < newList.length; i++) {
      Map msg = newList[i];
      if (isFirstMessage(newList, msg, i)) {
        typeArrayNew.add([]);
        countNew = countNew + 1;
      }
      typeArrayNew[countNew - 1].add(newList[i]);
    }
    for (var m = 0; m < typeArray.length; m++) {
      if (typeArray[m].length > 0) {
        slivers.add(
            _buildStickyList(typeArray[m], conversationList: conversationList));
      }
    }
    for (var m = 0; m < typeArrayNew.length; m++) {
      if (typeArrayNew[m].length > 0) {
        sliversNew.insert(
            0,
            _buildStickyList(typeArrayNew[m],
                conversationList: conversationList));
      }
    }

//    for (var i = 0; i < conversationList.length; i++) {
//      Map msg = conversationList[i];
//      if (isFirstMessage(conversationList, msg, i)) {
//        typeArray.add([]);
//        count = count + 1;
//      }
//      typeArray[count - 1].add(conversationList[i]);
//    }
//    for (var m = 0; m < typeArray.length; m++) {
//      if (typeArray[m].length > 0) {
//
//        slivers.add(_buildStickyList(typeArray[m],
//            conversationList: conversationList));
//      }
//    }
    return Listener(
      onPointerUp: (PointerEvent details) => _onPointerUp(details),
      onPointerDown: (PointerEvent details) {
        _onPointerDown(details);
      },
      onPointerMove: (PointerEvent details) {
        _onPointerMove(details);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _onNotify,
        child: Scrollbar(
          child: CustomScrollView(
            controller: _sliverController,
//            physics: AlwaysScrollableScrollPhysics(),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            reverse: true,
            center: centerKey,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: !hasGetHistoryDownOver
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          height: 40.0,
                          width: 40.0,
                          child: !hasGetHistoryDownOver
                              ? SizedBox(
                                  width: 30,
                                  height: 30.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.blue),
                                  ),
                                )
                              : SizedBox(),
                        ),
                      )
                    : SizedBox(),
              ),
              ...sliversNew,
              SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
//                  return Container(
//                    alignment: Alignment.center,
//                    color: Colors.green[200 + bottom[index] % 4 * 100],
//                    height: 100 + bottom[index] % 4 * 20.0,
//                    child: Text('Item: ${bottom[index]}'),
//                  );
                    return SizedBox();
                  },
                  childCount: 1,
                ),
              ),
              ...slivers,
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    height: 40.0,
                    width: 40.0,
                    child: !hasGetHistoryUpOver
                        ? SizedBox(
                            width: 30,
                            height: 30.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildStickyList(List list, {centerKey, List conversationList}) {
    bool showAvatar = false;
    int senderId;
    if (list.length > 0) {
      senderId = list[0]['senderId'];
      if (senderId != Global.profile.user.userId &&
          conversionInfo['groupType'] == 1) {
        showAvatar = true;
      }
    }
//    return SliverList(
//      delegate: SliverChildBuilderDelegate(
//            (BuildContext context, int index) {
//          var item = list[index];
////                  logger.d(item);
//          int countIndex;
//          for (var m = 0; m < conversationList.length; m++) {
//            if (item['createdDate'] == conversationList[m]['createdDate'] &&
//                item['timestamp'] == conversationList[m]['timestamp']) {
//              countIndex = m;
//            }
//          }
////              logger.d(countIndex);
//          return _buildItem(conversationList, countIndex,
//              showAvatarParent: showAvatar);
//        },
//        childCount: list.length,
//      ),
//    );
    return SliverStickyHeader(
      controller: _stickyHeaderController,
      sticky: true,
      overlapsContent: true,
      header: _buildStickyHeader(senderId, showAvatar: showAvatar),
      sliver: SliverPadding(
        padding: EdgeInsets.only(left: showAvatar ? 40 : 2),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var item = list[index];
//                  logger.d(item);
              int countIndex;
              for (var m = 0; m < conversationList.length; m++) {
                if (item['createdDate'] == conversationList[m]['createdDate'] &&
                    item['timestamp'] == conversationList[m]['timestamp']) {
                  countIndex = m;
                }
              }
//              logger.d(countIndex);
              return _buildItem(conversationList, countIndex,
                  showAvatarParent: showAvatar);
            },
            childCount: list.length,
          ),
        ),
      ),
    );
  }

  _buildStickyHeader(senderId, {int index, bool showAvatar}) {
    //    var avatarW = widget.isGroup
//        ? widget.isMe
//            ? SizedBox()
//            : widget.showAvatar
//                ? AvatarWidget(
//                    avatarUrl: '',
//                    avatarLocal: '',
//                    firstName: 'firstName',
//                    lastName: 'lastName',
//                    colorId: 0,
//                    width: 36,
//                    height: 36,
//                    fontSize: 16,
//                  )
//                : SizedBox(
//                    width: 36.0,
//                  )
//        : SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: showAvatar
            ? SizedBox(
                height: 36.0,
                width: 36.0,
                child: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  child: Text('$index'),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  _buildItem(List conversationList, int index, {bool showAvatarParent}) {
//    logger.d(index);
    Map msg = conversationList[index];
    var showUsername = false;
    var showAvatar = false;
//    var showAvatarParent = false;
    var showDate = false;
//    if (isFirstMessage(conversationList, msg, index)) {
////      showAvatar = true;
//      showAvatarParent = true;
//    }

    if (isLastMessage(conversationList, msg, index)) {
      showUsername = true;
    }
    if (isLastDate(conversationList, msg, index)) {
      showDate = true;
    }
    afterBuild();
    return ChatBubble(
      callback: callback,
      message: msg['contentType'] == 1 ? msg['content'] : msg['contentUrl'],
      content: msg['content'],
      contentName: msg['contentName'],
      username: msg["username"],
      avatarUrl: msg["avatarUrl"],
      time: msg["createdDate"],
      type: msg['contentType'],
      isMe: msg['isMe'],
      isGroup: conversionInfo['groupType'] == 1,
      replyText: msg["replyText"],
      isReply: msg['isReply'],
      replyName: msg['replyName'],
      isImage: msg['isImage'],
      index: index,
      filePath: msg['filePath'],
      downloading: msg['downloading'] != 0,
      downloadSuccess: msg['downloadSuccess'],
      sending: msg['sending'],
      success: msg['success'],
      isVideo: msg['isVideo'],
      isAudio: msg['isAudio'],
      showUsername: showUsername,
      showAvatar: showAvatar,
      showAvatarParent: showAvatarParent,
      showDate: showDate,
      contentId: msg['contentId'],
      id: msg['id'],
      timestamp: msg['timestamp'],
    );
  }

  void _showMarkedAsDoneSnackbar(bool isMarkedAsDone) {
    if (isMarkedAsDone ?? false)
      scaffoldKey.currentState.showSnackBar(const SnackBar(
        content: Text('Marked as done!'),
      ));
  }

  bool isFirstMessage(List list, Map item, int index) {
    if (list.length <= 1) {
      return true;
    } else {
      // console.log(index);
      // console.log(item);
      if (index >= 1) {
        // console.log(list[index - 1]);
        var senderId = 1;
        var index1 = 1;
        senderId = item['senderId'];
        index1 = list[index - 1]['senderId'];
        if (index1 != senderId) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }
  }

  bool isLastMessage(List list, Map item, int index) {
    if (list.length <= 1) {
      return true;
    } else {
      if (index < list.length - 1) {
        // console.log(list);
        // console.log(index);
        var senderId = 1;
        var index1 = 1;
        senderId = item['senderId'];
        index1 = list[index + 1]['senderId'];
        if (list.length - 1 == index) {
          return true;
        } else if (index1 == senderId) {
          return false;
        } else if (index1 != senderId) {
          return true;
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
  }

  bool isFirstDate(List list, Map item, int index) {
    if (list.length <= 1) {
      return true;
    } else {
      // console.log(index);
      // console.log(item);
      if (index >= 1) {
        var createdDate =
            DateTime.fromMillisecondsSinceEpoch(item['createdDate']).day;
        var preDate =
            DateTime.fromMillisecondsSinceEpoch(list[index - 1]['createdDate'])
                .day;
        // console.log(preDate);
        // console.log(createdDate);
        if (preDate != createdDate) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }
  }

  bool isLastDate(List list, Map item, int index) {
//    logger.d(list);
//    logger.d(item['content']);
//    logger.d(index);
    if (list.length <= 1) {
      return true;
    } else {
      if (index >= 1) {
        if (index == list.length - 1) {
          return true;
        }
        var createdDate =
            DateTime.fromMillisecondsSinceEpoch(item['createdDate']).day;
        var preDate =
            DateTime.fromMillisecondsSinceEpoch(list[index + 1]['createdDate'])
                .day;
        if (preDate != createdDate) {
          return true;
        } else {
          return false;
        }
      } else {
        var createdDate =
            DateTime.fromMillisecondsSinceEpoch(item['createdDate']).day;
        var preDate =
            DateTime.fromMillisecondsSinceEpoch(list[index + 1]['createdDate'])
                .day;
        if (preDate != createdDate) {
          return true;
        } else {
          return false;
        }
//        return false;
      }
    }
  }

  callback(index, property, filePath) {
    conversion.updateListItem(index, property, filePath);
  }

  showAttachmentBottomSheet(context) {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    showFilePicker(FileType.custom, 'camera', context);
                  },
                ),
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Image'),
                    onTap: () =>
                        showFilePicker(FileType.image, 'image', context)),
                ListTile(
                    leading: Icon(Icons.videocam),
                    title: Text('Video'),
                    onTap: () =>
                        showFilePicker(FileType.video, 'video', context)),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text('File'),
                  onTap: () => showFilePicker(FileType.any, 'file', context),
                ),
              ],
            ),
          );
        });
  }

  showFilePicker(FileType fileType, [String other, context]) async {
    Navigator.of(context).pop();
    var file;
    if (other == 'camera') {

      final isPermissionStatusGranted =
      await Git(context).requestCameraPermissions();
      if (!isPermissionStatusGranted) return;
      file = await getCamera(other);
    } else if (other == 'video') {
      final isPermissionStatusGranted =
      await Git(context).requestCameraPermissions();
      if (!isPermissionStatusGranted) return;
      final isPermissionStatusGranted2 =
      await Git(context).requestAudioPermissions(type: 'video');
      if (!isPermissionStatusGranted2) return;
      file = await getCamera(other);
    } else {
//      print('fileType: $fileType');
//    if (fileType == 'custom')

      final isPermissionStatusGranted =
      await Git(context).requestPermissions();
      if (!isPermissionStatusGranted) return;
      _pickingType = fileType;
      await _openFileExplorer();
      file = _path;
    }
    print('file$file');

    if (file == null) return;

//    File file = await FilePicker.getFile(type: fileType);
//    final _picker = ImagePicker();
//    PickedFile file;
//    LostData response;
//    if (fileType == FileType.image) {
////      file = await ImagePicker.pickImage();
//      file =
//          await _picker.getImage(source: ImageSource.gallery, imageQuality: 70);
//    } else {
//      response = await _picker.getLostData();
//    }
//
//    if (file == null) {
//      if (response == null) {
//        return;
//      }
//      if (response.file != null) {
//        setState(() {
//          if (response.type == RetrieveType.video) {
////            _handleVideo(response.file);
//          } else {
////            _handleImage(response.file);
//          }
//        });
//      }
//    } else {
////      chatBloc.dispatch(SendAttachmentEvent(chat.chatId, file, fileType));
////      Navigator.pop(context);
////      GradientSnackBar.showMessage(context, 'Sending attachment..');
//    }
  }

  Future _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      print('_multiPick: $_multiPick');
      if (_multiPick) {
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      } else {
        _paths = null;
        _path = await FilePicker.getFilePath(
            type: _pickingType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      }

      uploadFile(
        groupId: socketProviderConversationListModelGroupId,
        filePath: _path,
      );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  Future getCamera(type) async {
    var pickedFile;
    if (type == 'camera') {
      bool getCamera = await Git(context).requestCameraPermissions();
      if (getCamera) {
        pickedFile = await picker.getImage(source: ImageSource.camera);
      }
    } else if (type == 'video') {
      pickedFile = await picker.getVideo(source: ImageSource.camera);
    }
    print('pickedFile: $pickedFile');
    if (pickedFile != null) {
      setState(() {
        _filePath = pickedFile.path;
        _image = File(pickedFile.path);
        print('_filePath: $_filePath');
        print('_image: $_image');
//        var isImage = false;
//        var isVideo = false;
//        if (type == 'camera') {
//          isImage = true;
//        }
//        if (type == 'video') {
//          isVideo = true;
//        }
        uploadFile(
          groupId: socketProviderConversationListModelGroupId,
          filePath: _filePath,
        );

        return pickedFile;
//      socketInit.emit('msg', json.encode(chatObj));
      });
    }
  }

  uploadFile({groupId, filePath, fileDeter}) {
    final f = File(filePath);
    int sizeInBytes = f.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    print('file path: $filePath');
    print('file size: $sizeInMb MB');
    if (sizeInMb > 1024) {
      // This file is Longer the
      showToast('Please send files up to 1G');
      return;
    }
    final nowStr = DateTime.now();
    final timestamp = nowStr.millisecondsSinceEpoch;
    var dateStr = DateFormat("yyyy-MM-dd").format(nowStr);
    var timeStr = DateFormat("HH:mm:ss").format(nowStr);
    var utcStr = dateStr + 'T' + timeStr + 'Z';
    var isImage = false;
    var isVideo = false;
    var isAudio = false;
    String mimeStr = lookupMimeType(filePath);
    print('mimeStr: $mimeStr');
    if (mimeStr != null) {
      var fileTypeStr = mimeStr.split('/');
      print('file type $fileTypeStr');
      print('file type0 ${fileTypeStr[0]}');
      if (fileTypeStr[0] == 'image') {
        isImage = true;
        print('file isImage ${fileTypeStr[0]}');
      }
      if (fileTypeStr[0] == 'video') {
        isVideo = true;
        print('file isVideo ${fileTypeStr[0]}');
      }
      if (fileTypeStr[0] == 'audio') {
        isAudio = true;
        print('file isAudio ${fileTypeStr[0]}');
      }
    }
    if (fileDeter == 'audio') {
      isAudio = true;
    }
    var chatObj = {
      'content': '',
//                            username: this.userInfo.username,
      'contentType': 2,
      'groupId': groupId,
      'authtoken': Global.profile.token,
      'type': 'clientSendGroupMessage',
      "id": '',
      "createdDate": utcStr,
      "timestamp": timestamp,
      "username": "ham1",
      "contentName": "",
      "replyText": "",
      "isReply": false,
      "replyName": "",
      "isMe": true,
      "isGroup": false,
      "avatarUrl": "http://192.168.60.20:3000/file/file_1589646280592_2.jpg",
      "filePath": filePath,
      "success": false,
      "loading": false,
      "sending": true,
      "isUpload": true,
      "contentUrl": filePath,
      "downloading": false,
      "downloadSuccess": false,
      "isImage": isImage,
      "isVideo": isVideo,
      "isAudio": isAudio,
      "sendName": ''
//                                  Global.profile.user.username
    };
    conversionBox.insertFirst(chatObj);
    var res = Git(context).uploadFile(filePath, chatObj: chatObj).then((value) {
      print('Git back: $value');
    });
  }

  sendWordMessage({groupId, textInput}) async {
    if (converList.length > 0 &&
        converList[0]['timestamp'] != conversionInfo['timestamp']) {
//          socketProviderConversationListModel.resetChatHistory();
      await socketProviderConversationListModel.getConversationList(
//            page: 0,
        groupId: conversionInfo['groupId'],
//          offsetId: conversionInfo['latestMsgId'],
        offsetDate: 0,
        addOffset: 0,
        limit: 40,
        contactId: conversionInfo['contactId'],
        groupType: conversionInfo['groupType'],
        extentAfterId: 0,
        extentBeforeId: 0,
      );
    }
    _resetSavePosition();

    var utcTimestamp = TimeUtil.getUtcTimestamp();
    var chatObj = {
      'type': 'clientSendGroupMessage',
      'authtoken': Global.profile.token,
      "id": 0,
      'groupId': groupId,
      'contactId': conversionInfo['contactId'],
      'senderId': Global.profile.user.userId,
      'sendName': Global.profile.user.firstName,
      'messageId': 0,
      "createdDate": utcTimestamp,
      'timestamp': utcTimestamp,
      'content': textInput,
      'contentType': 1,
      "contentName": "",
      'sending': true,
      "replyText": "",
      "isReply": false,
      "replyName": "",
      "replyId": 0,
      "isMe": true,
      "isGroup": false,
      "avatarUrl": "",
      "filePath": '',
      "success": false,
      "loading": false,
      "isUpload": true,
      "contentUrl": '',
      "downloading": false,
      "downloadSuccess": false,
      "isImage": false,
      "isVideo": false,
      "isAudio": false,
    };

    socketProviderConversationListModel.insertFirst(chatObj);
//    socketProviderChatListModel.updateItem(chatObj['groupId'], chatObj);
    var dbHelper = DatabaseHelper.instance;
    if (groupId == 0) {
//    2 本地创建 groupUser, 会话表会增加一个与此人的会话
      await dbHelper.groupUserMerge([
        'id',
        'groupId',
        'messageId',
        'deleteChat',
        'timestamp',
      ], [
        'userId',
        'contactId',
      ], [
        0,
        0,
        0,
        1,
        utcTimestamp,
      ], [
        Global.profile.user.userId,
        chatObj['contactId']
      ]);
//    3 本地创建 groupMessage， 从会话页面进入时，查询所有未发送的消息
      var groupMessageInsert = GroupMessageSql(
        id: 0,
        groupId: groupId,
        senderId: Global.profile.user.userId,
        createdDate: chatObj['createdDate'],
        content: chatObj['content'],
        contentName: chatObj['contentName'],
        contentType: chatObj['contentType'],
        contentId: chatObj['contentId'],
        contactId: chatObj['contactId'],
        replyId: chatObj['replyId'],
        timestamp: chatObj['timestamp'],
        downloading: 0,
      );
      await dbHelper.groupMessageAdd(groupMessageInsert);
      socketProviderChatListModel.getChatList();

      ///      请求创建一个groupId,再进行发送消息，服务端
      SocketIoEmit.clientCreateGroup(
        groupType: 2,
        groupUserArr: [Global.profile.user.userId, chatObj['contactId']],
        groupName: '',
        groupAvatar: '',
        avatar: 0,
      );
    } else {
      await dbHelper.groupUserMerge([
        'messageId',
        'timestamp',
        'contactId',
      ], [
        'userId',
        'groupId',
      ], [
        0,
        utcTimestamp,
        conversionInfo['contactId'],
      ], [
        Global.profile.user.userId,
        groupId
      ]);
//    本地创建 groupMessage， 从会话页面进入时，查询所有未发送的消息
      var groupMessageInsert = GroupMessageSql(
        id: 0,
        groupId: groupId,
        senderId: Global.profile.user.userId,
        createdDate: chatObj['createdDate'],
        content: chatObj['content'],
        contentName: chatObj['contentName'],
        contentType: chatObj['contentType'],
        contentId: chatObj['contentId'],
        replyId: chatObj['replyId'],
        timestamp: chatObj['timestamp'],
        downloading: 0,
      );
      await dbHelper.groupMessageAdd(groupMessageInsert);
//      var updateObj = {
//        'senderId': Global.profile.user.userId,
//        'sendName': Global.profile.user.firstName,
//        'createdDate': chatObj['createdDate'],
//        'content': chatObj['content'],
//        'contentName': chatObj['contentName'],
//        'contentType': chatObj['contentType'],
//        'timestamp': chatObj['timestamp'],
//        'sending': true,
//        'messageId': chatObj['id'],
//      };
      socketProviderChatListModel.updateItemPropertyMultiple(groupId, chatObj);
//      _sliverController.jumpTo(-140);
//      logger.d(keyList[keyList.length - 1]['id']);
      SocketIoEmit.messageSend(
        groupId: chatObj['groupId'],
        contactId: chatObj['contactId'],
        timestamp: chatObj['timestamp'],
        createdDate: chatObj['createdDate'],
        contentType: chatObj['contentType'],
        content: chatObj['content'],
        contentName: chatObj['contentName'],
        replyId: chatObj['replyId'],
      );
    }

    logger.d(_sliverController.position.extentBefore);
    final double offset = _stickyHeaderController.stickyHeaderScrollOffset;
    logger.d(offset);
    _sliverController.jumpTo(-offset);
//    _sliverController.animateTo(
//      -offset,
//      duration: Duration(milliseconds: 1000),
//      curve: Curves.fastLinearToSlowEaseIn,
//    );
//    _stickyHeaderController.stickyHeaderScrollOffset(0.0);
//    _sliverController.jumpTo(-_sliverController.position.extentBefore);
  }

  void _clearCachedFiles() {
    FilePicker.clearTemporaryFiles().then((result) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  _start() async {
    try {
      var filePath;
      String path;
//      print('isPermissionStatusGranted: $isPermissionStatusGranted');
      bool isPermissionStatusGranted = await AudioRecorder.hasPermissions;
      if (isPermissionStatusGranted) {
        logger.d(_recording.path);
//        if (_recording.path != null && _recording.path != "") {
//
////        Directory appDocDirectory = await getApplicationSupportDirectory();
//          var appDocDirectory = await Git().getSaveDirectory();
//          logger.d(appDocDirectory.path);
//        path = appDocDirectory.path +
//            '/' +
//            DateTime.now().millisecondsSinceEpoch.toString() +
//            '.aac';
////          path = appDocDirectory.path +
////              '/' + _recording.path;
//          print("Start recording: $path");
//          await AudioRecorder.start(
//            path: path,
////          audioOutputFormat: AudioOutputFormat.AAC,
//          );
//        } else {
//          await AudioRecorder.start();
//        }

//        Directory libd = await getLibraryDirectory();
//        logger.d((await getApplicationSupportDirectory()).path);
//
//        logger.d(libd.path);
//        if (libd.path != null) {
//
//          var dirPreAll = libd.path + '/Dog/';
//          bool exists = await Directory(dirPreAll).exists();
//          if (!exists) {
//            await new Directory(dirPreAll).create();
//          }
//        }
        var appDocDirectory;
//        if (Platform.isIOS) {
//          appDocDirectory = await getLibraryDirectory();
//        } else {
//          appDocDirectory = await Git().getSaveDirectory(type: 'lib');
//        }
        appDocDirectory = await Git().getSaveDirectory(type: 'lib');
        logger.d(appDocDirectory.path);
        var dirPreAll = appDocDirectory.path + '/Dog/';
//        var dirPreAll = libd.path + '/Dog/';
        bool exists = await Directory(dirPreAll).exists();
        if (!exists) {
          await new Directory(dirPreAll).create();
        }
        path = dirPreAll +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.aac';
//          path = appDocDirectory.path +
//              '/' + _recording.path;
        print("Start recording: $path");
        await AudioRecorder.start(
          path: path,
          audioOutputFormat: AudioOutputFormat.AAC,
        );
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
          _isResetRecord = false;
        });
        const tick = const Duration(milliseconds: 1000);
        recodeTimeout = Timer.periodic(tick, (Timer t) async {
          if (_isRecording == false) {
            t.cancel();
          }
          secondsPassed = secondsPassed + 1;
          int seconds = secondsPassed % 60;
          int minutes = secondsPassed % (60 * 60) ~/ 60;
          int hours = secondsPassed ~/ (60 * 60);
          var h = hours.toString().padLeft(2, '0');
          var m = minutes.toString().padLeft(2, '0');
          var s = seconds.toString().padLeft(2, '0');
          setState(() {
            recodeTime = h + ':' + m + ':' + s;
          });
        });
      } else {
//        showToast('You must accept audio permissions');

        final isPermissionStatusGranted =
        await Git(context).requestAudioPermissions();
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = File(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
      secondsPassed = 0;
      recodeTime = '00:00:00';
    });
//    _controllerRecord.text = recording.path;
  }

  _deleteRecode() async {
    bool isRecording = await AudioRecorder.isRecording;
    if (isRecording) {
      AudioRecorder?.stop();
    }
    print('isRecording: $isRecording');
    var recodePath = _recording.path;
    print('recodePath: $recodePath');
    setState(() {
      _isResetRecord = true;
      _isRecording = false;
      secondsPassed = 0;
      recodeTime = '00:00:00';
    });
  }

  afterBuild() {
    if (hasJumpLastPosition || hasGetHistoryUp) return;
    const timeout = Duration(milliseconds: 10);
    getHistory?.cancel();
    getHistory = Timer.periodic(timeout, (Timer t) async {
      getHistory?.cancel();
      if (!hasJumpLastPosition) {
//        logger.d('jumpafterBuild');
        hasJumpLastPosition = true;
        _sliverController.jumpTo(conversionInfo['extentBefore']);
        if (conversionInfo['extentBefore'] == 0) {
          _resetSavePosition();
        } else {
          _scrollPosition();
        }
//        _getHistoryUp();
//        _getHistoryDown();
      }
    });
  }

//  保存滚动位置
  _scrollPosition() async {
    const timeout = Duration(milliseconds: 30);
    saveHistoryTime?.cancel();
    saveHistoryTime = Timer(timeout, () {
//      logger.d('key len ${scrollWidgetList.length}');
      var scrollArr = [];
      double positionMax = 0;
      double maxHeight = 850;
      var positionMaxItem;
      for (var s = 0; s < scrollWidgetList.length; s++) {
        if (scrollWidgetList[s]['key']?.currentContext != null) {
          scrollArr.add(scrollWidgetList[s]['id']);
          RenderBox renderBoxRed =
              scrollWidgetList[s]['key']?.currentContext?.findRenderObject();
          var positionsRed = renderBoxRed?.localToGlobal(Offset(0, 0));
          if (positionMax < positionsRed.dy && maxHeight >= positionsRed.dy) {
            positionMax = positionsRed.dy;
            positionMaxItem = {
              "key": scrollWidgetList[s]['key'],
              "id": scrollWidgetList[s]['id'],
              "dy": positionsRed.dy,
              "height": scrollWidgetList[s]['height'],
              "createdDate": scrollWidgetList[s]['createdDate'],
              "timestamp": scrollWidgetList[s]['timestamp'],
            };
          }
        }
      }
//      logger.d(scrollArr.join(','));
//      logger.d(scrollArr.length);
//      logger.d(positionMax);
//      logger.d(positionMaxItem['id']);
      if (positionMaxItem == null) {
        _resetSavePosition();
        return;
      }
      _savePosition(positionMaxItem);
    });
  }

  _savePosition(Map<String, dynamic> positionMaxItem) async {
    int extentAfterId = 0;
    double extentAfter = 0;
//      int extentBeforeId = converList.length > 0 ? converList[0]['id'] : 0;
    int extentBeforeId = 0;
    double extentBefore = 0;
//    extentBeforeId = positionMaxItem['id'];
    /// 由 保存id 转到 time
    extentBeforeId = positionMaxItem['createdDate'];
    extentBefore = positionMaxItem["dy"] -
        MediaQuery.of(context).size.height +
        48 +
        positionMaxItem["height"];
//    if (extentBeforeId == conversionInfo['latestMsgId']) {
//      extentBeforeId = 0;
//    }
//    logger.d(extentBeforeId);
    if (extentBeforeId == conversionInfo['latestMsgTime']) {
      extentBeforeId = 0;
    }
    if (extentBefore < 30) {
      extentBefore = 0;
      extentBeforeId = 0;
    }
    chatInfoModelSocket.saveChatPosition(
      groupId: conversionInfo['groupId'],
      contactId: conversionInfo['contactId'],
      extentAfter: extentAfter,
      extentBefore: extentBefore,
      extentAfterId: extentAfterId,
      extentBeforeId: extentBeforeId,
    );
    Map<String, dynamic> saveInfo = {
      "extentAfter": extentAfter,
      "extentBefore": extentBefore,
      "extentAfterId": extentAfterId,
      "extentBeforeId": extentBeforeId,
    };
    // logger.d(saveInfo);
    socketProviderChatListModel.updateItemPropertyMultiple(
      conversionInfo['groupId'],
      saveInfo,
      contactId: conversionInfo['contactId'],
    );
  }

  _resetSavePosition() {
    double extentAfter = 0;
    double extentBefore = 0;
    int extentAfterId = 0;
    int extentBeforeId = 0;
    chatInfoModelSocket.saveChatPosition(
      groupId: conversionInfo['groupId'],
      contactId: conversionInfo['contactId'],
      extentAfter: extentAfter,
      extentBefore: extentBefore,
      extentAfterId: extentAfterId,
      extentBeforeId: extentBeforeId,
    );
    Map<String, dynamic> saveInfo = {
      "extentAfter": extentAfter,
      "extentBefore": extentBefore,
      "extentAfterId": extentAfterId,
      "extentBeforeId": extentBeforeId,
    };
    socketProviderChatListModel.updateItemPropertyMultiple(
      conversionInfo['groupId'],
      saveInfo,
      contactId: conversionInfo['contactId'],
    );
    chatInfoModelSocket.updateInfoPropertyMultiple({
      "extentAfter": extentAfter,
      "extentBefore": extentBefore,
      "extentAfterId": extentAfterId,
      "extentBeforeId": extentBeforeId,
    });
    logger.d(saveInfo);
  }

  bool _onNotify(ScrollNotification notification) {
    double left =
        notification.metrics.maxScrollExtent - notification.metrics.pixels;
    if (hasJumpLastPosition) {
      if (left < 200) {
        _getHistoryUp();
      } else if (_sliverController.position.extentBefore < 200) {
        _getHistoryDown();
      }
    }
    return true;
  }

  _getHistoryUp() {
    if (!hasGetHistoryUp && !hasGetHistoryUpOver) {
      hasGetHistoryUp = true;
      int offsetDate = converList[converList.length - 1]['createdDate'];
//      for (var i = 0; i < converList.length; i++) {
//        if (i == 0) {
//          offsetDate = converList[i]['createdDate'];
//        } else {
//          if (converList[i]['createdDate'] < offsetDate) {
//            offsetDate = converList[i]['createdDate'];
//          }
//        }
//      }
      if (offsetDate != preOffset) {
        preOffset = offsetDate;
        socketProviderConversationListModel.getConversationList(
          page: 1,
          groupId: conversionInfo['groupId'],
//          offsetId: minId,
          offsetDate: offsetDate,
          addOffset: 0,
          contactId: conversionInfo['contactId'],
          groupType: conversionInfo['groupType'],
        );
//        const timeout = Duration(milliseconds: 2000);
//        Timer(timeout, () {
//          preOffset = 0;
//        });
//        getHistoryTime?.cancel();
//        getHistoryTime = Timer(timeout, () {
//          logger.d('11111111111111111111111111111111111111');
//        });
      }
    }
  }

  _getHistoryDown({int type}) async {
    FloatButtonModel fbModel =
        Provider.of<FloatButtonModel>(context, listen: false);
    if (type == 1) {
      /// 如果没有新消息，到最后一条消息
      hasGetHistoryDown = true;
      fbModel.setButtonState(false);
      _resetSavePosition();
      hasGetHistoryDownOver = true;
      bool sameLast = true;
      if (converList[0]['timestamp'] != conversionInfo['timestamp']) {
        hasGetHistoryUpOver = false;
        sameLast = false;
//          socketProviderConversationListModel.resetChatHistory();
        await socketProviderConversationListModel.getConversationList(
//            page: 0,
          groupId: conversionInfo['groupId'],
//          offsetId: conversionInfo['latestMsgId'],
          offsetDate: 0,
          addOffset: 0,
          limit: 40,
          contactId: conversionInfo['contactId'],
          groupType: conversionInfo['groupType'],
          extentAfterId: 0,
          extentBeforeId: 0,
        );
      }
      hasGetHistoryDown = false;
//      await Future.delayed(Duration(milliseconds: 30));
//      _sliverController.position
//          .jumpTo(-_sliverController.position.extentBefore);

//      final double offset =
//          _stickyHeaderController.stickyHeaderScrollOffset;
//      logger.d(offset);
      _sliverController.position
          .jumpTo(-_sliverController.position.extentBefore);
//      _sliverController.animateTo(
//        -offset,
//        duration: Duration(milliseconds: 1000),
//        curve: Curves.ease,
//      );
      if (!sameLast) {
        await Future.delayed(Duration(milliseconds: 1000));
        socketProviderConversationListModel.removeRangeList(
            40, converList.length);
      }
    } else if (type == 2) {
      /// 如果有新消息，就到新消息的事件最小一个地方

    } else {
      if (!hasGetHistoryDown && !hasGetHistoryDownOver) {
        int offsetDate = converList[0]['createdDate'];
        if (offsetDate != preOffset) {
          hasGetHistoryDown = true;
          preOffset = offsetDate;
          socketProviderConversationListModel.getConversationList(
            page: 1,
            groupId: conversionInfo['groupId'],
//              offsetId: converList[0]['id'],
            offsetDate: offsetDate,
            addOffset: -40,
            limit: 40,
            contactId: conversionInfo['contactId'],
            groupType: conversionInfo['groupType'],
          );
        }
      }
    }
  }

  _onPointerUp(PointerEvent details) {
    FloatButtonModel fbModel =
        Provider.of<FloatButtonModel>(context, listen: false);
    if (_sliverController.position.extentBefore < 30) {
      if (fbModel.showFloatButton) {
        fbModel.setButtonState(false);
      }
    }
  }

  _onPointerDown(PointerEvent details) {
    touchYMoveStart = details.position.dy;
    theFirstTouch = details.position.dy;
  }

  _onPointerMove(PointerEvent details) {
    FloatButtonModel fbModel =
        Provider.of<FloatButtonModel>(context, listen: false);
    if (details.position.dy - touchYMoveStart < moveNum && moveNum > 0) {
      touchYMoveStart = details.position.dy;
      theFirstTouch = details.position.dy;
    } else if (moveNum < 0 && details.position.dy - touchYMoveStart > moveNum) {
      touchYMoveStart = details.position.dy;
      theFirstTouch = details.position.dy;
    }
    moveNum = details.position.dy - touchYMoveStart;
    if (moveNum < -60) {
      if (!fbModel.showFloatButton &&
          _sliverController.position.extentBefore > 0) {
        fbModel.setButtonState(true);
//        setState(() {
//          showFloatButton = true;
//        });
      }
    } else if (moveNum > 60) {
      if (fbModel.showFloatButton) {
        fbModel.setButtonState(false);
//        setState(() {
//          showFloatButton = false;
//        });
      }
    } else if (_sliverController.position.extentBefore < 30) {
      if (fbModel.showFloatButton) {
        fbModel.setButtonState(false);
      }
    }
  }
}
