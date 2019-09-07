import 'dart:io';

import 'package:Okuna/widgets/video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OBVideoDialog extends StatelessWidget {
  final File video;
  final String videoUrl;
  final ChewieController chewieController;
  final VideoPlayerController videoPlayerController;

  const OBVideoDialog(
      {Key key,
      this.video,
      this.videoUrl,
      this.chewieController,
      this.videoPlayerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        child: SafeArea(
            child: Center(
                child: OBVideoPlayer(
          video: video,
          videoUrl: videoUrl,
          videoPlayerController: videoPlayerController,
          chewieController: chewieController,
          isInDialog: true,
        ))));
  }
}