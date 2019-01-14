import 'dart:io';

import 'package:Openbook/widgets/theming/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBCover extends StatelessWidget {
  final String coverUrl;
  final File coverFile;
  static const double HEIGHT = 230.0;
  static const COVER_PLACEHOLDER = 'assets/images/cover.jpg';

  OBCover({this.coverUrl, this.coverFile});

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (coverFile != null) {
      image = FadeInImage(
        placeholder: AssetImage(COVER_PLACEHOLDER),
        image: FileImage(coverFile),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );
    } else if (coverUrl == null) {
      image = _getCoverPlaceholder(HEIGHT);
    } else {
      image = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: coverUrl != null ? coverUrl : '',
        placeholder: Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: SizedBox(
          child: Center(
            child: OBText('Could not load cover'),
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );
    }

    return SizedBox(
      height: HEIGHT,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: image,
            ),
          )
        ],
      ),
    );
  }

  Widget _getCoverPlaceholder(double coverHeight) {
    return Image.asset(COVER_PLACEHOLDER, height: coverHeight, fit: BoxFit.cover,);
  }
}
