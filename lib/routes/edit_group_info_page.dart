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
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_luban/flutter_luban.dart';

bool isOnEditGroupInfoPage = false;
BuildContext editGroupInfoContext;

class EditGroupInfoRoute extends StatefulWidget {
  final String firstName;
  final String lastName;
  final int colorId;
  final int avatar;
  final String avatarUrl;
  final String avatarLocal;
  final int groupId;
  final String description;

  EditGroupInfoRoute({
    Key key,
    this.groupId,
    this.avatar,
    this.firstName,
    this.lastName,
    this.colorId,
    this.avatarUrl,
    this.avatarLocal,
    this.description,
  }) : super(key: key);

  @override
  _EditGroupInfoRouteState createState() => _EditGroupInfoRouteState();
}

class _EditGroupInfoRouteState extends State<EditGroupInfoRoute> {
  TextEditingController _groupNameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

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

//  上传 file 信息
  Widget gAvatar;
  String groupAvatar;
  int avatar;
  String fileOriginLocal;
  String fileOriginUrl;
  String fileCompressUrl;
  String fileCompressLocal;
  double fileSize;

//  备份groupName
  var groupName;
  @override
  void initState() {
    groupName = widget.firstName;
    if (widget.lastName != null) {
      groupName += ' ${widget.lastName}';
    }
    _groupNameController.text = groupName;
    _descriptionController.text = widget.description;
    isOnEditGroupInfoPage = true;
    gAvatar = AvatarWidget(
      width: 60,
      height: 60,
      firstName: widget.firstName,
      lastName: widget.lastName,
      colorId: widget.colorId,
      avatarUrl: widget.avatarUrl,
      avatarLocal: widget.avatarLocal,
    );
    avatar = widget.avatar;
    logger.d(widget.avatar);
    super.initState();
  }

