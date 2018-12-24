import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pigment/pigment.dart';


class OBZoomablePhotoModal extends StatelessWidget {
  final String imageUrl;

  OBZoomablePhotoModal(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return OBCupertinoPageScaffold(
        navigationBar: OBNavigationBar(
            leading: GestureDetector(
              child: OBIcon(OBIcons.close),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: ''
        ),
        child: OBPrimaryColorContainer(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              maxScale: PhotoViewComputedScale.contained * 3,
              minScale: PhotoViewComputedScale.contained * 0.8,
              backgroundDecoration: BoxDecoration(color: Pigment.fromString(themeService.getActiveTheme().primaryColor)),
            ),
          ),
        ));
  }
}

