// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatList _$ChatListFromJson(Map<String, dynamic> json) {
  return ChatList()
    ..columnId = json['columnId'] as num
    ..groupId = json['groupId'] as num
    ..groupType = json['groupType'] as num
    ..groupAvatar = json['groupAvatar'] as String
    ..groupName = json['groupName'] as String
    ..createdDate = json['createdDate'] as String
    ..content = json['content'] as String
    ..isOnline = json['isOnline'] as num
    ..newChatNumber = json['newChatNumber'] as num
    ..groupUserLength = json['groupUserLength'] as num
    ..contentName = json['contentName'] as String
    ..contentType = json['contentType'] as num
    ..sendName = json['sendName'] as String;
}

Map<String, dynamic> _$ChatListToJson(ChatList instance) => <String, dynamic>{
      'columnId': instance.columnId,
      'groupId': instance.groupId,
      'groupType': instance.groupType,
      'groupAvatar': instance.groupAvatar,
      'groupName': instance.groupName,
      'createdDate': instance.createdDate,
      'content': instance.content,
      'isOnline': instance.isOnline,
      'newChatNumber': instance.newChatNumber,
      'groupUserLength': instance.groupUserLength,
      'contentName': instance.contentName,
      'contentType': instance.contentType,
      'sendName': instance.sendName
    };
