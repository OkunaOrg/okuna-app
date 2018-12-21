import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/routes/fadein_material_route.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pigment/pigment.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post _post;

  OBPostBodyImage(this._post);


  @override
  Widget build(BuildContext context) {
    String imageUrl = _post.getImage();
    var themeService = OpenbookProvider.of(context).themeService;

    double screenWidth = MediaQuery.of(context).size.width;

    Widget _getPhotoBodyBox() {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenWidth),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: Image(image: AssetImage('assets/images/loading.gif')),
          errorWidget: Container(
            child: Center(child: Text('Could not load image.')),
          ),
        ),
      );
    }

    Widget _getZoomablePhotoBox() {

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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(OBFadeInMaterialPageRoute<bool>(
            builder: (BuildContext context) => Material(
              child: _getZoomablePhotoBox(),
            ),
          fullscreenDialog: true
          ));
      },
      child: _getPhotoBodyBox()
    );
  }
}


