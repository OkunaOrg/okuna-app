import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/video_player/aspect_ratio_video.dart';
import 'package:Openbook/widgets/video_player/network_player_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class OBPostBodyVideo extends StatelessWidget {
  VoidCallback listener;
  String videoUrl;
  final Post post;

  OBPostBodyVideo({this.post});

  @override
  Widget build(BuildContext context) {

      final String videoUrl = post.getVideo();
      return Center(
          child: NetworkPlayerLifeCycle(videoUrl,
                (BuildContext context, VideoPlayerController controller) => OBAspectRatioVideo(controller),
          )
        );
    }
}



