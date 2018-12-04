import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/user.dart';

class FollowsList {
  final int id;
  final User creator;
  final Emoji emoji;
  final String name;
  final int followsCount;

  FollowsList(
      {this.id, this.creator, this.emoji, this.name, this.followsCount});

  factory FollowsList.fromJSON(Map<String, dynamic> json) {
    return FollowsList(
        id: json['id'],
        name: json['name'],
        followsCount: json['follows_count'],
        creator: _parseUser(json['creator']),
        emoji: _parseEmoji(json['emoji']));
  }

  static User _parseUser(Map userData) {
    if (userData != null) return User.fromJson(userData);
  }

  static Emoji _parseEmoji(Map emojiData) {
    return Emoji.fromJson(emojiData);
  }

  String getEmojiImage() {
    return emoji.image;
  }

  String getPrettyFollowsCount(){
    String followsCountStr = followsCount.toString();
    return followsCountStr + (followsCount > 1 ? '' : '');
  }
}
