import 'dart:async';

import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:chewie/src/chewie_progress_colors.dart';
import 'package:chewie/src/material_progress_bar.dart';
import 'package:chewie/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OBVideoPlayerControls extends StatefulWidget {
  final Function(Function) onExpandCollapse;
  final OBVideoPlayerControlsController controller;

  const OBVideoPlayerControls({Key key, this.onExpandCollapse, this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBVideoPlayerControlsState();
  }
}

class OBVideoPlayerControlsState extends State<OBVideoPlayerControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _isDismissable;

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;

    bool isLoading = _latestValue != null &&
            !_latestValue.isPlaying &&
            _latestValue.duration == null ||
        _latestValue != null && _latestValue.isBuffering;

    bool hasError = _latestValue != null && _latestValue.hasError;

    if (isLoading) {
      mainWidget = Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (hasError) {
      mainWidget = chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
              context,
              chewieController.videoPlayerController.value.errorDescription,
            )
          : Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
            );
    } else {
      mainWidget = _buildHitArea();
    }

    return Stack(children: <Widget>[
      new AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: new Duration(milliseconds: 300),
        child: new Container(
          color: Colors.black38,
        ),
      ),
      new Column(
        children: <Widget>[
          mainWidget,
          _buildBottomBar(context, controller),
        ],
      ),
      _hideStuff || !_isDismissable
          ? new Container()
          : new IconButton(
              icon: new Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () async {
                print("pressed true");
                controller.pause();
                Navigator.pop(context);
              },
            ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _isDismissable = false;
    //widget.controller.attach(this);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
    VideoPlayerController controller,
  ) {
    return new AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: new Duration(milliseconds: 300),
      child: new Container(
        height: barHeight,
        color: Colors.transparent,
        child: new Row(
          children: <Widget>[
            _buildPlayPause(controller),
            _buildPosition(Colors.white),
            _buildProgressBar(),
            _buildMuteButton(controller),
            chewieController.allowFullScreen
                ? _buildExpandButton()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return new GestureDetector(
      onTap: widget.onExpandCollapse != null
          ? () {
              widget.onExpandCollapse(_onExpandCollapse);
            }
          : _onExpandCollapse,
      child: new AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: new Duration(milliseconds: 300),
        child: new Container(
          height: barHeight,
          margin: new EdgeInsets.only(right: 12.0),
          padding: new EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: new Center(
            child: new Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    return new Expanded(
      child: new GestureDetector(
        onTap: _latestValue != null && _latestValue.isPlaying
            ? () {
                _playPause();
                //_cancelAndRestartTimer;
                setState(() {
                  _hideStuff = false;
                });
              }
            : () {
                _playPause();
                setState(() {
                  _hideStuff = true;
                });
              },
        child: new Container(
          color: Colors.transparent,
          child: new Center(
            child: new AnimatedOpacity(
              opacity:
                  _latestValue != null && !_latestValue.isPlaying && !_dragging
                      ? 1.0
                      : 0.0,
              duration: new Duration(milliseconds: 300),
              child: new GestureDetector(
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(48.0),
                  ),
                  child: new Padding(
                    padding: new EdgeInsets.only(top: 30.0),
                    child: new Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return new GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: new AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: new Duration(milliseconds: 300),
        child: new ClipRect(
          child: new Container(
            child: new Container(
              height: barHeight,
              padding: new EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: new Icon(
                (_latestValue != null && _latestValue.volume > 0)
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return new GestureDetector(
      onTap: _playPause,
      child: new Container(
        height: barHeight,
        color: Colors.transparent,
        margin: new EdgeInsets.only(left: 8.0, right: 8.0),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return new Padding(
      padding: new EdgeInsets.only(right: 24.0),
      child: new Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  void setIsDismissible(bool isDismissible) {
    debugLog('Setting isDismissible to ${isDismissible.toString()}');

    setState(() {
      _isDismissable = isDismissible;
    });
  }

  Widget _buildProgressBar() {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    OBTheme activeTheme = openbookProvider.themeService.getActiveTheme();

    Color actionsForegroundColor = openbookProvider.themeValueParserService
        .parseGradient(activeTheme.primaryAccentColor)
        .colors[1];

    return new Expanded(
      child: new Padding(
        padding: new EdgeInsets.only(right: 20.0),
        child: new MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: ChewieProgressColors(
              playedColor: actionsForegroundColor,
              handleColor: actionsForegroundColor,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.grey),
        ),
      ),
    );
  }

  void debugLog(String log) {
    debugPrint('OBVideoPlayerControls:$log');
  }
}

class OBVideoPlayerControlsController {
  OBVideoPlayerControlsState _state;
  bool isDismissable;

  OBVideoPlayerControlsController({this.isDismissable});

  void attach(state) {
    _state = state;
  }

  void setIsDismissible(bool isDismissible) {
    _state.setIsDismissible(isDismissible);
    this.isDismissable = isDismissible;
  }
}
