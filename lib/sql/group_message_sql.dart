class GroupMessageSql {
  int id;

//  如果单人聊天中，还未创建好两人group, groupId为0，
//  则通过contactId 确定这个消息是发送给谁的
  int groupId;
  int contactId;
  int senderId;
  int createdDate;
  int contentId;
  int contentType;
  String content;
  String contentName;
  int replyId;
  int timestamp;

//  0 正在下载，1没有在下载
  int downloading;

  GroupMessageSql({
    this.id,
    this.groupId,
    this.contactId,
    this.senderId,
    this.createdDate,
    this.contentId,
    this.contentType,
    this.content,
    this.contentName,
    this.replyId,
    this.timestamp,
    this.downloading,
  });

  factory GroupMessageSql.fromMap(Map<String, dynamic> json) => GroupMessageSql(
        id: json["id"],
        groupId: json["groupId"],
        contactId: json["contactId"],
        senderId: json["senderId"],
        createdDate: json["createdDate"],
        contentId: json["contentId"],
        contentType: json["contentType"],
        content: json["content"],
        contentName: json["contentName"],
        replyId: json["replyId"],
        timestamp: json["timestamp"],
        downloading: json["downloading"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "groupId": groupId,
        "contactId": contactId,
        "senderId": senderId,
        "createdDate": createdDate,
        "contentId": contentId,
        "contentType": contentType,
        "content": content,
        "contentName": contentName,
        "replyId": replyId,
        "timestamp": timestamp,
        "downloading": downloading,
      };
}
