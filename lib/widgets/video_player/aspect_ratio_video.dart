import 'package:Openbook/widgets/video_player/play_pause_state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OBAspectRatioVideo extends StatefulWidget {
  OBAspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  OBAspectRatioVideoState createState() => OBAspectRatioVideoState();
}

class OBAspectRatioVideoState extends State<OBAspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value.size.width / controller.value.size.height,
          child: VideoPlayPause(controller),
        ),
      );
    } else {
      return Image(image: AssetImage('assets/images/loading.gif'));
    }
  }
}