  @override
  void dispose() {
    isOnEditGroupInfoPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    editGroupInfoContext = context;

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
                        "Edit Group",
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          height: 20.0,
                                          width: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                          ),
                                        ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              autofocus: false,
                              controller: _groupNameController,
                              decoration: InputDecoration(
                                hintText: 'Group Name',
//                                  border: InputBorder.none,
                              ),
                              // 校验（不能为空）
                              validator: (v) {
                                return v.trim().isNotEmpty
                                    ? null
                                    : 'Group Name is required';
                              },
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(42),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    autofocus: false,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description (optional)',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    maxLength: 200,
                  ),
                ),
              ],
            ),
          ),
        ));
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
                if (avatar != 0)
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
    } else if (other == 'image') {
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
//    if (type == 'camera') {
//      pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 80, maxHeight: 640, maxWidth: 640);
//    } else if (type == 'video') {
//      pickedFile = await picker.getVideo(source: ImageSource.camera);
//    } else if (type == 'image') {
//      pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 80, maxHeight: 640, maxWidth: 640);
//    }
    if (type == 'camera') {
      pickedFile = await picker.getImage(source: ImageSource.camera,maxHeight: 1280, maxWidth: 1280);
    } else if (type == 'video') {
      pickedFile = await picker.getVideo(source: ImageSource.camera);
    } else if (type == 'image') {
      pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight: 1280, maxWidth: 1280);
    }
    if (pickedFile != null && type != 'video') {
      logger.d('_groupNameController1: ${_groupNameController.text}');
      logger.d('groupName1: $groupName');
      final f = File(pickedFile.path);
      int sizeInBytes = f.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      logger.d('pickedFile: $sizeInMb');
      var newPath = pickedFile.path;
      final dir = await Git().getSaveDirectory();
      final isPermissionStatusGranted = await Git().requestPermissions();
//    print(dir.path);
      String savePath = path.join(dir.path + '/github_client/img');
      final tempDir = await getTemporaryDirectory();
      showLoading(context);
      CompressObject compressObject = CompressObject(
        imageFile: f, //image
        path: tempDir.path, //compress to path
        quality: 85,//first compress quality, default 80
        step: 9,//compress quality step, The bigger the fast, Smaller is more accurate, default 6
//          mode: CompressMode.LARGE2SMALL,//default AUTO
      );
      newPath = await Luban.compressImage(compressObject);

      logger.d('_groupNameController2: ${_groupNameController.text}');
      logger.d('groupName2: $groupName');
      logger.d(newPath);
      Navigator.of(context).pop();
      final f2 = File(newPath);
      int sizeInBytes2 = f2.lengthSync();
      double sizeInMb2 = sizeInBytes2 / (1024 * 1024);
      logger.d('pickedFile2: $sizeInMb2');
      File croppedFile = await ImageCropper.cropImage(
//          sourcePath: pickedFile.path,
          sourcePath: newPath,
//          aspectRatioPresets: [
//            CropAspectRatioPreset.square,
//            CropAspectRatioPreset.ratio3x2,
//            CropAspectRatioPreset.original,
//            CropAspectRatioPreset.ratio4x3,
//            CropAspectRatioPreset.ratio16x9
//          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: '',
              hideBottomControls: false,
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
//          iosUiSettings: IOSUiSettings(
//            minimumAspectRatio: 1.0,
//            aspectRatioLockEnabled: true,
//          )
          );
      logger.d('_groupNameController3: ${_groupNameController.text}');
      logger.d('groupName3: $groupName');
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
      if (sizeInMb > 0.5) {




//        Luban.compressImage(compressObject).then((value) async {
//          logger.d(value);
//          newPath = value;
//          final f = File(value);
//          int sizeInBytes = f.lengthSync();
//          double sizeInMb = sizeInBytes / (1024 * 1024);
//          logger.d('pickedFile2: $sizeInMb');
//
//        });
      }

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
      final dir = await Git().getSaveDirectory();

      String savePath = path.join(dir.path + '/temporary/', 'test.jpg');
      final isPermissionStatusGranted = await Git().requestPermissions();
//      final f = await testCompressAndGetFile(File(_path), savePath);


      File croppedFile = await ImageCropper.cropImage(
          sourcePath: _path,
          maxWidth: 640,
          maxHeight: 640,
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
      logger.d("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }
//  Future<File> testCompressAndGetFile(File file, String targetPath) async {
//    File result = await FlutterImageCompress.compressAndGetFile(
//      file.absolute.path, targetPath,
//      quality: 80,
////      rotate: 180,
//    );
//
//    print(file.lengthSync());
//    print(result.lengthSync());
//
////    int sizeInBytes = file.lengthSync();
////    double sizeInMb = sizeInBytes / (1024 * 1024);
////    if (sizeInMb > 5) {
////      await testCompressAndGetFile(result, targetPath);
////    }
//    return result;
//  }

  uploadFile({groupId, filePath, fileDeter}) async {
    isUploadAvatar = true;
    final f = File(filePath);
    int sizeInBytes = f.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    logger.d('file path: $filePath');
    logger.d('file size: $sizeInMb MB');
    var res = await Git(context).uploadFileOnly(filePath, compressWidth: 70, compressHeight: 70);
    if (res['success'] == 1) {
      logger.d(res);
      var fileName = res['content']['fileName'];
//      获得 filePath， filename
      avatar = res['content']['id'];
      groupAvatar = fileName;
      fileCompressUrl = res['content']['url'];
      fileOriginUrl = res['content']['originUrl'];
//      var saveObj = await Git(context).copyFile(fileName, filePath);
//      if (saveObj['isSuccess']) {
//        fileOriginLocal = saveObj['filePath'];
//      }
    }
    setState(() {
      gAvatar = AvatarWidget(
        width: 60,
        height: 60,
        firstName: widget.firstName,
        lastName: widget.lastName,
        colorId: widget.colorId,
        avatarUrl: fileCompressUrl,
        avatarLocal: null,
      );
      isUploadAvatar = false;
    });
  }

  _saveName(pageContext) async {

    logger.d('_groupNameController4: ${_groupNameController.text}');
    logger.d('groupName4: $groupName');
    if ((_formKey.currentState as FormState).validate()) {
      var oldGroupName = widget.firstName;
      if (widget.lastName != null) {
        oldGroupName += ' ${widget.lastName}';
      }
      if (avatar == widget.avatar &&
          oldGroupName == _groupNameController.text &&
          widget.description == _descriptionController.text) {
        Navigator.of(pageContext).pop();
        return;
      }
      showLoading(context);
//      socket 提交修改group
//      var newA = avatar == null ? widget.avatar : avatar;
//
//      logger.d(widget.avatar);
//      logger.d(avatar);
//      logger.d(newA);
      SocketIoEmit.clientEditGroupSimple(
        groupId: widget.groupId,
        groupAvatar: groupAvatar,
        avatar: avatar == null ? widget.avatar : avatar,
        groupName: _groupNameController.text,
        description: _descriptionController.text,
      );
    }
  }

  _removePhoto(pageContext) async {
    setState(() {
      groupAvatar = '';
      avatar = 0;
      gAvatar = AvatarWidget(
        width: 60,
        height: 60,
        firstName: widget.firstName,
        lastName: widget.lastName,
        colorId: widget.colorId,
        avatarUrl: '',
        avatarLocal: '',
      );
    });
    Navigator.of(pageContext).pop();
  }
}
