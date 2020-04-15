import 'package:Okuna/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

class PostNotificationsSubscription
    extends UpdatableModel<PostNotificationsSubscription> {
  final int id;
  final String postUuid;
  bool commentNotifications;
  bool reactionNotifications;
  bool replyNotifications;

  PostNotificationsSubscription(
      {this.id,
      this.postUuid,
      this.commentNotifications,
      this.reactionNotifications,
      this.replyNotifications});

  static final factory = PostNotificationsSubscriptionFactory();

  factory PostNotificationsSubscription.fromJSON(Map<String, dynamic> json) {
    if (json == null) return null;
    return factory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_uuid': postUuid,
      'comment_notifications': commentNotifications,
      'reaction_notifications': reactionNotifications,
      'reply_notifications': replyNotifications,
    };
  }

  Map<String, dynamic> getSettingsObject() {
    return {
      'commentNotifications': this.commentNotifications,
      'replyNotifications': this.replyNotifications,
      'reactionNotifications': this.reactionNotifications
    };
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('comment_notifications')) {
      commentNotifications = json['comment_notifications'];
    }
    if (json.containsKey('reaction_notifications')) {
      reactionNotifications = json['reaction_notifications'];
    }
    if (json.containsKey('reply_notifications')) {
      replyNotifications = json['reply_notifications'];
    }
  }
}

class PostNotificationsSubscriptionFactory
    extends UpdatableModelFactory<PostNotificationsSubscription> {
  @override
  SimpleCache<int, PostNotificationsSubscription> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 20));

  @override
  PostNotificationsSubscription makeFromJson(Map json) {
    return PostNotificationsSubscription(
        id: json['id'],
        postUuid: json['post_uuid'],
        commentNotifications: json['comment_notifications'],
        reactionNotifications: json['reaction_notifications'],
        replyNotifications: json['reply_notifications']);
  }
}
