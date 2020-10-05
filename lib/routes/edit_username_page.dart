import 'dart:io';
import 'dart:math';

import '../index.dart';

class EditUsernameRoute extends StatefulWidget {
  @override
  _EditUsernameState createState() => _EditUsernameState();
}

class _EditUsernameState extends State<EditUsernameRoute> {
  TextEditingController _unameController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  bool _nameAutoFocus = true;

  User user = Global.profile.user;

  @override
  void initState() {
    _unameController.text = user.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
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
                        "Username",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
//                        fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
//            conversionInfo['groupName'] = 'sdff';
//            conversion.updateInfoProperty('groupName', '123132');
            },
          ),
          actions: <Widget>[
            // 非隐藏的菜单
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                _onEdit(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                autovalidate: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          autofocus: _nameAutoFocus,
                          controller: _unameController,
                          decoration: InputDecoration(
//                        labelText: 'Your Username',
                            hintText: 'Your Username',
                          ),
                          // 校验用户名（不能为空）
                          validator: (v) {
                            return v.trim().isNotEmpty && v.length >= 2
                                ? null
                                : gm.userNameRequired;
                          }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'You can choose a username.' +
                      ' If you do, other people will be able ' +
                      'to find you by this username and contact you.',
//              style: TextStyle(
//                color:
//              ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'You can use a-z, 0-9.' +
                      ' Minimum length is 2 characters.',
//              style: TextStyle(
//                color:
//              ),
                ),
              ),
            ],
          ),
        ));
  }


  void _onEdit(pageContext) async {
    var userInfo = Provider.of<UserModel>(pageContext, listen: false);
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      User user;
      try {
        var resJson = await Git(context)
            .mergeUsername(_unameController.text);

        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        print("${resJson['content']}");
        if (resJson['success'] == 1) {
          var content = resJson['content'];
          print("${content['username']}");
          Provider.of<UserModel>(context, listen: false).user.username = _unameController.text;
          Global.saveProfile();
//        Navigator.of(context).pop();
          userInfo.changeUsername(_unameController.text);
          print('username: ${Global.profile.user.username}');

          // 返回
          Navigator.of(pageContext).pop();
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
//      if (user != null) {
//        // 返回
//        Navigator.of(pageContext).pop();
////        Navigator.pop(context);
//      }
    }
  }
}
