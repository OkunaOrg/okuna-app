import 'package:Openbook/models/notifications/connection_request_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBConnectionRequestNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionRequestNotification connectionRequestNotification;

  const OBConnectionRequestNotificationTile(
      {Key key,
      @required this.notification,
      @required this.connectionRequestNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String connectionRequesterUsername =
        connectionRequestNotification.connectionRequester.username;
    return ListTile(
      onTap: () {
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService.navigateToUserProfile(
            user: connectionRequestNotification.connectionRequester,
            context: context);
      },
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: connectionRequestNotification.connectionRequester
            .getProfileAvatar(),
      ),
      title: OBActionableSmartText(
        text: '@$connectionRequesterUsername wants to connect with you.',
      ),
      subtitle: OBSecondaryText(notification.getRelativeCreated()),
    );
  }
}
