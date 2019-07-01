import 'package:Openbook/models/notifications/connection_request_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBConnectionRequestNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionRequestNotification connectionRequestNotification;
  final VoidCallback onPressed;

  const OBConnectionRequestNotificationTile(
      {Key key,
      @required this.notification,
      @required this.connectionRequestNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String connectionRequesterUsername =
        connectionRequestNotification.connectionRequester.username;
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    var navigateToRequesterProfile = () {
      if (onPressed != null) onPressed();
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

      openbookProvider.navigationService.navigateToUserProfile(
          user: connectionRequestNotification.connectionRequester,
          context: context);
    };

    return OBNotificationTileSkeleton(
      onTap: navigateToRequesterProfile,
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: connectionRequestNotification.connectionRequester
            .getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
          onUsernamePressed: navigateToRequesterProfile,
          user: connectionRequestNotification.connectionRequester,
          text: TextSpan(
            text: ' wants to connect with you.',
          )),
      subtitle: OBSecondaryText(utilsService.timeAgo(notification.created)),
    );
  }
}
