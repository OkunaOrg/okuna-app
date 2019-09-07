import 'dart:io';

import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/video_player/widgets/video_player_controls.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:video_player/video_player.dart';

import '../progress_indicator.dart';

class OBVideoPlayer extends StatefulWidget {
  final File video;
  final String videoUrl;
  final String thumbnailUrl;
  final Key visibilityKey;
  final ChewieController chewieController;
  final VideoPlayerController videoPlayerController;
  final bool isInDialog;
  final bool autoPlay;
  final OBVideoPlayerController controller;

  const OBVideoPlayer(
      {Key key,
      this.video,
      this.videoUrl,
      this.thumbnailUrl,
      this.chewieController,
      this.videoPlayerController,
      this.isInDialog = false,
      this.autoPlay = false,
      this.visibilityKey,
      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBVideoPlayerState();
  }
}

class OBVideoPlayerState extends State<OBVideoPlayer> {
  VideoPlayerController _playerController;
  ChewieController _chewieController;
  OBVideoPlayerControlsController _obVideoPlayerControlsController;

  Future _initializeVideoPlayerFuture;

  bool _needsChewieBootstrap;

  bool _isVideoHandover;
  bool _hasVideoOpenedInDialog;

  Key _visibilityKey;

  bool _pausedDueToVisibilityChange;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _obVideoPlayerControlsController = OBVideoPlayerControlsController();
    _hasVideoOpenedInDialog = widget.isInDialog ?? false;
    _needsChewieBootstrap = true;
    _pausedDueToVisibilityChange = false;

    _isVideoHandover =
        widget.videoPlayerController != null && widget.chewieController != null;

    String visibilityKeyFallback;
    if (widget.videoUrl != null) {
      _playerController = VideoPlayerController.network(widget.videoUrl);
      visibilityKeyFallback = widget.videoUrl;
    } else if (widget.video != null) {
      _playerController = VideoPlayerController.file(widget.video);
      visibilityKeyFallback = widget.video.path;
    } else if (widget.videoPlayerController != null) {
      _playerController = widget.videoPlayerController;
      visibilityKeyFallback = widget.videoPlayerController.dataSource;
    } else {
      throw Exception('Video dialog requires video or videoUrl.');
    }

    _visibilityKey = widget.visibilityKey != null
        ? widget.visibilityKey
        : Key(visibilityKeyFallback);

    _initializeVideoPlayerFuture =
        _isVideoHandover ? Future.value() : _playerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    if (!_isVideoHandover && mounted) {
      if (_playerController != null) _playerController.dispose();
      if (_chewieController != null) _chewieController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_needsChewieBootstrap) {
            _chewieController = _getChewieController();
            _needsChewieBootstrap = false;
          }

          return VisibilityDetector(
            key: _visibilityKey,
            onVisibilityChanged: _onVisibilityChanged,
            child: Chewie(
              controller: _chewieController,
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Stack(
            children: <Widget>[
              widget.thumbnailUrl != null
                  ? Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AdvancedNetworkImage(widget.thumbnailUrl,
                            useDiskCache: true),
                      )),
                    )
                  : const SizedBox(),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Center(
                    child: OBProgressIndicator(
                  color: Colors.white,
                )),
              )
            ],
          );
        }
      },
    );
  }

  void _onExpandCollapse(Function originalExpandFunction) async {
    if (_hasVideoOpenedInDialog) {
      _obVideoPlayerControlsController.pop();
      _hasVideoOpenedInDialog = false;
      return;
    }

    _hasVideoOpenedInDialog = true;
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    await openbookProvider.dialogService.showVideo(
        context: context,
        video: widget.video,
        videoUrl: widget.videoUrl,
        videoPlayerController: _playerController,
        chewieController: _chewieController);
    _hasVideoOpenedInDialog = false;
  }

  // Return back to config

  ChewieController _getChewieController() {
    if (widget.chewieController != null) return widget.chewieController;
    double aspectRatio = _playerController.value.aspectRatio;
    return ChewieController(
        videoPlayerController: _playerController,
        showControlsOnInitialize: false,
        customControls: OBVideoPlayerControls(
            controller: _obVideoPlayerControlsController,
            onExpandCollapse: _onExpandCollapse),
        aspectRatio: aspectRatio,
        autoPlay: widget.autoPlay,
        looping: true);
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (_hasVideoOpenedInDialog) return;
    bool isVisible = visibilityInfo.visibleFraction != 0;

    debugLog('isVisible: ${isVisible.toString()}');

    if (isVisible) {
      if (_pausedDueToVisibilityChange) {
        debugLog('Was paused due to visibility change, now unpausing.');
        _chewieController.play();
        _pausedDueToVisibilityChange = false;
      }
    } else if (_playerController.value.isPlaying) {
      debugLog('Its not visible and the video is playing. Now pausing. .');
      _pausedDueToVisibilityChange = true;
      _chewieController.pause();
    }
  }

  void debugLog(String log) {
    ValueKey<String> key = _visibilityKey;
    debugPrint('OBVideoPlayer:${key.value}: $log');
  }
}

class OBVideoPlayerController {
  OBVideoPlayerState _state;

  void attach(state) {
    _state = state;
  }

  void pause() {
    if (!isReady()) {
      debugLog('State is not ready. Wont pause.');
      return;
    }
    _state._chewieController.pause();
  }

  void play() {
    if (!isReady()) {
      debugLog('State is not ready. Wont play.');
      return;
    }
    _state._chewieController.play();
  }

  bool isPlaying() {
    if (!isReady()) {
      debugLog('State is not ready. Obviously not playing.');
      return false;
    }

    return _state._playerController.value.isPlaying;
  }

  bool isReady() {
    return _state != null &&
        _state.mounted &&
        _state._playerController != null &&
        _state._playerController.value != null &&
        _state._chewieController != null;
  }

  String getIdentifier() {
    if (!isReady()) {
      debugLog('State is not ready. Can not get identifier.');
      return null;
    }

    return _state._playerController.dataSource;
  }

  void debugLog(String log) {
    debugPrint('OBVideoPlayerController: $log');
  }
}
