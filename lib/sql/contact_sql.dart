class ContactSql {
  int id;
  int contactId;
  String firstName;
  String lastName;
  int userId;
  int infoTimestamp;
//  int avatar;
//  String avatarUrl;
//  String avatarLocal;
//  String avatarName;
//  String username;

  ContactSql({
    this.id,
    this.contactId,
    this.firstName,
    this.lastName,
    this.userId,
    this.infoTimestamp,

//    this.avatar,
//    this.avatarUrl,
//    this.avatarLocal,
//    this.avatarName,
//    this.username,
  });

  factory ContactSql.fromMap(Map<String, dynamic> json) => ContactSql(
    id: json["id"],
    contactId: json["contactId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    userId: json["userId"],
    infoTimestamp: json["userId"],
//    avatar: json["avatar"],
//    avatarUrl: json["avatarUrl"],
//    avatarLocal: json["avatarLocal"],
//    avatarName: json["avatarName"],
//    username: json["username"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "contactId": contactId,
    "firstName": firstName,
    "lastName": lastName,
    "userId": userId,
    "infoTimestamp": infoTimestamp
//    "avatar": avatar,
//    "avatarUrl": avatarUrl,
//    "avatarLocal": avatarLocal,
//    "avatarName": avatarName,
//    "username": username
  };


}
