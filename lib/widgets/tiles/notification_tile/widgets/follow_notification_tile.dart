import 'package:Openbook/models/notifications/follow_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/rich_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBFollowNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final FollowNotification followNotification;

  const OBFollowNotificationTile(
      {Key key, @required this.notification, @required this.followNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String followerUsername = followNotification.follower.username;
    return ListTile(
      onTap: () {
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService.navigateToUserProfile(
            user: followNotification.follower, context: context);
      },
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: followNotification.follower.getProfileAvatar(),
      ),
      title: OBRichText(
        children: [
          TextSpan(
            text: '@$followerUsername',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' is now following you.')
        ],
      ),
      subtitle: OBSecondaryText(notification.getRelativeCreated()),
    );
  }
}
