import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';

class OBPostVideoPreviewer extends StatelessWidget {
  final File postVideo;
  final VoidCallback onRemove;

  final double buttonSize = 30.0;

  OBPostVideoPreviewer(this.postVideo, {this.onRemove});

  @override
  Widget build(BuildContext context) {
    double avatarBorderRadius = 10.0;

    Widget videoPreview = FutureBuilder<String>(
        future: Thumbnails.getThumbnail(
            // creates the specified path if it doesnt exist
            videoFile: postVideo.path,
            imageType: ThumbFormat.JPEG,
            quality: 30),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data == null) return const SizedBox();

          return SizedBox(
            height: 200.0,
            width: 200,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(avatarBorderRadius),
              child: Image.file(
                File(snapshot.data),
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
            child: _buildPlayButton(),
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

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _onWantsToPlay,
      child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 50,
            ),
          )),
    );
  }

  void _onWantsToPlay() {
    print('Play');
  }
}
