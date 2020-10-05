// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return ConversationModel()
    ..message = json['message'] as String
    ..content = json['content'] as String
    ..contentName = json['contentName'] as String
    ..username = json['username'] as String
    ..time = json['time'] as String
    ..type = json['type'] as num
    ..isMe = json['isMe'] as bool
    ..isGroup = json['isGroup'] as bool
    ..replyText = json['replyText'] as String
    ..isReply = json['isReply'] as bool
    ..replyName = json['replyName'] as String
    ..isImage = json['isImage'] as bool
    ..filePath = json['filePath'] as String
    ..downloading = json['downloading'] as bool
    ..index = json['index'] as num
    ..downloadSuccess = json['downloadSuccess'] as bool
    ..sending = json['sending'] as bool
    ..success = json['success'] as bool
    ..isVideo = json['isVideo'] as bool
    ..isAudio = json['isAudio'] as bool
    ..showUsername = json['showUsername'] as bool
    ..showAvatar = json['showAvatar'] as bool
    ..showDate = json['showDate'] as bool;
}

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'content': instance.content,
      'contentName': instance.contentName,
      'username': instance.username,
      'time': instance.time,
      'type': instance.type,
      'isMe': instance.isMe,
      'isGroup': instance.isGroup,
      'replyText': instance.replyText,
      'isReply': instance.isReply,
      'replyName': instance.replyName,
      'isImage': instance.isImage,
      'filePath': instance.filePath,
      'downloading': instance.downloading,
      'index': instance.index,
      'downloadSuccess': instance.downloadSuccess,
      'sending': instance.sending,
      'success': instance.success,
      'isVideo': instance.isVideo,
      'isAudio': instance.isAudio,
      'showUsername': instance.showUsername,
      'showAvatar': instance.showAvatar,
      'showDate': instance.showDate
    };
