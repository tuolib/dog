import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index.dart';

//bool isOnAddContactPage = false;
//BuildContext addContactContext;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart';

bool hasStartCall = false;
bool isInvite = false;
Signaling signalingCall;
List<dynamic> peersCall;
var selfIdCall;
RTCVideoRenderer localRendererCall = RTCVideoRenderer();
RTCVideoRenderer remoteRendererCall = RTCVideoRenderer();
bool inCalling = false;
String serverIP;
BuildContext callContext;

initRenderers() async {
  await localRendererCall.initialize();
  await remoteRendererCall.initialize();
  connectCall();
  // socketInit2.on('joinRoom', (_) async {
  //   logger.d('joinRoom');
  //
  // });
}

// invitate(user) {
//   socketInit2.emit(
//       "conferenceInvitation", {"room": room, "to": user, "from": username});
//   _invitePeer(context, username, false);
// }

void connectCall() async {
  logger.d('start connect signalingCall: $signalingCall');
  if (signalingCall == null) {
    // signalingCall = Signaling(serverIP)..connect();
    signalingCall = Signaling();
    signalingCall.connect(
      invite: isInvite,
      groupId: callGroupId,
    );

    signalingCall.onStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.CallStateNew:
          // this.setState(() {
          //   inCalling = true;
          // });
          inCalling = true;
          callInfoSocket.updateInCalling(true);
          break;
        case SignalingState.CallStateBye:
          // this.setState(() {
          //   localRendererCall.srcObject = null;
          //   remoteRendererCall.srcObject = null;
          //   inCalling = false;
          // });
          localRendererCall.srcObject = null;
          remoteRendererCall.srcObject = null;
          inCalling = false;
          callInfoSocket.updateInCalling(false);
          break;
        case SignalingState.CallStateInvite:
        case SignalingState.CallStateConnected:
        case SignalingState.CallStateRinging:
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };

    signalingCall.onPeersUpdate = ((event) {
      // this.setState(() {
      //   selfIdCall = event['self'];
      //   peersCall = event['peers'];
      // });
      selfIdCall = event['self'];
      peersCall = event['peers'];
    });

    signalingCall.onLocalStream = ((stream) {
      localRendererCall.srcObject = stream;
    });

    signalingCall.onAddRemoteStream = ((stream) {
      remoteRendererCall.srcObject = stream;
    });

    signalingCall.onRemoveRemoteStream = ((stream) {
      remoteRendererCall.srcObject = null;
    });
    // logger.d('center connect');
  }

  // logger.d('end connect');
  if (!hasStartCall) {
    hasStartCall = true;
    invitePeer(callContext, '${Global.profile.user.userId}', false);
  }
  // _invitePeer(context, '1', false);
}

invitePeer(context, peerId, use_screen) async {
  if (signalingCall != null && peerId != selfIdCall) {
    // logger.d('signalingCall invite');
    signalingCall.invite(peerId, 'video', use_screen);
  }
}

hangUpCall() async {
  if (signalingCall != null) {
    logger.d('hangup');
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // hangup(currentCallUuid);
    inCalling = false;
    callInfoSocket.updateInCalling(false);
    hasStartCall = false;
    isInvite = false;
    if (signalingCall != null) {
      signalingCall.close();
      // signalingCall.bye();
    }
    if (Platform.isAndroid) {
      await localRendererCall?.dispose();
      await remoteRendererCall?.dispose();
    }
    TestOverLay.remove();
    // Navigator.of(callContext).pop();
  }
}

switchCamera() {
  signalingCall.switchCamera();
}

muteMic() {}

