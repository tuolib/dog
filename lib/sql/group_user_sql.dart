class GroupUserSql {
  int id;
  int groupId;
  int userId;
  int lastReadMsgId;
  int deleteChat;
  int lastDeleteMsgId;
  int leaveMessageId;
  String leaveGroupName;
  int inviteUserId;

  int messageId;
  int timestamp;
  int newChatNumber;
  int groupUserLength;
  int contactId;
  int infoTimestamp;

  GroupUserSql({
    this.id,
    this.groupId,
    this.userId,
    this.lastReadMsgId,
    this.deleteChat,
    this.lastDeleteMsgId,
    this.leaveMessageId,
    this.leaveGroupName,
    this.inviteUserId,
    this.contactId,
    this.infoTimestamp,
  });

  factory GroupUserSql.fromMap(Map<String, dynamic> json) => GroupUserSql(
        id: json["id"],
        groupId: json["groupId"],
        userId: json["userId"],
        lastReadMsgId: json["lastReadMsgId"],
        deleteChat: json["deleteChat"],
        lastDeleteMsgId: json["lastDeleteMsgId"],
        leaveMessageId: json['leaveMessageId'],
        leaveGroupName: json['leaveGroupName'],
        inviteUserId: json['inviteUserId'],
        contactId: json['contactId'],
        infoTimestamp: json['infoTimestamp'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "groupId": groupId,
        "userId": userId,
        "lastReadMsgId": lastReadMsgId,
        "deleteChat": deleteChat,
        "lastDeleteMsgId": lastDeleteMsgId,
        "leaveMessageId": leaveMessageId,
        "leaveGroupName": leaveGroupName,
        "inviteUserId": inviteUserId,
        "contactId": contactId,
        "infoTimestamp": infoTimestamp,
      };
}
