import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityTile extends StatelessWidget {
  final Community community;
  final OnCommunityTilePressed onCommunityTilePressed;
  final Widget trailing;

  OBCommunityTile(this.community, {this.onCommunityTilePressed, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onCommunityTilePressed != null) onCommunityTilePressed(community);
      },
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: community.avatar,
      ),
      trailing: trailing,
      title: OBText(
        community.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [],
      ),
    );
  }
}

typedef void OnCommunityTilePressed(Community community);
