import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class OBPostBodyImage extends StatelessWidget {
  final Post post;

  const OBPostBodyImage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = post.getImage();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxBoxHeight = screenHeight * .75;

    double imageAspectRatio = post.getImageWidth() / post.getImageHeight();
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
    return TransitionToImage(
      width: width,
      height: height,
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
