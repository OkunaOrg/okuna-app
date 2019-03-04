import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/post_reaction_notification.dart';
import 'package:flutter/material.dart';

class OBPostReactionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostReactionNotification postReactionNotification;

  const OBPostReactionNotificationTile(
      {Key key,
      @required this.notification,
      @required this.postReactionNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('PostReaction notification');
  }
}
