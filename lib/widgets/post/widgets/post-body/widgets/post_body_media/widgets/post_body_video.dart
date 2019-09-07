import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/widgets/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class OBPostBodyVideo extends StatefulWidget {
  final Post post;
  final PostVideo postVideo;
  final String inViewId;

  const OBPostBodyVideo({this.postVideo, this.post, this.inViewId});

  @override
  OBPostVideoState createState() {
    return OBPostVideoState();
  }
}

class OBPostVideoState extends State<OBPostBodyVideo> {
  OBVideoPlayerController _obVideoPlayerController;

  @override
  void initState() {
    super.initState();
    _obVideoPlayerController = OBVideoPlayerController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inViewId == null) {
      return _buildVideoPlayer();
    }

    InViewState state = InViewNotifierList.of(context);
    state.addContext(context: context, id: widget.inViewId);

    return AnimatedBuilder(
      animation: state,
      builder: (BuildContext context, Widget child) {
        final bool inView = state.inView(widget.inViewId);
        _onInViewStateChanged(inView);
        return _buildVideoPlayer();
      },
    );
  }

  Widget _buildVideoPlayer() {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageAspectRatio = widget.postVideo.width / widget.postVideo.height;
    double imageHeight = (screenWidth / imageAspectRatio);

    OBVideoFormat videoFormat =
        widget.postVideo.getVideoFormatOfType(OBVideoFormatType.mp4SD);

    String videoUrl = videoFormat.file;

    return SizedBox(
        height: imageHeight,
        width: screenWidth,
        child: OBVideoPlayer(
          videoUrl: videoUrl,
          thumbnailUrl: widget.postVideo.thumbnail,
          controller: _obVideoPlayerController,
        ));
  }

  void _onInViewStateChanged(bool isVideoInView) {
    if (_obVideoPlayerController.hasVideoOpenedInDialog()) return;
    debugLog('Is in View: ${isVideoInView.toString()}');
    if (isVideoInView) {
      if (!_obVideoPlayerController.isPaused()) {
        debugLog('Video was not paused, playing as item is in view.');
        _obVideoPlayerController.play();
      }
    } else if (_obVideoPlayerController.isPlaying()) {
      debugLog('Pausing');
      _obVideoPlayerController.pause();
    }
  }

  void debugLog(String log) {
    debugPrint('OBPostBodyVideo: $log');
  }
}
