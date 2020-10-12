import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../index.dart';

class DevicesPage extends StatefulWidget {
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  @override
  Widget build(BuildContext context) {
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
                      "Devices",
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
          onTap: () {},
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30, left: 15, bottom: 6),
                width: MediaQuery.of(context).size.width,
                // color: Colors.white10,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(16.0),
                  color: Colors.black12,
                ),
                child: Text('Current session'),
              ),
              Column(
                children: [
                  Container(
                    child: ListTile(
                      title: Text('Dog IOS 1.0.0'),
                      subtitle: Text('iPhone 5s, ios, 12.4.5'),
                      trailing: Text(
                        'online',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Divider(
                      height: 2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                child: InkWell(
                  child: Text(
                    'Terminate all other sessions',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showModelAll();
                  },
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 6, left: 15, bottom: 6),
                width: MediaQuery.of(context).size.width,
                // color: Colors.white10,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(16.0),
                  color: Colors.black12,
                ),
                child: Text('Logs out all devices except for this one.'),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30, left: 15, bottom: 6),
                width: MediaQuery.of(context).size.width,
                // color: Colors.white10,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(16.0),
                  color: Colors.black12,
                ),
                child: Text('Active session'),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenus(),
        ),
        SliverToBoxAdapter(
          child: Container(
            child: Divider(
              height: 2,
            ),
          ),
        )
      ]),
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return Column(
          children: <Widget>[
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    children: [
                      Text('sdf'),
                    ],
                  ),
                  subtitle: TextOneLine(
                    "123",
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Container(
                        height: 16,
                        child: Text('sdf'),
                      ),
                    ],
                  ),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    showModel();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  showModelAll() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Terminate all other sessions',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );

    // return showCupertinoModalPopup(context: context, builder: null);
  }
  showModel() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Terminate session',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );

    // return showCupertinoModalPopup(context: context, builder: null);
  }
}
