import 'dart:math';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

class AvatarWidget extends StatefulWidget {
  final String avatarUrl;
  final String avatarLocal;
  final String firstName;
  final String lastName;
  final int colorId;
  final double width;
  final double height;
  final double fontSize;

  AvatarWidget({
    Key key,
    this.avatarUrl,
    this.avatarLocal,
    this.firstName,
    this.lastName,
    this.colorId,
    this.width,
    this.height,
    this.fontSize,
  }) : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);
  String localUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localUrl = widget.avatarLocal;
    judgeFile(localUrl);
  }

  @override
  Widget build(BuildContext context) {
    int rNum = widget.colorId;
    if (rNum == null) {
      rNum = 0;
    }
    var nameStr = '';
    Widget gAvatar;
    if (widget.firstName != null && widget.firstName != '') {
//      nameStr += widget.firstName.substring(0, 1);
      nameStr +=
          String.fromCharCode(widget.firstName.runes.first).toUpperCase();
    }
    if (widget.lastName != null && widget.lastName != '') {
//      nameStr += widget.lastName.substring(0, 1);
      nameStr += String.fromCharCode(widget.lastName.runes.first).toUpperCase();
    }
    if (widget.avatarUrl == null ||
        widget.avatarUrl == '' && localUrl == null ||
        localUrl == '') {
//      logger.d(rNum);
      gAvatar = Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[rNum],
        ),
        child: Text(
          '$nameStr',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      if (localUrl != null && localUrl != '') {
        gAvatar = Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(1), BlendMode.dstATop),
              image: FileImage(File("$localUrl")),
              fit: BoxFit.cover,
//                      new AssetImage("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg")
//          FileImage(File("/storage/emulated/0/DCIM/Camera/IMG_20200206_201702_BURST001_COVER.jpg"))
            ),
          ),
        );
      } else {
        gAvatar = CircleAvatar(
          backgroundImage: NetworkImage(
            "${widget.avatarUrl}",
          ),
          radius: widget.width / 2,
        );
      }
    }
    return gAvatar;
  }

  judgeFile(String fileUrl) async {
    if(fileUrl == null) return;
    bool exists = await File(fileUrl).exists();
    if (!exists) {
      if (!mounted) return;
      setState(() {
        localUrl = null;
      });
    }
  }
}
