import 'package:Openbook/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class OBProfileCover extends StatelessWidget {
  final User user;
  final double height = 200.0;

  OBProfileCover(this.user);

  @override
  Widget build(BuildContext context) {
    String profileCover = user.getProfileCover();

    if (profileCover == null) return SizedBox(height: height,);

    return Container(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: profileCover,
              placeholder: null,
              errorWidget: null,
            ),
          )
        ],
      ),
    );
  }
}
