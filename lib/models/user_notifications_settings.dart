class UserNotificationsSettings {
  final int id;
  bool postCommentNotifications;
  bool postCommentReactionNotifications;
  bool postCommentReplyNotifications;
  bool postCommentUserMentionNotifications;
  bool postUserMentionNotifications;
  bool postReactionNotifications;
  bool followNotifications;
  bool connectionRequestNotifications;
  bool connectionConfirmedNotifications;
  bool communityInviteNotifications;
  bool communityNewPostNotifications;

  UserNotificationsSettings(
      {this.id,
      this.connectionConfirmedNotifications,
      this.connectionRequestNotifications,
      this.followNotifications,
      this.postCommentNotifications,
      this.postCommentReactionNotifications,
      this.postCommentUserMentionNotifications,
      this.postUserMentionNotifications,
      this.postCommentReplyNotifications,
      this.postReactionNotifications,
      this.communityInviteNotifications,
      this.communityNewPostNotifications});

  factory UserNotificationsSettings.fromJSON(Map<String, dynamic> parsedJson) {
    return UserNotificationsSettings(
      id: parsedJson['id'],
      connectionConfirmedNotifications:
          parsedJson['connections_confirmed_notifications'],
      connectionRequestNotifications:
          parsedJson['connection_request_notifications'],
      followNotifications: parsedJson['follow_notifications'],
      postCommentNotifications: parsedJson['post_comment_notifications'],
      postCommentReactionNotifications:
          parsedJson['post_comment_reaction_notifications'],
      postCommentReplyNotifications:
          parsedJson['post_comment_reply_notifications'],
      postCommentUserMentionNotifications:
          parsedJson['post_comment_user_mention_notifications'],
      postUserMentionNotifications:
          parsedJson['post_user_mention_notifications'],
      postReactionNotifications: parsedJson['post_reaction_notifications'],
      communityInviteNotifications:
          parsedJson['community_invite_notifications'],
      communityNewPostNotifications:
          parsedJson['community_new_post_notifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'connections_confirmed_notifications': connectionConfirmedNotifications,
      'connection_request_notifications': connectionRequestNotifications,
      'follow_notifications': followNotifications,
      'post_comment_notifications': postCommentNotifications,
      'post_comment_reaction_notifications': postCommentReactionNotifications,
      'post_comment_user_mention_notifications': postCommentUserMentionNotifications,
      'post_user_mention_notifications': postUserMentionNotifications,
      'post_comment_reply_notifications': postCommentReplyNotifications,
      'post_reaction_notifications': postReactionNotifications,
      'community_invite_notifications': communityInviteNotifications,
      'community_new_post_notifications': communityNewPostNotifications,
    };
  }

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('connections_confirmed_notifications'))
      connectionConfirmedNotifications =
          json['connections_confirmed_notifications'];
    if (json.containsKey('connection_request_notifications'))
      connectionRequestNotifications = json['connection_request_notifications'];
    if (json.containsKey('follow_notifications'))
      followNotifications = json['follow_notifications'];
    if (json.containsKey('post_comment_notifications'))
      postCommentNotifications = json['post_comment_notifications'];

    if (json.containsKey('post_comment_reaction_notifications'))
      postCommentReactionNotifications =
          json['post_comment_reaction_notifications'];

    if (json.containsKey('post_comment_reply_notifications'))
      postCommentReplyNotifications = json['post_comment_reply_notifications'];

    if (json.containsKey('post_comment_user_mention_notifications'))
      postCommentUserMentionNotifications = json['post_comment_user_mention_notifications'];

    if (json.containsKey('post_user_mention_notifications'))
      postUserMentionNotifications = json['post_user_mention_notifications'];

    if (json.containsKey('post_reaction_notifications'))
      postReactionNotifications = json['post_reaction_notifications'];
    if (json.containsKey('community_invite_notifications'))
      communityInviteNotifications = json['community_invite_notifications'];
    if (json.containsKey('community_new_post_notifications'))
      communityInviteNotifications = json['community_new_post_notifications'];
  }
}
