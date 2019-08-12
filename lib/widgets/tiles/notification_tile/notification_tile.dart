import 'package:Okuna/models/notifications/community_invite_notification.dart';
import 'package:Okuna/models/notifications/connection_confirmed_notification.dart';
import 'package:Okuna/models/notifications/connection_request_notification.dart';
import 'package:Okuna/models/notifications/follow_notification.dart';
import 'package:Okuna/models/notifications/notification.dart';
import 'package:Okuna/models/notifications/post_comment_notification.dart';
import 'package:Okuna/models/notifications/post_comment_reaction_notification.dart';
import 'package:Okuna/models/notifications/post_comment_reply_notification.dart';
import 'package:Okuna/models/notifications/post_comment_user_mention_notification.dart';
import 'package:Okuna/models/notifications/post_reaction_notification.dart';
import 'package:Okuna/models/notifications/post_user_mention_notification.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/theme.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/community_invite_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/connection_confirmed_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/connection_request_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/follow_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/post_comment_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/post_comment_reaction_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/post_comment_reply_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/post_comment_user_mention_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/post_reaction_notification_tile.dart';
import 'package:Okuna/widgets/tiles/notification_tile/widgets/post_user_mention_notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ValueChanged<OBNotification> onNotificationTileDeleted;
  final ValueChanged<OBNotification> onPressed;

  const OBNotificationTile(
      {Key key,
      @required this.notification,
      this.onNotificationTileDeleted,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: notification,
      stream: notification.updateSubject,
      builder: _buildNotificationTile,
    );
  }

  Widget _buildNotificationTile(
      BuildContext context, AsyncSnapshot<OBNotification> snapshot) {
    OBNotification notification = snapshot.data;
    return _buildNotification(notification, context);
  }

  Widget _buildNotification(OBNotification notification, BuildContext context) {
    Widget notificationTile;

    dynamic notificationContentObject = this.notification.contentObject;

    Function finalOnPressed = onPressed != null
        ? () {
            onPressed(notification);
          }
        : null;

    switch (notificationContentObject.runtimeType) {
      case CommunityInviteNotification:
        notificationTile = OBCommunityInviteNotificationTile(
          notification: notification,
          communityInviteNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case FollowNotification:
        notificationTile = OBFollowNotificationTile(
          notification: notification,
          followNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case PostCommentNotification:
        notificationTile = OBPostCommentNotificationTile(
          notification: notification,
          postCommentNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case PostCommentReplyNotification:
        notificationTile = OBPostCommentReplyNotificationTile(
          notification: notification,
          postCommentNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case PostReactionNotification:
        notificationTile = OBPostReactionNotificationTile(
          notification: notification,
          postReactionNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case PostCommentReactionNotification:
        notificationTile = OBPostCommentReactionNotificationTile(
          notification: notification,
          postCommentReactionNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case ConnectionRequestNotification:
        notificationTile = OBConnectionRequestNotificationTile(
          notification: notification,
          connectionRequestNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case ConnectionConfirmedNotification:
        notificationTile = OBConnectionConfirmedNotificationTile(
          notification: notification,
          connectionConfirmedNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case PostCommentUserMentionNotification:
        notificationTile = OBPostCommentUserMentionNotificationTile(
          notification: notification,
          postCommentUserMentionNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      case PostUserMentionNotification:
        notificationTile = OBPostUserMentionNotificationTile(
          notification: notification,
          postUserMentionNotification: notificationContentObject,
          onPressed: finalOnPressed,
        );
        break;
      default:
        print('Unsupported notification content object type');
        return const SizedBox();
    }

    if (!notification.read) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      ThemeService themeService = openbookProvider.themeService;
      ThemeValueParserService themeValueParserService =
          openbookProvider.themeValueParserService;

      return _buildDismissable(StreamBuilder(
          stream: themeService.themeChange,
          initialData: themeService.getActiveTheme(),
          builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
            var theme = snapshot.data;
            var primaryColor =
                themeValueParserService.parseColor(theme.primaryColor);
            final bool isDarkPrimaryColor =
                primaryColor.computeLuminance() < 0.179;

            return DecoratedBox(
              decoration: BoxDecoration(
                color: isDarkPrimaryColor
                    ? Color.fromARGB(30, 255, 255, 255)
                    : Color.fromARGB(20, 0, 0, 0),
              ),
              child: notificationTile,
            );
          }));
    }

    return _buildDismissable(notificationTile);
  }

  Widget _buildDismissable(Widget child) {
    return Slidable(
      delegate: const SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: child,
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            onNotificationTileDeleted(notification);
          },
        ),
      ],
    );
  }
}
