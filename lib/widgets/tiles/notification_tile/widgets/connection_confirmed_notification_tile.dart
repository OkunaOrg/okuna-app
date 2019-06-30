import 'package:Openbook/models/notifications/connection_confirmed_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBConnectionConfirmedNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionConfirmedNotification connectionConfirmedNotification;
  final VoidCallback onPressed;

  const OBConnectionConfirmedNotificationTile(
      {Key key,
      @required this.notification,
      @required this.connectionConfirmedNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String connectionConfirmatorUsername =
        connectionConfirmedNotification.connectionConfirmator.username;
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    return ListTile(
      onTap: () {
        if (onPressed != null) onPressed();
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
      title: OBActionableSmartText(
        text:
            '@$connectionConfirmatorUsername accepted your connection request.',
      ),
      subtitle: OBSecondaryText(utilsService.timeAgo(notification.created)),
    );
  }
}
