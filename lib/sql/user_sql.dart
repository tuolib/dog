class UserSql {
  int id;
  String username;
  String firstName;
  String lastName;
  int avatar;
  int colorId;
  int lastSeen;
  bool isOnline;
  int infoTimestamp;
  String bio;

  UserSql({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.avatar,
    this.colorId,
    this.lastSeen,
    this.isOnline,
    this.infoTimestamp,
    this.bio,
  });

  factory UserSql.fromMap(Map<String, dynamic> json) => UserSql(
        id: json["id"],
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"],
        colorId: json["colorId"],
        lastSeen: json["lastSeen"],
        isOnline: json["lastSeen"] == 1,
        infoTimestamp: json["infoTimestamp"],
        bio: json["bio"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar,
        "colorId": colorId,
        "lastSeen": lastSeen,
        "isOnline": isOnline ? 1 : 0,
        "infoTimestamp": infoTimestamp,
        "bio": bio,
      };
}
