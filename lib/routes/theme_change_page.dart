import '../index.dart';
import 'package:flutter/cupertino.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

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
    themeObj = Provider.of<ThemeModel>(context);
    return Scaffold(
      backgroundColor: DataUtil.iosLightGrey(),
      appBar: AppBar(
        backgroundColor: DataUtil.iosBarBgColor(),
        // textTheme: Theme.of(context).primaryColor,
        brightness: Brightness.light,
        shadowColor: Colors.white,
        elevation: 0,
        toolbarHeight: 48,
        titleSpacing: 0,
        bottom: PreferredSize(
          child: Container(
            color: DataUtil.iosBorderGreyShallow(),
            height: 0.5,
          ),
          preferredSize: Size.fromHeight(0.5),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: DataUtil.iosLightTextBlue(),
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
            color: DataUtil.iosLightTextBlack(),
            //                        fontSize: 14,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildChat(context),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
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
          color: DataUtil.iosLightGrey(),
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(16.0),
          //   color: Colors.black12,
          // ),
          child: Text('Color theme'),
        ),
        Divider(
          height: 2,
          color: Color.fromRGBO(207, 206, 213, 1),
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
          color: Color.fromRGBO(207, 206, 213, 1),
        ),
        Container(
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
                          color: Colors.white,
                          border: Border.all(
                            color: themeObj.themeMode == 1
                                ? CupertinoTheme.of(context).primaryColor
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
                                      color: Colors.grey,
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
                                      color: Colors.blue,
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
                                ? CupertinoTheme.of(context).primaryColor
                                : Colors.grey,
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
                          color: Colors.white,
                          border: Border.all(
                            color: themeObj.themeMode == 2
                                ? CupertinoTheme.of(context).primaryColor
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
                                      color: Colors.grey,
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
                                      color: Colors.blue,
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
                                ? CupertinoTheme.of(context).primaryColor
                                : Colors.grey,
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
          padding: EdgeInsets.only(left: 16),
          child: Divider(
            height: 2,
            color: Color.fromRGBO(207, 206, 213, 1),
          ),
        ),
      ],
    );
  }

  _buildThemeColor(context) {
    var allMember = <Widget>[];
    var myList = Global.themes;
    for (var i = 0; i < myList.length; i++) {
      var item = Container(
        // height: 200,
        child: _colorItem(myList[i], i),
      );
      allMember.add(item);
    }

    double conHeight = con1 + 2 * border1 + 2 * border2;
    return Column(
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
          color: Color.fromRGBO(207, 206, 213, 1),
        ),
      ],
    );
  }

  _colorItem(Color colorItem, int index) {
    // logger.d(themeObj.theme);
    bool selected = false;
    if (colorItem == themesAll[themeObj.theme]) {
      selected = true;
    }
    return Container(
      margin: EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: colorItem,
        border: Border.all(
          color: colorItem,
          width: border2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Container(
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorItem,
          border: Border.all(
            color: selected
                ? CupertinoTheme.of(context).scaffoldBackgroundColor
                : colorItem,
            width: border1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(23),
        ),
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: con1,
                height: con1,
                decoration: BoxDecoration(
                  color: colorItem,
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
          onTap: () {
            Provider.of<ThemeModel>(context, listen: false).theme = index;
          },
        ),
      ),
    );
  }


  callback() {}
}
