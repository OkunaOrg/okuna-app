import 'package:Okuna/models/post.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../progress_indicator.dart';

class OBNotificationTilePostMediaPreview extends StatelessWidget {
  static final double postMediaPreviewSize = 40;
  final Post post;

  const OBNotificationTilePostMediaPreview({Key key, @required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
            height: postMediaPreviewSize,
            width: postMediaPreviewSize,
            child: ExtendedImage.network(
              post.mediaThumbnail,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              cache: true,
              timeLimit: const Duration(seconds: 5),
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return Center(
                      child: const OBProgressIndicator(),
                    );
                    break;
                  case LoadState.completed:
                    return null;
                    break;
                  case LoadState.failed:
                    return Image.asset(
                      'assets/images/fallbacks/post-fallback.png',
                      fit: BoxFit.cover,
                    );
                    break;
                  default:
                    return Image.asset(
                      'assets/images/fallbacks/post-fallback.png',
                      fit: BoxFit.cover,
                    );
                    break;
                }
              },
            )
            ));
  }
}
