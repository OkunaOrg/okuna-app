import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/community_invite.dart';
import 'package:Openbook/models/notifications/community_invite_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/avatars/community_avatar.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBCommunityInviteNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final CommunityInviteNotification communityInviteNotification;
  final VoidCallback onPressed;
  static final double postImagePreviewSize = 40;

  const OBCommunityInviteNotificationTile(
      {Key key,
      @required this.notification,
      @required this.communityInviteNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommunityInvite communityInvite =
        communityInviteNotification.communityInvite;
    User inviteCreator = communityInvite.creator;
    Community community = communityInvite.community;

    String inviteCreatorUsername = inviteCreator.username;
    String communityName = community.name;

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Function navigateToInviteCreatorProfile = () {
      openbookProvider.navigationService
          .navigateToUserProfile(user: inviteCreator, context: context);
    };

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService
            .navigateToCommunity(community: community, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToInviteCreatorProfile,
        size: OBAvatarSize.medium,
        avatarUrl: inviteCreator.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        user: inviteCreator,
        onUsernamePressed: navigateToInviteCreatorProfile,
        text: TextSpan(
            text: ' has invited you to join community /c/$communityName .'),
      ),
      trailing: OBCommunityAvatar(
        community: community,
        size: OBAvatarSize.medium,
      ),
      subtitle: OBSecondaryText(utilsService.timeAgo(notification.created)),
    );
  }
}
