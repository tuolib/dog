import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../index.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:photo_view/photo_view.dart';

class PhotoViewSimpleScreen extends StatefulWidget {
  const PhotoViewSimpleScreen({
    this.imageProvider, //图片
    this.loadingChild, //加载时的widget
    this.backgroundDecoration, //背景修饰
    this.minScale, //最大缩放倍数
    this.maxScale, //最小缩放倍数
    this.heroTag, //hero动画tagid
    this.fileId, // 文件id
  });

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;
  final int fileId;

  @override
  _PhotoViewSimpleScreenState createState() => _PhotoViewSimpleScreenState();
}

class _PhotoViewSimpleScreenState extends State<PhotoViewSimpleScreen> {
  bool loadingLargeAvatar = false;
  var gAvatar;
  String fileOriginLocal;
  String fileName;
  FileSql fileInfo;

  @override
  void initState() {
    gAvatar = widget.imageProvider;
    getLargeAvatar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery
              .of(context)
              .size
              .height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: PhotoView(
                imageProvider: gAvatar,
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                minScale: widget.minScale,
                maxScale: widget.maxScale,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
                enableRotation: true,
              ),
            ),
            Positioned(
              //左上角关闭按钮
              left: 3,
              top: MediaQuery
                  .of(context)
                  .padding
                  .top,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              // 右上角 菜单按钮
              right: 0,
              top: MediaQuery
                  .of(context)
                  .padding
                  .top,
              child: PopupMenuButton(
                onSelected: handleClickMenu,
                icon: Icon(
                  Icons.more_vert,
                  size: 25,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'save_to_gallery',
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 4),
                              child: Text("Save to gallery"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'save_to_downloads',
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.save_alt,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 4),
                              child: Text("Save to downloads"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ),
            loadingLargeAvatar
                ? Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  getLargeAvatar() async {
    if (widget.fileId != null && widget.fileId != 0) {
      final dbHelper = DatabaseHelper.instance;
      setState(() {
        loadingLargeAvatar = true;
      });
      fileInfo = await dbHelper.fileOne(widget.fileId);
      if (fileInfo == null) return;
      logger.d(fileInfo.id);
      if (fileInfo.fileOriginLocal == null || fileInfo.fileOriginLocal == '') {
        var downloadInfo = await Git().saveImageFileOrigin(
          fileInfo.id,
          fileInfo.fileName,
          fileInfo.fileOriginUrl,
        );
        if (downloadInfo['pathUrl'] != null) {
          setState(() {
            loadingLargeAvatar = false;
            fileOriginLocal = downloadInfo['pathUrl'];
            fileName = fileInfo.fileName;
            gAvatar = FileImage(File("${downloadInfo['pathUrl']}"));
            logger.d(fileOriginLocal);
//            gAvatar = Image.file(
//              File("${downloadInfo['pathUrl']}"),
////              fit: BoxFit.cover,
//            );
          });
          socketProviderChatListModel.getChatList();
        }
      } else {
        setState(() {
          loadingLargeAvatar = false;
          fileOriginLocal = fileInfo.fileOriginLocal;
          fileName = fileInfo.fileName;
          gAvatar = FileImage(File("${fileInfo.fileOriginLocal}"));
//          gAvatar = Image.file(
//            File("${fileInfo.fileOriginLocal}"),
////            fit: BoxFit.cover,
//          );
        });
      }
    }
  }

  handleClickMenu(String value) async {
    logger.d(value);
    switch (value) {
      case 'save_to_gallery':
        _downloadImage('pictures');
        break;
      case 'save_to_downloads':
        _downloadImage('download');
        break;
    }
  }

  _downloadImage(String type) async {
    if (!loadingLargeAvatar && fileOriginLocal != null &&
        fileOriginLocal != '') {
      logger.d(fileOriginLocal);
//      logger.d('${DateTime.now().toUtc().toIso8601String()}');
//      await ImageDownloader.downloadImage(fileInfo.fileCompressUrl);

      var ext = path.extension(fileName);
      var res = await Git().download(
        's',
        '${TimeUtil.getUtcNow()}$ext',
        fileOriginLocal,
        isLocal: true,
        type: type,
      );
      if (res['isSuccess']) {
        showToast('Saved success');
      }
    }
  }
}
