import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class OBPostImagePreviewer extends StatelessWidget {
  final File postImage;
  final VoidCallback onRemove;

  final ValueChanged<File> onPostImageEdited;

  final double buttonSize = 30.0;

  OBPostImagePreviewer(this.postImage,
      {this.onRemove, @required this.onPostImageEdited});

  @override
  Widget build(BuildContext context) {
    double avatarBorderRadius = 10.0;

    var imagePreview = SizedBox(
      height: 200.0,
      width: 200,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(avatarBorderRadius),
        child: Image.file(
          postImage,
          fit: BoxFit.cover,
        ),
      ),
    );

    if (onRemove == null) return imagePreview;

    return Stack(
      children: <Widget>[
        imagePreview,
        Positioned(
          top: 10,
          right: 10,
          child: _buildRemoveButton(),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: _buildEditButton(),
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
          heroTag: Key('postImagePreviewerRemoveButton'),
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

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: _onWantsToEditImage,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: FloatingActionButton(
          heroTag: Key('postImagePreviewerEditButton'),
          onPressed: _onWantsToEditImage,
          backgroundColor: Colors.black54,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  void _onWantsToEditImage() async {
    File croppedFile = await ImageCropper.cropImage(
      toolbarTitle: 'Edit image',
      toolbarColor: Colors.black,
      statusBarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
      sourcePath: postImage.path,
    );

    if (croppedFile != null) onPostImageEdited(croppedFile);
  }
}
