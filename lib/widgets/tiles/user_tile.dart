import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBUserTile extends StatelessWidget {
  final User user;
  final OnUserTilePressed onUserTilePressed;

  OBUserTile(this.user, {this.onUserTilePressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onUserTilePressed != null) onUserTilePressed(user);
      },
      leading: OBUserAvatar(
        size: OBUserAvatarSize.medium,
        avatarUrl: user.getProfileAvatar(),
      ),
      title: Text(
        user.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(children: [
        Text(user.getProfileName()),
        user.isFollowing ? Text(' · Following') : SizedBox()
      ]),
    );
  }
}

typedef void OnUserTilePressed(User user);
