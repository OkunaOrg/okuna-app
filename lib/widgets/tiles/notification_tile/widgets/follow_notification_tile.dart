import 'package:Openbook/models/notifications/follow_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:flutter/material.dart';

class OBFollowNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final FollowNotification followNotification;

  const OBFollowNotificationTile(
      {Key key, @required this.notification, @required this.followNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Follow notification');
  }
}
