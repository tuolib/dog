class FileSql {
  int id;
  String name;
  String fileName;
//  单位 B
  double fileSize;
  int fileTime;
  String fileOriginUrl;
  String fileOriginLocal;
  String fileCompressUrl;
  String fileCompressLocal;

  FileSql({
    this.id,
    this.name,
    this.fileName,
    this.fileSize,
    this.fileTime,
    this.fileOriginUrl,
    this.fileOriginLocal,
    this.fileCompressUrl,
    this.fileCompressLocal,
  });

  factory FileSql.fromMap(Map<String, dynamic> json) => FileSql(
    id: json["id"],
    name: json["name"],
    fileName: json["fileName"],
    fileSize: json["fileSize"],
    fileTime: json["fileTime"],
    fileOriginUrl: json["fileOriginUrl"],
    fileOriginLocal: json["fileOriginLocal"],
    fileCompressUrl: json["fileCompressUrl"],
    fileCompressLocal: json["fileCompressLocal"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "fileName": fileName,
    "fileSize": fileSize,
    "fileTime": fileTime,
    "fileOriginUrl": fileOriginUrl,
    "fileOriginLocal": fileOriginLocal,
    "fileCompressUrl": fileCompressUrl,
    "fileCompressLocal": fileCompressLocal,
  };

}
