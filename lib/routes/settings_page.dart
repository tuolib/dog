import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../index.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User user;
  var gAvatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserModel>(context);
    user = userInfo.user;
    // logger.d(user.avatarUrlLocal);
    gAvatar = AvatarWidget(
      firstName: user.firstName,
      lastName: user.lastName,
      avatarUrl: user.avatarUrl,
      avatarLocal: user.avatarUrlLocal,
      // avatarLocal: '/var/sdfdf.jpg',
      colorId: user.colorId,
      width: 60,
      height: 60,
      fontSize: 18,
    );
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
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: DataUtil.iosLightTextBlack(),
//                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: _buildSelf(),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 30,
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenus(),
        ),
      ]),
    );
  }

  Widget _buildSelf() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              InkWell(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              gAvatar,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "${user.firstName} ${user?.lastName}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "@${user.username}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          // color: DataUtil.iosLightTextGrey(),
                                          color: CupertinoTheme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: DataUtil.iosLightTextGrey(),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("editProfile");
                },
              ),
//                Row(
//                  children: [
//                    SizedBox(width: 13, height: 1,),
//                    Expanded(
//                      child: Divider(height: 1,),
//                    ),
//                  ],
//                ),
//                InkWell(
//                  child: Padding(
//                    padding: EdgeInsets.all(2),
//                    child: Row(
//                      children: [
//                        Padding(
//                          padding: EdgeInsets.all(13),
//                          child: Text('Set Profile Photo', style: TextStyle(
//                              color: Theme.of(context).primaryColor
//                          ),),
//                        ),
//                      ],
//                    ),
//                  ),
//                  onTap: () {
////                socketProviderConversationListModelGroupId = widget.groupId;
//                    Navigator.of(context).pushNamed("editProfile");
//                  },
//                ),
//                Row(
//                  children: [
//                    SizedBox(width: 13, height: 1,),
//                    Expanded(
//                      child: Divider(height: 1,),
//                    ),
//                  ],
//                ),
//                InkWell(
//                  child: Padding(
//                    padding: EdgeInsets.all(2),
//                    child: Row(
//                      children: [
//                        Padding(
//                          padding: EdgeInsets.all(13),
//                          child: Text('Set Username', style: TextStyle(
//                              color: Theme.of(context).primaryColor
//                          ),),
//                        ),
//                      ],
//                    ),
//                  ),
//                  onTap: () {
////                socketProviderConversationListModelGroupId = widget.groupId;
//                    Navigator.of(context).pushNamed("editUsername");
//                  },
//                ),
            ],
          ),
          Divider(
            height: 1,
            color: DataUtil.iosBorderGreyDeep(),
          ),
        ],
      ),
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    var devicesObj = Provider.of<DeviceModel>(context);
    var len = devicesObj.device.length;
    var deviceNum = len > 0 ? '$len' : '';
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        double iconWidth = 27;
        double iconMargin = 10;
        double iconSize = 20;
        double iconBorderWidth = 4;
        double dividerLeft = iconWidth + iconMargin * 2;
        Color forwardColor = DataUtil.iosLightTextGrey();
        var localeModel = Provider.of<LocaleModel>(context);

        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Divider(
                height: 1,
                color: DataUtil.iosBorderGreyDeep(),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: iconWidth,
                      height: iconWidth,
                      margin: EdgeInsets.all(iconMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(iconBorderWidth),
                        color: Color.fromRGBO(89, 168, 215, 1),
                      ),
                      child: Icon(
                        DefineIcons.appearance,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Appearance',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            color: forwardColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, "themes"),
              ),
              Container(
                padding: EdgeInsets.only(left: dividerLeft),
                child: Divider(
                  height: 1,
                  color: DataUtil.iosBorderGreyShallow(),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: iconWidth,
                      height: iconWidth,
                      margin: EdgeInsets.all(iconMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(iconBorderWidth),
                        color: Color.fromRGBO(196, 121, 224, 1),
                      ),
                      child: Icon(
                        Icons.language,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${gm.language}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${localeModel.localeName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: forwardColor,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.forward,
                                color: forwardColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, "language"),
              ),
              Container(
                padding: EdgeInsets.only(left: dividerLeft),
                child: Divider(
                  height: 1,
                  color: DataUtil.iosBorderGreyShallow(),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: iconWidth,
                      height: iconWidth,
                      margin: EdgeInsets.all(iconMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(iconBorderWidth),
                        color: Color.fromRGBO(240, 154, 54, 1),
                      ),
                      child: Icon(
                        Icons.devices,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Devices',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$deviceNum',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: forwardColor,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.forward,
                                color: forwardColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, "devices"),
              ),
              Container(
                padding: EdgeInsets.only(left: dividerLeft),
                child: Divider(
                  height: 1,
                  color: DataUtil.iosBorderGreyShallow(),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: iconWidth,
                      height: iconWidth,
                      margin: EdgeInsets.all(iconMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(iconBorderWidth),
                        color: Color.fromRGBO(142, 142, 147, 1),
                      ),
                      child: Icon(
                        CupertinoIcons.padlock_solid,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy and Security',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            color: forwardColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, "themes"),
              ),

              Divider(
                height: 1,
                color: DataUtil.iosBorderGreyDeep(),
              ),
              // ListTile(
              //   //89, 168, 215
              //   leading: const Icon(DefineIcons.appearance),
              //   title: Text(gm.theme),
              //   onTap: () => Navigator.pushNamed(context, "themes"),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.language),
              //   title: Text(gm.language),
              //   onTap: () => Navigator.pushNamed(context, "language"),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.devices),
              //   title: Text("Devices"),
              //   onTap: () => Navigator.pushNamed(context, "devices"),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenusAbout() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        double iconWidth = 27;
        double iconMargin = 10;
        double iconSize = 20;
        double iconBorderWidth = 4;
        double dividerLeft = iconWidth + iconMargin * 2;
        Color forwardColor = DataUtil.iosLightTextGrey();
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Divider(
                height: 1,
                color: DataUtil.iosBorderGreyDeep(),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: iconWidth,
                      height: iconWidth,
                      margin: EdgeInsets.all(iconMargin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(iconBorderWidth),
                        color: Color.fromRGBO(89, 168, 215, 1),
                      ),
                      child: Icon(
                        DefineIcons.appearance,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Appearance',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            color: forwardColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, "themes"),
              ),

              Divider(
                height: 1,
                color: DataUtil.iosBorderGreyDeep(),
              ),
              // ListTile(
              //   //89, 168, 215
              //   leading: const Icon(DefineIcons.appearance),
              //   title: Text(gm.theme),
              //   onTap: () => Navigator.pushNamed(context, "themes"),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.language),
              //   title: Text(gm.language),
              //   onTap: () => Navigator.pushNamed(context, "language"),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.devices),
              //   title: Text("Devices"),
              //   onTap: () => Navigator.pushNamed(context, "devices"),
              // ),
            ],
          ),
        );
      },
    );
  }

  getMyInfo() async {
    // if (!mounted) return;
    // logger.d('get info');
    final dbHelper = DatabaseHelper.instance;
    var myInfo = await dbHelper.userOne(Global.profile.user.userId);
    // logger.d(myInfo);
    if (myInfo != null) {
      Global.profile.user.firstName = myInfo.firstName;
      Global.profile.user.lastName = myInfo.lastName;
      FileSql fileInfo = await dbHelper.fileOne(myInfo.avatar);
      if (fileInfo != null) {
        Global.profile.user.avatarUrl = fileInfo.fileCompressUrl;
        Global.profile.user.avatarUrlLocal = fileInfo.fileOriginLocal;
        // logger.d(fileInfo.fileOriginLocal);
      }

      UserModel userInfo = Provider.of<UserModel>(context, listen: false);
      userInfo.user = Global.profile.user;
      Global.saveProfile();
      userInfo.changeUser();
    }
  }
}
