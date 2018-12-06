import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';

class FollowsList {
  final int id;
  final User creator;
  final UsersList users;
  final Emoji emoji;
  final String name;
  final int followsCount;

  FollowsList(
      {this.id,
      this.creator,
      this.emoji,
      this.name,
      this.followsCount,
      this.users});

  factory FollowsList.fromJSON(Map<String, dynamic> json) {
    return FollowsList(
        id: json['id'],
        name: json['name'],
        followsCount: json['follows_count'],
        creator: _parseUser(json['creator']),
        users: _parseUsers(json['users']),
        emoji: _parseEmoji(json['emoji']));
  }

  static User _parseUser(Map userData) {
    if (userData != null) return User.fromJson(userData);
  }

  static UsersList _parseUsers(List usersData) {
    if (usersData != null) return UsersList.fromJson(usersData);
  }

  static Emoji _parseEmoji(Map emojiData) {
    return Emoji.fromJson(emojiData);
  }

  String getEmojiImage() {
    return emoji.image;
  }

  String getPrettyFollowsCount() {
    String followsCountStr = followsCount.toString();
    return followsCountStr + (followsCount > 1 ? '' : '');
  }
}
