import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../index.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';

// 滚动时，记录滚动过的widget位置 key
List scrollWidgetList = [];

typedef void OnError(Exception exception);

Timer doStreamTime;
// ignore: must_be_immutable
class ChatBubbleWidget extends StatefulWidget {
  String message,
      username,
      avatarUrl,
      replyText,
      replyName,
      content,
      filePath,
      contentName;
  final int time, type, index;
  bool isMe,
      isGroup,
      isReply,
      isImage,
      downloading,
      downloadSuccess,
      sending,
      success,
      isAudio,
      showUsername,
      showAvatar,
      showDate,
      isVideo,
      showAvatarParent;
  Function callback;
  int contentId;
  int id;
  Function afterBuild;
  int timestamp;
  Color topColor;
  Color bottomColor;
  Color primaryColor;
  // StreamController streamController;

  ChatBubbleWidget({
    this.afterBuild,
    @required this.callback,
    @required this.message,
    @required this.content,
    @required this.time,
    @required this.isMe,
    @required this.isGroup,
    @required this.username,
    this.avatarUrl,
    @required this.showUsername,
    @required this.showAvatar,
    this.showAvatarParent,
    @required this.showDate,
    @required this.type,
    @required this.replyText,
    @required this.isReply,
    @required this.isImage,
    @required this.replyName,
    @required this.index,
    @required this.filePath,
    @required this.downloading,
    @required this.downloadSuccess,
    @required this.contentName,
    @required this.sending,
    @required this.success,
    @required this.isVideo,
    @required this.isAudio,
    this.contentId,
    this.id,
    this.timestamp,
    this.topColor,
    this.bottomColor,
    this.primaryColor,
    // this.streamController,
    Key key,
  }) : super(key: key);

  @override
  ChatBubbleState createState() => ChatBubbleState();
}

