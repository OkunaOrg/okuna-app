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

  const OBPostBodyImage({Key key, this.postImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = postImage.image;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxBoxHeight = screenHeight * .75;

    double imageAspectRatio = postImage.width / postImage.height;
    double imageHeight = (screenWidth / imageAspectRatio);
    double boxHeight = min(imageHeight, maxBoxHeight);

    List<Widget> stackItems = [
      _buildImageWidget(screenWidth, imageHeight, imageUrl)
    ];

    if (imageHeight > maxBoxHeight) {
      stackItems.add(_buildExpandIcon());
    }

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
            children: stackItems,
          ),
        ));
  }

  Widget _buildImageWidget(double width, double height, String imageUrl) {
    return Image(
      width: width,
      height: height,
      fit: BoxFit.fitWidth,
      alignment: Alignment.center,
      image: AdvancedNetworkImage(imageUrl,
          useDiskCache: true,
          fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
          retryLimit: 3,
          timeoutDuration: const Duration(minutes: 1)),
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
