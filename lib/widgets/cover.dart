import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBCover extends StatelessWidget {
  final String imageUrl;
  static const double HEIGHT = 200.0;

  OBCover(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null)
      return SizedBox(
        height: HEIGHT,
      );

    return Container(
      height: HEIGHT,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              placeholder: null,
              errorWidget: null,
            ),
          )
        ],
      ),
    );
  }
}
