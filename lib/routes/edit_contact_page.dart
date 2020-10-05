import 'dart:io';
import 'dart:math';
import 'dart:convert';

import '../index.dart';

bool isOnEditContactPage = false;
BuildContext editContactContext;

class EditContactRoute extends StatefulWidget {
  final String firstName;
  final String lastName;
  final int colorId;
  final String avatarUrl;
  final String avatarLocal;
//  人的 user 表中id
  final int userId;
//  contact 表中的 id
  final int contactSqlId;
  final bool isAdd;
  final String username;

  EditContactRoute({
    Key key,
    this.firstName,
    this.lastName,
    this.colorId,
    this.avatarUrl,
    this.avatarLocal,
    this.userId,
    this.contactSqlId,
    this.isAdd,
    this.username,
  }) : super(key: key);

  @override
  _EditContactRouteState createState() => _EditContactRouteState();
}

class _EditContactRouteState extends State<EditContactRoute> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  BuildContext pageCon;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
//    logger.d(widget.contactSqlId);
    isOnEditContactPage = true;
  }

  @override
  void dispose() {
    super.dispose();
    isOnEditContactPage = false;
  }

  @override
  Widget build(BuildContext context) {
    editContactContext = context;
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
                        "${widget.isAdd ? 'New Contact' : 'Edit Name'}",
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
                                    AvatarWidget(
                                      colorId: widget.colorId,
                                      firstName: widget.firstName,
                                      lastName: widget.lastName,
                                      width: 60,
                                      height: 60,
                                      avatarUrl: widget.avatarUrl,
                                      avatarLocal: widget.avatarLocal,
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
      if (widget.isAdd) {
        SocketIoEmit.clientAddContacts(
          username: widget.username,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        );
      } else {
        SocketIoEmit.clientEditContacts(
          contactSqlId: widget.contactSqlId,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        );
      }
//      Navigator.of(context).pop();

    }
  }
}
