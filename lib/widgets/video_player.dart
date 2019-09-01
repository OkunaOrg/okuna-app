import 'dart:io';

import 'package:Okuna/widgets/custom_chewie/src/ob_controls.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class OBVideoPlayer extends StatefulWidget {
  final File video;
  final String videoUrl;
  final VideoPlayerController videoPlayerController;

  const OBVideoPlayer(
      {Key key, this.video, this.videoUrl, this.videoPlayerController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBVideoPlayerState();
  }
}

class OBVideoPlayerState extends State<OBVideoPlayer> {
  VideoPlayerController _playerController;
  ChewieController _chewieController;

  Future _initializeVideoPlayerFuture;

  bool _needsChewieBootstrap;

  @override
  void initState() {
    super.initState();
    _needsChewieBootstrap = true;
    if (widget.videoUrl != null) {
      _playerController = VideoPlayerController.network(widget.videoUrl);
    } else if (widget.video != null) {
      _playerController = VideoPlayerController.file(widget.video);
    } else if (widget.videoPlayerController != null) {
      _playerController = widget.videoPlayerController;
    } else {
      throw Exception(
          'Video dialog requires video,videoUrl or videoPlayerController.');
    }

    _initializeVideoPlayerFuture = _playerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    if (_playerController.hasListeners) _playerController.dispose();
    _playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black, // status bar color
    ));

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_needsChewieBootstrap) {
            double aspectRatio = _playerController.value.aspectRatio;
            _chewieController = ChewieController(
                videoPlayerController: _playerController,
                customControls: OBControls(),
                aspectRatio: aspectRatio,
                autoPlay: true,
                looping: true);
            _needsChewieBootstrap = false;
          }

          return Chewie(
            controller: _chewieController,
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
