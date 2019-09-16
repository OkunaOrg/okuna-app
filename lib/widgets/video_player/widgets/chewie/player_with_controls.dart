import 'dart:ui';

import 'package:Okuna/widgets/video_player/widgets/chewie/chewie_player.dart';
import 'package:Okuna/widgets/video_player/widgets/chewie/cupertino_controls.dart';
import 'package:Okuna/widgets/video_player/widgets/chewie/material_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerWithControls extends StatelessWidget {
  final maxHeight;

  const PlayerWithControls({Key key, this.maxHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: _buildPlayerWithControls(chewieController, context)),
    );
  }

  Container _buildPlayerWithControls(
      ChewieController chewieController, BuildContext context) {
    final double aspectRatio =
        chewieController.aspectRatio ?? _calculateAspectRatio(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool hasMaxHeight = maxHeight != null;

    Widget videoWidget = Center(
      child: Hero(
        tag: chewieController.videoPlayerController,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: VideoPlayer(chewieController.videoPlayerController),
        ),
      ),
    );

    return Container(
      height: maxHeight,
      color: Colors.red,
      child: Stack(
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          hasMaxHeight
              ? Positioned(
                  top: -((screenHeight - maxHeight) / 2),
                  height: screenHeight,
                  width: screenWidth,
                  child: videoWidget,
                )
              : videoWidget,
          chewieController.overlay ?? Container(),
          _buildControls(context, chewieController),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ChewieController chewieController,
  ) {
    return chewieController.showControls
        ? chewieController.customControls != null
            ? chewieController.customControls
            : Theme.of(context).platform == TargetPlatform.android
                ? MaterialControls()
                : CupertinoControls(
                    backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
                    iconColor: Color.fromARGB(255, 200, 200, 200),
                  )
        : Container();
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}
