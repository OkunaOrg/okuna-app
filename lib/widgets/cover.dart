import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBCover extends StatelessWidget {
  final String coverUrl;
  static const double HEIGHT = 200.0;

  OBCover({@required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    if (coverUrl == null)
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
              imageUrl: coverUrl,
              placeholder: null,
              errorWidget: null,
            ),
          )
        ],
      ),
    );
  }
}
