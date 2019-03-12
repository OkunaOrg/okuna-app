import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pigment/pigment.dart';

class OBZoomablePhotoModal extends StatefulWidget {
  final String imageUrl;

  OBZoomablePhotoModal(this.imageUrl);

  @override
  State<StatefulWidget> createState() {
    return OBZoomablePhotoModalState();
  }
}

class OBZoomablePhotoModalState extends State<OBZoomablePhotoModal> {
  bool isCloseButtonVisible;

  @override
  void initState() {
    super.initState();
    isCloseButtonVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
        child: Stack(
      children: <Widget>[
        GestureDetector(
          onTap: toggleIsCloseButtonVisible,
          child: Center(
            child: PhotoView(
              enableRotation: false,
              scaleStateChangedCallback: _photoViewScaleStateChangedCallback,
              imageProvider: AdvancedNetworkImage(widget.imageUrl,
                  retryLimit: 0,
                  useDiskCache: true,
                  fallbackAssetImage:
                      'assets/images/fallbacks/post-fallback.png'),
              maxScale: PhotoViewComputedScale.covered,
              minScale: PhotoViewComputedScale.contained,
            ),
          ),
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
        opacity: (isCloseButtonVisible ? 1 : 0),
        duration: Duration(milliseconds: 200),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (!isCloseButtonVisible) return;
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
        setIsCloseButtonVisible(true);
        break;
      case PhotoViewScaleState.zooming:
        setIsCloseButtonVisible(false);
        break;
      default:
        setIsCloseButtonVisible(false);
    }
  }

  void setIsCloseButtonVisible(bool isCloseButtonVisible) {
    setState(() {
      this.isCloseButtonVisible = isCloseButtonVisible;
    });
  }

  void toggleIsCloseButtonVisible() {
    setIsCloseButtonVisible(!isCloseButtonVisible);
  }
}
