import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index.dart';

//bool isOnAddContactPage = false;
//BuildContext addContactContext;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';

bool hasStartCall = false;
bool isInvite = false;
Signaling signalingCall;
List<dynamic> peersCall;
var selfIdCall;
RTCVideoRenderer localRendererCall = RTCVideoRenderer();
RTCVideoRenderer remoteRendererCall = RTCVideoRenderer();
String serverIP;
BuildContext callContext;
IncallManager incallManager = new IncallManager();

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
      groupId: int.parse(Global.callGroupId),
    );

    signalingCall.onStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.CallStateNew:
          // callInfoSocket.updateInCalling(true);
          break;
        case SignalingState.CallStateBye:
          // localRendererCall.srcObject = null;
          // remoteRendererCall.srcObject = null;
          // callInfoSocket.updateInCalling(false);
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
      selfIdCall = event['self'];
      peersCall = event['peers'];
    });

    signalingCall.onLocalStream = ((stream) {
      // if (hasStartCall) {
      //   localRendererCall.srcObject = stream;
      // }
      localRendererCall.srcObject = stream;
    });

    signalingCall.onAddRemoteStream = ((stream) {
      // if (hasStartCall) {
      //   remoteRendererCall.srcObject = stream;
      //   // callInfoSocket.updateCall();
      // }
      remoteRendererCall.srcObject = stream;
    });

    signalingCall.onRemoveRemoteStream = ((stream) {
      // if (hasStartCall) {
      //   remoteRendererCall.srcObject = null;
      // }
      remoteRendererCall.srcObject = null;
    });
    //
  }
  if (!hasStartCall) {
    hasStartCall = true;
    if (isInvite) {
      invitePeer(callContext, '${Global.callFriendId}', false);
    } else {
      logger.d('callDescriptionGet');
      SocketIoEmit.callDescriptionGet(
        fromId: Global.profile.user.userId,
        // toId: chatInfoModelSocket.conversationInfo['contactId'],
        groupId: int.parse(Global.callGroupId),
      );

      // SocketIoEmit.callCandidateGet(
      //   fromId: Global.profile.user.userId,
      //   // toId: chatInfoModelSocket.conversationInfo['contactId'],
      //   groupId: int.parse(Global.callGroupId),
      // );
    }
  }
}

invitePeer(context, peerId, use_screen) async {
  if (signalingCall != null) {
    // logger.d('signalingCall invite');
    signalingCall.invite(peerId, 'video', use_screen);
  }
}

switchCamera() {
  signalingCall.switchCamera();
}

videoSet() {
  bool enable = !callInfoSocket.videoEnable;
  logger.d(enable);
  callInfoSocket.updateVideo(enable);
  signalingCall.videoSet(enable);
}

muteMic(enable) {
  logger.d('mute mic');
  callInfoSocket.updateVoice(enable);
  signalingCall.voiceSet(enable);
}

mutePhoneCall(enable) async {
  if (Platform.isAndroid) {
    // bool isBusy = await callKeepIn.isCallActive(currentCallUuid);
    // if (isBusy) {
    //   setCallMuted(currentCallUuid, enable);
    // }
    // setCallMuted(Global.currentCallUuid, enable);
    callKeepIn.setMutedCall(Global.currentCallUuid, enable);
  } else if (Platform.isIOS) {
    // callKitIn.
    // bool isBusy =  await callKitIn.checkIfBusy();
    // if (isBusy) {
    //   callKitIn.setMutedCall(Global.currentCallUuid, enable);
    // }
    callKitIn.setMutedCall(Global.currentCallUuid, enable);
  }
}

hangUpCall() async {
  hasStartCall = false;
  isInvite = false;
  // callInfoSocket.updateFullScreen(false);
  // callInfoSocket.updateInCalling(false);

  callInfoSocket.updateSystemFull(false, noti: false);
  TestOverLay.remove();
  socketInit.off('callDescriptionGet');
  socketInit.off('callCandidateGet');
  socketInit.off('callCandidate');
  socketInit.off('callOffer');
  socketInit.off('callAnswer');
  socketInit.off('callBye');
  socketInit.off('callClosed');

  if (signalingCall != null) {
    // logger.d('signalingCall.close');
    await signalingCall.close();
  }

  if (localRendererCall != null) {
    logger.d('localRendererCall.close');

    // localRendererCall.srcObject = null;
    await localRendererCall?.dispose();
    localRendererCall = null;
  }
  if (remoteRendererCall != null) {
    logger.d('remoteRendererCall.close');
    // remoteRendererCall.srcObject = null;
    await remoteRendererCall?.dispose();
    remoteRendererCall = null;
  }
}

