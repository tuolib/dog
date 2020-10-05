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

bool isOnAddGroupPage = false;
BuildContext addGroupContext;

class NewGroupInfoPage extends StatefulWidget {
  @override
  _NewGroupInfoPageState createState() => _NewGroupInfoPageState();
}

class _NewGroupInfoPageState extends State<NewGroupInfoPage> {
  TextEditingController _groupNameController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

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

  var fileCompressUrl;
  var fileCompressLocal;
  var groupAvatarName;
  var avatar;

  BuildContext pageCon;
  List contacts = [];

  @override
  void initState() {
    super.initState();
    _groupNameController.text = '';
    isOnAddGroupPage = true;
  }

  @override
  void dispose() {
    super.dispose();
    isOnAddGroupPage = false;
  }

  @override
  Widget build(BuildContext context) {
    addGroupContext = context;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var addPeople = Provider.of<AddPeopleModel>(context);
    var addPeopleArr = addPeople.addPeopleList;

    var membersStr = 'members';
    if (addPeopleArr.length == 1) {
      membersStr = 'member';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group'),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildGroupInfo(context),
                  Container(
                    height: 20,
                    color: Colors.black12,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '${addPeopleArr.length}' + ' $membersStr',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildBody(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          //悬浮按钮
          child: Icon(Icons.check),
          onPressed: () {
            _createGroup(context);
          }),
      // 构建主页面
    );
  }

  Widget _buildBody(context) {
    return Consumer<AddPeopleModel>(
      builder:
          (BuildContext context, AddPeopleModel addPeopleModel, Widget child) {
        var friends = addPeopleModel.addPeopleList;
        contacts = friends;
        return memberArray();
      },
    );

//    print('chats: $chats');
  }

  Widget _buildGroupInfo(context) {
    var gAvatar;
    if (fileCompressLocal == null || fileCompressLocal == '') {
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
      gAvatar = Container(
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(1), BlendMode.dstATop),
            image: FileImage(File("$fileCompressLocal")),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Padding(
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
                        ? Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
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
                Form(
                  key: _formKey,
                  autovalidate: false,
                  child: TextFormField(
                    autofocus: true,
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter group name',
                    ),
                    validator: (v) {
                      return v.trim().isNotEmpty
                          ? null
                          : 'Group name is required';
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget memberArray() {
    List myList = List.from(contacts);
    if (myList.length == 0) return SizedBox();
    ArrayUtil.sortArray(myList, sortOrder: 1, property: 'firstName');
    return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return _buildDefineMembers(myList[index]);
        }
    );
  }

  Widget _buildDefineMembers(Map friend) {
    var nameStr = '${friend['firstName']}';
    if (friend['lastName'] != null && friend['lastName'] != '') {
      nameStr += ' ${friend['lastName']}';
    }
    var gAvatar;
    gAvatar = AvatarWidget(
      avatarUrl: friend['avatarUrl'],
      avatarLocal: friend['avatarLocal'],
      firstName: friend['firstName'],
      lastName: friend['lastName'],
      width: 40,
      height: 40,
      colorId: friend['colorId'],
    );
    return Padding(
      padding: EdgeInsets.only(right: 15),
//      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 10),
                    child: Stack(
                      children: [
                        gAvatar,
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextOneLine(
                          "$nameStr",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          friend['isOnline']
                              ? 'online'
                              : '${TimeUtil.lastSeen(friend['lastSeen'])}',
                          style: TextStyle(
                            color: friend['isOnline']
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 65,
              child: Divider(),
            ),
          ),
        ],
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
                if (groupAvatarName != '' && groupAvatarName != null)
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('View Photo'),
                    onTap: () {
                      var arg = {
                        'imageProvider': fileCompressUrl,
                        'heroTag': fileCompressUrl,
                      };
                      Navigator.of(context)
                          .pushNamed('photoView', arguments: json.encode(arg));
                    },
                  ),
                if (groupAvatarName != '' && groupAvatarName != null)
                  ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Remove Photo'),
                      onTap: () {
                        groupAvatarName = null;
                        fileCompressUrl = null;
                        avatar = null;
                        fileCompressLocal = null;
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
      var uploadInfo = res['content'];
      setState(() {
        fileCompressUrl = uploadInfo['originUrl'];
        fileCompressLocal = filePath;
        groupAvatarName = uploadInfo['fileName'];
        avatar = uploadInfo['id'];
      });
//      var changeRes = await Git(context).mergeAvatar(res['content']['id']);
//      if (changeRes['success'] == 1) {
//        print("filename : ${res['content']['fileName']}");
//        print("filename : ${res['content']['originUrl']}");
//        var downloadInfo = await Git(context).download(
//            'id', res['content']['fileName'], res['content']['originUrl']);
//        if (downloadInfo['isSuccess']) {
//          var avatarUrlLocal = downloadInfo['filePath'];
//          print('downloadInfo: ${downloadInfo["filePath"]}');
////          userInfo.changeAvatar(res['content']['id'],
////              res['content']['originUrl'], avatarUrlLocal);
//        }
//      }

      isUploadAvatar = false;
    } else {
      isUploadAvatar = false;
    }
  }

  _createGroup(pageContext) {
    var friends = Provider.of<AddPeopleModel>(context, listen: false);
    pageCon = pageContext;
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      List groupUserArr = [];
      for (var i = 0; i < friends.addPeopleList.length; i++) {
        groupUserArr.add(friends.addPeopleList[i]['contactId']);
      }
      groupUserArr.add(Global.profile.user.userId);
      SocketIoEmit.clientCreateGroup(
        groupUserArr: groupUserArr,
        groupName: _groupNameController.text,
        groupAvatar: groupAvatarName,
        avatar: avatar,
      );
    }
  }

  // partially applicable sorter
  static Function(dynamic, dynamic) sorter(int sortOrder, String property) {
    int handleSortOrder(int sortOrder, int sort) {
      if (sortOrder == 1) {
        // a is before b
        if (sort == -1) {
          return -1;
        } else if (sort > 0) {
          // a is after b
          return 1;
        } else {
          // a is same as b
          return 0;
        }
      } else {
        // a is before b
        if (sort == -1) {
          return 1;
        } else if (sort > 0) {
          // a is after b
          return 0;
        } else {
          // a is same as b
          return 0;
        }
      }
    }

    return (dynamic a, dynamic b) {
      if (a['firstName'] != null && b['firstName'] != null) {
        switch (property) {
          case "firstName":
            int sort = a['firstName']
                .toLowerCase()
                .compareTo(b['firstName'].toLowerCase());
            return handleSortOrder(sortOrder, sort);
          default:
            return 0;
            break;
        }
      } else {
        return 0;
      }
    };
  }

  static void sortChats(List<dynamic> chats,
      {int sortOrder = 0, String property = "firstName"}) {
    switch (property) {
      case "firstName":
        chats.sort(sorter(sortOrder, property));
        break;
      case "createdDate":
        chats.sort(sorter(sortOrder, property));
        break;
      default:
//        print("Unrecognized property $property");
        break;
    }
  }
}
