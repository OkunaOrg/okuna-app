import 'dart:io';
import 'package:Openbook/widgets/video_player/aspect_ratio_video.dart';
import 'package:Openbook/widgets/video_player/network_player_lifecycle.dart';
import 'package:Openbook/widgets/video_player/play_pause_state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OBPostVideoPreviewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OBPostVideoPreviewerState();
  }

  final File postVideo;
  final VoidCallback onRemove;

  OBPostVideoPreviewer(this.postVideo, {this.onRemove});
}

class _OBPostVideoPreviewerState extends State<OBPostVideoPreviewer> {

  Widget _assetPlayer;
  Widget _getVideoPlayerWidget() {

   return Center(
        child: _assetPlayer
    );
  }

  @override
  void initState() {
    super.initState();
    _assetPlayer =  AssetPlayerLifeCycle(widget.postVideo,
            (BuildContext context, VideoPlayerController controller) => AspectRatioVideo(controller)
    );
  }

  @override
  Widget build(BuildContext context) {
    double avatarBorderRadius = 10.0;

    var videoPreview = Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(avatarBorderRadius)),
      child: Container(
        child: _getVideoPlayerWidget(),
      ),
    );

    if (widget.onRemove == null) return videoPreview;

    double buttonSize = 30.0;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        videoPreview,
        Positioned(
            right: -10.0,
            top: -10.0,
            child: GestureDetector(
              onTap: widget.onRemove,
              child: SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: FloatingActionButton(
                  onPressed: widget.onRemove,
                  backgroundColor: Colors.black87,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

