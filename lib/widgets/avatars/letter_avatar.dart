import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';
export 'package:Openbook/widgets/avatars/user_avatar.dart';

class OBLetterAvatar extends StatelessWidget {
  final OBAvatarSize size;
  final Color color;
  final Color labelColor;
  final String letter;

  const OBLetterAvatar(
      {Key key,
      this.size = OBAvatarSize.medium,
      @required this.color,
      @required this.labelColor,
      @required this.letter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double avatarSize = OBAvatar.getAvatarSize(size);

    return Container(
      height: avatarSize,
      width: avatarSize,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(OBAvatar.avatarBorderRadius)),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
              color: labelColor, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }
}
