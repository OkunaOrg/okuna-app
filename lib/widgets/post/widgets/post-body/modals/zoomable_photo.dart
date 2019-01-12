import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    var themeService = OpenbookProvider.of(context).themeService;

    return OBCupertinoPageScaffold(
        child: OBPrimaryColorContainer(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: toggleIsCloseButtonVisible,
            child: Center(
              child: PhotoView(
                enableRotation: false,
                scaleStateChangedCallback: _photoViewScaleStateChangedCallback,
                imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                maxScale: PhotoViewComputedScale.covered,
                minScale: PhotoViewComputedScale.contained,
                backgroundDecoration: BoxDecoration(
                    color: Pigment.fromString(
                        themeService.getActiveTheme().primaryColor)),
              ),
            ),
          ),
          _buildCloseButton()
        ],
      ),
    ));
  }

  Widget _buildCloseButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: (isCloseButtonVisible ? 1 : 0),
        duration: Duration(milliseconds: 20),
        child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 50, minHeight: 50),
                      child: OBButton(
                        child: OBIcon(
                          OBIcons.close,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        type: OBButtonType.highlight,
                      ),
                    ))
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
