import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/widgets/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class OBPostBodyVideo extends StatelessWidget {
  final Post post;
  final PostVideo postVideo;
  final String inViewId;

  const OBPostBodyVideo({this.postVideo, this.post, this.inViewId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageAspectRatio = postVideo.width / postVideo.height;
    double imageHeight = (screenWidth / imageAspectRatio);

    OBVideoFormat videoFormat =
        postVideo.getVideoFormatOfType(OBVideoFormatType.mp4SD);

    String videoUrl = videoFormat.file;

    if (inViewId != null) {
      return SizedBox(
        height: imageHeight,
        width: screenWidth,
        child: OBVideoPlayer(
          videoUrl: videoUrl,
          thumbnailUrl: postVideo.thumbnail,
        ),
      );
    }

    InViewState state = InViewNotifierList.of(context);

    return AnimatedBuilder(
      animation: state,
      builder: (BuildContext context, Widget child) {
        final bool inView = state.inView(inViewId);

        return SizedBox(
          height: imageHeight,
          width: screenWidth,
          child: inView
              ? OBVideoPlayer(
                  videoUrl: videoUrl,
                  thumbnailUrl: postVideo.thumbnail,
                )
              : Image(
                  fit: BoxFit.cover,
                  image: AdvancedNetworkImage(postVideo.thumbnail,
                      useDiskCache: true),
                ),
        );
      },
    );
  }
}
