import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

import '../index.dart';

import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileRoute extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileRoute> {
  TextEditingController _firstController = new TextEditingController();
  TextEditingController _lastController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  User user = Global.profile.user;

  //  image_picker 选择插件 相关变量
  File _image;
  final picker = ImagePicker();
  String _filePath;

//  file_picker 插件
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = new TextEditingController();

//  上传头像
  bool isUploadAvatar = false;

  UserModel userInfo;

  @override
  void initState() {
    _firstController.text = user.firstName;
    _lastController.text = user.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    userInfo = Provider.of<UserModel>(context);
    var gAvatar;
    User user = userInfo.user;
    print(user.avatarUrl);
    if (user.avatarUrl == null ||
        user.avatarUrl == '' ||
        user.avatarUrlLocal == null) {
      gAvatar = Container(
        width: 60.0,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[rNum],
        ),
        child: Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      if (user.avatarUrlLocal == null || user.avatarUrlLocal == '') {
        gAvatar = InkWell(
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(1), BlendMode.dstATop),
                image: NetworkImage("${user.avatarUrlLocal}"),
                fit: BoxFit.cover,
//                      new AssetImage("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg")
//          FileImage(File("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg"))
              ),
            ),
          ),
          onTap: () {
            var arg = {
              'imageProvider': user.avatarUrl,
              'heroTag': user.avatarUrl,
              'type': 'local'
            };
            Navigator.of(context)
                .pushNamed('photoView', arguments: json.encode(arg));
          },
        );
      } else {
        gAvatar = InkWell(
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(1), BlendMode.dstATop),
                image: FileImage(File("${user.avatarUrlLocal}")),
                fit: BoxFit.cover,
//                      new AssetImage("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg")
//          FileImage(File("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg"))
              ),
            ),
          ),
          onTap: () {
            var arg = {
              'imageProvider': user.avatarUrlLocal,
              'heroTag': user.avatarUrlLocal,
              'type': 'local'
            };
            Navigator.of(context)
                .pushNamed('photoView', arguments: json.encode(arg));
          },
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
//                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
//            conversionInfo['groupName'] = 'sdff';
//            conversion.updateInfoProperty('groupName', '123132');
          },
        ),
        actions: <Widget>[
          // 非隐藏的菜单
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              _saveName(context);
            },
          ),
        ],
      ),
      body: MediaQuery.removePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            gAvatar,
                            Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            isUploadAvatar
                                ? Container(
                                    child: SizedBox(
                                      height: 10.0,
                                      width: 10.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        valueColor: AlwaysStoppedAnimation(
                                            Theme.of(context)
                                                .textTheme
                                                .title
                                                .color),
                                      ),
                                    ),
                                    height: 10.0,
                                    width: 10.0,
                                  )
                                : Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  )
                          ],
                        ),
                      ),
                      onTap: () {
                        _changeAvatar(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          autovalidate: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
//                                Padding(
//                                  padding: EdgeInsets.all(5),
//                                  child: Text(
//                                    "${user.username}",
//                                    maxLines: 1,
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 18),
//                                  ),
//                                ),
//                                Divider(
//                                  height: 1,
//                                ),
//                                Padding(
//                                  padding: EdgeInsets.all(5),
//                                  child: Text(
//                                    "${user.username}",
//                                    maxLines: 1,
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 18),
//                                  ),
//                                ),
                                TextFormField(
                                  autofocus: false,
                                  controller: _firstController,
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                    border: InputBorder.none,
                                  ),
                                  // 校验用户名（不能为空）
                                  validator: (v) {
                                    return v.trim().isNotEmpty && v.length >= 2
                                        ? null
                                        : 'First name is required';
                                  },
                                ),
                                Divider(height: 1),
                                TextFormField(
                                  autofocus: false,
                                  controller: _lastController,
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(13),
              child: Text('Enter your name and add an optional profile photo.'),
            ),
            SizedBox(height: 20),
            Divider(height: 1),
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 13, top: 8, bottom: 8),
                      child: Text(
                        'Username',
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '@' + user.username,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              ),
              onTap: () {
//                socketProviderConversationListModelGroupId = widget.groupId;
                Navigator.of(context).pushNamed("editUsername");
              },
            ),
            Divider(height: 1),
            SizedBox(height: 30),
            Expanded(
              child: _buildMenus(),
            ),
          ],
        ),
      ),
    );
  }

  _changeAvatar(context) {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    showFilePicker(FileType.custom, 'camera', context);
                  },
                ),
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Image'),
                    onTap: () =>
                        showFilePicker(FileType.image, 'image', context)),
                if (user.avatarUrlLocal != '' && user.avatarUrlLocal != null)
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('View Photo'),
                    onTap: () {
                      var arg = {
                        'imageProvider': user.avatarUrlLocal,
                        'heroTag': user.avatarUrlLocal,
                        'type': 'local',
                        'fileId': 2172,
                      };
                      Navigator.of(context)
                          .pushNamed('photoView', arguments: json.encode(arg));
                    },
                  ),
                if (user.avatarUrlLocal != '' && user.avatarUrlLocal != null)
                  ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Remove Photo'),
                      onTap: () {
                        _removePhoto(context);
                      }),
              ],
            ),
          );
        });
  }

  showFilePicker(FileType fileType, [String other, context]) async {
    Navigator.of(context).pop();
    var file;
    if (other == 'camera') {
      file = await getCamera(other);
    } else if (other == 'video') {
      file = await getCamera(other);
    } else {
//      print('fileType: $fileType');
//    if (fileType == 'custom')
      _pickingType = fileType;
      await _openFileExplorer();
      file = _path;
    }
    print('file: $file');

    if (file == null) return;
  }

  Future getCamera(type) async {
    var pickedFile;
    if (type == 'camera') {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else if (type == 'video') {
      pickedFile = await picker.getVideo(source: ImageSource.camera);
    }
    print('pickedFile: $pickedFile');
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        pickedFile = croppedFile;
      }
      setState(() {
        _filePath = pickedFile.path;
        _image = File(pickedFile.path);
        print('_filePath: $_filePath');
        print('_image: $_image');
//        var isImage = false;
//        var isVideo = false;
//        if (type == 'camera') {
//          isImage = true;
//        }
//        if (type == 'video') {
//          isVideo = true;
//        }
        uploadFile(
          groupId: socketProviderConversationListModelGroupId,
          filePath: _filePath,
        );

        return pickedFile;
//      socketInit.emit('msg', json.encode(chatObj));
      });
    }
  }

  Future _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      print('_multiPick: $_multiPick');
      if (_multiPick) {
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      } else {
        _paths = null;
        _path = await FilePicker.getFilePath(
            type: _pickingType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      }

      File croppedFile = await ImageCropper.cropImage(
          sourcePath: _path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        _path = croppedFile.path;
      }

      uploadFile(
        groupId: socketProviderConversationListModelGroupId,
        filePath: _path,
      );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  uploadFile({groupId, filePath, fileDeter}) async {
    isUploadAvatar = true;
    final f = File(filePath);
    int sizeInBytes = f.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    print('file path: $filePath');
    print('file size: $sizeInMb MB');
    var res = await Git(context).uploadFileOnly(filePath);
    if (res['success'] == 1) {
      var changeRes = await Git(context).mergeAvatar(res['content']['id']);
      if (changeRes['success'] == 1) {
        print("filename : ${res['content']['fileName']}");
        print("filename : ${res['content']['originUrl']}");
        var downloadInfo = await Git(context).download(
            'id', res['content']['fileName'], res['content']['originUrl']);
        if (downloadInfo['isSuccess']) {
          var avatarUrlLocal = downloadInfo['filePath'];
          print('downloadInfo: ${downloadInfo["filePath"]}');
          userInfo.changeAvatar(res['content']['id'],
              res['content']['originUrl'], avatarUrlLocal);
        }
      }

      isUploadAvatar = false;
    } else {
      isUploadAvatar = false;
    }
  }

  _saveName(pageContext) async {
    var userInfo = Provider.of<UserModel>(pageContext, listen: false);
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      User user;
      try {
        var resJson = await Git(context)
            .mergeName(_firstController.text, _lastController.text);

        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        print("${resJson['content']}");
        if (resJson['success'] == 1) {
          var content = resJson['content'];
          Provider.of<UserModel>(context, listen: false).user.firstName =
              _firstController.text;
          Provider.of<UserModel>(context, listen: false).user.lastName =
              _lastController.text;
          Global.saveProfile();
//        Navigator.of(context).pop();
          userInfo.changeName(_firstController.text, _lastController.text);
//          print('username: ${Global.profile.user.username}');

          // 返回
          Navigator.of(pageContext).pop();
        } else {
          showToast(resJson['respMsg']);
        }
      } catch (e) {
        //登录失败则提示
        print('e-----: $e');
        if (e.response?.statusCode == 401) {
          showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
        } else {
          showToast(e.toString());
        }
      } finally {
        // 隐藏loading框
        Navigator.of(context).pop();
      }
    }
  }

  _removePhoto(pageContext) async {
    var userInfo = Provider.of<UserModel>(pageContext, listen: false);
    showLoading(context);
    User user;
    try {
      var resJson = await Git(context).mergeAvatar(0);

      // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
      print("${resJson['content']}");
      if (resJson['success'] == 1) {
        var content = resJson['content'];
        Provider.of<UserModel>(context, listen: false).user.avatarUrlLocal = '';
        Provider.of<UserModel>(context, listen: false).user.avatar = 0;
        Provider.of<UserModel>(context, listen: false).user.avatarUrl = '';
        Global.saveProfile();
        userInfo.changeAvatar(0, '', '');
        // 返回
        Navigator.of(pageContext).pop();
      } else {
        showToast(resJson['respMsg']);
      }
    } catch (e) {
      //登录失败则提示
      print('e-----: $e');
      if (e.response?.statusCode == 401) {
        showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
      } else {
        showToast(e.toString());
      }
    } finally {
      // 隐藏loading框
      Navigator.of(context).pop();
    }
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return ListView(
          children: <Widget>[
            Divider(height: 1),
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 13, top: 8, bottom: 8),
                        child: Text(
                          gm.logout,
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    //退出账号前先弹二次确认窗
                    return AlertDialog(
                      content: Text(gm.logoutTip),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(gm.cancel),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text(gm.yes),
                          onPressed: () {
                            //该赋值语句会触发MaterialApp rebuild
                            userModel.user = null;
                            Global.profile.token = null;
                            Global.saveProfile();
                            socketInit.disconnect();
//                            socketInit.close();
//                            socketInit = null;
//                            socketInit.destroy();
//                            socketInit = null;
                            isSend = false;
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(height: 1),
          ],
        );
      },
    );
  }
}
