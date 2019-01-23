import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post post;

  const OBPostBodyImage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = post.getImage();
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () {
          var _modalService = OpenbookProvider.of(context).modalService;
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
                ))));
  }
}
