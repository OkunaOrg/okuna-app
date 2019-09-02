import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/widgets/video_player.dart';
import 'package:flutter/material.dart';

class OBPostBodyVideo extends StatelessWidget {
  final PostVideo postVideo;

  const OBPostBodyVideo({this.postVideo});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double imageAspectRatio = postVideo.width / postVideo.height;
    double imageHeight = (screenWidth / imageAspectRatio);

    OBVideoFormat videoFormat =
        postVideo.getVideoFormatOfType(OBVideoFormatType.mp4SD);

    String videoUrl = videoFormat.file;

    return SizedBox(
      height: imageHeight,
      width: screenWidth,
      child: OBVideoPlayer(
        videoUrl: videoUrl,
        isDismissable: false,
        thumbnailUrl: postVideo.thumbnail,
      ),
    );
  }
}
