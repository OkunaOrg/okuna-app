class UserNotificationsSettings {
  final int id;
  bool postCommentNotifications;
  bool postReactionNotifications;
  bool followNotifications;
  bool connectionRequestNotifications;
  bool connectionConfirmedNotifications;
  bool communityInviteNotifications;

  UserNotificationsSettings(
      {this.id,
      this.connectionConfirmedNotifications,
      this.connectionRequestNotifications,
      this.followNotifications,
      this.postCommentNotifications,
      this.postReactionNotifications,
      this.communityInviteNotifications});

  factory UserNotificationsSettings.fromJSON(Map<String, dynamic> parsedJson) {
    return UserNotificationsSettings(
      id: parsedJson['id'],
      connectionConfirmedNotifications:
          parsedJson['connections_confirmed_notifications'],
      connectionRequestNotifications:
          parsedJson['connection_request_notifications'],
      followNotifications: parsedJson['follow_notifications'],
      postCommentNotifications: parsedJson['post_comment_notifications'],
      postReactionNotifications: parsedJson['post_reaction_notifications'],
      communityInviteNotifications:
          parsedJson['community_invite_notifications'],
    );
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
    if (json.containsKey('post_reaction_notifications'))
      postReactionNotifications = json['post_reaction_notifications'];
    if (json.containsKey('community_invite_notifications'))
      communityInviteNotifications = json['community_invite_notifications'];
  }
}
