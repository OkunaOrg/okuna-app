import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter/material.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post post;

  const OBPostBodyImage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    var themeService = provider.themeService;
    var themeValueParserService = provider.themeValueParserService;

    String imageUrl = post.getImage();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double aspectRatio = post.getImageWidth() / post.getImageHeight();
    double imageHeight = (screenWidth / aspectRatio);
    double boxHeight = imageHeight < screenHeight*.75 ? imageHeight : screenHeight*.75;

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
            alignment: Alignment.topCenter,
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
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: OBIcon(
                    OBIcons.fullscreen,
                    size: OBIconSize.extraLarge,
                    themeColor: OBIconThemeColor.primaryAccent,
                  )
              )
          ),
          ],
        ),
      )
    );
  }
}
