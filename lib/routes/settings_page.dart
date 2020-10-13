import 'dart:io';
import 'dart:math';
import 'dart:convert';


import '../index.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyInfo();

  }

  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserModel>(context);
    var gAvatar;
    User user = userInfo.user;
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
      appBar: AppBar(
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
//                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
          },
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
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
                                                        fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Icon(Icons.arrow_forward_ios),
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
                    Divider(height: 1,),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _buildMenus(),
          ),

        ]
      ),
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(gm.theme),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.pushNamed(context, "language"),
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: Text("Devices"),
              onTap: () => Navigator.pushNamed(context, "devices"),
            ),

          ],
        );
      },
    );
  }

  getMyInfo() async {
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
