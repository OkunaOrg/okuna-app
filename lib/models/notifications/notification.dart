import 'package:Openbook/models/notifications/community_invite_notification.dart';
import 'package:Openbook/models/notifications/connection_confirmed_notification.dart';
import 'package:Openbook/models/notifications/connection_request_notification.dart';
import 'package:Openbook/models/notifications/follow_notification.dart';
import 'package:Openbook/models/notifications/post_comment_notification.dart';
import 'package:Openbook/models/notifications/post_comment_reply_notification.dart';
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
      {this.id,
      this.owner,
      this.type,
      this.contentObject,
      this.created,
      this.read});

  static final factory = NotificationFactory();

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
      type = NotificationType.parse(json['notification_type']);
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

  void markNotificationAsRead() {
    read = true;
    notifyUpdate();
  }
}

class NotificationFactory extends UpdatableModelFactory<OBNotification> {
  @override
  SimpleCache<int, OBNotification> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 120));

  @override
  OBNotification makeFromJson(Map json) {
    NotificationType type = NotificationType.parse(json['notification_type']);

    return OBNotification(
        id: json['id'],
        owner: parseUser(json['owner']),
        type: type,
        contentObject: parseContentObject(
            contentObjectData: json['content_object'], type: type),
        created: parseCreated(json['created']),
        read: json['read']);
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  dynamic parseContentObject(
      {@required Map contentObjectData, @required NotificationType type}) {
    if (contentObjectData == null) return null;

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
      case NotificationType.postCommentReply:
        contentObject = PostCommentReplyNotification.fromJson(contentObjectData);
        break;
      case NotificationType.postReaction:
        contentObject = PostReactionNotification.fromJson(contentObjectData);
        break;
      case NotificationType.communityInvite:
        contentObject = CommunityInviteNotification.fromJson(contentObjectData);
        break;
      default:
    }
    return contentObject;
  }

  DateTime parseCreated(String created) {
    return DateTime.parse(created).toLocal();
  }
}

class NotificationType {
  // Using a custom-built enum class to link the notification type strings
  // directly to the matching enum constants.
  // This class can still be used in switch statements as a normal enum.
  final String code;

  const NotificationType._internal(this.code);

  toString() => code;

  static const postReaction = const NotificationType._internal('PR');
  static const postComment = const NotificationType._internal('PC');
  static const postCommentReply = const NotificationType._internal('PCR');
  static const connectionRequest = const NotificationType._internal('CR');
  static const connectionConfirmed = const NotificationType._internal('CC');
  static const follow = const NotificationType._internal('F');
  static const communityInvite = const NotificationType._internal('CI');

  static const _values = const <NotificationType>[
    postReaction,
    postComment,
    postCommentReply,
    connectionRequest,
    connectionConfirmed,
    follow,
    communityInvite
  ];

  static values() => _values;

  static NotificationType parse(String string) {
    if (string == null) return null;

    NotificationType notificationType;
    if (string == postReaction.code) {
      notificationType = postReaction;
    } else if (string == postComment.code) {
      notificationType = postComment;
    } else if (string == postCommentReply.code) {
      notificationType = postCommentReply;
    } else if (string == connectionRequest.code) {
      notificationType = connectionRequest;
    } else if (string == connectionConfirmed.code) {
      notificationType = connectionConfirmed;
    } else if (string == follow.code) {
      notificationType = follow;
    } else if (string == communityInvite.code) {
      notificationType = communityInvite;
    } else {
      // Don't throw as we might introduce new notifications on the API which might not be yet in code
      print('Unsupported notification type');
    }

    return notificationType;
  }
}