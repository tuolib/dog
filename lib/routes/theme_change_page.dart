import '../index.dart';
import 'package:flutter/cupertino.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
// import 'modals/floating_modal.dart';

class ThemeChangeRoute extends StatefulWidget {
  @override
  _ThemeChangeRoute createState() => _ThemeChangeRoute();
}

class _ThemeChangeRoute extends State<ThemeChangeRoute> {
  ThemeModel themeObj;

  double con1 = 30;
  double border1 = 2;
  double border2 = 2;

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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        color: themeObj.messagesChatBg,
                        padding: EdgeInsets.only(
                          top: index == 0 ? 10 : 0,
                          bottom: index == 1 ? 10 : 0,
                        ),
                        child: _buildChatList(context, index),
                      );
                    },
                    childCount: 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildThemeMode(context),
                ),
                SliverToBoxAdapter(
                  child: _buildThemeColor(context),
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
            'Color theme',
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
      return ChatBubble(
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
        replyText: '',
        isReply: false,
        replyName: '',
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
      return ChatBubble(
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
      );
    }
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
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeObj.messagesChatBgAppearanceDay,
                          border: Border.all(
                            color: themeObj.themeMode == 1
                                ? themeObj.primaryColor
                                : Colors.grey,
                            width: themeObj.themeMode == 1 ? 3 : 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: themeObj
                                          .messagesColorSideAppearanceDay,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          themeObj.messagesColorAppearanceDay,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeObj.messagesChatBgAppearanceDark,
                          border: Border.all(
                            color: themeObj.themeMode == 2
                                ? themeObj.primaryColor
                                : Colors.grey,
                            width: themeObj.themeMode == 2 ? 3 : 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: themeObj
                                          .messagesColorSideAppearanceDark,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          themeObj.messagesColorAppearanceDark,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  _buildThemeColor(context) {
    var allMember = <Widget>[];
    allMember.add(Container(
      color: themeObj.menuBackgroundColor,
      margin: EdgeInsets.only(right: 10),
      child: GestureDetector(
        child: CircleWidget(),
        onTap: () {
          _showColorPicker(context);
        },
      ),
    ));
    var myList = Global.themes;
    for (var i = 0; i < myList.length; i++) {
      var item = Container(
        // height: 200,
        child: _colorItem(myList[i], i),
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

  _colorItem(int colorItem, int index) {
    // logger.d(themeObj.theme);
    int themeIndex;

    if (Global.profile.themeMode == 1) {
      themeIndex = themeObj.theme;
    } else if (Global.profile.themeMode == 2) {
      themeIndex = themeObj.themeDark;
    } else {
      themeIndex = 0;
    }
    bool selected = false;
    if (colorItem == Global.themes[themeIndex]) {
      selected = true;
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
                    : SizedBox(),
              ),
            ],
          ),
        ),
        onTap: () {
          if (Global.profile.themeMode == 1) {
            Provider.of<ThemeModel>(context, listen: false).theme = index;
          } else if (Global.profile.themeMode == 2) {
            Provider.of<ThemeModel>(context, listen: false).themeDark = index;
          }
        },
      ),
    );
  }

  callback() {}

  _showColorPicker(context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context, scrollController) => ModalFit(),
    );
  }

  // _


}
