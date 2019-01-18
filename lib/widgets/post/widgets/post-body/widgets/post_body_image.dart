import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post _post;

  OBPostBodyImage(this._post);

  @override
  Widget build(BuildContext context) {
    String imageUrl = _post.getImage();
    var _modalService = OpenbookProvider.of(context).modalService;

    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () {
          _modalService.openZoomablePhotoBoxView(
              imageUrl: imageUrl, context: context);
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenWidth / 2),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: Container(
              child: Center(child: Text('Could not load image.')),
            ),
          ),
        ));
  }
}
