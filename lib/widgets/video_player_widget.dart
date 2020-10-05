import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dart:convert';
import 'gradient_fab.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import '../index.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

//  VideoPlayerWidget(this.videoUrl);
  VideoPlayerWidget({Key key, this.videoUrl})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState(videoUrl);
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final String videoUrl;
  _VideoPlayerWidgetState(this.videoUrl);

  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _sizeH = 200;
  int _sizeW = 200;
  int _timeMs = 100;

  GenThumbnailImage _futreImage;

  String _tempDir;

  @override
  void initState() {
    super.initState();
    getTemporaryDirectory().then((d) {
      _tempDir = d.path;
      print('videoUrl: $videoUrl');
      setState(() {
        _futreImage = GenThumbnailImage(
            thumbnailRequest: ThumbnailRequest(
                video: videoUrl,
                thumbnailPath: _tempDir,
                imageFormat: _format,
                maxHeight: _sizeH,
                maxWidth: _sizeW,
                quality: _quality));
        print('_futreImage: $_futreImage');
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
//            var arg = {
//              'videoUrl': videoUrl,
//            };
//            Navigator.of(context)
//                .pushNamed('videoPlay', arguments: json.encode(arg));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayRoute(videoUrl)),
        );
      },
      child: Container(
        color: Color(0xFF737373),
        // This line set the transparent background
        child: Container(
          color: Theme.of(context).backgroundColor,
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                constraints: BoxConstraints(maxHeight: 400),
                child: SizedBox(),
              ),
//            Slider(
//              value: currentDuration,
//              max: videoDuration,
//              onChanged: (value) => videoPlayerController
//                  .seekTo(Duration(milliseconds: value.toInt())),
//            ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Column(
                  children: [
                    (_futreImage != null) ? _futreImage : SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:0.0),
                child: GradientFab(
                    elevation: 0,
                    child: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
//    videoPlayerController.dispose();
    super.dispose();
  }
}

class ThumbnailRequest {
  final String video;
  final String thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;

  const ThumbnailRequest(
      {this.video,
        this.thumbnailPath,
        this.imageFormat,
        this.maxHeight,
        this.maxWidth,
        this.timeMs,
        this.quality});
}

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;

  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if (r.thumbnailPath != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: r.video,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality);

    print("thumbnail file is located: $thumbnailPath");

    final file = File(thumbnailPath);
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
        video: r.video,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality);
  }

  int _imageDataSize = bytes.length;
  print("image size: $_imageDataSize");

  final _image = Image.memory(bytes);
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  final ThumbnailRequest thumbnailRequest;

  const GenThumbnailImage({Key key, this.thumbnailRequest}) : super(key: key);

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: genThumbnail(widget.thumbnailRequest),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final _image = snapshot.data.image;
          final _width = snapshot.data.width;
          final _height = snapshot.data.height;
          final _dataSize = snapshot.data.dataSize;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
//              Center(
//                child: Text(
//                    "Image ${widget.thumbnailRequest.thumbnailPath == null ? 'data size' : 'file size'}: $_dataSize, width:$_width, height:$_height"),
//              ),
//              Container(
//                color: Colors.grey,
//                height: 1.0,
//              ),
              _image,
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              "No data",
            ),
          );
        } else {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                Text(
//                    "Generating the thumbnail for: ${widget.thumbnailRequest.video}..."),
                SizedBox(
                  height: 10.0,
                ),
                CircularProgressIndicator(),
              ]);
        }
      },
    );
  }
}
