import 'package:Openbook/models/post.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post _post;

  OBPostBodyImage(this._post);

  @override
  Widget build(BuildContext context) {
    String imageUrl = _post.getImage();

    double screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: screenWidth),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: Text('Could not load image.'),
      ),
    );
  }
}
