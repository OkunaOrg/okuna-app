import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

enum OBFollowsListEmojiSize { small, medium, large }

class OBFollowsListEmoji extends StatelessWidget {
  final String followsListEmojiUrl;
  final File followsListEmojiFile;
  final OBFollowsListEmojiSize size;
  final VoidCallback onPressed;
  final BoxBorder avatarBorder;

  static const double AVATAR_SIZE_SMALL = 10.0;
  static const double AVATAR_SIZE_MEDIUM = 25.0;
  static const double AVATAR_SIZE_LARGE = 50.0;
  static const String DEFAULT_AVATAR_ASSET = 'assets/images/avatar.png';

  OBFollowsListEmoji(
      {this.followsListEmojiUrl,
      this.size = OBFollowsListEmojiSize.medium,
      this.onPressed,
      this.followsListEmojiFile,
      this.avatarBorder});

  @override
  Widget build(BuildContext context) {
    double avatarSize;

    OBFollowsListEmojiSize finalSize = size ?? OBFollowsListEmojiSize.small;

    switch (finalSize) {
      case OBFollowsListEmojiSize.small:
        avatarSize = AVATAR_SIZE_SMALL;
        break;
      case OBFollowsListEmojiSize.medium:
        avatarSize = AVATAR_SIZE_MEDIUM;
        break;
      case OBFollowsListEmojiSize.large:
        avatarSize = AVATAR_SIZE_LARGE;
        break;
    }

    Widget finalAvatarImage;

    var placeholderImage = Image.asset(DEFAULT_AVATAR_ASSET);

    if (followsListEmojiFile != null) {
      finalAvatarImage = FadeInImage(
        placeholder: AssetImage(DEFAULT_AVATAR_ASSET),
        image: FileImage(followsListEmojiFile),
        fit: BoxFit.cover,
      );
    } else if (followsListEmojiUrl != null) {
      finalAvatarImage = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: followsListEmojiUrl,
        placeholder: placeholderImage,
        errorWidget: placeholderImage,
      );
    } else {
      finalAvatarImage = placeholderImage;
    }

    var avatar = Container(height: avatarSize, child: finalAvatarImage);

    if (onPressed == null) return avatar;

    return GestureDetector(
      child: avatar,
      onTap: onPressed,
    );
  }
}
