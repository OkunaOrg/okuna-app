import 'dart:io';

import 'package:Okuna/provider.dart';
import 'package:flutter/material.dart';

class OBPostVideoPreview extends StatelessWidget {
  final File postVideo;
  final VoidCallback onRemove;
  final double buttonSize = 30.0;
  final double size ;

  OBPostVideoPreview(this.postVideo, {this.onRemove, this.size=100});

  @override
  Widget build(BuildContext context) {
    double avatarBorderRadius = 10.0;

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);


    Widget videoPreview = FutureBuilder<File>(
        future: openbookProvider.mediaPickerService.getVideoThumbnail(postVideo),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.data == null) return const SizedBox();

          return SizedBox(
            height: 200.0,
            width: 200,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(avatarBorderRadius),
              child: Image.file(
                snapshot.data,
                fit: BoxFit.cover,
              ),
            ),
          );
        });

    if (onRemove == null) return videoPreview;

    return Stack(
      children: <Widget>[
        videoPreview,
        Positioned(
          top: 10,
          right: 10,
          child: _buildRemoveButton(),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Center(
            child: _buildPlayButton(context),
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: onRemove,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: FloatingActionButton(
          onPressed: onRemove,
          backgroundColor: Colors.black54,
          child: Icon(
            Icons.clear,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onWantsToPlay(context);
      },
      child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 50,
            ),
          )),
    );
  }

  void _onWantsToPlay(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

    openbookProvider.dialogService
        .showVideo(context: context, video: postVideo, autoPlay:true);
  }
}
