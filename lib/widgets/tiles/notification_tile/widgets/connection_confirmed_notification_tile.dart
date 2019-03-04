import 'package:Openbook/models/notifications/connection_confirmed_notification.dart';
import 'package:Openbook/models/notifications/notification.dart';
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
    return Text('Connection confirmed');
  }
}
