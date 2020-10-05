import 'dart:io';
import 'dart:math';
import 'dart:convert';


import '../index.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserModel>(context);
    var gAvatar;
    User user = userInfo.user;
    print('user.firstName ${user.firstName}');
    var nameStr = '';
    if (user.firstName != null && user.firstName != '') {
      nameStr += user.firstName.substring(0, 1);
    }
    if (user.lastName != null && user.lastName != '') {
      nameStr += user.lastName.substring(0, 1);
    }
//    print(user.avatarUrl);
    if (user.avatarUrl == null ||
        user.avatarUrl == '' ||
        user.avatarUrlLocal == null) {
      gAvatar = Container(
        width: 60.0,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[rNum],
        ),
        child: Text(
          '$nameStr',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      if (user.avatarUrlLocal == null || user.avatarUrlLocal == '') {
        gAvatar = InkWell(
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(1), BlendMode.dstATop),
                image: NetworkImage("${user.avatarUrlLocal}"),
                fit: BoxFit.cover,
//                      new AssetImage("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg")
//          FileImage(File("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg"))
              ),
            ),
          ),
          onTap: () {
            var arg = {
              'imageProvider': user.avatarUrl,
              'heroTag': user.avatarUrl,
              'type': 'local'
            };
            Navigator.of(context)
                .pushNamed('photoView', arguments: json.encode(arg));
          },
        );
      } else {
        gAvatar = InkWell(
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(1), BlendMode.dstATop),
                image: FileImage(File("${user.avatarUrlLocal}")),
                fit: BoxFit.cover,
//                      new AssetImage("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg")
//          FileImage(File("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg"))
              ),
            ),
          ),
          onTap: () {
            var arg = {
              'imageProvider': user.avatarUrlLocal,
              'heroTag': user.avatarUrlLocal,
              'type': 'local'
            };
            Navigator.of(context)
                .pushNamed('photoView', arguments: json.encode(arg));
          },
        );
      }
    }
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
      body: MediaQuery.removePadding(
        context: context,
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
//                socketProviderConversationListModelGroupId = widget.groupId;
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
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }



  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return ListView(
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

          ],
        );
      },
    );
  }
}
