import 'dart:io';
import 'dart:math';
import 'dart:convert';

import '../index.dart';

bool isOnAddContactPage = false;
BuildContext addContactContext;

class AddContactRoute extends StatefulWidget {
  @override
  _AddContactRouteState createState() => _AddContactRouteState();
}

class _AddContactRouteState extends State<AddContactRoute> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  bool _nameAutoFocus = true;

  User user = Global.profile.user;

  BuildContext pageCon;

  @override
  void initState() {
    super.initState();
    isOnAddContactPage = true;
  }

  @override
  void dispose() {
    super.dispose();
    isOnAddContactPage = false;
  }

  @override
  Widget build(BuildContext context) {
    addContactContext = context;
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
                        "New Contact",
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
                autovalidate: false,
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(right: 10),
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                        autofocus: true,
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          labelText: 'First name(required)',
                                          hintText: 'First name(required)',
                                        ),
                                        // 校验用户名（不能为空）
                                        validator: (v) {
                                          return v.trim().isNotEmpty
                                              ? null
                                              : "First name is required";
                                        }),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name(option)',
                                        hintText: 'Last Name(option)',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                  autofocus: false,
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username(required)',
                                    hintText: 'Username(required)',
                                  ),
                                  // 校验用户名（不能为空）
                                  validator: (v) {
                                    return v.trim().isNotEmpty && v.length >= 2
                                        ? null
                                        : gm.userNameRequired;
                                  }),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  void _onEdit(pageContext) async {
    pageCon = pageContext;
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      SocketIoEmit.clientAddContacts(
        username: _usernameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );
//      Navigator.of(context).pop();

    }
  }
}
