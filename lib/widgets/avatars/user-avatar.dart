import 'package:flutter/material.dart';

enum OBUserAvatarSize { small, medium }

class OBUserAvatar extends StatelessWidget {
  final ImageProvider avatarImage;
  final OBUserAvatarSize size;
  final VoidCallback onPressed;

  static const double AVATAR_SIZE_SMALL = 30.0;
  static const double AVATAR_SIZE_MEDIUM = 40.0;
  static const ImageProvider DEFAULT_AVATAR =
      AssetImage('assets/images/avatar.png');

  OBUserAvatar(
      {this.avatarImage = DEFAULT_AVATAR,
      this.size = OBUserAvatarSize.small,
      this.onPressed});

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

    var finalAvatarImage = avatarImage ?? DEFAULT_AVATAR;

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
        child: Container(
          child: FadeInImage(
            placeholder: DEFAULT_AVATAR,
            image: finalAvatarImage,
            fit: BoxFit.cover,
          ),
        ),
      )),
    );

    if (onPressed == null) return avatar;

    return GestureDetector(
      child: avatar,
      onTap: onPressed,
    );
  }
}
