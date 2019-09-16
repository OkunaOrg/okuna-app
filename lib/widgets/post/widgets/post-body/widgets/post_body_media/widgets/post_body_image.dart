import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class OBPostBodyImage extends StatelessWidget {
  final PostImage postImage;
  final bool hasExpandButton;

  const OBPostBodyImage({Key key, this.postImage, this.hasExpandButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = postImage.image;

    List<Widget> stackItems = [_buildImageWidget(imageUrl)];

    if (hasExpandButton) {
      stackItems.add(_buildExpandIcon());
    }

    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
              child: Stack(
                children: stackItems,
              ),
              onTap: () {
                var dialogService = OpenbookProvider
                    .of(context)
                    .dialogService;
                dialogService.showZoomablePhotoBoxView(
                    imageUrl: imageUrl, context: context);
              },
            ))
      ],
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Image(
              fit: BoxFit.cover,
              image: AdvancedNetworkImage(imageUrl,
                  useDiskCache: true,
                  fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
                  retryLimit: 3,
                  timeoutDuration: const Duration(minutes: 1)),
            ),
        )
      ],
    );
  }

  Widget _buildExpandIcon() {
    return Positioned(
        bottom: 15,
        right: 15,
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              //Same dark grey as in OBZoomablePhotoModal
              color: Colors.black87,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: OBIcon(
              OBIcons.expand,
              customSize: 12,
            )));
  }
}