overCallAll({
  bool emit = true,
  bool system = true,
  bool view = true,
}) {
  // 接听的那一方，还未接通，挂断
  // logger.d('hasCall ${Global.hasCall}');
  // logger.d('hasStartCall $hasStartCall');
  // logger.d('callSuccess ${callInfoSocket.callSuccess}');
  if (emit &&
      Global.hasCall == '1' &&
      !hasStartCall &&
      !callInfoSocket.callSuccess) {
    // logger.d('bye call');
    SocketIoEmit.callBye(
      groupId: int.parse(Global.callGroupId),
    );
  }
  // && Global.hasCall == '1'
  if (system) {
    if (Platform.isAndroid) {
      callKeepIn.endCall(Global.currentCallUuid);
    } else {
      callKitIn.endCall(Global.currentCallUuid);
    }
  }
  if (view && hasStartCall) {
    hangUpCall();
  }

  if (emit && callInfoSocket.callSuccess) {
    callInfoSocket.updateCallSuccess(false, noti: false);
    // sendCallBye = true;
    SocketIoEmit.callBye(
      groupId: int.parse(Global.callGroupId),
    );
  }
// 放在最后
//   hasCall = false;

  // Global.saveUuid('');
  // Global.saveCallFriendId('0');
  // Global.saveCallGroupId('0');
  Global.saveHasCall('0');
}

