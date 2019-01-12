import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
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
          Center(
            child: PhotoView(
              enableRotation: false,
              scaleStateChangedCallback: _photoViewScaleStateChangedCallback,
              imageProvider: CachedNetworkImageProvider(widget.imageUrl),
              maxScale: PhotoViewComputedScale.contained * 3,
              minScale: PhotoViewComputedScale.contained * 0.8,
              backgroundDecoration: BoxDecoration(
                  color: Pigment.fromString(
                      themeService.getActiveTheme().primaryColor)),
            ),
          ),
          _buildCloseButton()
        ],
      ),
    ));
  }

  Widget _buildCloseButton() {
    if (!this.isCloseButtonVisible) return SizedBox();
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
          child: IconButton(icon: OBIcon(OBIcons.close), onPressed: () {
            Navigator.pop(context);
          })),
    );
  }

  void _photoViewScaleStateChangedCallback(PhotoViewScaleState state) {
    switch (state) {
      case PhotoViewScaleState.initial:
        setIsCloseButtonVisible(true);
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
}
