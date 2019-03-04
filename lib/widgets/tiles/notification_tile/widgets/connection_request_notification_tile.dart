import 'package:Openbook/models/notifications/connection_request_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
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
    return Text('Connection request');
  }
}
