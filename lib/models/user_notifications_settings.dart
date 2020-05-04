class UserNotificationsSettings {
  final int id;
  bool postNotifications;
  bool postReactionNotifications;
  bool followNotifications;
  bool connectionRequestNotifications;
  bool connectionConfirmedNotifications;
  bool communityInviteNotifications;
  bool communityNewPostNotifications;
  bool userNewPostNotifications;

  UserNotificationsSettings(
      {this.id,
      this.connectionConfirmedNotifications,
      this.connectionRequestNotifications,
      this.followNotifications,
      this.postNotifications,
      this.communityInviteNotifications,
      this.communityNewPostNotifications,
      this.userNewPostNotifications});

  factory UserNotificationsSettings.fromJSON(Map<String, dynamic> parsedJson) {
    return UserNotificationsSettings(
      id: parsedJson['id'],
      connectionConfirmedNotifications:
          parsedJson['connections_confirmed_notifications'],
      connectionRequestNotifications:
          parsedJson['connection_request_notifications'],
      followNotifications: parsedJson['follow_notifications'],
      postNotifications: parsedJson['post_notifications'],
      communityInviteNotifications:
          parsedJson['community_invite_notifications'],
      communityNewPostNotifications:
          parsedJson['community_new_post_notifications'],
      userNewPostNotifications: parsedJson['user_new_post_notifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'connections_confirmed_notifications': connectionConfirmedNotifications,
      'connection_request_notifications': connectionRequestNotifications,
      'follow_notifications': followNotifications,
      'post_notifications': postNotifications,
      'community_invite_notifications': communityInviteNotifications,
      'community_new_post_notifications': communityNewPostNotifications,
      'user_new_post_notifications': userNewPostNotifications,
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
    if (json.containsKey('post_notifications'))
      postNotifications = json['post_notifications'];
    if (json.containsKey('community_invite_notifications'))
      communityInviteNotifications = json['community_invite_notifications'];
    if (json.containsKey('community_new_post_notifications'))
      communityNewPostNotifications = json['community_new_post_notifications'];
    if (json.containsKey('user_new_post_notifications'))
      userNewPostNotifications = json['user_new_post_notifications'];
  }
}
