import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/widgets/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController _playerController;
  InViewState _inViewState;

  void initState() {
    super.initState();
    OBVideoFormat videoFormat =
        widget.postVideo.getVideoFormatOfType(OBVideoFormatType.mp4SD);

    String videoUrl = videoFormat.file;
    _playerController = VideoPlayerController.network(videoUrl);
  }

  @override
  void dispose() {
    super.dispose();
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

    return SizedBox(
        height: imageHeight,
        width: screenWidth,
        child: OBVideoPlayer(
          videoPlayerController: _playerController,
          thumbnailUrl: widget.postVideo.thumbnail,
        ));
  }

  void _onInViewStateChanged(bool isVideoInView) {
    debugLog('Is in View: ${isVideoInView.toString()}');
    bool videoIsInitialized =
        _playerController != null && _playerController.value != null;
    if (isVideoInView &&
        videoIsInitialized &&
        !_playerController.value.isPlaying) {
      debugLog('Playing');
      _playerController.play();
    } else if (videoIsInitialized && _playerController.value.isPlaying) {
      debugLog('Pausing');
      _playerController.pause();
    }
  }

  void debugLog(String log) {
    debugPrint('OBPostBodyVideo:${_playerController.dataSource}: $log');
  }
}
