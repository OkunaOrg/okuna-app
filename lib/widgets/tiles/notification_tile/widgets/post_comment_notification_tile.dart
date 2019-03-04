import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/post_comment_notification.dart';
import 'package:flutter/material.dart';

class OBPostCommentNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentNotification postCommentNotification;

  const OBPostCommentNotificationTile(
      {Key key, @required this.notification, @required this.postCommentNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('PostComment notification');
  }
}
