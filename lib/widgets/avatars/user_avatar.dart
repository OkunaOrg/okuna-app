import 'dart:io';
import 'package:flutter_image/network.dart';
import 'package:flutter/material.dart';

enum OBUserAvatarSize { small, medium, large, extraLarge }

class OBUserAvatar extends StatelessWidget {
  final String avatarUrl;
  final File avatarFile;
  final OBUserAvatarSize size;
  final VoidCallback onPressed;
  final double borderWidth;

  static const double AVATAR_SIZE_SMALL = 20.0;
  static const double AVATAR_SIZE_MEDIUM = 40.0;
  static const double AVATAR_SIZE_LARGE = 100.0;
  static const double AVATAR_SIZE_EXTRA_LARGE = 100.0;
  static const String DEFAULT_AVATAR_ASSET = 'assets/images/avatar.jpg';

  OBUserAvatar(
      {this.avatarUrl,
      this.size = OBUserAvatarSize.small,
      this.onPressed,
      this.avatarFile,
      this.borderWidth});

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

    if (avatarFile != null) {
      finalAvatarImage = FadeInImage(
        fit: BoxFit.cover,
        height: avatarSize,
        width: avatarSize,
        placeholder: AssetImage(DEFAULT_AVATAR_ASSET),
        image: FileImage(avatarFile),
      );
    } else if (avatarUrl != null) {
      finalAvatarImage = Image(
          height: avatarSize,
          width: avatarSize,
          fit: BoxFit.cover,
          image: NetworkImageWithRetry(avatarUrl));
    } else {
      finalAvatarImage = _getAvatarPlaceholder(avatarSize);
    }

    double avatarBorderRadius = 10.0;

    Widget avatar = ClipRRect(
      borderRadius: BorderRadius.circular(avatarBorderRadius),
      child: finalAvatarImage,
    );

    if (onPressed == null) return avatar;

    return GestureDetector(
      child: avatar,
      onTap: onPressed,
    );
  }

  Widget _getAvatarPlaceholder(double avatarSize) {
    return Image.asset(
      DEFAULT_AVATAR_ASSET,
      height: avatarSize,
      width: avatarSize,
    );
  }
}
