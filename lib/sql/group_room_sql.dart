class GroupRoomSql {
  int id;
  int groupType;
  String groupName;
  int createdDate;
  int avatar;
  int colorId;
  int createdUserId;
  int infoTimestamp;
  int userTimestamp;
  String description;


  GroupRoomSql({
    this.id,
    this.createdUserId,
    this.groupType,
    this.groupName,
    this.createdDate,
    this.avatar,
    this.colorId,
    this.infoTimestamp,
    this.userTimestamp,
    this.description,
  });

  factory GroupRoomSql.fromMap(Map<String, dynamic> json) => GroupRoomSql(
    id: json["id"],
    createdUserId: json["createdUserId"],
    groupType: json["groupType"],
    groupName: json["groupName"],
    createdDate: json["createdDate"],
    avatar: json["avatar"],
    colorId: json["colorId"],
    infoTimestamp: json["infoTimestamp"],
    userTimestamp: json["userTimestamp"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "createdUserId": createdUserId,
    "groupType": groupType,
    "groupName": groupName,
    "createdDate": createdDate,
    "avatar": avatar,
    "colorId": colorId,
    "infoTimestamp": infoTimestamp,
    "userTimestamp": userTimestamp,
    "description": description,
  };


}
