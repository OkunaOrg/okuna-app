import 'package:Openbook/models/community_invite.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/push_notifications/connection_request_push_notification_payload.dart';
import 'package:Openbook/models/push_notifications/follow_push_notification_payload.dart';
import 'package:meta/meta.dart';

class PushNotification {
  static PushNotificationType parseType(String pushNotificationTypeStr) {
    if (pushNotificationTypeStr == null) return null;

    PushNotificationType pushNotificationType;
    if (pushNotificationTypeStr == OBNotification.postReaction) {
      pushNotificationType = PushNotificationType.postReaction;
    } else if (pushNotificationTypeStr == OBNotification.postComment) {
      pushNotificationType = PushNotificationType.postComment;
    } else if (pushNotificationTypeStr == OBNotification.connectionRequest) {
      pushNotificationType = PushNotificationType.connectionRequest;
    } else if (pushNotificationTypeStr == OBNotification.follow) {
      pushNotificationType = PushNotificationType.follow;
    } else if (pushNotificationTypeStr == OBNotification.communityInvite) {
      pushNotificationType = PushNotificationType.communityInvite;
    } else {
      throw 'Unsupported push notification type';
    }

    return pushNotificationType;
  }

  static dynamic parsePayload(
      {@required Map<String, dynamic> payloadData,
      @required PushNotificationType type}) {
    dynamic payload;
    switch (type) {
      case PushNotificationType.postComment:
        payload = PostComment.fromJson(payloadData);
        break;
      case PushNotificationType.connectionRequest:
        payload =
            ConnectionRequestPushNotificationPayload.fromJson(payloadData);
        break;
      case PushNotificationType.follow:
        payload = FollowPushNotificationPayload.fromJson(payloadData);
        break;
      case PushNotificationType.postReaction:
        payload = PostReaction.fromJson(payloadData);
        break;
      case PushNotificationType.communityInvite:
        payload = CommunityInvite.fromJSON(payloadData);
        break;
      default:
        throw 'Unhandled push notification type';
    }
    return payload;
  }

  final dynamic payload;
  final PushNotificationType type;

  const PushNotification({this.payload, this.type});

  factory PushNotification.fromJson(Map<String, dynamic> parsedJson) {
    PushNotificationType type = parseType(parsedJson['type']);
    dynamic payload =
        parsePayload(payloadData: parsedJson['payload'], type: type);

    return PushNotification(payload: payload, type: type);
  }
}

enum PushNotificationType {
  postReaction,
  postComment,
  connectionRequest,
  follow,
  communityInvite
}
