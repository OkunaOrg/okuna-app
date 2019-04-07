import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter/material.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post post;

  const OBPostBodyImage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = post.getImage();
    double screenWidth = MediaQuery.of(context).size.width;
    double aspectRatio = post.getImageWidth() / post.getImageHeight();

    return GestureDetector(
      onTap: () {
        var dialogService = OpenbookProvider.of(context).dialogService;
        dialogService.showZoomablePhotoBoxView(
            imageUrl: imageUrl, context: context);
      },
      child: SizedBox(
        width: screenWidth,
        height: screenWidth / aspectRatio,
        child: TransitionToImage(
          width: screenWidth,
          height: screenWidth / aspectRatio,
          fit: BoxFit.contain,
          image: AdvancedNetworkImage(imageUrl,
              useDiskCache: true,
              fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
              retryLimit: 3,
              timeoutDuration: const Duration(minutes: 1)),
          // This is the default placeholder widget at loading status,
          // you can write your own widget with CustomPainter.
          placeholder: Center(
            child: const OBProgressIndicator(),
          ),
          // This is default duration
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
