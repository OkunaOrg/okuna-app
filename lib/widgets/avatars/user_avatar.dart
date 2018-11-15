import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum OBUserAvatarSize { small, medium }

class OBUserAvatar extends StatelessWidget {
  final String avatarUrl;
  final OBUserAvatarSize size;
  final VoidCallback onPressed;

  static const double AVATAR_SIZE_SMALL = 20.0;
  static const double AVATAR_SIZE_MEDIUM = 30.0;
  static const double AVATAR_SIZE_LARGE = 40.0;
  static const String DEFAULT_AVATAR_ASSET = 'assets/images/avatar.png';

  OBUserAvatar(
      {this.avatarUrl, this.size = OBUserAvatarSize.small, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double avatarSize;

    OBUserAvatarSize finalSize = size ?? OBUserAvatarSize.small;

    switch (finalSize) {
      case OBUserAvatarSize.small:
        avatarSize = AVATAR_SIZE_SMALL;
        break;
      case OBUserAvatarSize.medium:
        avatarSize = AVATAR_SIZE_MEDIUM;
        break;
    }

    Widget finalAvatarImage;

    var placeholderImage = Image.asset(DEFAULT_AVATAR_ASSET);

    if (avatarUrl != null) {
      finalAvatarImage = CachedNetworkImage(
        imageUrl: avatarUrl,
        placeholder: placeholderImage,
        errorWidget: placeholderImage,
      );
    } else {
      finalAvatarImage = placeholderImage;
    }

    double avatarBorderRadius = 10.0;

    var avatar = Container(
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(avatarBorderRadius)),
      height: avatarSize,
      width: avatarSize,
      child: Container(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarBorderRadius),
        child: Container(child: finalAvatarImage),
      )),
    );

    if (onPressed == null) return avatar;

    return GestureDetector(
      child: avatar,
      onTap: onPressed,
    );
  }
}
