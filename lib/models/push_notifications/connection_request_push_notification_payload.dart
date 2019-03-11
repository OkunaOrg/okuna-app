import 'package:Openbook/models/user.dart';

class ConnectionRequestPushNotificationPayload {
  final User connectionRequester;

  const ConnectionRequestPushNotificationPayload({this.connectionRequester});

  factory ConnectionRequestPushNotificationPayload.fromJson(
      Map<String, dynamic> parsedJson) {
    User connectionRequester =
        User.fromJson(parsedJson['connection_requester']);

    return ConnectionRequestPushNotificationPayload(
        connectionRequester: connectionRequester);
  }
}
