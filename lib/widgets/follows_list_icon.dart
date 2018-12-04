import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

enum OBFollowsListIconSize { small, medium, large }

class OBFollowsListIcon extends StatelessWidget {
  final String followsListIconUrl;
  final File followsListIconFile;
  final OBFollowsListIconSize size;
  final VoidCallback onPressed;
  final BoxBorder avatarBorder;

  static const double AVATAR_SIZE_SMALL = 10.0;
  static const double AVATAR_SIZE_MEDIUM = 25.0;
  static const double AVATAR_SIZE_LARGE = 50.0;
  static const String DEFAULT_AVATAR_ASSET = 'assets/images/avatar.png';

  OBFollowsListIcon(
      {this.followsListIconUrl,
      this.size = OBFollowsListIconSize.medium,
      this.onPressed,
      this.followsListIconFile,
      this.avatarBorder});

  @override
  Widget build(BuildContext context) {
    double avatarSize;

    OBFollowsListIconSize finalSize = size ?? OBFollowsListIconSize.small;

    switch (finalSize) {
      case OBFollowsListIconSize.small:
        avatarSize = AVATAR_SIZE_SMALL;
        break;
      case OBFollowsListIconSize.medium:
        avatarSize = AVATAR_SIZE_MEDIUM;
        break;
      case OBFollowsListIconSize.large:
        avatarSize = AVATAR_SIZE_LARGE;
        break;
    }

    Widget finalAvatarImage;

    var placeholderImage = Image.asset(DEFAULT_AVATAR_ASSET);

    if (followsListIconFile != null) {
      finalAvatarImage = FadeInImage(
        placeholder: AssetImage(DEFAULT_AVATAR_ASSET),
        image: FileImage(followsListIconFile),
        fit: BoxFit.cover,
      );
    } else if (followsListIconUrl != null) {
      finalAvatarImage = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: followsListIconUrl,
        placeholder: placeholderImage,
        errorWidget: placeholderImage,
      );
    } else {
      finalAvatarImage = placeholderImage;
    }

    var avatar = Container(
        height: avatarSize, width: avatarSize, child: finalAvatarImage);

    if (onPressed == null) return avatar;

    return GestureDetector(
      child: avatar,
      onTap: onPressed,
    );
  }
}
