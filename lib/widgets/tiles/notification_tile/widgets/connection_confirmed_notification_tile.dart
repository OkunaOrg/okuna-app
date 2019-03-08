import 'package:Openbook/models/notifications/connection_confirmed_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/rich_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBConnectionConfirmedNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionConfirmedNotification connectionConfirmedNotification;

  const OBConnectionConfirmedNotificationTile(
      {Key key,
      @required this.notification,
      @required this.connectionConfirmedNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String connectionConfirmatorUsername =
        connectionConfirmedNotification.connectionConfirmator.username;
    return ListTile(
      onTap: () {
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService.navigateToUserProfile(
            user: connectionConfirmedNotification.connectionConfirmator,
            context: context);
      },
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: connectionConfirmedNotification.connectionConfirmator
            .getProfileAvatar(),
      ),
      title: OBRichText(
        children: [
          TextSpan(
            text: '@$connectionConfirmatorUsername',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' accepted your connection request.')
        ],
      ),
      subtitle: OBSecondaryText(notification.getRelativeCreated()),
    );
  }
}
