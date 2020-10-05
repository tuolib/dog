import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../index.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

//import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class Git {
  final dbHelper = DatabaseHelper.instance;

  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  Git([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext context;
  Options _options;
  static Dio dio = new Dio(BaseOptions(
    baseUrl: 'https://4ursafety.ml/api',
    headers: {
//      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
//          "application/vnd.github.symmetra-preview+json",
    },
  ));

  static void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        // 在请求被发送之前做一些事情
        options.headers["authtoken"] = Global.profile.token;
        return options; //continue
        // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onResponse: (Response response) async {
        // 在返回响应数据之前做一些预处理
        return response; // continue
      },
      onError: (DioError e) async {
        // 当请求失败时做一些预处理
        return e; //continue
      },
    ));
    // 添加缓存插件
//    dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
//    dio.options.headers[HttpHeaders.authorizhamationHeader] = Global.profile.token;

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease) {
      dio.options.baseUrl = '$localAddress/api';
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//          (client) {
//        client.findProxy = (uri) {
//          return "PROXY 192.168.60.20:8888";
//        };
//        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
//        client.badCertificateCallback =
//            (X509Certificate cert, String host, int port) => true;
//      };
    }
  }

  // 注册接口，注册成功后返回用户信息
  Future register(String login, String pwd, String confirmPassword,
      String firstName, String lastName) async {
    Response r = await dio.post(
      "/system/user/userSignUp",
      data: {
        "username": "$login",
        "password": "$pwd",
        "confirmPassword": "$confirmPassword",
        "firstName": "$firstName",
        "lastName": "$lastName"
      },
    );
    Global.netCache.cache.clear();
    Map<String, dynamic> responseData = json.decode(r.toString());
    print(responseData);
    return responseData;
  }

  // 登录接口，登录成功后返回用户信息
  Future login(String login, String pwd) async {
    print(login);
    print(pwd);

    Response r = await dio.post(
      "/system/userLogin/login",
      data: {"username": "$login", "password": "$pwd"},
    );
//    print(r.data);
    //清空所有缓存
    Global.netCache.cache.clear();
    Map<String, dynamic> responseData = json.decode(r.toString());
//    print(responseData['success']);
//    if (responseData['success'] == 1) {
//      print(responseData['content']['token']);
////      更新profile中的token信息
//      Global.profile.token = responseData['content']['token'];
//      Global.saveProfile();
//      print(responseData['content']);
////      Global.profile.user = responseData['content']['username'];
//      var content = responseData['content'];
//      return responseData;
//    }
    return responseData;
  }


  // 登录接口，登录成功后返回用户信息
  Future loginVideo(String login, String pwd) async {
    print(login);
    print(pwd);

    Response r = await dio.post(
      "/auth/login",
      data: {"username": "$login", "room": "$pwd"},
    );
    Global.netCache.cache.clear();
    Map<String, dynamic> responseData = json.decode(r.toString());
    logger.d(responseData);
    return responseData;
  }

  // 修改 username
  Future mergeUsername(String username) async {
    Response r = await dio.post(
      "/account/person/mergeUsername",
      data: {"username": "$username"},
    );
    Map<String, dynamic> responseData = json.decode(r.toString());
    return responseData;
  }

  // 修改人名
  Future mergeName(String firstName, String lastName) async {
    Response r = await dio.post(
      "/account/person/mergeName",
      data: {"firstName": "$firstName", "lastName": "$lastName"},
    );
    Map<String, dynamic> responseData = json.decode(r.toString());
    return responseData;
  }

  // 修改头像
  Future mergeAvatar(int avatar) async {
    Response r = await dio.post(
      "/account/person/mergeAvatar",
      data: {"avatar": "$avatar"},
    );
    Map<String, dynamic> responseData = json.decode(r.toString());
    return responseData;
  }

  // 账号信息查询
  Future myInfo() async {
    Response r = await dio.post("/account/person/info");
    //清空所有缓存
//    Global.netCache.cache.clear();
    Map<String, dynamic> responseData = json.decode(r.toString());
    return responseData;
  }

  Future saveChatListAvatar(ChatListSql row) async {
//    var resObj = await download('id', row.avatarName, row.groupAvatar);
    var isSuccess = false;
//    if (resObj['isSuccess']) {
//      String condition = 'groupAvatarLocal = ? WHERE groupId = ?';
//      List valueArr = [resObj["filePath"], row.groupId];
//      var index = await dbHelper.chatListUpdateMultiple(
//          condition, valueArr, row.groupId);
//      print('saveChatListAvatar: $index');
//      if (index != null) {
//        isSuccess = true;
//        var objInsert = ChatListSql(
//          groupId: row.groupId,
//          groupType: row.groupType,
//          groupAvatar: row.groupAvatar,
//          groupAvatarLocal: resObj["filePath"],
//          avatarName: row.avatarName,
//          groupName: row.groupName,
//          createdDate: row.createdDate,
//          content: row.content,
//          isOnline: row.isOnline,
//          newChatNumber: row.newChatNumber,
//          groupUserLength: row.groupUserLength,
//          contentName: row.contentName,
//          contentType: row.contentType,
//          sendName: row.sendName,
//        );

//        var saveRes = await dbHelper.chatListUpdate(objInsert);
//        if (saveRes) {
//          isSuccess = true;
//        }
//      }
//    }
    return isSuccess;
  }

  Future saveMyAvatar(String fileName, String fileUrl) async {
    var resObj = await download('id', fileName, fileUrl);
    var isSuccess = false;
    if (resObj['isSuccess']) {
      isSuccess = true;
      var pathUrl = resObj['filePath'];
      Global.profile.user.avatarUrlLocal = pathUrl;
      Global.saveProfile();
      return pathUrl;
    }
    return '';
  }

  Future saveImageFileOrigin(int id, String fileName, String fileUrl) async {
    var res;
    FileSql fileInfo = await dbHelper.fileOne(id);
    FileSql insertFile;
    var pathUrl;
    if (fileInfo != null) {
      if (fileInfo.fileOriginLocal == null || fileInfo.fileOriginLocal == '') {
        var resObj = await download('id', fileName, fileUrl);
        if (resObj['isSuccess']) {
          pathUrl = resObj['filePath'];
          insertFile = FileSql(
            id: id,
            name: fileInfo.name,
            fileName: fileInfo.fileName,
            fileSize: fileInfo.fileSize,
            fileOriginUrl: fileInfo.fileOriginUrl,
            fileOriginLocal: pathUrl,
            fileCompressUrl: fileInfo.fileCompressUrl,
            fileCompressLocal: fileInfo.fileCompressLocal,
          );
          res = await dbHelper.fileUpdate(insertFile);
        }
      }
    } else {
      var resObj = await download('id', fileName, fileUrl);
      if (resObj['isSuccess']) {
        pathUrl = resObj['filePath'];
        insertFile = FileSql(
          id: id,
          name: fileName,
          fileName: fileName,
          fileOriginUrl: fileUrl,
          fileOriginLocal: pathUrl,
        );
        res = await dbHelper.fileAdd(insertFile);
      }
    }
    Map<String, dynamic> backData = {
      "pathUrl": pathUrl,
      "id": id,
    };
    return backData;
    return res;
  }

  Future saveImageFileCompress(int id, String fileName, String fileUrl) async {
    var res;
    FileSql fileInfo = await dbHelper.fileOne(id);
    FileSql insertFile;
    var pathUrl;
    if (fileInfo != null) {
      if (fileInfo.fileCompressLocal == null ||
          fileInfo.fileCompressLocal == '') {
        var resObj = await download('id', fileName, fileUrl, menu: 'compress');
        if (resObj['isSuccess']) {
          pathUrl = resObj['filePath'];

//          logger.d(pathUrl);
          insertFile = FileSql(
            id: id,
            name: fileInfo.name,
            fileName: fileInfo.fileName,
            fileSize: fileInfo.fileSize,
            fileOriginUrl: fileInfo.fileOriginUrl,
            fileOriginLocal: fileInfo.fileOriginLocal,
            fileCompressUrl: fileInfo.fileCompressUrl,
            fileCompressLocal: pathUrl,
          );
          res = await dbHelper.fileUpdate(insertFile);
//          logger.d(res);
        }
      }
    } else {
      var resObj = await download('id', fileName, fileUrl, menu: 'compress');
      if (resObj['isSuccess']) {
        pathUrl = resObj['filePath'];
        insertFile = FileSql(
          id: id,
          name: fileName,
          fileName: fileName,
          fileCompressUrl: fileUrl,
          fileCompressLocal: pathUrl,
        );
        res = await dbHelper.fileAdd(insertFile);
      }
    }
    Map<String, dynamic> backData = {
      "pathUrl": pathUrl,
      "id": id,
    };
    return backData;
  }

  Future saveContactListAvatar(ContactSql row) async {
//    var resObj = await download('id', row.avatarName, row.avatarUrl);
    var isSuccess = false;
//    if (resObj['isSuccess']) {
//      String condition = 'avatarLocal = ? WHERE contactId = ?';
//      List valueArr = [resObj["filePath"], row.contactId];
//      var index = await dbHelper.contactListUpdateMultiple(
//          condition, valueArr, row.contactId);
////      print('saveContactListAvatar: $index');
//      if (index != null) {
//        isSuccess = true;
//      }
//    }
    return isSuccess;
  }

  // 复制文件到本地，并重命名
  Future copyFile(String fileName, String filePath, {String menu}) async {
    var success = false;
    final dir = await getSaveDirectory();
    final isPermissionStatusGranted = await requestPermissions();
//    print(dir.path);

    String savePath = path.join(dir.path + '/dog/', fileName);
    if (menu != null) {
      savePath = path.join(dir.path + '/dog/$menu/', fileName);
    }
    if (isPermissionStatusGranted) {
      try {
        await File(filePath).rename(savePath);
        success = true;
      } catch (e) {}
    }
    Map<String, dynamic> result = {
      'isSuccess': success,
      'filePath': savePath,
      'error': null,
    };
    return result;
  }

  // 下载文件
  Future download(String id, String fileName, String fileUrl,
      {String menu, String type, bool isLocal}) async {
    var success = false;
    var dir = await getSaveDirectory(type: type);
    var isPermissionStatusGranted = await requestPermissions();
    String dirPreAll;
    if (type == 'userData') {
      dirPreAll = dir.path + '/Dog';
    } else if (type == 'downloads') {
      if (Platform.isAndroid) {
        dirPreAll = dir.path.split('/Android/')[0] + '/Downloads';
      } else {
        dirPreAll = dir.path + '/Downloads';
      }
    } else if (type == 'download') {
      if (Platform.isAndroid) {
        dirPreAll = dir.path.split('/Android/')[0] + '/Download';
      } else {
        dirPreAll = dir.path + '/Downloads';
      }
    } else if (type == 'pictures') {
      if (Platform.isAndroid) {
        dirPreAll = dir.path.split('/Android/')[0] + '/Pictures' + '/Dog';
      } else {
        dirPreAll = dir.path + '/Pictures' + '/Dog';
      }
    } else {
      dirPreAll = dir.path + '/Dog';
    }
//    logger.d(dirPreAll);
//    String dirPreAll = dirPre + '/dog/';
    String savePath = path.join(dirPreAll, fileName);
    if (menu != null) {
      savePath = path.join(dirPreAll + '/$menu/', fileName);
    }
    if (isPermissionStatusGranted) {
//      logger.d(isLocal);
      if (isLocal == true) {
        try {
//          logger.d(savePath);
          bool exists = await Directory(dirPreAll).exists();
          if (!exists) {
            await new Directory(dirPreAll).create();
          }
//          bool fileExists = await File(savePath).exists();
//          if (!fileExists) {
//            await File(savePath).writeAsString('');
//          }

          /// 方法0
//          await File(fileUrl).rename(savePath);

          /// 方法1
//          ByteData data = await rootBundle.load(fileUrl);
//          List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//          await File(savePath).writeAsBytes(bytes);

          /// 方法2
//          var imgBytes = await File(fileUrl).readAsBytes();
//          await File(savePath).writeAsBytes(imgBytes);
          /// 方法3
          await moveFile(File(fileUrl), savePath);
          success = true;
        } catch (e) {
          logger.d(e);
        }
      } else {
        try {
          await dio.download(
            fileUrl,
            savePath,
          );
          success = true;
        } catch (e) {}
      }
    }
    Map<String, dynamic> result = {
      'isSuccess': success,
      'filePath': savePath,
      'error': null,
    };
    return result;
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
//      await sourceFile.delete();
      return newFile;
    }
  }

  getSaveDirectory({String type}) async {
    if (type == 'userData') {
      /// android/data/com.flutter.dog/ 文件夹，用户可见
      if (Platform.isAndroid) {
        return await getExternalStorageDirectory();
      }

      /// ios
      return await getApplicationDocumentsDirectory();
    } else if (type == 'downloads') {
      /// /android/data/com.flutter.dog/ 文件夹，用户可见
      if (Platform.isAndroid) {
        return await getExternalStorageDirectory();
      }
      return await getApplicationDocumentsDirectory();
    } else if (type == 'download') {
      /// /android/data/com.flutter.dog/ 文件夹，用户可见
      if (Platform.isAndroid) {
        return await getExternalStorageDirectory();
      }
      return await getApplicationDocumentsDirectory();
    } else if (type == 'pictures') {
      /// /android/data/com.flutter.dog/ 文件夹，用户可见
      if (Platform.isAndroid) {
        return await getExternalStorageDirectory();
      }
      return await getApplicationDocumentsDirectory();
    } else if (type == 'lib') {
      /// 用户不可见
      if (Platform.isAndroid) {
        return await getApplicationSupportDirectory();
      }
      /// ios library 目录
      return await getLibraryDirectory();
    } else {
      /// 默认 应用内文件夹，用户不可见
      return await getApplicationSupportDirectory();
    }

//    if (Platform.isAndroid) {
//      return await DownloadsPathProvider.downloadsDirectory;
//    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.

      if (await Permission.storage.request().isGranted) {
        status = await Permission.storage.status;
        // Either the permission was already granted before or the user just granted it.
      }

    } else {
      if (!status.isGranted) {
        String tip = "Dog needs storage access"  +
            " so that you can send and save photos, videos, music, and other media." +
            "  Please go to your device's settings and set Dog to ON.";
        showDeleteConfirmGroup(tip);
      }
      status = await Permission.storage.status;
    }
    return status == PermissionStatus.granted;

