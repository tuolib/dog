
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
// import 'modals/floating_modal.dart';

import '../index.dart';

int oldTheme;
int oldThemeDark;

class ThemeChangeRoute extends StatefulWidget {
  @override
  _ThemeChangeRoute createState() => _ThemeChangeRoute();
}

class _ThemeChangeRoute extends State<ThemeChangeRoute> {
  ThemeModel themeObj;

  double con1 = 30;
  double border1 = 2;
  double border2 = 2;

  int segmentedControlGroupValue = 0;

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Accent"),
    1: Text("Background"),
    2: Text("Messages"),
  };

  @override
  Widget build(BuildContext context) {
    // logger.d(Color.fromRGBO(0, 0, 0, 1).value);
    // logger.d(Color.fromRGBO(177, 177, 177, 1).value);
    // logger.d(Color.fromRGBO(200, 255, 160, 1).value);
    // logger.d(Color.fromRGBO(255, 255, 255, 1).value);
    themeObj = Provider.of<ThemeModel>(context);
    return Scaffold(
      backgroundColor: themeObj.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeObj.barBackgroundColor,
        // textTheme: Theme.of(context).primaryColor,
        brightness: themeObj.brightness,
        shadowColor: null,
        elevation: 0,
        toolbarHeight: 48,
        titleSpacing: 0,
        bottom: PreferredSize(
          child: Container(
            color: themeObj.borderColor,
            height: 0.5,
          ),
          preferredSize: Size.fromHeight(0.5),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: themeObj.primaryColor,
            size: 34,
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed("newMessage");
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "${GmLocalizations.of(context).theme}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeObj.normalColor,
            //                        fontSize: 14,
          ),
        ),
      ),
      body: CupertinoPageScaffold(
        child: SizedBox.expand(
          child: SafeArea(
            child: CustomScrollView(
              primary: true,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _buildChat(context),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: _buildBackground(),
                    // constraints: BoxConstraints(
                    //   minHeight: 136,
                    // ),
                    child: Stack(
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildChatList(context, 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildChatList(context, 1),
                              ],
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (BuildContext context, int index) {
                //       return Container(
                //         color: themeObj.messagesChatBg,
                //         padding: EdgeInsets.only(
                //           top: index == 0 ? 10 : 0,
                //           bottom: index == 1 ? 10 : 0,
                //         ),
                //         child: _buildChatList(context, index),
                //       );
                //     },
                //     childCount: 2,
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: _buildThemeMode(context),
                ),
                SliverToBoxAdapter(
                  child: _buildThemeColor(context),
                ),
                _buildOther(),
                SliverToBoxAdapter(
                  child: Container(
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildChat(context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30, left: 15, bottom: 6),
          width: MediaQuery.of(context).size.width,
          // color: themeObj.scaffoldBackgroundColor,
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(16.0),
          //   color: Colors.black12,
          // ),
          child: Text(
            'COLOR THEME',
            style: TextStyle(
              color: themeObj.inactiveColor,
            ),
          ),
        ),
        Divider(
          height: 2,
          color: themeObj.borderColor,
        ),
      ],
    );
  }

  _buildChatList(context, index) {
    if (index == 0) {
      return ChatBubbleWidget(
        callback: callback,
        message: 'Do you know what time it is?',
        content: 'Do you know what time it is?',
        contentName: '',
        username: '',
        avatarUrl: '',
        time: 1601108277901,
        type: 1,
        isMe: false,
        isGroup: false,
        replyText:
            'Do you have some apple xxxxxx slsdf sldfjs sdf lfsdf sdlf sdf sdfs sdf?',
        isReply: true,
        replyName: 'Bob Smith',
        isImage: false,
        index: 1,
        filePath: '',
        downloading: false,
        downloadSuccess: false,
        sending: false,
        success: false,
        isVideo: false,
        isAudio: false,
        showUsername: false,
        showAvatar: false,
        showAvatarParent: false,
        showDate: false,
        contentId: 1234,
        id: 1234,
        timestamp: 1601108277901,
      );
    } else {
      return _chatBubble(
        isMe: true,
        isReply: false,
        message: "It's morning in Tokyo",
        time: 1601108277901,
        index: 1,
      );
      return ChatBubbleWidget(
        callback: callback,
        message: "It's morning in Tokyo",
        content: "It's morning in Tokyo",
        contentName: '',
        username: '',
        avatarUrl: '',
        time: 1601108277901,
        type: 1,
        isMe: true,
        isGroup: false,
        replyText: '',
        isReply: false,
        replyName: '',
        isImage: false,
        index: 2,
        filePath: '',
        downloading: false,
        downloadSuccess: false,
        sending: false,
        success: true,
        isVideo: false,
        isAudio: false,
        showUsername: false,
        showAvatar: false,
        showAvatarParent: false,
        showDate: false,
        contentId: 1234,
        id: 1234,
        timestamp: 1601108277901,
        topColor: themeObj.messagesColor,
        bottomColor: themeObj.messagesColor2,
      );
    }
  }


  _buildBackground() {
    BoxDecoration box;
    if (themeObj.backgroundImage == null) {
      var bg2 = themeObj.messagesChatBg2;
      if (bg2 == null) {
        bg2 = themeObj.messagesChatBg;
      }
      box = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themeObj.messagesChatBg,
            bg2,
          ],
        ),
      );
    } else {
      box = BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(themeObj.backgroundImageUrl)),
          fit: BoxFit.cover,
        ),
      );
    }
    return box;
    // return Container(
    //   decoration: box,
    //   // child: backG,
    // );
  }

  Widget _chatBubble({
    bool isMe,
    bool isReply,
    String replyName,
    String replyText,
    String message,
    int time,
    int index,
  }) {
    // themeObj = Provider.of<ThemeModel>(context);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    Color paintColor = isMe ? themeObj.messagesColor : themeObj.messagesColorSide;
    var alignCorner = isMe ? Alignment.topRight : Alignment.bottomLeft;
    double _radius = themeObj.radius == null ? 16 : themeObj.radius;
    Color startColor = themeObj.messagesColor;
    Color endColor = themeObj.messagesColor2;
    Color lastStartValue;
    Color lastEndValue;
    if (endColor != null) {
      lastStartValue = Color.lerp(startColor, endColor, 0);
      lastEndValue = Color.lerp(startColor, endColor, 1);
      if (isMe) {
        paintColor = lastEndValue;
      }
    } else {
      lastStartValue = startColor;
      lastEndValue = startColor;
    }
    if (!isMe) {
      lastStartValue = paintColor;
      lastEndValue = paintColor;
    }
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Row(
//          crossAxisAlignment: align,
          mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
              child: CustomPaint(
                painter: ChatCustomCorner(
                  color: paintColor,
                  alignment: alignCorner,
                  showCorner: false,
                  radius: _radius,
                  topColor: lastStartValue,
                  bottomColor: lastEndValue,
                ),
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, bottom: 3, right: 8, left: 8),
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, right: 2, left: 5),
                        decoration: BoxDecoration(
                          // color: chatBubbleColor(),
                          // color: widget.isMe
                          //     ? themeObj.messagesColor
                          //     : themeObj.messagesColorSide,
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                        constraints: BoxConstraints(
                          maxWidth:
                          MediaQuery.of(context).size.width / 1.3 - 30,
                          minWidth: 20.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: align,
                          children: <Widget>[
                            Stack(
                              children: [
                                _buildMessage(
                                  context: context,
                                  isMe: isMe,
                                  message: message,
                                  lineColor: lastEndValue,
                                ),
                                _buildMessageTime(
                                  isMe: isMe,
                                  time: time,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            // _buildNothing(),
          ],
        ),
      ],
    );
  }

  Widget _buildMessage({
    BuildContext context,
    String message,
    bool isMe,
    Color lineColor,
  }) {
    var contentWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$message',
            style: TextStyle(
              color:
              isMe ? themeObj.messagesWordSelf : themeObj.messagesWordSide,
            ),
          ),
          TextSpan(
            text: '_________',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        // color: widget.isMe ? themeObj.messagesColor : themeObj.messagesColorSide,
        borderRadius: BorderRadius.circular(themeObj.radius),
      ),
      child: contentWidget,
    );
  }

  Widget _buildMessageTime({bool isMe, int time}) {
    bool sending = false;
    bool success = true;
    return Positioned(
      right: 0.0,
      bottom: -10.0,
      child: Padding(
        padding: isMe
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
              '${TimeUtil.formatTime(time, 1, 'HH:mm')}',
              style: TextStyle(
                color: isMe
                    ? themeObj.inactiveColorMessageSelf
                    : themeObj.inactiveColorMessage,
                fontSize: 10.0,
              ),
            ),
            if (isMe)
              sending
                  ? Container(
                child: Icon(
                  Icons.access_time,
                  size: 10,
                  color: themeObj.messagesWordSelf,
                ),
                height: 10.0,
                width: 10.0,
              )
                  : success
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

  _buildThemeMode(context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 2,
          color: themeObj.borderColor,
        ),
        Container(
          color: themeObj.menuBackgroundColor,
          padding: EdgeInsets.all(6),
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(16.0),
          //   color: Colors.black12,
          // ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _themeModeBox(mode: 1),
                      Container(
                        child: Text(
                          'Day',
                          style: TextStyle(
                            color: themeObj.themeMode == 1
                                ? themeObj.primaryColor
                                : themeObj.normalColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Provider.of<ThemeModel>(context, listen: false).themeMode =
                        1;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _themeModeBox(mode: 2),
                      Container(
                        child: Text(
                          'Night',
                          style: TextStyle(
                            color: themeObj.themeMode == 2
                                ? themeObj.primaryColor
                                : themeObj.normalColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Provider.of<ThemeModel>(context, listen: false).themeMode =
                        2;
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          color: themeObj.menuBackgroundColor,
          padding: EdgeInsets.only(left: 16),
          child: Divider(
            height: 2,
            color: themeObj.borderColor,
          ),
        ),
      ],
    );
  }

  _themeModeBox({int mode}) {

    Color topColor;
    Color bottomColor;
    if (mode == 1) {
      topColor = themeObj.messagesChatBgAppearanceDay;
      if (themeObj.messagesChatBgAppearanceDay2 != null) {
        bottomColor = themeObj.messagesChatBgAppearanceDay2;
      } else {
        bottomColor = topColor;
      }
    } else if (mode == 2) {
      topColor = themeObj.messagesChatBgAppearanceDark;
      if (themeObj.messagesChatBgAppearanceDark2 != null) {
        bottomColor = themeObj.messagesChatBgAppearanceDark2;
      } else {
        bottomColor = topColor;
      }

    }
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        // color: themeObj.messagesChatBgAppearanceDark,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
        border: Border.all(
          color: themeObj.themeMode == mode
              ? themeObj.primaryColor
              : Colors.grey,
          width: themeObj.themeMode == mode ? 3 : 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _themeModeBubble(me: false, mode: mode),
          _themeModeBubble(me: true, mode: mode),
        ],
      ),
    );
  }

  _themeModeBubble({bool me, int mode}) {
    Color topColor;
    Color bottomColor;
    if (mode == 1) {
      topColor = themeObj.messagesColorAppearanceDay;
      if (themeObj.messagesColorAppearanceDay2 != null) {
        bottomColor = themeObj.messagesColorAppearanceDay2;
      } else {
        bottomColor = topColor;
      }

      if (!me) {
        topColor = themeObj.messagesColorSideAppearanceDay;
        topColor = themeObj.messagesColorSideAppearanceDay;
      }
    } else if (mode == 2) {
      topColor = themeObj.messagesColorAppearanceDark;
      if (themeObj.messagesColorAppearanceDark2 != null) {
        bottomColor = themeObj.messagesColorAppearanceDark2;
      } else {
        bottomColor = topColor;
      }

      if (!me) {
        topColor = themeObj.messagesColorSideAppearanceDark;
        topColor = themeObj.messagesColorSideAppearanceDark;
      }
    }
    return Container(
      width: 100,
      margin: EdgeInsets.only(left: me ? 0 : 5, right: me ? 5 : 0),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  topColor,
                  me ? bottomColor : topColor,
                ],
              ),
              // color: mode == 1
              //     ? themeObj.messagesColorSideAppearanceDay
              //     : themeObj.messagesColorSideAppearanceDark,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
    //     gradient: LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [
    //         Colors.lightBlue,
    //         Colors.deepPurpleAccent,
    //         Colors.pinkAccent,
    //       ],
    //     ),
  }

  _buildThemeColor(context) {
    var allMember = <Widget>[];
    allMember.add(Container(
      color: themeObj.menuBackgroundColor,
      margin: EdgeInsets.only(right: 10),
      child: GestureDetector(
        child: CircleWidget(),
        onTap: () {
          _showColorPicker(context, 2);
        },
      ),
    ));
    var myList = Global.themes;
    for (var i = 0; i < myList.length; i++) {
      var item = Container(
        // height: 200,
        child: _colorItem(myList[i]['primary'], i, myList[i]),
      );
      allMember.add(item);
    }

    double conHeight = con1 + 2 * border1 + 2 * border2;
    return Container(
      color: themeObj.menuBackgroundColor,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 12, top: 12, bottom: 12),
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   // borderRadius: BorderRadius.circular(16.0),
            //   color: Colors.black12,
            // ),
            height: conHeight,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                ...allMember,
              ],
            ),
          ),
          Divider(
            height: 2,
            color: themeObj.borderColor,
          ),
        ],
      ),
    );
  }

  _colorItem(int colorItem, int index, Map colorObj) {
    // logger.d(themeObj.theme);
    int themeIndex;
    bool selected = false;

    bool showLitter = true;
    Color litterCirBg;
    int litterValue;
    if (themeObj.themeMode == 1) {
      themeIndex = themeObj.theme;
      litterValue = Global.profile.dayList[index]['message'];
      litterCirBg = Color(litterValue);
      if (index == themeObj.theme) {
        selected = true;
      }
    } else if (themeObj.themeMode == 2) {
      themeIndex = themeObj.themeDark;
      litterValue = Global.profile.darkList[index]['message'];
      litterCirBg = Color(litterValue);
      if (index == themeObj.themeDark) {
        selected = true;
      }
    } else {
      themeIndex = 0;
      if (index == themeObj.theme) {
        selected = true;
      }
    }
    // if (litterValue != colorItem) {
    //   showLitter = true;
    // }

    Color topColor;
    Color bottomColor;

    topColor = Color(colorObj['message']);
    if (colorObj['message2'] != null) {
      bottomColor = Color(colorObj['message2']);
    } else {
      bottomColor = Color(colorObj['message']);
    }

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Color(colorItem),
        border: Border.all(
          color: Color(colorItem),
          width: border2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(colorItem),
            border: Border.all(
              color: selected
                  ? CupertinoTheme.of(context).scaffoldBackgroundColor
                  : Color(colorItem),
              width: border1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(23),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: con1,
                height: con1,
                decoration: BoxDecoration(
                  color: Color(colorItem),
                  // border: Border.all(
                  //   color: Colors.grey,
                  //   width: 1,
                  //   style: BorderStyle.solid,
                  // ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: selected
                    ? Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      )
                    : showLitter
                        ? Container(
                            // color: Color(colorItem),
                            decoration: BoxDecoration(
                              color: Color(colorItem),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                // color: litterCirBg,

                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    topColor,
                                    bottomColor,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : SizedBox(),
              ),
            ],
          ),
        ),
        onTap: () {
          if (Global.profile.themeMode == 1) {
            if (themeObj.theme == index) {
              _showColorPicker(context, 1);
            } else {
              themeObj.theme = index;
            }
          } else if (Global.profile.themeMode == 2) {
            if (themeObj.themeDark == index) {
              _showColorPicker(context, 1);
            } else {
              themeObj.themeDark = index;
            }
          }
        },
      ),
    );
  }

  _buildOther() {
    return SliverToBoxAdapter(
      child: Consumer<ThemeModel>(
        builder: (BuildContext context, ThemeModel themeModel, Widget child) {
          var gm = GmLocalizations.of(context);
          double iconWidth = 25;
          double iconMargin = 10;
          double iconSize = 20;
          double iconBorderWidth = 4;
          double dividerLeft = 20;
          // Color forwardColor = DataUtil.iosLightTextGrey();
          // var localeModel = Provider.of<LocaleModel>(context);

          return Container(
            color: themeObj.menuBackgroundColor,
            child: Column(
              children: <Widget>[
                Container(
                  color: themeObj.scaffoldBackgroundColor,
                  height: 30,
                  // width: MediaQuery.of(context).size.width,
                ),
                Divider(
                  height: 1,
                  color: themeObj.borderColor,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: iconWidth,
                        height: iconWidth,
                        margin: EdgeInsets.all(iconMargin),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chat Background',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeObj.normalColor,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.forward,
                              color: themeObj.inactiveColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.pushNamed(context, "chatBackground"),
                ),
                Container(
                  padding: EdgeInsets.only(left: dividerLeft),
                  child: Divider(
                    height: 1,
                    color: themeObj.borderColor,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: iconWidth,
                        height: iconWidth,
                        margin: EdgeInsets.all(iconMargin),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Text Size',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeObj.normalColor,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeObj.inactiveColor,
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.forward,
                                  color: themeObj.inactiveColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "testGradient");
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: dividerLeft),
                  child: Divider(
                    height: 1,
                    color: themeObj.borderColor,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: iconWidth,
                        height: iconWidth,
                        margin: EdgeInsets.all(iconMargin),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Message Corners',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeObj.normalColor,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.forward,
                              color: themeObj.inactiveColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "blendMode");
                  },
                ),
                Divider(
                  height: 1,
                  color: themeObj.borderColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  callback( {int index, String property, String filePath, int type}) {
    // logger.d('callback');
    // if (type == 2) {
    //   _setColor();
    // } else {
    //   conversion.updateListItem(index, property, filePath);
    // }

  }

  _showColorPicker(BuildContext context, int type) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // int accentColor = themeObj.primaryColor.value;
    // int backgroundColor = themeObj.scaffoldBackgroundColor.value;
    // int messagesColor = themeObj.messagesColor.value;
    // themeObj.themeColorAdd(accentColor, 0);
    // themeObj.themeColorAdd(backgroundColor, 1);
    // themeObj.themeColorAdd(messagesColor, 2);
    // if (themeObj.themeMode == 1) {
    //   oldTheme = themeObj.theme;
    //   themeObj.theme = 0;
    // } else if (themeObj.themeMode == 2) {
    //   oldThemeDark = themeObj.theme;
    //   themeObj.themeDark = 0;
    // }
    CupertinoScaffold.showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context, scrollController) => SetColorWidget(
        type: type,
      ),
    );
  }

  // accent background message
  _setColor() {
    // Map<int, Widget> myTabs = <int, Widget>{
    //   0: GestureDetector(
    //     child: Text("Accent"),
    //     onTap: () {
    //       setState(() {
    //         segmentedControlGroupValue = 0;
    //       });
    //     },
    //   ),
    //   1: GestureDetector(
    //     child: Text("Background"),
    //     onTap: () {
    //       setState(() {
    //         segmentedControlGroupValue = 1;
    //       });
    //     },
    //   ),
    //   2: GestureDetector(
    //     child: Text("Messages"),
    //     onTap: () {
    //       logger.d(segmentedControlGroupValue);
    //       setState(() {
    //         segmentedControlGroupValue = 2;
    //       });
    //     },
    //   ),
    // };

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: themeObj.barBackgroundColor,
        child: SafeArea(
          // top: false,
          // left: false,
          // right: false,
          child: Container(
            color: themeObj.barBackgroundColor,
            // width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: themeObj.barBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: themeObj.borderColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  // margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: CupertinoSlidingSegmentedControl<int>(
                    // backgroundColor: themeObj.inputBackgroundColor,
                    groupValue: segmentedControlGroupValue,
                    children: myTabs,
                    onValueChanged: (i) {
                      logger.d(i);
                      setState(() {
                        segmentedControlGroupValue = i;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
