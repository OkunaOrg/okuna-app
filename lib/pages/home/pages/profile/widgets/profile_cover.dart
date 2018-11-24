import 'package:Openbook/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class OBProfileCover extends StatelessWidget {
  User user;

  OBProfileCover(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: user.getProfileCover(),
              placeholder: null,
              errorWidget: null,
            ),
          )
        ],
      ),
    );
  }
}
