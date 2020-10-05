import 'package:json_annotation/json_annotation.dart';

part 'conversationModel.g.dart';

@JsonSerializable()
class ConversationModel {
    ConversationModel();

    String message;
    String content;
    String contentName;
    String username;
    String time;
    num type;
    bool isMe;
    bool isGroup;
    String replyText;
    bool isReply;
    String replyName;
    bool isImage;
    String filePath;
    bool downloading;
    num index;
    bool downloadSuccess;
    bool sending;
    bool success;
    bool isVideo;
    bool isAudio;
    bool showUsername;
    bool showAvatar;
    bool showDate;
    
    factory ConversationModel.fromJson(Map<String,dynamic> json) => _$ConversationModelFromJson(json);
    Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
