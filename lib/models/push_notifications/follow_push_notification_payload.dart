import 'package:Openbook/models/user.dart';

class FollowPushNotificationPayload {
  final User followingUser;

  const FollowPushNotificationPayload({this.followingUser});

  factory FollowPushNotificationPayload.fromJson(Map<String, dynamic> parsedJson) {
    User followingUser = User.fromJson(parsedJson['following_user']);

    return FollowPushNotificationPayload(followingUser: followingUser);
  }
}
