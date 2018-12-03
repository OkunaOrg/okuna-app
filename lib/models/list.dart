import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/user.dart';

class OBList {
  final int id;
  final User creator;
  final Emoji emoji;

  OBList({this.id, this.creator, this.emoji});

  factory OBList.fromJSON(Map<String, dynamic> json) {
    return OBList(
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
