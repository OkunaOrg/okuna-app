import 'dart:io';

import 'package:Okuna/models/post_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class OBPostImagePreviewer extends StatelessWidget {
  final PostImage postImage;
  final File postImageFile;
  final VoidCallback onRemove;
  final VoidCallback onWillEditImage;

  final ValueChanged<File> onPostImageEdited;

  final double buttonSize = 30.0;

  OBPostImagePreviewer(
      {this.onRemove,
      @required this.onPostImageEdited,
      this.onWillEditImage,
      this.postImageFile,
      this.postImage});

  @override
  Widget build(BuildContext context) {
    double avatarBorderRadius = 10.0;

    bool isFileImage = postImageFile != null;

    var imagePreview = SizedBox(
        height: 200.0,
        width: 200,
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(avatarBorderRadius),
            child: isFileImage
                ? Image.file(
                    postImageFile,
                    fit: BoxFit.cover,
                  )
                : Image(
                    fit: BoxFit.cover,
                    image: AdvancedNetworkImage(postImage.image,
                        useDiskCache: true,
                        fallbackAssetImage:
                            'assets/images/fallbacks/post-fallback.png',
                        retryLimit: 0),
                  )));

    if (onRemove == null) return imagePreview;

    return Stack(
      children: <Widget>[
        imagePreview,
        Positioned(
          top: 10,
          right: 10,
          child: _buildRemoveButton(),
        ),
        isFileImage
            ? Positioned(
                bottom: 10,
                left: 10,
                child: _buildEditButton(),
              )
            : const SizedBox()
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
    if (onWillEditImage != null) onWillEditImage();

    File croppedFile = await ImageCropper.cropImage(
      toolbarTitle: 'Edit image',
      toolbarColor: Colors.black,
      statusBarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
      sourcePath: postImageFile.path,
    );

    if (croppedFile != null) onPostImageEdited(croppedFile);
  }
}
