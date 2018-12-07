import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:dcache/dcache.dart';

class FollowsList extends UpdatableModel<FollowsList> {
  final int id;
  final User creator;
  UsersList users;
  Emoji emoji;
  String name;
  int followsCount;

  static final factory = FollowsListFactory();

  factory FollowsList.fromJSON(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  FollowsList(
      {this.id,
      this.creator,
      this.emoji,
      this.name,
      this.followsCount,
      this.users});

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('users')) {
      users = factory.parseUsers(json['users']);
    }
    if (json.containsKey('emoji')) {
      emoji = factory.parseEmoji(json['emoji']);
    }
    if (json.containsKey('name')) {
      name = json['name'];
    }
    if (json.containsKey('follows_count')) {
      followsCount = json['follows_count'];
    }
  }

  bool hasUsers() {
    return this.users != null;
  }

  String getEmojiImage() {
    return emoji.image;
  }

  String getPrettyFollowsCount() {
    String followsCountStr = followsCount.toString();
    return followsCountStr + (followsCount > 1 ? '' : '');
  }
}

class FollowsListFactory extends UpdatableModelFactory<FollowsList> {
  @override
  SimpleCache<int, FollowsList> cache =
      SimpleCache(storage: SimpleStorage(size: 20));

  @override
  FollowsList makeFromJson(Map json) {
    return FollowsList(
        id: json['id'],
        name: json['name'],
        followsCount: json['follows_count'],
        creator: parseUser(json['creator']),
        users: parseUsers(json['users']),
        emoji: parseEmoji(json['emoji']));
  }

  User parseUser(Map userData) {
    if (userData != null) return User.fromJson(userData);
  }

  UsersList parseUsers(List usersData) {
    if (usersData != null) return UsersList.fromJson(usersData);
  }

  Emoji parseEmoji(Map emojiData) {
    return Emoji.fromJson(emojiData);
  }
}
