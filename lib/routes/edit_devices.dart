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
      backgroundColor: DataUtil.iosLightGrey(),
      // backgroundColor: CupertinoColors.lightBackgroundGray,
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
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: DataUtil.iosLightTextBlue(),
            size: 34,
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed("newMessage");
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Devices",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          color: DataUtil.iosLightTextBlack(),
      //                        fontSize: 14,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildSelf(context),
          ),
          SliverToBoxAdapter(
            child: _buildMenus(),
          ),
          // SliverToBoxAdapter(
          //   child: Container(
          //     child: Divider(
          //       height: 2,
          //     ),
          //   ),
          // )
        ]),
      ),
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
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(16.0),
          //   color: Colors.black12,
          // ),
          child: Text('Current session'),
        ),
        Divider(
          height: 2,
          color: Color.fromRGBO(207, 206, 213, 1),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 15,
          ),
          // color: Color.fromRGBO(255, 255, 255, 1),
          color: Colors.white,
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(16.0),
          //   // color: Colors.white,
          //   color: HexColor.fromHex('#FFFFFF'),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    // decoration: BoxDecoration(
                    //   // borderRadius: BorderRadius.circular(16.0),
                    //   color: Colors.white,
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextOneLine(
                                "$dogClient",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '$dogInfo',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 10),
                          child: Text(
                            'online',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    // child: ListTile(
                    //   title: Text('$dogClient'),
                    //   subtitle: Text('$dogInfo'),
                    //   trailing: Text(
                    //     'online',
                    //     style: TextStyle(color: Colors.blue),
                    //   ),
                    // ),
                  ),
                  if (showT)
                    Container(
                      child: Divider(
                        height: 2,
                        color: Color.fromRGBO(201, 200, 205, 1.000),
                      ),
                    ),
                ],
              ),
              if (showT)
                GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'Terminate all other sessions',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    showModelAll(allOtherId);
                  },
                ),
            ],
          ),
        ),
        Divider(
          height: 2,
          color: Color.fromRGBO(207, 206, 213, 1),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 6, left: 15, bottom: 6),
              width: MediaQuery.of(context).size.width,
              // color: Colors.white10,
              // decoration: BoxDecoration(
              //   // borderRadius: BorderRadius.circular(16.0),
              //   color: Colors.black12,
              // ),
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
            // decoration: BoxDecoration(
            //   // borderRadius: BorderRadius.circular(16.0),
            //   color: Colors.black12,
            // ),
            child: Text('Active session'),
          ),
        if (showT)
          Divider(
            height: 1,
            color: Color.fromRGBO(207, 206, 213, 1),
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
    if (devices.length <= 1) return SizedBox();
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
      bool isLast = myList.length - 1 == i;
      var item = Container(
//        height: 80,
        child: _buildItem(myList[i], isLast),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
      );
      allMember.add(item);
    }
    return Wrap(
      children: <Widget>[...allMember],
    );
  }

  Widget _buildItem(Map device, bool last) {
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
            child: Container(
              padding: EdgeInsets.only(
                left: 6,
              ),
              // color: Color.fromRGBO(255, 255, 255, 1),
              color: Colors.white,
              // decoration: BoxDecoration(
              //   // borderRadius: BorderRadius.circular(16.0),
              //   // color: Colors.white,
              //   color: HexColor.fromHex('#FFFFFF'),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        // decoration: BoxDecoration(
                        //   // borderRadius: BorderRadius.circular(16.0),
                        //   color: Colors.white,
                        // ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextOneLine(
                                    "$dogClient",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '$dogInfo',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.only(left: 15, right: 10),
                            //   child: Text(
                            //     'online',
                            //     style: TextStyle(color: Colors.blue),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Terminate',
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
          child: !last
              ? Divider(
                  height: 1,
                  color: DataUtil.iosBorderGreyDeep(),
                )
              : SizedBox(),
        ),
        if (last)
          Divider(
            height: 1,
            color: DataUtil.iosBorderGreyDeep(),
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
