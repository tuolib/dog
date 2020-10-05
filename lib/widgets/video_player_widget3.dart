import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'gradient_fab.dart';
import 'dart:convert';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState(videoUrl);
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final VideoPlayerController videoPlayerController;
  final String videoUrl;
  double videoDuration = 0;
  double currentDuration = 0;

  _VideoPlayerWidgetState(this.videoUrl)
      : videoPlayerController = VideoPlayerController.network(videoUrl);

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize().then((_) {
      setState(() {
        videoDuration =
            videoPlayerController.value.duration.inMilliseconds.toDouble();
      });
    });

    videoPlayerController.addListener(() {
      setState(() {
        currentDuration =
            videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
    print(videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: 200.0, //宽度尽可能大
          maxHeight: 200.0, //最小高度为50像素
      ),
      // This line set the transparent background
      child: Stack(
        alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            constraints: BoxConstraints(maxHeight: 400),
            child: videoPlayerController.value.initialized
                ? AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            )
                : Container(
              height: 200,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: GradientFab(
                elevation: 0,
                child: Icon(
                  Icons.play_arrow,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {

                  var arg = {
                    'videoUrl': videoUrl,
                  };
                  Navigator.of(context)
                      .pushNamed('videoPlay', arguments: json.encode(arg));
                }),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