class ChatBubbleState extends State<ChatBubbleWidget> with WidgetsBindingObserver {
  ThemeModel themeObj;
  Color topColor;
  Color bottomColor;

//  final exampleAudioFilePath = this.message;
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  Color chatBubbleColor() {
    if (widget.isMe) {
      return Theme.of(context).accentColor;
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Colors.grey[200];
      }
    }
  }

  Color chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[600];
    } else {
      return Colors.grey[50];
    }
  }

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;

  GlobalKey _keyRed = GlobalKey();

  // StreamSubscription streamSubscription;

  Color primaryColor;

  bool shouldAdd = true;
  int addNum = 0;
  @override
  void initState() {
    topColor = widget.topColor;
    bottomColor = widget.bottomColor;
    primaryColor = widget.primaryColor;

    //监听Widget是否绘制完毕
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
    super.initState();
  }

  @override
  void dispose() {
    // logger.d(widget.content);
    scrollWidgetList.removeWhere((item) => item['timestamp'] == widget.timestamp);

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    themeObj = Provider.of<ThemeModel>(context);
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    if (widget.primaryColor == null) {
      primaryColor = themeObj.primaryColor;
    }
    // final radius = widget.isMe
    //     ? BorderRadius.only(
    //         topLeft: Radius.circular(5.0),
    //         bottomLeft: Radius.circular(5.0),
    //         bottomRight: Radius.circular(10.0),
    //       )
    //     : BorderRadius.only(
    //         topRight: Radius.circular(5.0),
    //         bottomLeft: Radius.circular(10.0),
    //         bottomRight: Radius.circular(5.0),
    //       );

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
    var avatarW = SizedBox();
    var dateW = widget.showDate
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  margin: widget.showAvatarParent && widget.isGroup
                      ? EdgeInsets.only(right: 40, top: 4)
                      : EdgeInsets.only(top: 4),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text('${TimeUtil.chatDate(widget.time)}'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                    //3像素圆角
//            boxShadow: [
//              //阴影
//              BoxShadow(
//                  color: Colors.black54,
//                  offset: Offset(2.0, 2.0),
//                  blurRadius: 4.0)
//            ],
                  ),
                ),
              )
            ],
          )
        : SizedBox();
    return Column(
      key: _keyRed,
      crossAxisAlignment: align,
      children: <Widget>[
        dateW,
        Row(
//          crossAxisAlignment: align,
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            avatarW,
            _buildPaint(),
            // _buildNothing(),
          ],
        ),
      ],
    );
  }

  Widget _buildPaint() {
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    // final radius = widget.isMe
    //     ? BorderRadius.only(
    //   topLeft: Radius.circular(5.0),
    //   bottomLeft: Radius.circular(5.0),
    //   bottomRight: Radius.circular(10.0),
    // )
    //     : BorderRadius.only(
    //   topRight: Radius.circular(5.0),
    //   bottomLeft: Radius.circular(10.0),
    //   bottomRight: Radius.circular(5.0),
    // );
    Color paintColor =
        widget.isMe ? themeObj.messagesColor : themeObj.messagesColorSide;
    var alignCorner = widget.isMe ? Alignment.topRight : Alignment.bottomLeft;
    double _radius = themeObj.radius == null ? 16 : themeObj.radius;
    return Consumer<ConversationScrollModel>(
        builder: (BuildContext context,
            ConversationScrollModel conversationScrollModel, Widget child) {

          // print('widget.content: ${widget.content}');
          if (widget.isMe) {
            // print(mounted);
            _setColor();
          }

      return Container(
        margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
        child: CustomPaint(
          painter: ChatCustomCorner(
            color: paintColor,
            alignment: alignCorner,
            showCorner: widget.showAvatar,
            radius: _radius,
            topColor: topColor == null ? paintColor : topColor,
            bottomColor: bottomColor == null ? paintColor : bottomColor,
          ),
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 3, bottom: 3, right: 8, left: 8),
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, right: 2, left: 5),
                  decoration: BoxDecoration(
                    // color: chatBubbleColor(),
                    // color: widget.isMe
                    //     ? themeObj.messagesColor
                    //     : themeObj.messagesColorSide,
                    borderRadius: BorderRadius.circular(_radius),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.3 - 30,
                    minWidth: 20.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: align,
                    children: <Widget>[
                      _buildName(),
                      _buildReply(),
                      widget.isReply ? SizedBox(height: 5) : SizedBox(),
                      Stack(
                        children: [
                          _buildMessage(context),
                          _buildMessageTime(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  ColorFiltered _chatBubbleFilter({Widget child, bool ismine}) {

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          Colors.white, ismine ? BlendMode.values[4] : BlendMode.values[7]),
      child: Container(
        // width: MediaQuery.of(context).size.width,
        // alignment: _ismine ? Alignment.centerLeft : Alignment.centerRight,
        // color: Colors.transparent,
        child: Container(
          // width: width > 300 ? 300 - randomizer.nextInt(150).toDouble() : width,
          // height: 40,
          //height: randomizer.nextInt(5) == 1 ? 80 : 40,
          // margin: EdgeInsets.only(top: _issame ? 5 : 15, right: 10, left: 10),
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(20.0),
          //   color: Colors.grey.withOpacity(0.5),
          // ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    var contentWidget;

    var conversion = Provider.of<ConversationListModel>(context);
    if (widget.type == 1) {
      contentWidget = Stack(
        children: [
          Opacity(
            opacity: 0,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.message}',
                    style: TextStyle(
                      color: widget.isMe
                          ? themeObj.messagesWordSelf
                          : themeObj.messagesWordSide,
                    ),
                  ),
                  TextSpan(
                    // text: '             ',
                    text: '_________',
                    style: TextStyle(
                      color: widget.isMe
                          ? bottomColor != null ? bottomColor : themeObj.messagesColor
                          : themeObj.messagesColorSide,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${widget.message}',
                  style: TextStyle(
                    color: widget.isMe
                        ? themeObj.messagesWordSelf
                        : themeObj.messagesWordSide,
                  ),
                ),
                TextSpan(
                  text: '          ',
                  // text: '_________',
                  style: TextStyle(
                    color: widget.isMe
                        ? bottomColor != null ? bottomColor : themeObj.messagesColor
                        : themeObj.messagesColorSide,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
//       if (!widget.isReply) {
// //        contentWidget = Padding(
// //          padding: EdgeInsets.only(right: 50.0),
// //          child: Text(
// //            widget.message,
// //            style: TextStyle(
// //              color: widget.isMe
// //                  ? Colors.white
// //                  : Theme.of(context).textTheme.title.color,
// //            ),
// //            textAlign: TextAlign.left,
// //          ),
// //        );
// //      加空格占位置，放时间
// //        textAlign: TextAlign.left,
//         contentWidget = Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(
//                 text: '${widget.message}',
//                 style: TextStyle(
//                   color: widget.isMe
//                       ? themeObj.messagesWordSelf
//                       : themeObj.messagesWordSide,
//                 ),
//               ),
//               TextSpan(
//                 text: '_________',
//                 style: TextStyle(
//                   color: widget.isMe
//                       ? themeObj.messagesColor
//                       : themeObj.messagesColorSide,
//                 ),
//               ),
//             ],
//           ),
//         );
//       } else {
//         contentWidget = Container(
// //          alignment: Alignment.centerLeft,
//           child: Text(
//             widget.message,
//             style: TextStyle(
//               color: widget.isMe
//                   ? Colors.white
//                   : Theme.of(context).textTheme.title.color,
//             ),
//             textAlign: TextAlign.left,
//           ),
//         );
//       }
    } else if (widget.type == 2) {
//      print('isAudio: ${widget.isAudio}');
      if (widget.isImage) {
        var loadingW;
        if (widget.sending == true) {
//          loadingW = Center(
//            child: CircularProgressIndicator(
//              strokeWidth: 3,
//              valueColor: AlwaysStoppedAnimation(
//                  Theme.of(context).textTheme.title.color),
//            ),
//          );

          loadingW = SizedBox(
            width: 50.0,
            height: 50.0,
          );
        } else {
//          logger.d(MediaQuery.of(context).size.width);
//          logger.d(MediaQuery.of(context).size.height);
          var deviceWidth = MediaQuery.of(context).size.width;
          var deviceHeight = MediaQuery.of(context).size.height;
          if (deviceWidth > deviceHeight) {
            loadingW = Container(
              constraints: BoxConstraints(
                maxHeight: deviceHeight / 1.3 > 490 ? 490 : deviceHeight / 1.3,
                maxWidth: deviceHeight / 1.3 > 490 ? 490 : deviceHeight / 1.3,
              ),
              child: Image.network(
                "${widget.message}",
//            height: 130,
//              width: MediaQuery.of(context).size.width / 1.3,
                fit: BoxFit.cover,
              ),
            );
//            loadingW = Image.network(
//              "${widget.message}",
////            height: 130,
////              width: MediaQuery.of(context).size.width / 1.3,
//              fit: BoxFit.cover,
//            );
          } else {
            loadingW = Container(
              constraints: BoxConstraints(
                  maxWidth: deviceWidth / 1.3 > 490 ? 490 : deviceWidth / 1.3,
                  maxHeight: deviceWidth),
              child: Image.network(
                "${widget.message}",
//            height: 130,
//              width: MediaQuery.of(context).size.width / 1.3,
                fit: BoxFit.cover,
              ),
            );
//            loadingW = Image.network(
//              "${widget.message}",
////            height: 130,
//              width: MediaQuery.of(context).size.width / 1.3,
//              fit: BoxFit.cover,
//            );
          }
        }
        contentWidget = InkWell(
          onTap: () {
            if (widget.sending == true) {
              return;
            }
            var arg = {
              'imageProvider': widget.message,
              'heroTag': widget.message,
            };

            Navigator.of(context)
                .pushNamed('photoView', arguments: json.encode(arg));
          },
          child: loadingW,
        );
      } else if (widget.isVideo) {
        var loadingW;
        if (widget.sending == true) {
//          loadingW = Center(
//            child: CircularProgressIndicator(
//              strokeWidth: 3,
//              valueColor: AlwaysStoppedAnimation(
//                  Theme.of(context).textTheme.title.color),
//            ),
//          );
          loadingW = SizedBox(
            width: 50.0,
            height: 50.0,
          );
        } else {
          loadingW = Icon(
            Icons.play_circle_filled,
          );
        }
        contentWidget = InkWell(
          onTap: () {
            var arg = {
              'videoUrl': widget.message,
            };
//            showVideoPlayer(context, widget.message);

            Navigator.of(context)
                .pushNamed('videoPlay', arguments: json.encode(arg));
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => VideoPlayRoute(widget.message)),
//            );
          },
          child: Container(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 100.0,
//                  MediaQuery.of(context).size.width * 0.3
                  decoration: BoxDecoration(
                    // this adds the top and bottom tints to the video thumbnail
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xAA000000),
                        const Color(0x00000000),
                        const Color(0x00000000),
                        const Color(0x00000000),
                        const Color(0x00000000),
                        const Color(0xAA000000),
                      ],
                    ),
                  ),
                ),
                loadingW,
              ],
            ),
          ),
//          tag: "Pick a video",
        );
      } else if (widget.isAudio) {
        var loadingW;
        if (widget.sending == true) {
//          loadingW = Center(
//            child: CircularProgressIndicator(
//              strokeWidth: 3,
//              valueColor: AlwaysStoppedAnimation(
//                  Theme.of(context).textTheme.title.color),
//            ),
//          );

          loadingW = SizedBox(
            width: 50.0,
            height: 50.0,
          );
        } else {
          loadingW = PlayerWidget(url: widget.message);
        }
        contentWidget = InkWell(
          onTap: () {},
          child: loadingW,
        );
      } else {
        var fileIcon;
        if (widget.downloading) {
          fileIcon = Icon(
            Icons.close,
            color: Colors.white,
          );
        } else {
          if (widget.downloadSuccess) {
            fileIcon = Icon(
              Icons.folder_open,
              color: Colors.white,
            );
          } else {
            fileIcon = Icon(
              Icons.vertical_align_bottom,
              color: Colors.white,
            );
          }
        }
        if (widget.sending == true) {
//          fileIcon = Center(
//            child: CircularProgressIndicator(
//              strokeWidth: 3,
//              valueColor: AlwaysStoppedAnimation(
//                  Theme.of(context).textTheme.title.color),
//            ),
//          );

          fileIcon = SizedBox(
            width: 50.0,
            height: 50.0,
          );
        }
        var fileExtensionStr;
        var fileNamePreStr;
        if (widget.contentName != '' && widget.contentName != null) {
          var arrFileStr = widget.contentName.split('.');

          if (arrFileStr.length >= 2) {
            fileExtensionStr = '.' + arrFileStr[arrFileStr.length - 1];
            fileNamePreStr =
                widget.contentName.replaceAll(fileExtensionStr, '');
          }
        }
        contentWidget = Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 40.0,
            //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
            child: Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: 40.0,
//                  color: Colors.blue,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
//                    color: Theme.of(context).primaryColor,
//                    boxShadow: [
//                      BoxShadow(color: Colors.green, spreadRadius: 3),
//                    ],
                  ),
//                  color: Theme.of(context).textTheme.title.color,
                  child: IconButton(
                    icon: fileIcon,
                    onPressed: () async {
                      var downData;
                      print('widget.filePath: ${widget.filePath}');
                      print('widget.index: ${widget.index}');
                      var filePath =
                          conversion.conversationList[widget.index]['filePath'];
                      print('filePath: $filePath');
                      var fileExist;
                      if (filePath != null && filePath != '') {
                        fileExist = await File(filePath).exists();
                        // for a directory
//                        Directory(filePath).exists();
                      }
//                      print('fileExist: $fileExist');
                      if (filePath != null &&
                          filePath != '' &&
                          fileExist == true) {
                        OpenFile.open(filePath);
                      } else {
                        try {
                          widget.callback(widget.index, 'downloading', true);
                          downData = await Git(context).download(
                              '1', widget.contentName, widget.message);
                          if (downData['isSuccess'] == true) {
                            widget.callback(
                                widget.index, 'filePath', downData['filePath']);
//                            folder_open
//                            conversion.updateListItem(
//                                widget.index, 'filePath', downData['filePath']);
//                            setState(
//                              () {
//                                widget.filePath = downData['filePath'];
//                              },
//                            );
                            widget.callback(
                                widget.index, 'downloadSuccess', true);
                          }
                          print('downData: $downData');
                        } catch (e) {
                          print('downData error: $e');
                          widget.callback(
                              widget.index, 'downloadSuccess', false);
                        } finally {}

                        widget.callback(widget.index, 'downloading', false);
                      }
                    },
                  ),
                ),
                Expanded(
//                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "${widget.contentName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isMe
                            ? Colors.white
                            : Theme.of(context).textTheme.title.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else if (widget.type == 3) {
//      contentWidget = Image.network(
//        "${widget.message}",
////        height: 130,
////        width: MediaQuery.of(context).size.width / 1.3,
////        fit: BoxFit.cover,
//      );
      var loadingW;
      if (widget.sending == true) {
        loadingW = Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor:
                AlwaysStoppedAnimation(Theme.of(context).textTheme.title.color),
          ),
        );
      } else {
        loadingW = Image.network(
          "${widget.message}",
//          height: 130,
//          width: MediaQuery.of(context).size.width / 1.3,
//          fit: BoxFit.cover,
        );
      }
      contentWidget = InkWell(
        onTap: () {
          if (widget.sending == true) {
            return;
          }
          var arg = {
            'imageProvider': widget.message,
            'heroTag': widget.message
          };
          Navigator.of(context)
              .pushNamed('photoView', arguments: json.encode(arg));
        },
        child: loadingW,
      );
    }
    return Container(
      padding: EdgeInsets.all(widget.type == 1 ? 1 : 0),
      decoration: BoxDecoration(
        // color: widget.isMe ? themeObj.messagesColor : themeObj.messagesColorSide,
        borderRadius: BorderRadius.circular(themeObj.radius),
      ),
      child: contentWidget,
    );
  }

  Widget _buildMessageTime() {
    return Positioned(
      right: 0.0,
      bottom: -10.0,
      child: Padding(
        padding: widget.isMe
            ? EdgeInsets.only(
                right: 10,
                bottom: 10.0,
              )
            : EdgeInsets.only(
                left: 10,
                bottom: 10.0,
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${TimeUtil.formatTime(widget.time, 1, 'HH:mm')}',
              style: TextStyle(
                color: widget.isMe
                    ? themeObj.inactiveColorMessageSelf
                    : themeObj.inactiveColorMessage,
                fontSize: 10.0,
              ),
            ),
            if (widget.isMe)
              widget.sending
                  ? Container(
                      child: Icon(
                        Icons.access_time,
                        size: 10,
                        color: themeObj.messagesWordSelf,
                      ),
                      height: 10.0,
                      width: 10.0,
                    )
                  : widget.success
                      ? Icon(
                          Icons.check,
                          color: themeObj.messagesWordSelf,
                          size: 10.0,
                        )
                      : Icon(
                          Icons.sms_failed,
                          color: Colors.red,
                          size: 10.0,
                        )
          ],
        ),
      ),
    );
  }

  Widget _buildReply() {
    return widget.isReply
        ? Container(
            decoration: BoxDecoration(
              // color: chatBubbleReplyColor(),
              // borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border(
                left: BorderSide(
                  color: primaryColor,
                  width: 2.0,
                )
              ),
            ),
            // constraints: BoxConstraints(
            //   minHeight: 25,
            //   maxHeight: 100,
            //   minWidth: 80,
            // ),
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TextOneLine(
                      "${widget.isMe ? "You" : widget.replyName}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    // Text(
                    //   widget.isMe ? "You" : widget.replyName,
                    //   style: TextStyle(
                    //     color: Theme.of(context).accentColor,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 12,
                    //   ),
                    //   maxLines: 1,
                    //   textAlign: TextAlign.left,
                    // ),
                    // alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 2),
                  Container(
                    child: TextOneLine(
                      "${widget.replyText}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: widget.isMe
                            ? themeObj.messagesWordSelf
                            : themeObj.messagesWordSide,
                      ),
                    ),
                    // Text(
                    //   widget.replyText,
                    //   style: TextStyle(
                    //     color: widget.isMe
                    //         ? themeObj.messagesWordSelf
                    //         : themeObj.messagesWordSide,
                    //     fontSize: 10,
                    //   ),
                    //   maxLines: 1,
                    // ),
                    // alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            ),
          )
        : SizedBox(width: 2);
  }

  Widget _buildName() {
    var nameWidget = Container(
      child: Text(
        'username',
        style: TextStyle(
          fontSize: 13,
          color: colors[rNum],
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.3 - 30,
        minWidth: 20.0,
      ),
    );
    return widget.isMe
        ? SizedBox()
        : widget.isGroup
            ? widget.showUsername ? nameWidget : SizedBox()
            : SizedBox();
  }

  void showVideoPlayer(parentContext, String videoUrl) async {
    await showModalBottomSheetApp(
        context: parentContext,
        builder: (BuildContext bc) {
          return VideoPlayerWidget(videoUrl: videoUrl);
        });
  }

  void _afterLayout(_) {
    _getPositions();
  }

  _getPositions() {
    final RenderBox renderBoxRed = _keyRed.currentContext?.findRenderObject();
    final positionsRed = renderBoxRed?.localToGlobal(Offset(0, 0));
    final sizeRed = renderBoxRed?.size;
    //输出背景为红色的widget的宽高
    if (_keyRed.currentContext != null) {
      Map<String, dynamic> scrollItem = {
        "key": _keyRed,
        "createdDate": widget.time,
        "dy": positionsRed.dy,
        "id": widget.id,
        "height": sizeRed.height,
        "timestamp": widget.timestamp,
        "isMe": widget.isMe,
        "content": widget.content,
      };
      // logger.d(widget.content);
      // logger.d(positionsRed.dy);
      // logger.d(sizeRed.height);
      if (scrollWidgetList.length > 0) {
        if (widget.timestamp < scrollWidgetList[0]['timestamp']) {
          scrollWidgetList.insert(0, scrollItem);
        } else {
          scrollWidgetList.add(scrollItem);
        }
      } else {
        scrollWidgetList.add(scrollItem);
      }
      ArrayUtil.sortArray(scrollWidgetList, sortOrder: 1, property: 'timestamp');

      // _setColor();
    }
  }


  _setColor() {
    // List colors = [Colors.red, Colors.green, Colors.yellow];
    // Random random = new Random();

    // int index = 0;


    var scrollModel = Provider.of<ConversationScrollModel>(context, listen: false);
    List scrollList = scrollModel.scrollList;

    // ArrayUtil.sortArray(scrollWidgetList, sortOrder: 1, property: 'timestamp');
    double totalHeight = 0;
    bool hasSelf;
    // 自己发消息颜色背景设置
    for (var s = 0; s < scrollList.length; s++) {
      totalHeight += scrollList[s]['height'];
      // index = random.nextInt(3);
      // if (scrollWidgetList[s]['key']?.currentContext != null) {
      //   // scrollArr.add(scrollWidgetList[s]['id']);
      //   RenderBox renderBoxRed =
      //   scrollWidgetList[s]['key']?.currentContext?.findRenderObject();
      //   var positionsRed = renderBoxRed?.localToGlobal(Offset(0, 0));
      //   logger.d(positionsRed.dy);
      //   logger.d('${scrollWidgetList[s]['height']}');
      //   // if (positionMax < positionsRed.dy && maxHeight >= positionsRed.dy) {
      //   //   positionMax = positionsRed.dy;
      //   //   positionMaxItem = {
      //   //     "key": scrollWidgetList[s]['key'],
      //   //     "id": scrollWidgetList[s]['id'],
      //   //     "dy": positionsRed.dy,
      //   //     "height": scrollWidgetList[s]['height'],
      //   //     "createdDate": scrollWidgetList[s]['createdDate'],
      //   //     "timestamp": scrollWidgetList[s]['timestamp'],
      //   //   };
      //   // }
      // }
    }

    double preHeight = 0;
    Color startColor = Colors.blue;
    Color endColor = Colors.red;
    for (var s = 0; s < scrollList.length; s++) {
      var scrollW = scrollList[s];
      // double currentHeight = scrollW['height'];
      // 此widget 开始的高度
      final double startH = preHeight / totalHeight;
      preHeight += scrollW['height'];
      // 此widget 结束高度
      final double endH = preHeight / totalHeight;

      // 使用开始颜色
      Color lastStartValue;
      // 使用结束颜色
      Color lastEndValue;
      if (scrollW['timestamp'] == widget.timestamp) {
        lastStartValue = Color.lerp(startColor, endColor, startH);
        lastEndValue = Color.lerp(startColor, endColor, endH);
        // setState(() {
        //   topColor = lastStartValue;
        //   bottomColor = lastEndValue;
        // });
        topColor = lastStartValue;
        bottomColor = lastEndValue;
      }
    }

  }

  _deleteColor() {
    var scrollModel = Provider.of<ConversationScrollModel>(context, listen: false);
    List scrollList = scrollModel.scrollList;
    for (var s = 0; s < scrollList.length; s++) {
      if (scrollList[s]['key']?.currentContext != null) {
        // scrollArr.add(scrollList[s]['id']);
        RenderBox renderBoxRed =
        scrollList[s]['key']?.currentContext?.findRenderObject();
        var positionsRed = renderBoxRed?.localToGlobal(Offset(0, 0));
        // logger.d(positionsRed.dy);
        // logger.d('${scrollList[s]['height']}');
      }
    }
  }




  // void _afterLayoutPersistent(Duration duration) {
  //   logger.d('persistent: ${duration.inMilliseconds}');
  //   logger.d(widget.content);
  // }
}
