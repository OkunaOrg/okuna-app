import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/video_player/aspect_ratio_video.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/video_player/network_player_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class OBPostBodyVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBPostVideoState();
  }

  final Post post;

  OBPostBodyVideo({this.post});

}

class OBPostVideoState extends State<OBPostBodyVideo> {
  VideoPlayerController _controller;
  VoidCallback listener;
  String videoUrl;
  bool _isPlaying;

  @override
  void initState() {
    super.initState();
    videoUrl = widget.post.getVideo();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget _getVideoPlayerWidget() {
      return Center(
          child: NetworkPlayerLifeCycle(videoUrl,
                (BuildContext context, VideoPlayerController controller) => AspectRatioVideo(controller),
          )
        );
    }

    Widget _getVideoBodyBox() {
      return Container(
          child: _getVideoPlayerWidget()
      );
    }

    Widget _getFullScreenVideoBox() {

      return OBCupertinoPageScaffold(
          navigationBar: OBNavigationBar(
              leading: GestureDetector(
                child: OBIcon(OBIcons.close),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              title: ''
          ),
          child: OBPrimaryColorContainer(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: _getVideoPlayerWidget(),
            ),
          )
      );
    }

    return _getVideoPlayerWidget();

  }
}