//    var permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.storage);
//
//    if (permission != PermissionStatus.granted) {
//      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//      permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
//    }
//    return permission == PermissionStatus.granted;
  }
  Future<bool> requestPermissionsPhone() async {
    var status = await Permission.phone.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.

      if (await Permission.phone.request().isGranted) {
        status = await Permission.phone.status;
        // Either the permission was already granted before or the user just granted it.
      }

    } else {
      // if (!status.isGranted) {
      //   String tip = "Dog needs storage access"  +
      //       " so that you can send and save photos, videos, music, and other media." +
      //       "  Please go to your device's settings and set Dog to ON.";
      //   showDeleteConfirmGroup(tip);
      // }
      status = await Permission.phone.status;
    }
    return status == PermissionStatus.granted;

//    var permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.storage);
//
//    if (permission != PermissionStatus.granted) {
//      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//      permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
//    }
//    return permission == PermissionStatus.granted;
  }

  Future<bool> requestAudioPermissions({String type}) async {
    var status = await Permission.microphone.status;

    if (status.isUndetermined) {
      // We didn't ask for permission yet.

      if (await Permission.microphone.request().isGranted) {
        status = await Permission.microphone.status;
        // Either the permission was already granted before or the user just granted it.
      }

    } else {
      if (!status.isGranted) {
        String access = 'send voice message';
        if (type == 'video') {
          access = 'record videos';
        }
        String tip = "Dog needs access to your microphone"  +
            " so that you can $access." +
            " Please go to your device's settings and set Dog to ON.";
        showDeleteConfirmGroup(tip);
      }
      status = await Permission.microphone.status;
    }
    return status == PermissionStatus.granted;


//    var permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.microphone);
//
//    if (permission != PermissionStatus.granted) {
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.microphone]);
//      permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.microphone);
//    }
//
//    return permission == PermissionStatus.granted;
  }
  //  弹出对话框 去设置对话框
  Future<bool> showDeleteConfirmGroup(String tip) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
