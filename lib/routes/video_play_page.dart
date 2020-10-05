import '../index.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';

class VideoPlayRoute extends StatefulWidget {
  final String videoUrl;

  VideoPlayRoute(this.videoUrl);

//  @override
//  State<StatefulWidget> createState() {
//    return _VideoPlayRouteState();
//  }

  @override
  _VideoPlayRouteState createState() => _VideoPlayRouteState(videoUrl);
}

class _VideoPlayRouteState extends State<VideoPlayRoute> {
  TargetPlatform _platform;
  final String videoUrl;

  VideoPlayerController videoPlayerController;
  var chewieController;
  var playerWidget;

  _VideoPlayRouteState(this.videoUrl)
      : videoPlayerController = VideoPlayerController.network(videoUrl);

  @override
  void initState() {
    super.initState();

//    videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );

    playerWidget = Chewie(
      controller: chewieController,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
        appBar: AppBar(
          backgroundColor: Colors.transparent, //把appbar的背景色改成透明
          // elevation: 0,//appbar的阴影
        ),
        body: Center(
          child: playerWidget,
        ),
      ),
    );
  }
}
