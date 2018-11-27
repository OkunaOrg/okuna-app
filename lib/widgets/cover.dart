import 'package:Openbook/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBCover extends StatelessWidget {
  final String coverUrl;
  static const double HEIGHT = 200.0;
  static const DEFAULT_COVER_ASSET = 'assets/images/cover.png';
  static const PLACEHOLDER_IMAGE = 'assets/images/loading.gif';

  OBCover({@required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    Widget image;

    var errorImage = Container(
      color: Pigment.fromString('#f5f5f5'),
    );

    var placeholderImage = Image.asset(PLACEHOLDER_IMAGE, fit: BoxFit.cover);

    if (coverUrl == null) {
      image = errorImage;
    } else {
      image = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: coverUrl != null ? coverUrl : '',
        placeholder: placeholderImage,
        errorWidget: errorImage,
      );
    }

    return Container(
      height: HEIGHT,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: image,
          )
        ],
      ),
    );
  }
}