createOverlayView(BuildContext context, bool invite) {
  isInvite = invite;
  // if (!inCalling) {
  //   if (!hasStartCall) {
  //     // SystemChrome.setEnabledSystemUIOverlays([]);
  //     initRenderers();
  //   }
  // }
  initRenderers();
  // logger.d('createOverlayView');
  TestOverLay.show(
    context: context,
    view: Consumer<CallInfoModel>(builder:
        (BuildContext context, CallInfoModel callInfoModel, Widget child) {
      bool fullScreen = callInfoModel.fullScreen;
      double width = callInfoModel.width;
      double height = callInfoModel.height;
      return Container(
        width: fullScreen ? MediaQuery.of(context).size.width : width,
        height: fullScreen ? MediaQuery.of(context).size.height : height,
        child: Scaffold(
          body: Container(
            child: callInfoModel.inCalling
                ? OrientationBuilder(builder: (context, orientation) {
                    return Container(
                      child: Stack(children: <Widget>[
                        Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: 0,
                            bottom: 0.0,
                            child: Container(
                              // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: fullScreen
                                  ? MediaQuery.of(context).size.width
                                  : width,
                              height: fullScreen
                                  ? MediaQuery.of(context).size.height
                                  : height,
                              child: RTCVideoView(remoteRendererCall, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,),
                              decoration: BoxDecoration(color: Colors.black54),
                            )),
                        if (fullScreen)
                          Positioned(
                            left: 20.0,
                            top: 80.0,
                            child: Container(
                              width: orientation == Orientation.portrait
                                  ? 90.0
                                  : 120.0,
                              height: orientation == Orientation.portrait
                                  ? 120.0
                                  : 90.0,
                              child: RTCVideoView(localRendererCall),
                              decoration: BoxDecoration(color: Colors.black54),
                            ),
                          ),
                        if (fullScreen)
                          Positioned(
                            //左上角关闭按钮
                            left: 3,
                            top: MediaQuery.of(context).padding.top,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                callInfoSocket.updateFullScreen(false);
                              },
                            ),
                          ),
                        if (!fullScreen)
                          Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: 0,
                            bottom: 0.0,
                            child: InkWell(
                              onTap: () {
                                callInfoSocket.updateFullScreen(true);
                              },
                              child: Container(
                                width: width,
                                height: height,
                              ),
                            ),
                          ),
                      ]),
                    );
                  })
                : SizedBox(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: callInfoModel.inCalling && fullScreen
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FloatingActionButton(
                child: const Icon(Icons.switch_camera),
                onPressed: switchCamera,
              ),
              FloatingActionButton(
                onPressed: hangUpCall,
                tooltip: 'Hangup',
                child: Icon(Icons.call_end),
                backgroundColor: Colors.pink,
              ),
              FloatingActionButton(
                child: const Icon(Icons.mic_off),
                onPressed: muteMic,
              )
            ],
          )
              : SizedBox(),
        ),
      );
    }),
  );
}

class CallVideoTest extends StatefulWidget {
  CallVideoTest({
    Key key,
    this.invite,
  }) : super(key: key);

  final bool invite;

  @override
  _CallVideoTestState createState() => _CallVideoTestState();
}

class _CallVideoTestState extends State<CallVideoTest> {
  @override
  void initState() {
    super.initState();

    // SystemChrome.setEnabledSystemUIOverlays([]);
    if (!inCalling) {
      if (!hasStartCall) {
        // SystemChrome.setEnabledSystemUIOverlays([]);
        initRenderers();
      }
    }
  }

//   @override
//   void dispose() {
//     super.dispose();
// //    isOnAddContactPage = false;
// //     localRendererCall.dispose();
// //     remoteRendererCall.dispose();
// //     signalingCall.close();
//     hasStartCall = false;
//   }

  // @override
  // deactivate() {
  //   super.deactivate();
  // logger.d(signalingCall);
  // if (signalingCall != null) {
  //   signalingCall.close();
  // }
  // localRendererCall.dispose();
  // remoteRendererCall.dispose();
  // hasStartCall = false;
  // hangUpCall();
  // inCalling = false;
  // callInfoSocket.updateInCalling(false);
  // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  // }

  @override
  Widget build(BuildContext context) {
    callContext = context;
    return Consumer<CallInfoModel>(builder:
        (BuildContext context, CallInfoModel callInfoModel, Widget child) {
      return Scaffold(
        appBar: AppBar(title: Text('call')),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: callInfoModel.inCalling
              ? OrientationBuilder(builder: (context, orientation) {
                  return Container(
                    child: Stack(children: <Widget>[
                      Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 50,
                          bottom: 0.0,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: RTCVideoView(remoteRendererCall),
                            decoration: BoxDecoration(color: Colors.black54),
                          )),
                      Positioned(
                        left: 20.0,
                        top: 80.0,
                        child: Container(
                          width: orientation == Orientation.portrait
                              ? 90.0
                              : 120.0,
                          height: orientation == Orientation.portrait
                              ? 120.0
                              : 90.0,
                          child: RTCVideoView(localRendererCall),
                          decoration: BoxDecoration(color: Colors.black54),
                        ),
                      ),
                    ]),
                  );
                })
              : SizedBox(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: callInfoModel.inCalling
            ? SizedBox(
                width: 200.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        child: const Icon(Icons.switch_camera),
                        onPressed: switchCamera,
                      ),
                      FloatingActionButton(
                        onPressed: hangUpCall,
                        tooltip: 'Hangup',
                        child: Icon(Icons.call_end),
                        backgroundColor: Colors.pink,
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.mic_off),
                        onPressed: muteMic,
                      )
                    ]))
            : null,
      );
    });
  }
}