//                gAvatar,
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("Please Allow Access"),
                ),
              ],
            ),
          ),
          content: Text('$tip'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                'SETTINGS',
//                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }


  Future<bool> requestCameraPermissions() async {
    var status = await Permission.camera.status;

    if (status.isUndetermined) {
      // We didn't ask for permission yet.

      if (await Permission.camera.request().isGranted) {
        status = await Permission.camera.status;
        // Either the permission was already granted before or the user just granted it.
      }

    } else {
      if (!status.isGranted) {
        String tip = "Dog needs camera access"  +
            " so that you can take photos and videos." +
            "  Please go to your device's settings and set Dog to ON.";
        showDeleteConfirmGroup(tip);
      }
      status = await Permission.camera.status;
    }
    return status == PermissionStatus.granted;
  }

  // 上传
  Future uploadFile(String fileUrl, {String fileName, chatObj}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(fileUrl),
    });
    var response = await dio.post("/upload/uploadImg", data: formData);
    print('response.data: ${response.data}');
    var value = response.data;

    if (value['success'] == 1) {
      print('GroupId: ${chatObj['groupId']}');
      print('fileName: ${value['content']['fileName']}');
      chatObj['content'] = value['content']['fileName'];
      chatObj['contentName'] = value['content']['originName'];
      chatObj['contentId'] = value['content']['id'];
      chatObj['contentUrl'] = value['content']['originUrl'];
//            chatObj['sending'] = false;
//            chatObj['isUpload'] = false;
//            chatObj['success'] = true;
      socketInit.emit('msg', json.encode(chatObj));
    }

    return response.data;
  }

  // 上传
  Future uploadFileOnly(String fileUrl,
      {int compressWidth,
      int compressHeight,
      String fileName,
      Map<String, dynamic> chatObj}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(fileUrl),
      "compressWidth": compressWidth,
      "compressHeight": compressHeight,
    });
    logger.d(formData);
    var response = await dio.post("/upload/uploadImg", data: formData);
    print('response.data: ${response.data}');
    return response.data;
  }
}
