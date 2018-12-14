import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBCover extends StatelessWidget {
  final String coverUrl;
  final File coverFile;
  static const double HEIGHT = 200.0;
  static const PLACEHOLDER_IMAGE = 'assets/images/loading.gif';

  OBCover({this.coverUrl, this.coverFile});

  @override
  Widget build(BuildContext context) {
    Widget image;

    var errorImage = Container();

    if (coverFile != null) {
      image = FadeInImage(
        placeholder: AssetImage(PLACEHOLDER_IMAGE),
        image: FileImage(coverFile),
        fit: BoxFit.cover,
      );
    } else if (coverUrl == null) {
      image = errorImage;
    } else {
      image = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: coverUrl != null ? coverUrl : '',
        placeholder: Image.asset(PLACEHOLDER_IMAGE, fit: BoxFit.cover),
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
