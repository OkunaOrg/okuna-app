import 'package:Openbook/models/notifications/connection_confirmed_notification.dart';
import 'package:Openbook/models/notifications/connection_request_notification.dart';
import 'package:Openbook/models/notifications/follow_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/post_comment_notification.dart';
import 'package:Openbook/models/notifications/post_reaction_notification.dart';
import 'package:Openbook/widgets/tiles/notification_tile/widgets/connection_confirmed_notification_tile.dart';
import 'package:Openbook/widgets/tiles/notification_tile/widgets/connection_request_notification_tile.dart';
import 'package:Openbook/widgets/tiles/notification_tile/widgets/follow_notification_tile.dart';
import 'package:Openbook/widgets/tiles/notification_tile/widgets/post_comment_notification_tile.dart';
import 'package:Openbook/widgets/tiles/notification_tile/widgets/post_reaction_notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ValueChanged<OBNotification> onNotificationTileDeleted;

  const OBNotificationTile(
      {Key key, @required this.notification, this.onNotificationTileDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget notificationTile;

    dynamic notificationContentObject = this.notification.contentObject;

    switch (notificationContentObject.runtimeType) {
      case FollowNotification:
        notificationTile = OBFollowNotificationTile(
          notification: notification,
          followNotification: notificationContentObject,
        );
        break;
      case PostCommentNotification:
        notificationTile = OBPostCommentNotificationTile(
          notification: notification,
          postCommentNotification: notificationContentObject,
        );
        break;
      case PostReactionNotification:
        notificationTile = OBPostReactionNotificationTile(
          notification: notification,
          postReactionNotification: notificationContentObject,
        );
        break;
      case ConnectionRequestNotification:
        notificationTile = OBConnectionRequestNotificationTile(
          notification: notification,
          connectionRequestNotification: notificationContentObject,
        );
        break;
      case ConnectionConfirmedNotification:
        notificationTile = OBConnectionConfirmedNotificationTile(
          notification: notification,
          connectionConfirmedNotification: notificationContentObject,
        );
        break;
      default:
        throw 'Unsupported notification content object type';
    }

    return Slidable(
      delegate: const SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: notificationTile,
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
