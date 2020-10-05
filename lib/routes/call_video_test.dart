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

bool hasInvite = false;

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
  Signaling _signaling;
  List<dynamic> _peers;
  var _selfId;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  String serverIP;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
    if (!hasInvite) {
      // SystemChrome.setEnabledSystemUIOverlays([]);
      initRenderers();
    }
  }

//   @override
//   void dispose() {
//     super.dispose();
// //    isOnAddContactPage = false;
// //     _localRenderer.dispose();
// //     _remoteRenderer.dispose();
// //     _signaling.close();
//     hasInvite = false;
//   }

  @override
  deactivate() {
    super.deactivate();
    // logger.d(_signaling);
    if (_signaling != null) {
      _signaling.close();
    }
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    hasInvite = false;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('call')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _inCalling
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
                          child: RTCVideoView(_remoteRenderer),
                          decoration: BoxDecoration(color: Colors.black54),
                        )),
                    Positioned(
                      left: 20.0,
                      top: 80.0,
                      child: Container(
                        width:
                            orientation == Orientation.portrait ? 90.0 : 120.0,
                        height:
                            orientation == Orientation.portrait ? 120.0 : 90.0,
                        child: RTCVideoView(_localRenderer),
                        decoration: BoxDecoration(color: Colors.black54),
                      ),
                    ),
                  ]),
                );
              })
            : SizedBox(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? SizedBox(
              width: 200.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      child: const Icon(Icons.switch_camera),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.mic_off),
                      onPressed: _muteMic,
                    )
                  ]))
          : null,
    );
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _connect();
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

  void _connect() async {
    logger.d('start connect');
    if (_signaling == null) {
      // _signaling = Signaling(serverIP)..connect();
      _signaling = Signaling();
      _signaling.connect(invite: widget.invite);

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _inCalling = true;
            });
            break;
          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
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

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _selfId = event['self'];
          _peers = event['peers'];
        });
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
      logger.d('center connect');
    }

    logger.d('end connect');
    if (!hasInvite) {
      hasInvite = true;
      _invitePeer(context, '1', false);
    }
    // _invitePeer(context, '1', false);
  }

  _invitePeer(context, peerId, use_screen) async {
    if (_signaling != null && peerId != _selfId) {
      logger.d('_signaling invite');
      _signaling.invite(peerId, 'video', use_screen);
    }
  }

  _hangUp() async {
    if (_signaling != null) {
      logger.d('hangup');
      _signaling.bye();
      if (_signaling != null) {
        _signaling.close();
      }
      _localRenderer.dispose();
      _remoteRenderer.dispose();
      hasInvite = false;
      // Navigator.of(context).pop();
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _muteMic() {}
}
