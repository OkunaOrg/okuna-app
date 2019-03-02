import 'package:Openbook/models/notifications/notification.dart';

class NotificationsList {
  final List<Notification> notifications;

  NotificationsList({
    this.notifications,
  });

  factory NotificationsList.fromJson(List<dynamic> parsedJson) {
    List<Notification> notifications = parsedJson
        .map((notificationJson) => Notification.fromJSON(notificationJson))
        .toList();

    return new NotificationsList(
      notifications: notifications,
    );
  }
}
