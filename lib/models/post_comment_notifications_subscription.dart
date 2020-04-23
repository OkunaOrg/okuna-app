import 'package:Okuna/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

class PostCommentNotificationsSubscription
    extends UpdatableModel<PostCommentNotificationsSubscription> {
  final int id;
  final int postCommentId;
  bool reactionNotifications;
  bool replyNotifications;

  PostCommentNotificationsSubscription(
      {this.id,
      this.postCommentId,
      this.reactionNotifications,
      this.replyNotifications});

  static final factory = PostCommentNotificationsSubscriptionFactory();

  factory PostCommentNotificationsSubscription.fromJSON(
      Map<String, dynamic> json) {
    if (json == null) return null;
    return factory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_comment': postCommentId,
      'reaction_notifications': reactionNotifications,
      'reply_notifications': replyNotifications,
    };
  }

  Map<String, dynamic> getSettingsObject() {
    return {
      'replyNotifications': this.replyNotifications,
      'reactionNotifications': this.reactionNotifications
    };
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('reaction_notifications')) {
      reactionNotifications = json['reaction_notifications'];
    }
    if (json.containsKey('reply_notifications')) {
      replyNotifications = json['reply_notifications'];
    }
  }
}

class PostCommentNotificationsSubscriptionFactory
    extends UpdatableModelFactory<PostCommentNotificationsSubscription> {
  @override
  SimpleCache<int, PostCommentNotificationsSubscription> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 20));

  @override
  PostCommentNotificationsSubscription makeFromJson(Map json) {
    return PostCommentNotificationsSubscription(
        id: json['id'],
        postCommentId: json['post_comment'],
        reactionNotifications: json['reaction_notifications'],
        replyNotifications: json['reply_notifications']);
  }
}
