import 'package:flutter/widgets.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../index.dart';
import 'dart:convert';

ChatListSql clientFromJson(String str) {
  final jsonData = json.decode(str);
  return ChatListSql.fromMap(jsonData);
}

String clientToJson(ChatListSql data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class ChatListSql {
// 如果有id,则直接使用groupId,
// 如果为0，则是客户端临时与某个人创建的对话，但是服务器还没有返回创建成功时使用，
// 这时结合 groupUser 表显示到chats 列表中
// 1 如果服务端还没创建group成功，获取联系人发送的消息， 从groupMessage获取历史发送消息，
// 用这三个字段确定与谁的单聊对话 groupId=0, userId=myUserId, contactId=对方id
// 问题解决,
  int groupId;
  int contactId;
  int userId;

//  messageId消息id 和 timestamp 配合使用，
//  如果 消息有id, 则直接从groupMessage表查询
//  如果 消息没有id,没有发送成功但是有timestamp 发送时间，就可以索引到groupMessage表
  int messageId;
  int timestamp;

//  新消息数量
  int newChatNumber;

//  维护最新消息id, 以便查询历史消息记录
  int latestMsgId;
  int latestMsgTime;

//  如下都是可选字段
  int createdDate;
  int groupUserLength;
  int groupType;
  String content;
  String contentName;
  int contentType;
  int senderId;

//  int groupType;
//  String groupAvatar;
//  String groupAvatarLocal;
//  String groupName;
//  String content;
//  bool isOnline;
//  String contentName;
//  int contentType;
//  String sendName;
//  String avatarName;
//  String username;
//  int colorId;

  ChatListSql({
    this.groupId,
    this.contactId,
    this.userId,
    this.messageId,
    this.timestamp,
    this.newChatNumber,
    this.latestMsgId,
    this.latestMsgTime,
    this.senderId,
    this.groupUserLength,
    this.createdDate,
    this.groupType,
    this.content,
    this.contentName,
    this.contentType,

//    this.colorId,
//
//    this.groupAvatar,
//    this.groupAvatarLocal,
//    this.avatarName,
//    this.groupName,
//    this.username,
//    this.content,
//    this.isOnline,
//    this.contentName,
//    this.contentType,
//    this.sendName,
  });

  factory ChatListSql.fromMap(Map<String, dynamic> json) => ChatListSql(
        groupId: json["groupId"],
        contactId: json["contactId"],
        userId: json["userId"],
        messageId: json["messageId"],
        timestamp: json["timestamp"],
        newChatNumber: json["newChatNumber"],
        latestMsgId: json["latestMsgId"],
        latestMsgTime: json["latestMsgTime"],

        groupUserLength: json["groupUserLength"],
        groupType: json["groupType"],
        createdDate: json["createdDate"],
        content: json["content"],
        contentName: json["contentName"],
        contentType: json["contentType"],
        senderId: json["senderId"],

//
//    colorId: json["colorId"],
//    username: json["username"],
//
//    groupAvatar: json["groupAvatar"],
//    groupAvatarLocal: json["groupAvatarLocal"],
//    avatarName: json["avatarName"],
//    groupName: json["groupName"],
//
//    content: json["content"],
//    isOnline: json["isOnline"] == 1,
//    contentName: json["contentName"],
//    contentType: json["contentType"],
//    sendName: json["sendName"],
      );

  Map<String, dynamic> toMap() => {
        "groupId": groupId,
        "contactId": contactId,
        "userId": userId,
        "messageId": messageId,
        "timestamp": timestamp,
        "newChatNumber": newChatNumber,
        "latestMsgId": latestMsgId,
        "latestMsgTime": latestMsgTime,

        "groupUserLength": groupUserLength,
        "createdDate": createdDate,
        "groupType": groupType,
        "contentName": contentName,
        "contentType": contentType,
        "content": content,
        "senderId": senderId,

//    "colorId": colorId,
//    "groupAvatar": groupAvatar,
//    "groupAvatarLocal": groupAvatarLocal,
//    "avatarName": avatarName,
//    "groupName": groupName,
//    "isOnline": isOnline ? 1 : 0,
//    "newChatNumber": newChatNumber,
//    "sendName": sendName,
//    "username": username
      };
}
