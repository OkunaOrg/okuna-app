import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';
import 'dart:math';

class OBPostBodyImage extends StatelessWidget {
  final Post post;

  const OBPostBodyImage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = post.getImage();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxBoxHeight = screenHeight*.75;

    double aspectRatio = post.getImageWidth() / post.getImageHeight();
    double imageHeight = (screenWidth / aspectRatio);
    double boxHeight = min(imageHeight, maxBoxHeight);

    return GestureDetector(
        onTap: () {
          var dialogService = OpenbookProvider.of(context).dialogService;
          dialogService.showZoomablePhotoBoxView(
              imageUrl: imageUrl, context: context);
        },
        child: SizedBox(
          width: screenWidth,
          height: boxHeight,
          child: Stack(
            children: <Widget>[TransitionToImage(
              width: screenWidth,
              height: imageHeight,
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              image: AdvancedNetworkImage(imageUrl,
                  useDiskCache: true,
                  fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
                  retryLimit: 3,
                  timeoutDuration: const Duration(minutes: 1)),
              placeholder: Center(
                child: const OBProgressIndicator(),
              ),
              duration: const Duration(milliseconds: 300),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Pigment.fromString("#1d1d1d"), //Same as in OBZoomablePhotoModal
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: OBIcon(
                      OBIcons.fullscreen,
                      size: OBIconSize.medium,
                      color: Colors.white,
                    )
                )
            ),
            ],
          ),
        )
    );
  }
}
