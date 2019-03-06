import 'package:Openbook/models/notifications/connection_confirmed_notification.dart';
import 'package:Openbook/models/notifications/connection_request_notification.dart';
import 'package:Openbook/models/notifications/follow_notification.dart';
import 'package:Openbook/models/notifications/post_comment_notification.dart';
import 'package:Openbook/models/notifications/post_reaction_notification.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;

class OBNotification extends UpdatableModel<OBNotification> {
  final int id;
  User owner;
  NotificationType type;
  dynamic contentObject;
  DateTime created;

  bool read;

  OBNotification(
      {this.id, this.owner, this.type, this.contentObject, this.created});

  static final factory = NotificationFactory();
  static final postReaction = 'PR';
  static final postComment = 'PC';
  static final connectionRequest = 'CR';
  static final connectionConfirmed = 'CC';
  static final follow = 'F';

  factory OBNotification.fromJSON(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('owner')) {
      owner = factory.parseUser(json['owner']);
    }

    if (json.containsKey('notification_type')) {
      type = factory.parseType(json['notification_type']);
    }

    if (json.containsKey('content_object')) {
      contentObject = factory.parseContentObject(
          contentObjectData: json['content_object'], type: type);
    }

    if (json.containsKey('read')) {
      read = json['read'];
    }

    if (json.containsKey('created')) {
      created = factory.parseCreated(json['created']);
    }
  }
}

class NotificationFactory extends UpdatableModelFactory<OBNotification> {
  @override
  SimpleCache<int, OBNotification> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 20));

  @override
  OBNotification makeFromJson(Map json) {
    NotificationType type = parseType(json['notification_type']);

    return OBNotification(
        id: json['id'],
        owner: parseUser(json['owner']),
        type: type,
        contentObject: parseContentObject(
            contentObjectData: json['content_object'], type: type),
        created: parseCreated(json['created']));
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  NotificationType parseType(String notificationTypeStr) {
    if (notificationTypeStr == null) return null;

    NotificationType notificationType;
    if (notificationTypeStr == OBNotification.postReaction) {
      notificationType = NotificationType.postReaction;
    } else if (notificationTypeStr == OBNotification.postComment) {
      notificationType = NotificationType.postComment;
    } else if (notificationTypeStr == OBNotification.connectionRequest) {
      notificationType = NotificationType.connectionRequest;
    } else if (notificationTypeStr == OBNotification.connectionConfirmed) {
      notificationType = NotificationType.connectionConfirmed;
    } else if (notificationTypeStr == OBNotification.follow) {
      notificationType = NotificationType.follow;
    } else {
      throw 'Unsupported notification type';
    }

    return notificationType;
  }

  dynamic parseContentObject(
      {@required Map contentObjectData, @required NotificationType type}) {
    dynamic contentObject;
    switch (type) {
      case NotificationType.connectionConfirmed:
        contentObject =
            ConnectionConfirmedNotification.fromJson(contentObjectData);
        break;
      case NotificationType.connectionRequest:
        contentObject =
            ConnectionRequestNotification.fromJson(contentObjectData);
        break;
      case NotificationType.follow:
        contentObject = FollowNotification.fromJson(contentObjectData);
        break;
      case NotificationType.postComment:
        contentObject = PostCommentNotification.fromJson(contentObjectData);
        break;
      case NotificationType.postReaction:
        contentObject = PostReactionNotification.fromJson(contentObjectData);
        break;
      default:
    }
    return contentObject;
  }

  DateTime parseCreated(String created) {
    return DateTime.parse(created).toLocal();
  }
}

enum NotificationType {
  postReaction,
  postComment,
  connectionRequest,
  connectionConfirmed,
  follow
}
