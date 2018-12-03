import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/user.dart';

class FollowList {
  final int id;
  final User creator;
  final Emoji emoji;

  FollowList({this.id, this.creator, this.emoji});

  factory FollowList.fromJSON(Map<String, dynamic> json) {
    return FollowList(
        id: json['id'],
        creator: _parseUser(json['creator']),
        emoji: _parseEmoji(json['emoji']));
  }

  static User _parseUser(Map userData) {
    return User.fromJson(userData);
  }

  static Emoji _parseEmoji(Map emojiData) {
    return Emoji.fromJson(emojiData);
  }
}
