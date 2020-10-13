import 'dart:convert';

import '../index.dart';

class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _confirmPwdController = new TextEditingController();
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
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                    autofocus: true,
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      hintText: 'First Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    // 校验用户名（不能为空）
                    validator: (v) {
                      return v.trim().isNotEmpty
                          ? null
                          : 'First name is required';
                    }),
                TextFormField(
                  autofocus: false,
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Last Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                    autofocus: false,
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
                  autofocus: false,
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
                      onPressed: _onRegister,
                      textColor: Colors.white,
                      child: Text('Register'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() async {
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      User user;
      try {
        final dbHelper = DatabaseHelper.instance;
        var resJson = await Git(context).register(
            _unameController.text,
            _pwdController.text,
            _pwdController.text,
            _firstNameController.text,
            _lastNameController.text);

        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        print("${resJson['content']}");
        if (resJson['success'] == 1) {
          var content = resJson['content'];
          print("${content['username']}");

          final dir = await Git(context).getSaveDirectory();
          final isPermissionStatusGranted = await Git(context).requestPermissions();
          String avatarUrlLocal;
//          if (content["avatarUrl"] != null && content["avatarUrl"] != '') {
//            var downloadInfo = Git(context)
//                .download('id', content['avatarName'], content['avatarUrl']);
////            if (downloadInfo['isSuccess']) {
////              avatarUrlLocal = downloadInfo['filePath'];
////            }
//          }

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
          Provider.of<UserModel>(context, listen: false).user = user;
//        Global.profile.user = user;
//        Global.profile.user.username = user.username;
//        Global.profile.user.userId = user.userId;
//        Global.profile.user.avatar = user.avatar;
//        Global.profile.user.avatarUrl = user.avatarUrl;

//      更新profile中的token信息
          Global.profile.token = resJson['content']['token'];
          Global.saveProfile();
//        Navigator.of(context).pop();
          print('-------------first name: ${Global.profile.user.firstName}');
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
        socketIoItem.initCommunication();
        socketInit.connect();
        if (socketProviderChatListModel != null) {
          socketProviderChatListModel.reset();
        }
        if (socketProviderContactListModel != null) {
          socketProviderContactListModel.reset();
        }
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
