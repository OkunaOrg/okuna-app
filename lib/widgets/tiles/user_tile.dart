import 'package:Openbook/models/badge.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/user_badge.dart';
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
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: user.getProfileAvatar(),
      ),
      trailing: trailing,
      title: Row(
          children: <Widget>[
            OBText(
              user.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _getUserBadge(user)
          ]),
      subtitle: Row(
        children: [
          OBSecondaryText(user.getProfileName()),
          showFollowing && user.isFollowing != null && user.isFollowing
              ? OBSecondaryText(' · Following')
              : const SizedBox()
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

  Widget _getUserBadge(User creator) {
    if (creator.getProfileBadges().length > 0) {
      Badge badge = creator.getProfileBadges()[0];
      return OBUserBadge(badge: badge, size: OBUserBadgeSize.small);
    }
    return const SizedBox();
  }
}

typedef void OnUserTilePressed(User user);
typedef void OnUserTileDeleted(User user);
