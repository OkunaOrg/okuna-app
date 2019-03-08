import 'package:Openbook/models/badge.dart';

class UserProfile {
  final int id;
  String name;
  String avatar;
  String cover;
  String bio;
  String url;
  String location;
  bool followersCountVisible;
  List<Badge> badges;

  UserProfile(
      {this.id,
      this.name,
      this.avatar,
      this.cover,
      this.bio,
      this.url,
      this.location,
      this.badges,
      this.followersCountVisible});

  factory UserProfile.fromJSON(Map<String, dynamic> parsedJson) {
    List badgesList;
    if (parsedJson.containsKey('badges')) {
      List<dynamic> badges = parsedJson['badges'];
      badgesList =
          badges.map((badgeJson) => Badge.fromJson(badgeJson)).toList();
    }

    return UserProfile(
        id: parsedJson['id'],
        name: parsedJson['name'],
        avatar: parsedJson['avatar'],
        cover: parsedJson['cover'],
        bio: parsedJson['bio'],
        url: parsedJson['url'],
        location: parsedJson['location'],
        badges: badgesList,
        followersCountVisible: parsedJson['followers_count_visible']);
  }

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('name')) name = json['name'];
    if (json.containsKey('avatar')) avatar = json['avatar'];
    if (json.containsKey('cover')) cover = json['cover'];
    if (json.containsKey('bio')) bio = json['bio'];
    if (json.containsKey('url')) url = json['url'];
    if (json.containsKey('location')) location = json['location'];
    if (json.containsKey('followers_count_visible'))
      followersCountVisible = json['followers_count_visible'];
  }

  bool hasLocation() {
    return location != null;
  }

  bool hasUrl() {
    return url != null;
  }
}
