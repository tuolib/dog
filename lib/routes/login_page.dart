import '../index.dart';
import 'dart:convert';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
//    _unameController.text = Global.profile.lastLogin;
//    if (_unameController.text != null || _unameController.text != '') {
//      _nameAutoFocus = false;
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.login)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                    autofocus: _nameAutoFocus,
                    controller: _unameController,
                    decoration: InputDecoration(
                      labelText: gm.userName,
                      hintText: gm.userNameOrEmail,
                      prefixIcon: Icon(Icons.person),
                    ),
                    // 校验用户名（不能为空）
                    validator: (v) {
                      return v.trim().isNotEmpty ? null : gm.userNameRequired;
                    }),
                TextFormField(
                  controller: _pwdController,
                  autofocus: !_nameAutoFocus,
                  decoration: InputDecoration(
                      labelText: gm.password,
                      hintText: gm.password,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                            pwdShow ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            pwdShow = !pwdShow;
                          });
                        },
                      )),
                  obscureText: !pwdShow,
                  //校验密码（不能为空）
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : gm.passwordRequired;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 55.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: _onLogin,
                      textColor: Colors.white,
                      child: Text(gm.login),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('Register'), Icon(Icons.arrow_forward)],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed("register");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      User user;
      try {
        final dbHelper = DatabaseHelper.instance;
        var resJson = await Git(context)
            .login(_unameController.text, _pwdController.text);

        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        print("${resJson['content']}");
        if (resJson['success'] == 1) {
          String avatarUrlLocal;
          var content = resJson['content'];
          print("${content['username']}");
          final dir = await Git(context).getSaveDirectory();
          final isPermissionStatusGranted =
              await Git(context).requestPermissions();
          if (content["avatarUrl"] != null && content["avatarUrl"] != '') {
            var downloadInfo = Git(context)
                .saveMyAvatar(content['avatarName'], content['avatarUrl']);
//            if (downloadInfo != '') {
//              avatarUrlLocal = downloadInfo;
//            }
            Git(context).saveImageFileOrigin(
                content["avatar"], content['avatarName'], content["avatarUrl"]);
          }

          UserSql addInfo = UserSql(
            username: content["username"],
            firstName: content["firstName"],
            lastName: content["lastName"],
            id: content["userId"],
            avatar: content["avatar"],
            colorId: content["colorId"],
            bio: content["bio"],
            isOnline: true,
            lastSeen: content["lastSeen"],
          );
          await dbHelper.userUpdateOrInsert(addInfo);
          user = User.fromJson({
            "username": content["username"],
            "firstName": content["firstName"],
            "lastName": content["lastName"],
            "userId": content["userId"],
            "avatar": content["avatar"],
            "avatarUrl": content["avatarUrl"],
            "avatarUrlLocal": avatarUrlLocal,
            "token": content["token"],
            "tokenId": content["tokenId"],
          });
          logger.d(content['tokenId']);
//        Global.profile.user = user;
//        Global.profile.user.username = user.username;
//        Global.profile.user.userId = user.userId;
//        Global.profile.user.avatar = user.avatar;
//        Global.profile.user.avatarUrl = user.avatarUrl;

          Provider.of<UserModel>(context, listen: false).user = user;
//      更新profile中的token信息
          Global.profile.token = resJson['content']['token'];
          Global.saveProfile();
//        Navigator.of(context).pop();
          print('username: ${Global.profile.user.userId}');
        } else {
          showToast(resJson['respMsg']);
        }
      } catch (e) {
        //登录失败则提示
        print('e-----: $e');
        if (e.response?.statusCode == 401) {
          showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
        } else {
          showToast(e.toString());
        }
      } finally {
        // 隐藏loading框
        Navigator.of(context).pop();
      }
      if (user != null) {
        // 返回

//        socketInit.connect();
        socketIoItem.initCommunication();
        socketInit.connect();
        if (socketProviderChatListModel != null) {
          socketProviderChatListModel.reset();
        }
        if (socketProviderContactListModel != null) {
          socketProviderContactListModel.reset();
        }
        print('=============issend: $isSend');
//        if (isSend == false) {
//          isSend = true;
//          var sendDataGroup = json.encode({
//            'type': 'clientOpenGroup',
//            'authtoken': Global.profile.token,
//          });
//          socketInit.emit('msg', sendDataGroup);
//
//          var clientGetContacts = json.encode({
//            'type': 'clientGetContacts',
//            'authtoken': Global.profile.token,
//          });
//          socketInit.emit('msg', clientGetContacts);
//        }
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed("main");
//        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}
