import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

enum OBUserAvatarSize { small, medium, large, extraLarge }

class OBUserAvatar extends StatelessWidget {
  final String avatarUrl;
  final File avatarFile;
  final OBUserAvatarSize size;
  final VoidCallback onPressed;
  final BoxBorder avatarBorder;

  static const double AVATAR_SIZE_SMALL = 20.0;
  static const double AVATAR_SIZE_MEDIUM = 30.0;
  static const double AVATAR_SIZE_LARGE = 100.0;
  static const double AVATAR_SIZE_EXTRA_LARGE = 100.0;
  static const String DEFAULT_AVATAR_ASSET = 'assets/images/avatar.png';

  OBUserAvatar(
      {this.avatarUrl,
      this.size = OBUserAvatarSize.small,
      this.onPressed,
      this.avatarFile,
      this.avatarBorder});

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
      case OBUserAvatarSize.large:
        avatarSize = AVATAR_SIZE_LARGE;
        break;
      case OBUserAvatarSize.extraLarge:
        avatarSize = AVATAR_SIZE_EXTRA_LARGE;
        break;
    }

    Widget finalAvatarImage;

    var placeholderImage = Image.asset(DEFAULT_AVATAR_ASSET);

    if (avatarFile != null) {
      finalAvatarImage = FadeInImage(
        placeholder: AssetImage(DEFAULT_AVATAR_ASSET),
        image: FileImage(avatarFile),
        fit: BoxFit.cover,
      );
    } else if (avatarUrl != null) {
      finalAvatarImage = CachedNetworkImage(
        fit: BoxFit.cover,
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
            color: Pigment.fromString('#efefef'),
            borderRadius: BorderRadius.circular(avatarBorderRadius),
            border: avatarBorder),
        height: avatarSize,
        width: avatarSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(avatarBorderRadius),
          child: finalAvatarImage,
        ));

    if (onPressed == null) return avatar;

    return GestureDetector(
      child: avatar,
      onTap: onPressed,
    );
  }
}
