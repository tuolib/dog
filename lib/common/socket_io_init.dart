import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';
import '../index.dart';

class SocketsIoNotify {
//  static final SocketsIoNotify _sockets = new SocketsIoNotify._internal();
//
//  factory SocketsIoNotify() {
//    return _sockets;
//  }

//  SocketsIoNotify._internal();
//  var timer;

  initCommunication({Function callback}) {
    final dbHelper = DatabaseHelper.instance;
    try {
//      socketProviderChatListModel.getChatList();
      print('socketInit  $socketInit');
      print('socketInit?.connected ${socketInit?.connected}');
      if (socketInit != null) return;
      // if (Global.profile.token == null || Global.profile.token == '') return;
      var addr = "$localAddress";
      socketInit = io(addr, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      logger.d('start connect socket');

//      socketProviderChatListModel.getChatList();
//      socketInit.on('connecting', (_) async {
//        logger.d('connecting');
////        socketProviderChatListModel.getChatList();
//      });
      socketInit.on('connect', (_) async {
        print('connect');
        // logger.d(lifecycleState);
        if (callback != null) {
          callback();
        }
        if (lifecycleState == AppLifecycleState.inactive) {
          isUpdatingGroup = true;
          if (socketProviderConnectModel != null) {
            socketProviderConnectModel.notifyConnect();
          }
          SocketIoEmit.connectInfoSend();
//        SocketIoEmit.clientOpenGroupTable();
          SocketIoEmit.clientGetContacts();
          SocketIoEmit.contactStatusGet();
          SocketIoEmit.messageDialogsGet();
          SocketIoEmit.deviceGet();
        }

      });


      socketInit.on('disconnect', (reason) {
        print('disconnect');
        isSend = false;
        if (socketProviderConnectModel != null) {
          socketProviderConnectModel.notifyConnect();
        }
        print(reason);
      });
      SocketIoListen.serverToken();
      /// open
//      SocketIoListen.serverOpenGroupTable();

      /// dialog 请求 会话表
      SocketIoListen.messageDialogsGet();

      /// contact
      SocketIoListen.serverGetContacts();
      SocketIoListen.serverAddContacts();
      SocketIoListen.serverEditContacts();
      SocketIoListen.serverDeleteContacts();
      SocketIoListen.contactStatusGet();

      /// chat
      SocketIoListen.serverGetOneGroup();
      SocketIoListen.serverCreateGroup();
      SocketIoListen.serverEditGroup();
      SocketIoListen.serverEditGroupSimple();
      SocketIoListen.serverAddGroupMember();
      SocketIoListen.serverDeleteGroupMember();
      SocketIoListen.messageChatGet();

      /// message
      SocketIoListen.serverGetGroupMessage();
      SocketIoListen.messageHistoryGet();
      SocketIoListen.serverSendGroupMessage();
      SocketIoListen.serverSendGroupMessageSelf();
      SocketIoListen.serverGroupMessageRead();
      SocketIoListen.messageListDetail();
      SocketIoListen.messageUnRead();

      /// user
//      SocketIoListen.();
      SocketIoListen.userInfoGet();
      SocketIoListen.userStatusGet();


      /// other
      SocketIoListen.serverUserOnline();

      /// device
      SocketIoListen.deviceGet();
    } catch (e) {
      print(e);
//
    }
  }
}
