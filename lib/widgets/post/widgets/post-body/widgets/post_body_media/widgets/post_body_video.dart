import 'dart:async';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/connectivity.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:Okuna/widgets/video_player/video_player.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:async/async.dart';

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
  bool _needsBootstrap;
  StreamSubscription _videosSoundSettingsChangeSubscription;
  StreamSubscription _connectivityChangeSubscription;

  VideosAutoPlaySetting _currentVideosAutoPlaySetting;
  ConnectivityResult _connectivity;

  CancelableOperation _digestInViewStateChangeOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _obVideoPlayerController = OBVideoPlayerController();
  }

  @override
  void dispose() {
    super.dispose();
    _connectivityChangeSubscription?.cancel();
    _videosSoundSettingsChangeSubscription?.cancel();
    _digestInViewStateChangeOperation?.cancel();
  }

  void _bootstrap() async {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    UserPreferencesService userPreferencesService =
        openbookProvider.userPreferencesService;
    _currentVideosAutoPlaySetting =
        await userPreferencesService.getVideosAutoPlaySetting();

    _videosSoundSettingsChangeSubscription = userPreferencesService
        .videosAutoPlaySettingChange
        .listen(_onVideosAutoPlaySettingChange);

    ConnectivityService connectivityService =
        openbookProvider.connectivityService;

    //_connectivity = connectivityService.getConnectivity();
    //_connectivityChangeSubscription =
    //    connectivityService.onConnectivityChange(_onConnectivityChange);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inViewId == null) {
      return _buildVideoPlayer();
    }

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
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
    _digestInViewStateChangeOperation?.cancel();
    _digestInViewStateChangeOperation = CancelableOperation.fromFuture(
        _digestInViewStateChanged(isVideoInView));
  }

  Future _digestInViewStateChanged(bool isVideoInView) async {
    if (_obVideoPlayerController.hasVideoOpenedInDialog()) return;
    debugLog('Is in View: ${isVideoInView.toString()}');
    if (isVideoInView) {
      if (!_obVideoPlayerController.isPausedDueToInvisibility() &&
          !_obVideoPlayerController.isPausedByUser()) {
        debugLog('Playing as item is in view and allowed by user.');
        _obVideoPlayerController.play();
      }
    } else if (_obVideoPlayerController.isPlaying()) {
      _obVideoPlayerController.pause();
    }
  }

  void _onVideosAutoPlaySettingChange(
      VideosAutoPlaySetting videosAutoPlaySetting) {
    _currentVideosAutoPlaySetting = videosAutoPlaySetting;
  }

  void _onConnectivityChange(ConnectivityResult connectivity) {
    _connectivity = connectivity;
  }

  void debugLog(String log) {
    //debugPrint('OBPostBodyVideo: $log');
  }
}
