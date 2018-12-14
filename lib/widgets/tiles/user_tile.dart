import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBUserTile extends StatelessWidget {
  final User user;
  final OnUserTilePressed onUserTilePressed;
  final OnUserTileDeleted onUserTileDeleted;
  final bool showFollowing;
  final Widget trailing;

  OBUserTile(this.user,
      {this.onUserTilePressed,
      this.onUserTileDeleted,
      this.showFollowing = true,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    Widget tile = ListTile(
      onTap: () {
        if (onUserTilePressed != null) onUserTilePressed(user);
      },
      leading: OBUserAvatar(
        size: OBUserAvatarSize.medium,
        avatarUrl: user.getProfileAvatar(),
      ),
      trailing: trailing,
      title: OBText(
        user.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          OBSecondaryText(user.getProfileName()),
          showFollowing && user.isFollowing != null && user.isFollowing
              ? OBSecondaryText(' · Following')
              : SizedBox()
        ],
      ),
    );

    if (onUserTileDeleted != null) {
      tile = Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: tile,
        secondaryActions: <Widget>[
          new IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              onUserTileDeleted(user);
            },
          ),
        ],
      );
    }
    return tile;
  }
}

typedef void OnUserTilePressed(User user);
typedef void OnUserTileDeleted(User user);
