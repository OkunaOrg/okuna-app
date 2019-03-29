import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pigment/pigment.dart';
import 'package:swipedetector/swipedetector.dart';

class OBZoomablePhotoModal extends StatefulWidget {
  final String imageUrl;

  OBZoomablePhotoModal(this.imageUrl);

  @override
  State<StatefulWidget> createState() {
    return OBZoomablePhotoModalState();
  }
}

class OBZoomablePhotoModalState extends State<OBZoomablePhotoModal> {
  bool isDismissible;

  @override
  void initState() {
    super.initState();
    isDismissible = true;
  }

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        child: Stack(
          children: <Widget>[
            SwipeDetector(
              child: PhotoView(
                backgroundDecoration:
                BoxDecoration(color: Colors.transparent),
                key: Key(widget.imageUrl),
                enableRotation: false,
                scaleStateChangedCallback:
                _photoViewScaleStateChangedCallback,
                imageProvider: AdvancedNetworkImage(widget.imageUrl,
                    retryLimit: 0,
                    useDiskCache: true,
                    fallbackAssetImage:
                    'assets/images/fallbacks/post-fallback.png'),
                maxScale: PhotoViewComputedScale.covered,
                minScale: PhotoViewComputedScale.contained,
              ),
              onSwipeUp: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              onSwipeDown: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              swipeConfiguration: SwipeConfiguration(
                  verticalSwipeMinVelocity: 100.0,
                  verticalSwipeMinDisplacement: 50.0,
                  verticalSwipeMaxWidthThreshold: 100.0,
                  horizontalSwipeMaxHeightThreshold: 50.0,
                  horizontalSwipeMinDisplacement: 50.0,
                  horizontalSwipeMinVelocity: 200.0),
            ),
            _buildCloseButton()
          ],
        ));
  }

  Widget _buildCloseButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: (isDismissible ? 1 : 0),
        duration: Duration(milliseconds: 50),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            GestureDetector(
              onTapDown: (tap) {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Pigment.fromString('#1d1d1d'),
                    borderRadius: BorderRadius.circular(50)),
                child: const OBIcon(
                  OBIcons.close,
                  size: OBIconSize.large,
                  color: Colors.white,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  void _photoViewScaleStateChangedCallback(PhotoViewScaleState state) {
    switch (state) {
      case PhotoViewScaleState.initial:
        setIsDismissible(true);
        break;
      default:
        setIsDismissible(false);
    }
  }

  void setIsDismissible(bool isDismissible) {
    setState(() {
      this.isDismissible = isDismissible;
    });
  }

  void toggleIsDismissible() {
    setIsDismissible(!isDismissible);
  }
}
