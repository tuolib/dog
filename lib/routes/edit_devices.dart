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
  List devices = [];

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
          child: _buildSelf(context),
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

  Widget _buildSelf(BuildContext context) {
    var deviceInfo = Provider.of<DeviceModel>(context);
    var allDevice = deviceInfo.device;
    int tokenId = Global.profile.user.tokenId;
    var device;
    List<int> allOtherId = [];
    for (var i = 0; i < allDevice.length; i++) {
      if (allDevice[i]['id'] == tokenId) {
        device = allDevice[i];
        // break;
      } else {

        allOtherId.add(allDevice[i]['id']);
      }
    }
    if (device == null) return SizedBox();
    // logger.d(device);
    var dogClient = device['loginType'] == 0
        ? 'Dog web'
        : device['loginType'] == 1 ? 'Dog IOS' : 'Dog Android';
    var dogInfo = device['deviceInfo'] == null ? '' : device['deviceInfo'];
    bool showT = allDevice.length >= 2 ? true : false;
    return Column(
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
                title: Text('$dogClient'),
                subtitle: Text('$dogInfo'),
                trailing: Text(
                  'online',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            if (showT)
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Divider(
                  height: 2,
                ),
              ),
          ],
        ),
        if (showT)
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: InkWell(
              child: Text(
                'Terminate all other sessions',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showModelAll(allOtherId);
              },
            ),
          ),
        Column(
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
              child: showT
                  ? Text('Logs out all devices except for this one.')
                  : SizedBox(),
            ),
          ],
        ),
        if (showT)
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
    );
  }

  // 构建 list
  Widget _buildMenus() {
    return Consumer<DeviceModel>(
      builder: (BuildContext context, DeviceModel deviceModel, Widget child) {
        devices = deviceModel.device;
        return _buildDevice();
      },
    );
  }

  Widget _buildDevice() {
    // logger.d(devices);
    // logger.d(Global.profile.user.tokenId);
    int tokenId = Global.profile.user.tokenId;
    List myList = [];
    for (var i = 0; i < devices.length; i++) {
      if (devices[i]['id'] != tokenId) {
        myList.add(devices[i]);
      }
    }
    // List myList = List.from(devices);
    // ArrayUtil.sortArray(myList, sortOrder: 0, property: 'lastSeen');
    // ArrayUtil.sortArray(myList, sortOrder: 0, property: 'isOnline');
    var allMember = <Widget>[];
    for (var i = 0; i < myList.length; i++) {
      var item = Container(
//        height: 80,
        child: _buildItem(myList[i]),
      );
      allMember.add(item);
    }
    return Wrap(
      children: <Widget>[...allMember],
    );
  }

  Widget _buildItem(Map device) {
    var dogClient = device['loginType'] == 0
        ? 'Dog web'
        : device['loginType'] == 1 ? 'Dog IOS' : 'Dog Android';
    var dogInfo = device['deviceInfo'] == null ? '' : device['deviceInfo'];
    return Column(
      children: <Widget>[
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 6),
              title: Row(
                children: [
                  Text('$dogClient'),
                ],
              ),
              subtitle: TextOneLine(
                "$dogInfo",
                overflow: TextOverflow.ellipsis,
              ),
              // trailing: Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: <Widget>[
              //     SizedBox(height: 10),
              //     Container(
              //       height: 16,
              //       child: Text('sdf'),
              //     ),
              //   ],
              // ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                showModel(device['id']);
              },
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 15),
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  }

  showModelAll(List<int> ids) {
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
                SocketIoEmit.deviceDelete(ids);
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

  showModel(int id) {
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
                SocketIoEmit.deviceDelete([id]);
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
