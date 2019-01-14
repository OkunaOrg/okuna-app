import 'dart:io';

import 'package:flutter/material.dart';

class OBPostImagePreviewer extends StatelessWidget {
  final File postImage;
  final VoidCallback onRemove;

  OBPostImagePreviewer(this.postImage, {this.onRemove});

  @override
  Widget build(BuildContext context) {
    double avatarBorderRadius = 10.0;

    var imagePreview = Container(
      height: 200.0,
      width: 200.0,
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(avatarBorderRadius)),
      child: SizedBox(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(avatarBorderRadius),
            child: Container(
              child: null,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(postImage), fit: BoxFit.cover)),
            )),
      ),
    );

    if (onRemove == null) return imagePreview;

    double buttonSize = 30.0;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        imagePreview,
        Positioned(
            right: -10.0,
            top: -10.0,
            child: GestureDetector(
              onTap: onRemove,
              child: SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: FloatingActionButton(
                  onPressed: onRemove,
                  backgroundColor: Colors.black87,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
