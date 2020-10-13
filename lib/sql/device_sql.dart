class DeviceSql {
  int id;
  String authtoken;
  String deviceInfo;
  int loginType;
  int userId;

  DeviceSql({
    this.id,
    this.authtoken,
    this.deviceInfo,
    this.loginType,
    this.userId,
  });

  factory DeviceSql.fromMap(Map<String, dynamic> json) => DeviceSql(
    id: json["id"],
    authtoken: json["authtoken"],
    deviceInfo: json["deviceInfo"],
    loginType: json["loginType"],
    userId: json["userId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "authtoken": authtoken,
    "deviceInfo": deviceInfo,
    "loginType": loginType,
    "userId": userId,
  };

}
