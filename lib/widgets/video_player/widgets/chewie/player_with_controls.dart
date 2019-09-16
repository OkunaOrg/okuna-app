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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool hasMaxHeight = maxHeight != null;

    double aspectRatio =
        chewieController.aspectRatio ?? _calculateAspectRatio(context);

    double containerHeight = (screenWidth / aspectRatio);

    return Container(
      height: maxHeight ?? null,
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          hasMaxHeight
              ? Positioned(
                  top: -((containerHeight - maxHeight) / 2),
                  height: containerHeight,
                  width: screenWidth,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      color: Colors.yellow,
                      child: SizedBox(
                        child: VideoPlayer(
                            chewieController.videoPlayerController),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Hero(
                    tag: chewieController.videoPlayerController,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child:
                          VideoPlayer(chewieController.videoPlayerController),
                    ),
                  ),
                ),
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
