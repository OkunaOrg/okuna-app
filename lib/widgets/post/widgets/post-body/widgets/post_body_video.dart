import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/widgets/video_player/aspect_ratio_video.dart';
import 'package:Okuna/widgets/video_player/network_player_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OBPostBodyVideo extends StatelessWidget {
  final PostVideo postVideo;

  const OBPostBodyVideo({this.postVideo});

  @override
  Widget build(BuildContext context) {
    OBVideoFormat videoFormat =
        postVideo.getVideoFormatOfType(OBVideoFormatType.mp4SD);

    String videoUrl = videoFormat.file;

    return Center(
        child: NetworkPlayerLifeCycle(
      videoUrl,
      (BuildContext context, VideoPlayerController controller) =>
          OBAspectRatioVideo(controller),
    ));
  }
}
