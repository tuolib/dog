import 'package:json_annotation/json_annotation.dart';

part 'chatList.g.dart';

@JsonSerializable()
class ChatList {
    ChatList();

    num columnId;
    num groupId;
    num groupType;
    String groupAvatar;
    String groupName;
    String createdDate;
    String content;
    num isOnline;
    num newChatNumber;
    num groupUserLength;
    String contentName;
    num contentType;
    String sendName;
    
    factory ChatList.fromJson(Map<String,dynamic> json) => _$ChatListFromJson(json);
    Map<String, dynamic> toJson() => _$ChatListToJson(this);
}
