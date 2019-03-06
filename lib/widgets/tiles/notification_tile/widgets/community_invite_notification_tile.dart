import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/community_invite.dart';
import 'package:Openbook/models/notifications/community_invite_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/avatars/community_avatar.dart';
import 'package:Openbook/widgets/theming/rich_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OBCommunityInviteNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final CommunityInviteNotification communityInviteNotification;
  static final double postImagePreviewSize = 40;

  const OBCommunityInviteNotificationTile(
      {Key key,
      @required this.notification,
      @required this.communityInviteNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommunityInvite communityInvite =
        communityInviteNotification.communityInvite;
    User inviteCreator = communityInvite.creator;
    Community community = communityInvite.community;

    String inviteCreatorUsername = inviteCreator.username;
    String communityName = community.name;

    Function navigateToInviteCreatorProfile = () {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

      openbookProvider.navigationService
          .navigateToUserProfile(user: inviteCreator, context: context);
    };

    return ListTile(
      onTap: () {
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService
            .navigateToCommunity(community: community, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToInviteCreatorProfile,
        size: OBAvatarSize.medium,
        avatarUrl: inviteCreator.getProfileAvatar(),
      ),
      title: OBRichText(
        children: [
          TextSpan(
              text: '@$inviteCreatorUsername',
              style: TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = navigateToInviteCreatorProfile),
          TextSpan(text: ' has invited you to join community '),
          TextSpan(
              text: communityName,
              style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
      trailing: OBCommunityAvatar(
        community: community,
        size: OBAvatarSize.medium,
      ),
      subtitle: OBSecondaryText(notification.getRelativeCreated()),
    );
  }
}
