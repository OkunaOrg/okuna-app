import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/post/widgets/post-body/modals/zoomable_photo.dart';
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

    double screenWidth = MediaQuery.of(context).size.width;

    Widget _getPhotoBodyBox() {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenWidth),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: Container(
            child: Center(child: Text('Could not load image.')),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(OBFadeInMaterialPageRoute<bool>(
            builder: (BuildContext context) => Material(
              child: OBZoomablePhotoBox(imageUrl),
            ),
          fullscreenDialog: true
          ));
      },
      child: _getPhotoBodyBox()
    );
  }
}