createOverlayView(BuildContext context, bool invite, {String uuid}) async {
  if (Platform.isAndroid && uuid != null) {
    final dbHelper = DatabaseHelper.instance;
    var callInfo = await dbHelper.callOne(uuid);
    logger.d(callInfo);
    if (callInfo != null) {
      var detailCall = callInfo[0];
      Global.callGroupId = detailCall['groupId'];
      Global.saveUuid(uuid);
      Global.saveCallGroupId(detailCall['groupId']);
      Global.saveCallerName(detailCall['callerName']);
    }
  }
  // 还未拨通成功
  callInfoSocket.updateInCalling(true);
  // 还未拨通成功
  callInfoSocket.updateCallSuccess(false);
  // 打开全屏幕
  callInfoSocket.updateFullScreen(true);
  callInfoSocket.updateSystemFull(true);
  // 打开声音
  callInfoSocket.updateVoice(false);
  // sendCallBye = false;
  isInvite = invite;
  // if (!inCalling) {
  //   if (!hasStartCall) {
  //     // SystemChrome.setEnabledSystemUIOverlays([]);
  //     initRenderers();
  //   }
  // }

  localRendererCall = RTCVideoRenderer();
  remoteRendererCall = RTCVideoRenderer();
  await initRenderers();
  // logger.d('createOverlayView');
  // incallManager.start(
  //     media: MediaType.AUDIO, auto: false, ringback: '');
  // incallManager.setSpeakerphoneOn(true);
  // incallManager.setForceSpeakerphoneOn(flag: ForceSpeakerType.FORCE_ON);
  // callKeepIn.
  // callKitIn.
  TestOverLay.show(
    context: context,
    view: Consumer<CallInfoModel>(builder:
        (BuildContext context, CallInfoModel callInfoModel, Widget child) {
      bool fullScreen = callInfoModel.fullScreen;
      double width = callInfoModel.width;
      double height = callInfoModel.height;
      // var remoteStream = callInfoModel.remoteStream;
      bool voiceMute = callInfoModel.voiceMute;
      bool videoEnable = callInfoModel.videoEnable;
      bool inCalling = callInfoModel.inCalling;
      bool selfBig = callInfoModel.selfBig;
      bool showButton = callInfoModel.showButton;
      bool callSuccess = callInfoModel.callSuccess;
      return Container(
        width: fullScreen ? MediaQuery.of(context).size.width : width,
        height: fullScreen ? MediaQuery.of(context).size.height : height,
        child: Scaffold(
          body: Container(
            child: inCalling
                ? OrientationBuilder(builder: (context, orientation) {
                    return Container(
                      child: Stack(children: <Widget>[
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0,
                          bottom: 0.0,
                          child: InkWell(
                            child: Container(
                              // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: fullScreen
                                  ? MediaQuery.of(context).size.width
                                  : width,
                              height: fullScreen
                                  ? MediaQuery.of(context).size.height
                                  : height,
                              child: RTCVideoView(
                                !callSuccess || selfBig
                                    ? localRendererCall
                                    : remoteRendererCall,
                                objectFit: RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitCover,
                              ),
                              decoration: BoxDecoration(color: Colors.black54),
                            ),
                            onTap: () {
                              callInfoSocket.updateShowButton(!showButton);
                            },
                          ),
                        ),
                        if (fullScreen && callSuccess)
                          Positioned(
                            right: 20.0,
                            bottom: showButton ? 80.0 : 20.0,
                            child: InkWell(
                              child: Container(
                                width: orientation == Orientation.portrait
                                    ? 90.0
                                    : 120.0,
                                height: orientation == Orientation.portrait
                                    ? 120.0
                                    : 90.0,
                                child: RTCVideoView(!callSuccess || selfBig
                                    ? remoteRendererCall
                                    : localRendererCall),
                                decoration:
                                    BoxDecoration(color: Colors.black54),
                              ),
                              onTap: () {
                                callInfoSocket.updateSelfBig(!selfBig);
                              },
                            ),
                          ),
                        if (fullScreen && showButton)
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
                                callInfoSocket.updateSystemFull(false);
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
                                callInfoSocket.updateSystemFull(true);
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
          floatingActionButton: inCalling && fullScreen && showButton
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(
                        Icons.videocam,
                        color: videoEnable ? Colors.black38 : Colors.white,
                      ),
                      onPressed: videoSet,
                      backgroundColor:
                          videoEnable ? Colors.white : Colors.white24,
                    ),
                    FloatingActionButton(
                      child: Icon(
                        Icons.mic_off,
                        color: voiceMute ? Colors.black38 : Colors.white,
                      ),
                      onPressed: () {
                        bool enable = !callInfoSocket.voiceMute;
                        logger.d(enable);
                        // callInfoSocket.updateVoice(enable);
                        muteMic(enable);
                        // mutePhoneCall(enable);
                      },
                      backgroundColor:
                          voiceMute ? Colors.white : Colors.white24,
                    ),
                    FloatingActionButton(
                      child: Icon(
                        Icons.switch_camera,
                        color: Colors.white,
                      ),
                      onPressed: switchCamera,
                      backgroundColor: Colors.white24,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (!callInfoSocket.callSuccess) {
                          SocketIoEmit.cancelInvite(
                            groupId: int.parse(Global.callGroupId),
                            fromId: Global.profile.user.userId,
                            toId: int.parse(Global.callFriendId),
                            uuid: Global.currentCallUuid,
                          );
                        }
                        overCallAll();
                      },
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
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
    // if (!callInfoSocket.inCalling) {
    //   if (!hasStartCall) {
    //     // SystemChrome.setEnabledSystemUIOverlays([]);
    //     initRenderers();
    //   }
    // }
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
    return Text('123');
    // return Consumer<CallInfoModel>(builder:
    //     (BuildContext context, CallInfoModel callInfoModel, Widget child) {
    //   return Scaffold(
    //     appBar: AppBar(title: Text('call')),
    //     body: Padding(
    //       padding: EdgeInsets.all(10),
    //       child: callInfoModel.inCalling
    //           ? OrientationBuilder(builder: (context, orientation) {
    //               return Container(
    //                 child: Stack(children: <Widget>[
    //                   Positioned(
    //                       left: 0.0,
    //                       right: 0.0,
    //                       top: 50,
    //                       bottom: 0.0,
    //                       child: Container(
    //                         margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    //                         width: MediaQuery.of(context).size.width,
    //                         height: MediaQuery.of(context).size.height,
    //                         child: RTCVideoView(remoteRendererCall),
    //                         decoration: BoxDecoration(color: Colors.black54),
    //                       )),
    //                   Positioned(
    //                     left: 20.0,
    //                     top: 80.0,
    //                     child: Container(
    //                       width: orientation == Orientation.portrait
    //                           ? 90.0
    //                           : 120.0,
    //                       height: orientation == Orientation.portrait
    //                           ? 120.0
    //                           : 90.0,
    //                       child: RTCVideoView(localRendererCall),
    //                       decoration: BoxDecoration(color: Colors.black54),
    //                     ),
    //                   ),
    //                 ]),
    //               );
    //             })
    //           : SizedBox(),
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //     floatingActionButton: callInfoModel.inCalling
    //         ? SizedBox(
    //             width: 200.0,
    //             child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   // FloatingActionButton(
    //                   //   child: const Icon(Icons.switch_camera),
    //                   //   onPressed: switchCamera,
    //                   // ),
    //                   // FloatingActionButton(
    //                   //   onPressed: hangUpCall,
    //                   //   tooltip: 'Hangup',
    //                   //   child: Icon(Icons.call_end),
    //                   //   backgroundColor: Colors.pink,
    //                   // ),
    //                   // FloatingActionButton(
    //                   //   child: const Icon(Icons.mic_off),
    //                   //   onPressed: muteMic,
    //                   // )
    //                 ]))
    //         : null,
    //   );
    // });
  }
}
